#  strings 
S = 'Spam'
print(len(S)) 
print(S[0])
print(S[1])
# 
#  last item from the end 
print ( S[-1]) 
# second to last item 
print ( S[-2])
# negative indexing the hard way 
print ( S[len(S)-1 ] )  
# slice from offsets 1 through 2 (not 3)
print("slice: ", S[1:3])
#  X[I:J]  means "give me everything in X from offet I up to but not including offset J"
print ( S[1:]) # everything past the first char 
print ( S[0:3]) # everything but the last letter
print ( S[:3]) # same as S[0:3]
print ( S[:-1]) # everything but the last again , (0:-1)
print ( S[:]) # all of S as a top-level copy (0:len(S))
#  concatenation
print (S + 'xyz')
#  repetition
print (S * 8)

#  string are immutable in python  
#  S[0] = 'z'  
#  will give you an error , immutable objects cannot be changed

#  expression to make new object
S = 'z' + S[1:] 
print(S)

#  you can change text-based data in place if you either expand
#  in a list of individual characters and join it back together
S = 'shrubbery'
L = list(S)  # create a list from string 
print(L)   # expand the list 
L[1] = 'c'  # change the second character to c
''.join(L)  # join the list with an empty delimeter
print(L)
# 
B = bytearray(b'spam')
B.extend(b'eggs')
print(B)
print(B.decode())
# 
#  string methods 
S = 'Spam'
print(S.find('pa')) # find the offset of a substring in S 
#  string replace 
print ( S.replace('pa', 'xyz'))

print(S)
# split 
line = 'aaa,bbb,cccc,dd'
print( line.split(',') ) # split on the ',' delimeter 
# upper and lowercase 
S = 'spam'
print (S.upper() )
print (S.lower() )
print ( S.isalpha() )  # return strue if alphabet
# 
line = 'aaa,bbb,cccc,dd\n'
print ( line.rstrip() )  # remove trailing whitespace on the right 
#  combine two operations 
print (  line.rstrip().split(','))

#  String formatting
print ( '%s, eggs, and %s' % ('spam','SPAM'))
print ( '{0},eggs, and {1}'.format('spam','SPAM!')) 
print ( '{},eggs, and {}'.format('spam','SPAM!'))  # numbers optional 

print( '{:,.2f}'.format(296999.2597)) # separators, decimal digits 
print ( '%.2f | %+05d' % (3.14159, -42))  # digits, padding, signs 

print( 'The {q} {b} {f}'.format(f='fox', b='brown', q='quick'))

# formating floating point numbers 
#  formula goes,     {value:width.precision f}
# width how many dec  places
result = 100/777
print("the result was {r:1.3f}".format(r=result))

# string literals 3.6 python ver
# F STRINGS 
name = "Jose"
print(f'the result was {name}')




# call on the available object methods for variable S
print ( dir(S))

#
# leading and trialing underscores represent the naming convention for implementation details 
#  the names without the leading underscores are methods 
print ( S + 'NI!')
print ( S.__add__('NI!'))   # not very common, may be slower 

# dir function simply lists the methods names, to ask what they do
print ( help(S.replace))

S = 'A\nB\tC' # \n end of line   \t is a tab
print (len(S))
print( ord('\n'))  # '\n' is one character coded as decimal value 10 
    # ord(c, /)
    # Return the Unicode code point for a one-character string.

#  python also supports raw string literal that turns off the backlash escape mechanism
#   example (   r'C:\text\new' )

#  python strings come swith full Unicode suport




