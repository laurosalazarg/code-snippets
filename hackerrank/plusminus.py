
# hackerrank - Plus Minus
def main(n, seq):
    
    n = len(seq) 
    pos=0
    neg=0
    zer=0
    
    for num in seq:
        if num > 0:
            pos = pos+1
        elif num < 0:
            neg = neg+1
        elif num == 0:
            zer = zer + 1
            
    positives = pos / n
    negatives = neg / n
    zeros = zer / n
    print( str(round(positives,6)))
    print( str(round(negatives,6)))
    print( str(round(zeros,6)))
    

if __name__ == "__main__":
        sizen = input()
        seqx = list(map(int,input().split())) 
        # print(seqx)
        main(sizen, seqx)
        