#!/usr/bin/env python
import json, subprocess, lastpass, sys, os, re
from subprocess import call, check_output
from lastpass import *

username='lastpass-email-login'
password='lastpass-password'

#Add in Outfile

lpass = lastpass.Vault.open_remote(username, password)

for i in lpass.accounts:
    x=((i.notes).decode("utf-8"))
    y = (str(x))
    print(x)




