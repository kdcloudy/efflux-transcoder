#!/bin/sh

ssh -i "EffluxKeys.pem" ubuntu@ec2-65-2-83-255.ap-south-1.compute.amazonaws.com

echo "Efflux Video Transcoding"
echo "Developed by Kaustubh Debnath and Sumit Prakash"
echo "Enter the file name to be processed: "
read filepath
if [! -d $filepath]
then
exit $err
fi


aws s3 cp s3://efflux-raw/$filepath

ffmpeg -i $filepath -c:v copy -filter:v scale=720:-1 -c:a copy output-720.mp4
aws s3 cp output-720.mp4 s3://efflux-raw/OUTPUT/output-720.mp4

ffmpeg -i $filepath -c:v libx265  -filter:v scale=480:-1 -c:v copy output-720.mp4


# ffmpeg -i $filepath -c:v copy -c:a copy -tag:v hvc1 output.mp4

