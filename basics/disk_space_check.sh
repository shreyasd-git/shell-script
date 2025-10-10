#!/bin/bash

Threshold=80

#grep -vE '^Filesystem'
# -v means to discard and -E means regular expression - the grep will discrd anything starting with 'Filesystem'
df -H | grep -vE '^Filesystem | tmps | cdrom' | awk '{print $5 " " $1}' | 
while read output;
do
    usage=$(echo $output | awk '{print $1}' | cut -d'%' -f1)
    partition=$(echo $outut | awk '{print $2}')
    if [ $usage -ge $Threshold ]; 
    then
        echo "Warning: Disk Usage on $partition is at ${usage}%"
    fi
done 