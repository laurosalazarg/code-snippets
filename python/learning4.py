# dictionaries 
# useful when need to associate a set of values with keys , to describe properties of something 
# mapping, with keys 
D = { 'food': 'Spam' , 'quantity': 4, 'color': 'Pink'}

print( D['food'] )
D['quantity'] += 1 # add 1 to quantity
print(D) 

#
D = {}
D['name'] = 'Bob'
D['job'] = 'dev'
D['age'] = 40
print(D) 

print(D['name'])


# stacking dictionary 
d = {'k1': 123, 'k2':[0,1,2], 'k3':{'insidekey':100}}
d['k3']['insidekey']


# we can use dict() to also make dictionaries 
bob1 = dict(name='bob', job='dev',age=40 )
print(bob1) 
bob2 = dict( zip(['name','job','age'],['bob','dev',40]))
print(bob2) 
# dict keys may be scrambled . mappings are not positionally ordered , so they may come back in a different order than typed


# dictionary literal
rec = { 'name': {'first': 'bob' , 'last': 'smith'},
        'jobs': ['dev','mgr'],
        'age': 40.5 }
print(rec['name']) # name is a nested dictionary 
print(rec['name']['last']) # index the nested dictionary 
print(rec['jobs'])
print(rec['jobs'][-1]) # jobs is a nested list 
rec['jobs'].append('janitor') # expand Bobs job description in place
print(rec)

# sorting keys 

D = { 'a': 1, 'b': 2 , 'c' : 3}
print(D) 



Ks = list(D.keys() ) # get the keys, by keys method 
print ( Ks)
Ks.sort() 
print(Ks) 
# now iterate through the keys 
for key in Ks:
        print(key,'=>', D[key])

# can also be done with the sorted built in function to reduce the number of steps 
print(D) 
for key in sorted(D):
        print(key, '=>',D[key])

# For loop note
# the list comprehension, and related functional programming tools like map and filter,
# will often run faster than a for loop for some types of code 


# Tuples
# immutable, roughly like a list, , they are sequences , cannot be changed once they are created
# use parenthesis 
T = ( 1,2,3,4)
print(len(T))
print(T + (5,6) ) # concat 
print(T[0]) # indexing, slicing, and more 

# tuples have type specific methods 
print(T.index(4)) # index location of the digit 4
print(T.count(4)) # 4 appears once 

# make a new tuple for a new value 
T = (2,) + T[1:] 
print(T) 
# tuples support mixed types and nesting, but they dont grow or shrink bc they are immutable 


## Files
#
#
f = open('data.txt','w')  # 'w' is write , also available 'r' read, 'x' create 
f.write('hello\n') 
f.write('world\n')
f.close()
#
f = open('data.txt')  # 'r' is the default 
text = f.read() 
print(text)
print(text.split() ) # file content is always a string 


with open('file', mode='r')as f:
    print(f.read())

# Sets 
# unordered collections of unique elements

myset = set()
myset.add(1)
myset
myset.add(2)
myset.add(2)
myset

mylist = [ 1,1,1,1,1,2,2,2,2,3,3,3,]
set(mylist)



# files provide an iterator that automatically reads line by line in for loops 
for line in open('data.txt') : print(line) 
print( dir(f) )

# example of a class
#
#
class Worker:
    def __init__(self, name, pay):
        self.name = name
        self.pay = pay 
    def lastname(self):
        return self.name.split()[-1]
    def giveRaise(self,percent):
        self.pay *= (1.0 + percent)

bob = Worker('bob smith',50000)
sue = Worker('sue jones', 60000)
print(bob.lastname() )
sue.giveRaise(.10)
print(sue.pay) 

#
# Numeric Built ins
#
# other built in numeric tools
# import math
# math.pi
# math.e
# math.sqrt()
# pow(2,4) , same as  2 ** 4 
# abs()
# min(), max()
# sum()
# math.floor()
# math.trunc() truncate, (drop decimal digits)
# int()    conver to integer
# round()
#
#  import random
# random.random()
# random.randint(1,10)   random int from 1 to 10

# random.choice()    can ;chose' an item at random from a sequence
# random.shuffle()     changhes order in a list of items 

# import decimal
# from fractions import fraction
# decimal()
# can set decimal precision manually by   decimal.localcontext() 
# fraction()
# 