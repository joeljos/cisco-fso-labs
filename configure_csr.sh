#!/bin/sh
rm -rf __pycache__
export AWS_PAGER=""
python3 configure_csr.py
