#Player Tracker, version popo
import os
import subprocess

userinput = raw_input('Search user: ')
dateinput = raw_input('Enter date such as 2013-05-12: ')

left = ' "\<'
middle = '\>.*\<' 
right = '\>"'

filename = 'BungeeTrack.txt'

grepoutput = subprocess.Popen(['egrep --line-buffered %s%s%s%s%s %s'%(left,userinput,middle,dateinput,right,filename)],stdout=subprocess.PIPE,stderr=subprocess.STDOUT,shell=True).communicate()[0]

lengthUserInput = len(userinput)
lengthGrepOutput = len(grepoutput)

#print grepoutput

[ip,user,connect,date]= grepoutput[1:(15*4+lengthUserInput)].split(" | ",3)

print ip, user, connect, date

grepoutput2 = subprocess.Popen(['grep', ip ,'BungeeTrack.txt'],stdout=subprocess.PIPE).communicate()[0]

print grepoutput2



