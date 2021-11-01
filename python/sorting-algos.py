
# From Python Algorithms , mastering basic algorithms in the python language
# Magnus Lie Hetland

# Gnome Sort 
# 
# Gnome sort contains a single while loop and an index variable that goes from 0 to len(seq)-1, which
# might tempt us to conclude that it has a linear running time, but the statement i -= 1 in the last line
# would indicate otherwise. To figure out how long it runs, you need to understand something about how
# it works. Initially, it scans from a from the left (rep
# reatedly incrementing i), looking for a position i where
# seq[i-1] is greater than seq[i], that is, two values that are in the wrong order. At this point, the else part
# kicks in.
# The else clause swaps seq[i] and seq[i-1] and decrements i. This behavior will continue until,
# once again, seq[i-1] <= seq[i] (or we reach position 0) and order is restored. In other words, the
# algorithm alternately scans upward in the sequence for an out-of-place (that is, too small) element and
# moves that element down to a valid position (by repeated swapping).
def gnomesort(seq):
    i = 0
    while i < len(seq):
        if i == 0 or seq[i-1] <= seq[i]:
            i += 1
        else:   
            seq[i], seq[i-1] = seq[i-1], seq[i]
            i -= 1
            
    return seq
            
# Merge Sort 
# 
def mergesort(seq):
    mid = len(seq)//2
    lft, rgt = seq[:mid], seq[mid:]
    if len(lft) > 1: lft = mergesort(lft)
    if len(rgt) > 1: rgt = mergesort(rgt)
    res = []
    while lft and rgt:
        if lft[-1] >= rgt[-1]:
            res.append(lft.pop())
        else:
            res.append(rgt.pop())
    res.reverse()
            
    return (lft or rgt) + res

# recursion 
def S(seq, i=0):
    if i == len(seq): return 0
    return S(seq, i+1) + seq[i]
# recursion - cost of finding solution
def T(seq, i=0):
    if i == len(seq): return 1
    return T(seq, i+1) + 1




# call main 
def main():
    valrecursion = range(1,101)
    valset = {1234,23452,123,34252 }
    result = []
    value = [24352, 432 ,332, 1234, 5562, 62452, 723452]
    result = gnomesort(value)
    print(result)

    result2 = S(valrecursion)
    print(result2)
    
    result3 = T(valrecursion)
    print(result3)


if __name__ == "__main__":
        main()