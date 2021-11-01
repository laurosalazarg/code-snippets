function padSig = paddSignal_gw(sgw,samples,location)


sgtemp1 = padarray(sgw,[0 (location-1) ],'pre');
    rightPad = length(sgtemp1);
% pad right
sgtemp2 = padarray(sgtemp1,[0 (samples-rightPad )],'post');

padSig = sgtemp2;


end