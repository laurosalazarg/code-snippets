# learning python 
# fundamentals 
#  
print("print statement 1")
print(2 ** 100)  # 2 to the power of 100
# repeat text
print( 'Spam!' * 8)
# import libraries
import os             # import os libraries 
print(os.getcwdb() )  # get working directory
# 
import sys 
print(sys.platform) 
# 
x = 'Spam'
print(x * 8)
# import file 
import sc2
# import variables from file
from sc2 import a,b,c
print(a)
print(c)
#  reload function, force python to run the file again in the same session wihtout stopping and restarting
#  the session , call the reload()   function 

# list of all available names inside a module
print (dir(sc2)) 
print (dir(os))

#  run this script from the python prompt , each time this runs the file a new 
#  >>>>exec( open('learning.py').read() )

# list example, pg 91 ex 6
List1 = [1,2]
List1.append(List1)
print(List1)

# Built-in types
# 
print("String length: " , len( str(2** 100)))  # output the string length, convert 2**100 result to string 
# 
import math 
print (math.pi)
print(math.sqrt(85))
# 
import random
print("random number: ",random.random())
#  print random from list 
print( random.choice([1,2,3,4]))
print(dir (random)) # get list of names in random module 



# clear console trick 

print("\033[H\033[J", end="")


