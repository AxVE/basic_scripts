#!/usr/bin/python3

import sys
import os

def printInfos():
	print("Current light : "+str(curL)+" "+str(lightP)+"%")
	return 0
#Main
pathDir="/sys/class/backlight/intel_backlight"
f=open(pathDir+"/brightness", 'r')
curL=int(f.read())
f.close()
f=open(pathDir+"/max_brightness", 'r')
minL=1
maxL=int(f.read())
f.close()
lightP=int(100*curL/maxL)

if(len(sys.argv) == 1):
	printInfos()
elif (sys.argv[1] == "-i" or sys.argv[1] == "--infos"):
	printInfos()
elif (len(sys.argv)>=3 and (sys.argv[1] == '+' or sys.argv[1] == '-' or sys.argv[1] == '=')):
	#TODO : check that argv[2] is an int
	value = int(sys.argv[2])
	if(sys.argv[1] == '+'):
		lightP = lightP + value
	elif(sys.argv[1] == '-'):
		lightP = lightP - value
	else:
		lightP = value

	if(lightP >= 100):curL=maxL
	elif(lightP < 1):curL=minL
	else: curL = int(lightP*maxL/100)

	with open(pathDir+"/brightness",'w') as f:
		print(curL, file=f)
else:
	print("Unknow parameter : "+sys.argv[1])


