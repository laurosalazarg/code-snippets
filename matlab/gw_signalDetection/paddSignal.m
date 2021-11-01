function padSig = paddSignal(sg,newSamples,newLocation)

% paddSignal(samples,location, width,phase, newSamples,newLocation)
% create sine gaussian
%sg = gsine(samples,location, width, phase);

% pad left
sgtemp1 = padarray(sg,[0 (newLocation-1) ],'pre');
    rightPad = length(sgtemp1);
% pad right
sgtemp2 = padarray(sgtemp1,[0 (newSamples-rightPad )],'post');

padSig = sgtemp2;


end