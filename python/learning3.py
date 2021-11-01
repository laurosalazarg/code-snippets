# continue Strings
#  pattern matching  pg 100
import re  # re module has calls for searching, splitting, and replacement
match = re.match('Hello[ \t]*(.*)world','Hello      Python world')
#  searches for the word hello followed by zero or more tabs or spaces, 
#  terminated by the word world, if found portions of hte substring matched by parts
#  of the pattern closed in parenthesis are available as groups 
print( match)
print(match.group(1))
# examples
match = re.match('[/:](.*)[/:](.*)[/:](.*)', '/usr/home:lumberjack')
print ( match.groups())
print( re.split('[/:]', '/usr/home/lumberjack'))

# Lists
# 
###### 

# list object is the most general sequence 
# positionally ordered collections of arbitrarily typed objects, have no fixed size
# lists are mutable, unlike strings
L = [123,'spam',1.23]
print(len(L)) 

# list index
print(L[0])
# list slicing 
print(L[:-1])
# list concat
print( L + [4,5,6])
#
print ( L * 2)

# lists can be reminiscent of arrays, but have no fixed type constraint
L.append('NI')
print(L)
#
L.pop(2)
print(L)

# sort, lists are mutable - therefore can change order
M = ['bb','aa','cc']
M.sort()
print(M)
M.reverse()
print(M)

# to grow a list, we call append

# Nesting
M = [ [1,2,3],
      [4,5,6],          # 3x3 matrix
      [7,8,9] ]
print (M)

print(M[1])
print(M[1][2])

## List comprehensions
col2 = [ row[1] for row in M ] 
print(col2) # print row 1 column 2 
print(M)  # unchanged matrix

#
print( [ row[1] + 1 for row in M] )  # add 1 to each item 
print( [ row[1] for row in M if row[1] % 2 == 0] ) # filter out odd items
#
# collect a diagonal from a string
diag = [ M[i][i] for i in [0,1,2] ]    # [0,1,2] is the index location
print(diag)
# repeat characters in a string
doubles = [ c*2 for c in 'spam']
print(doubles) 

## Range
#
print( list(range(4)))
print( list(range(-6,7,2))) # from -6 to + 6 by 2,    list size of 7 
#
print( [[x ** 2, x ** 3 ] for x in range(4)] ) 
#
print ( [ [x,x/2,x*2] for x in range(-6,7,2) if x > 0])
#
# enclosing comprehensions in paranthesis can also be used to create generators 
# that produce results on demand 
# ex:
G = ( sum(row) for row in M) 
print(next(G))   # iteration protocol next 
print(next(G)) 
print(next(G)) 

# the map built in can do similar work, by generating results of running items through a function, one at a time, on request
print("M: ", M)
print( list(map(sum,M))) 

# sets and dictionaries

print(  { sum(row) for row in M} )   # a set of row sums 
print( { i : sum(M[i]) for i in range(3) }) # creates key/value table of row sums 

# lists, sets, dictionaries, and generators, can all be built with comprehensions in 3.X and 2.7




