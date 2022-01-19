#!/bin/sh
python3 auth.py > out.csv
sed '/^$/d' out.csv > out-cln.csv
aws configure import --csv file://out-cln.csv
cp config ~/.aws/config
export AWS_PAGER=""
rm -rf __pycache__
cp config ~/.aws
rm -rf __pycache__
python3 configure_csr.py
