#!/bin/sh                                           
 
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; version 2 of the License only.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 
ST_OK=0
ST_WR=1
ST_CR=2
ST_UK=3
wcdiff=0
wclvls=0
 
PROGNAME=`basename $0`
VERSION="Version 1.0,"
AUTHOR="2009, Mike Adolphs (http://www.matejunkie.com/)"
 
print_version() {
    echo "$VERSION $AUTHOR"
}                          
 
print_help() {
    print_version $PROGNAME $VERSION
    echo ""
    echo "$PROGNAME is a Nagios plugin to check the current memory usage via"
    echo "/proc/meminfo. It should work on almost every system where you're"
    echo "able to cat /proc/meminfo. The script itself is written sh-compliant"
    echo "and free software under the terms of the GPLv2."
    echo ""
    echo "$PROGNAME [-w/--warning] [-c/--critical]"
    echo "Options:"
    echo "  -w/--warning)"
    echo "     Warning level in kb or percent for the amount of used memory."
    echo "     Note that when the style is set to percentage, only values"
    echo "     betweeen 0 and 100 are allowed. Default is: Off."
    echo "  -c/--critical)"
    echo "     Critical level in kb or percent for the amount of used memory."
    echo "     Note that when the style is set to percentage, only values"
    echo "     between 0 and 100 are allowed. Default is: Off."
    exit $ST_UK
}                                                                              
 
val_wcdiff() {
    if [ ${lv_wr} -gt ${lv_cr} ]
    then
        wcdiff=1
    fi
}                               
 
style="perc"
 
while test -n "$1"; do
    case "$1" in
        --help|-h)
            print_help
            exit $ST_UK
            ;;
        --version|-v)
            print_version $PROGNAME $VERSION
            exit $ST_UK
            ;;
        --warning|-w)
            lv_wr=$2
            shift
            ;;
        --critical|-c)
            lv_cr=$2
            shift
            ;;
        *)
            echo "Unknown argument: $1"
            print_help
            exit $ST_UK
            ;;
    esac
    shift
done                                        
 
if [ ! -z "$lv_wr" -a ! -z "$lv_cr" ]
then
    val_wcdiff
    val_wclvls
fi                                   
 
if [ $wcdiff = 1 ]
then
    echo "Please adjust levels. The critical level must be higher than the warning level!"
    exit $ST_UK
fi                                                                                        
 
MEM_TOTAL=`grep "^MemTotal" /proc/meminfo|awk '{print $2}'`
TMP_MEM_FREE=`grep "^MemFree" /proc/meminfo|awk '{print $2}'`
TMP_MEM_USED=`expr $MEM_TOTAL - $TMP_MEM_FREE`
BUFFERS=`grep "^Buffers" /proc/meminfo|awk '{print $2}'`
CACHED=`grep "^Cached" /proc/meminfo|awk '{print $2}'`       
 
P_MEM_FREE=`echo "scale=2; $TMP_MEM_FREE / $MEM_TOTAL * 100" | bc -l | sed 's/.[0-9][0-9]//'`
P_MEM_USED=`echo "scale=0; 100 - $P_MEM_FREE" | bc -l`                                       
 
if [ $style = "perc" ]
then
    if [ ! -z "$lv_wr" -a ! -z "$lv_cr" ]
    then
        if [ ${P_MEM_USED} -ge ${lv_wr} -a ${P_MEM_USED} -lt ${lv_cr} ]
        then
            echo "WARNING - Used: $P_MEM_USED%, Free: $P_MEM_FREE% | 'mem_used'=$P_MEM_USED;$lv_wr;$lv_cr 'mem_free'=$P_MEM_FREE"
            exit $ST_WR
        elif [ ${P_MEM_USED} -ge ${lv_cr} ]
        then
            echo "CRITICAL - Used: $P_MEM_USED%, Free: $P_MEM_FREE% | 'mem_used'=$P_MEM_USED;$lv_wr;$lv_cr 'mem_free'=$P_MEM_FREE"
            exit $ST_CR
        else
            echo "OK - Used: $P_MEM_USED%, Free: $P_MEM_FREE% | 'mem_used'=$P_MEM_USED;$lv_wr;$lv_cr 'mem_free'=$P_MEM_FREE"
            exit $ST_OK
        fi
    else
            echo "OK - Used: $P_MEM_USED%, Free: $P_MEM_FREE% | 'mem_used'=$P_MEM_USED 'mem_free'=$P_MEM_FREE"
            exit $ST_OK
    fi
else
    echo "For more information try -h or --help!"
    exit $ST_UK
fi
