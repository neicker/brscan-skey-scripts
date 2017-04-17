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

date=`date +%Y%m%d%H%M%S`
outputFile=~/brscan/brscan_"${date}"".pdf"
pdfmarksFile=~/brscan/pdfmarks_"${date}"
deviceName=`scanimage -f "%v %m"`

echo "scan from $2($device) to $outputFile"

# Create pdfmark file
echo "[ /Title (Scan by "${deviceName}" at "${date}")" >> ${pdfmarksFile}
echo "  /ModDate (D:"${date}")" >> ${pdfmarksFile}
echo "  /CreationDate (D:"${date}")" >> ${pdfmarksFile}
echo "  /Creator ("$deviceName")" >> ${pdfmarksFile}
echo "  /DOCINFO pdfmark" >> ${pdfmarksFile}

# Now start the actual scan and conversion pipeline
scanimage --device-name "$device" --resolution $resolution 	\
		-x 210 -y 297  -l 2 -t 0 2>/dev/null |		\
	pnmtops -dpi=${resolution} -imagewidth 8.26 -nocenter 2>/dev/null | \
	gs -q -sDEVICE=pdfwrite -r${resolution} -sPAPERSIZE=a4	\
		-dBATCH -sOutputFile=${outputFile} 		\
		- ${pdfmarksFile} 2>/dev/null

# Cleanup
rm -f ${pdfmarksFile}

echo  $outputFile is created.
