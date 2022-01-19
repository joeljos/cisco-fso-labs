#!/usr/bin/env python
import json, re, sys, os, json
import subprocess
from subprocess import call, check_output

infile="item.json"
outfile="cred.json"
with open (infile) as access_json:
    read_content = json.load(access_json)
    question_access=read_content['note']
    note=question_access

with open(outfile, 'a+') as my_file:
    my_file.write(note + "\n")
    
