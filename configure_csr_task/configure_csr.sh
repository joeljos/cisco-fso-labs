#!/bin/sh
pip install netmiko
echo "working directory"
pwd
echo "directory contents"
ls -la
cd input
ls -la
echo "contents of input directory"
chmod 400 sconrod.pem
export AWS_PAGER=""
rm -rf __pycache__
python3 configure_csr.py
