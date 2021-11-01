function  [CE,x,y]= EllipticDescrp(curve, scale)
% n = number of coefficients
%if n=0 then n=m/2
%scale amplitud output

X = curve(:,1)';
Y = curve(:,2)';
m = size(X,2);

n = m;

%Graph of the curve

% subplot(3,3,1);
% plot(X,Y);
mx = max( max(X), max(Y) ) + 10;

% axis( [ 0, mx, 0 ,mx]);  %axis of the graph pf the curve
% axis square;             %aspect ratio

%Graph of X
p = 0:2*pi/m:2*pi-pi/m; %parameter
% subplot(3,3,2);
% plot(p,X);
% axis( [ 0,2*pi, 0, mx]); %axis of the graph pf the curve

%Graph of Y
% subplot(3,3,3);
% plot(p, Y);
% 
% axis( [ 0, 2*pi, 0, mx] );  %axis of the graph pf the curve

% Elliptic Fourier Descriptors

if(n==0)
    n = floor(m/2)  %number of coefficients
end

%Fourier Coefficients
ax = zeros(1,n);
bx = zeros(1,n);

ay = zeros(1,n);
by = zeros(1,n);

t = 2*pi/m;

for k = 1:n
    for i=1:m
        ax(k) = ax(k) + X(i)*cos(k*t*(i-1));
        bx(k) = bx(k) + X(i)*sin(k*t*(i-1));
        ay(k) = ay(k) + Y(i)*cos(k*t*(i-1));
        by(k) = by(k) + Y(i)*sin(k*t*(i-1));
        
        
    end
    
    ax(k) = ax(k)*(2.0/m);
    bx(k) = bx(k)*(2.0/m);
    
    ay(k) = ay(k)*(2.0/m);
    by(k) = by(k)*(2.0/m);
    
    
end
% save ax ax
% save ay ay
% save bx bx
% save by by


%Graph coefficient ax
% subplot(3,3,4);
% bar(ax);
% axis( [ 0,n,-scale,scale]);

%Graph coefficient ay
% subplot(3,3,5);
% bar(ay);
% axis( [ 0,n,-scale,scale]);

%Graph coefficient bx
% axis( [ 0,n,-scale,scale]);
% subplot(3,3,6);
% bar(bx);

%Graph coefficient by
% subplot(3,3,7);
% bar(by);
% axis( [ 0,n,-scale,scale]);

%Invariant
CE = zeros(1,n);
for k=1:n
    CE(k) = sqrt(( ax(k)^2+ay(k)^2)  /  (ax(1)^2+ay(1)^2))...
    +sqrt(( bx(k)^2+by(k)^2) / (bx(1)^2+by(1)^2));
end
%graph of elliptic descriptors
% subplot(4,3,9);
% plot(CE),title 'signature from fourier coefficients';
% axis([0,n,0,2.2]);

% g_wholenotecut_CE = CE;
% 
%  save g_wholenotecut_CE g_wholenotecut_CE
%=============================================================

 % get curve back from descriptors
 
  t = 2*pi/m;
    for i=1:m
        
        temp1 = 0;
        temp2 = 0;
        temp3 = 0;
        temp4 = 0;
        
        for k = 1:n
        
        temp1 =  temp1 + scale*( ax(k)*cos( k*t*(i-1) ) );     
        temp2 =  temp2 + scale*( bx(k)*sin( k*t*(i-1) ) );
        temp3 =  temp3 + scale*( ay(k)*cos( k*t*(i-1) ) );
        temp4 =  temp4 + scale*( by(k)*sin( k*t*(i-1) ) ); 
        
        end

x(i) = ( temp1 + temp2 );
y(i) = ( temp3 + temp4 ) ;  

    end
% xg_wholenotecut = x;
% yg_wholenotecut = y;
% 
% save xg_wholenotecut xg_wholenotecut
% save yg_wholenotecut yg_wholenotecut
       
%  subplot(4,3,10), 
%  plot(x, y),title 'curve from descriptors';


end











