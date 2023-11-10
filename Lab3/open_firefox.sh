#!/bin/bash

instances=100

for((i=1; i<=instances; i++)); do
    firefox &
done    

sleep 20

killall firefox