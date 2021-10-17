#!/bin/sh



echo "Efflux Video Transcoding"
echo "Developed by Kaustubh Debnath and Sumit Prakash"
echo "Enter the file name to be processed: "
read filepath
if [! -d $filepath]
then
exit $err
fi

wget https://efflux-raw.s3.ap-south-1.amazonaws.com/$filepath

ffmpeg -i $filepath -c:v copy -filter:v scale=720:-1 -c:a copy output-720.mp4
aws s3 cp output-720.mp4 s3://efflux-raw/OUTPUT/output-720.mp4


# ffmpeg -i $filepath -c:v copy -c:a copy -tag:v hvc1 output.mp4

