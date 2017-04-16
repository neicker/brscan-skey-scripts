#! /bin/sh
set +o noclobber
#
#   $1 = scanner device
#   $2 = friendly name
#

#   
#       100,200,300,400,600
#
resolution=100
device=$1
mkdir -p ~/brscan
if [ "`which usleep  2>/dev/null `" != '' ];then
    usleep 10000
else
    sleep  0.01
fi
output_file=~/brscan/brscan_"`date +%Y-%m-%d-%H-%M-%S`"".pnm"
#echo "scan from $2($device) to $output_file"
scanimage --device-name "$device" --resolution $resolution> $output_file  2>/dev/null
echo  $output_file is created.