#!/bin/sh
python3 auth.py > out.csv
sed '/^$/d' out.csv > out-cln.csv
aws configure import --csv file://out-cln.csv
cp config ~/.aws/config
export AWS_PAGER=""
cp config ~/.aws
python3 aws_ubuntu_lan_deploy.py

