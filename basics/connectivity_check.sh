#!/bin/bash

Host='www.google.com'

output_file="/home/sdevarka/output.txt"

#check if host is reachble > -c 1 means to sed single ping
if ping -c 1 $Host &> /dev/null
then
    echo "$Host is reachable" >> $output_file
else
    echo "$Host is unreachable" >> $output_file
fi