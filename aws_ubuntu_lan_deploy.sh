#!/bin/sh
export AWS_PAGER=""
cp config ~/.aws
python3 aws_ubuntu_lan_deploy.py

