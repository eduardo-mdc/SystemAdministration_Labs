#!/bin/bash


echo "<group>,<username>"

cat /etc/group | awk -F ':' '{print $1, $NF}' | awk 'NF >= 2'