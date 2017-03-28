#!/bin/bash

#check number of parameters
if [ $# -ne 2 ]; then
    echo $0: usage: compile-push-arm.sh input output
    exit 1
fi

#Choose architecture and compile programm
echo "Choose architecture (1. ARM / 2. x86):"
read -r arc
if [$arc -eq 1]; then
    arm-linux-gnueabi-gcc -static "$1" -o "$2"
else if [$arc -eq 2]; then
    gcc "$1" -o "$2"
else
    echo "$(tput setaf 1)Chosen option is not correct"
    tput sgr0
    exit 1
fi

#Check if compilation succeeded
if [ $? -ne 0 ]; then
    echo "$(tput setaf 1)Compilation failed"
    tput sgr0
    exit 1
else
    echo "$(tput setaf 2)Compilation OK"
    tput sgr0
fi


#adb push to device /data/c (creates c folder if it doesn't exist)
adb shell mkdir -p /data/c
adb push "$2" /data/c
if [ $? -ne 0 ]; then
    echo "$(tput setaf 1)adb push failed"
    tput sgr0
    exit 1
else
    echo "$(tput setaf 2)adb push OK"
    tput sgr0
fi

#run programm from adb shell
echo Program output:
tput bold
adb shell /data/c/"$2"
tput sgr0
if [ $? -ne 0 ]; then
    echo "$(tput setaf 1)execution failed"
    tput sgr0
    exit 1
else
    echo "$(tput setaf 2)execution OK"
    tput sgr0
fi
