#!/bin/bash

Service="jenkins"

#--quiet mode will no give std o/p, instead will provie status code
if systemctl is-active --quiet $Service;
then
    echo "$Service is Running"
else
    echo "$Service is not Running"
    systemctl start $Service
fi