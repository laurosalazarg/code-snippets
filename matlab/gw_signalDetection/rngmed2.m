function y=rngmed2(x,blksz)
%Y=RNGMED2(X,BLKSZ)
%returns the running median obtained with 
%a block size of BLKSZ. The median for each
%block is centered in the block. For the first
%and last BLKSZ/2 samples in X, the median at 
%the k'th sample is computed from samples 1 to k
%(k to 'end' for the end points).
%This function employs the efficient running median
%calculator RNGMED for all remaining point.

%Soumya D. Mohanty
%AEI, August 2001
%%%%%%%%%%%%%%%%%%%%%%%%%

y=zeros(size(x));
lenx=length(x);
endblksz=fix(blksz/2);

dummy=median(x(1:endblksz));
y(1:endblksz)=dummy;
    
y((endblksz+1):(endblksz+lenx-blksz+1))=rngmed(x,blksz);

dummy=median(x((lenx-blksz+2):end));
y((lenx-blksz+2):lenx)=dummy;
