#!/bin/bash -e
  
var7=$(ec2metadata --instance-id)

aws autoscaling set-instance-protection --instance-ids $var7 --auto-scaling-group-name efflux-new-ASG --protected-from-scale-in
export AWS_DEFAULT_REGION=ap-south-1

main_obj=$(aws sqs receive-message --queue-url https://sqs.ap-south-1.amazonaws.com/265595266672/EffluxQueue)

echo -e $main_obj > version.json

var1=$(jq '.Messages[] | {Body} | .Body | fromjson | . | .Records[] | {s3} | .s3 | .bucket | .name'  version.json)

var2=$(jq '.Messages[] | {Body} | .Body | fromjson | . | .Records[] | {s3} | .s3 | .object | .key'  version.json)

var3=$(echo s3://$var1/$var2 | tr -d '""')

var4=$(echo $var2 | tr -d '""')

echo "input file" $var4

# var5=$(echo $var4-1080.mp4)

var6=$(echo $var4-720.mp4)

aws s3 cp $var3 $var4

# ffmpeg -i $var4 -filter:v "scale=w=1920:h=-1" -b:v 6M $var5

ffmpeg -i $var4 -filter:v "scale=w=1280:h=-1" -b:v 3M $var6

# aws s3 cp $var5 s3://efflux-raw/OUTPUT/

aws s3 cp $var6 s3://efflux-raw/

var8=$(jq '.Messages[] | {ReceiptHandle} | .ReceiptHandle'  version.json)

receipt_handle=$(echo $var8 | tr -d '""')

aws sqs delete-message --queue-url https://sqs.ap-south-1.amazonaws.com/265595266672/EffluxQueue --receipt-handle $receipt_handle

aws autoscaling set-instance-protection --instance-ids $var7 --auto-scaling-group-name efflux-new-ASG --no-protected-from-scale-in