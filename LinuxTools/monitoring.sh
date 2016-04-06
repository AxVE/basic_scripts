#!/bin/bash

watch -t --color '
echo -n "DATE:\t" &&
date && 
echo "\nRAM/SWAP:" &&
free -h &&
echo "\nUSERS:" &&
users &&
echo "\nDMESG:" &&
dmesg -H -P -T --color=always | tail -10'
