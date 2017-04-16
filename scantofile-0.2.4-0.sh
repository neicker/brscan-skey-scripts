#! /bin/sh
set +o noclobber
#
#   $1 = scanner device
#   $2 = friendly name
#

#   
#       100,200,300,400,600
#
resolution=300
device=$1
mkdir -p ~/brscan
if [ "`which usleep  2>/dev/null `" != '' ];then
    usleep 10000
else
    sleep  0.01
fi

# Close a bunch of file descriptors
#for i in {4..11}; do
#	exec ${i}>&-
#done
exec 4>&-
exec 5>&-
exec 6>&-
exec 7>&-
exec 8>&-
exec 9>&-
exec 10>&-
exec 11>&-

output_file=~/brscan/brscan_"`date +%Y-%m-%d-%H-%M-%S`"".pdf"

echo "scan from $2($device) to $output_file"

scanimage --device-name "$device" --resolution $resolution 	\
		-x 210 -y 297  2>/dev/null | \
	pnmtops -dpi=${resolution} -equalpixels 2>/dev/null |	\
	gs -q -sDEVICE=pdfwrite -r${resolution} -sPAPERSIZE=a4	\
		-dBATCH -sOutputFile=${output_file} - 2>/dev/null

echo  $output_file is created.
