% test standalone cond
load('/gpfs1/LS0231307/Desktop/phys_res/RIDGE/output/testdata.mat');
load s11_2_h
SNo = s11_2_h;
SNo = SNo(:,2)';

snTime = 1.496;

scale = 50;
% scale
SN = SNo*scale;

% ridge detectors data
s4h1 = H1.data'; s4h2 = H2.data'; s4L1 = L1.data';

% sampling
samplesSN = length(SN); % S11WW  89485 , 
                        % nomoto 895596
                        % s13    111271
s4dataL = length(s4h1); %819201

ridgeFs = 16384;

% Downsample =====

Fsn = ceil(samplesSN/snTime); 

SNresh = resample(SN,ridgeFs/2, Fsn);

% seconds, SN signal
secSN = 0:(1/Fsn):( (samplesSN-1)/Fsn );
% seconds, s4 data
secS4 = 0:(1/ridgeFs):( (s4dataL-1)/ridgeFs );

% prepare for padding
sigPad = zeros(1,s4dataL); tempsig = zeros(1,s4dataL);

% inserting and padding 1 SN signal (sgw,samples,location)
tempsig = paddSignal_gw(SNresh,s4dataL,369680);
sigPad = sigPad+tempsig;

% add to s4 data, normalize
S1 = sigPad+s4h1;  S1 = (S1-mean(S1))/std(S1);

S2 = sigPad+s4h2;  S2 = (S2-mean(S2))/std(S2);

S3 = sigPad+s4L1;  S3 = (S3-mean(S3))/std(S3); 

%%
%transpose to save  
H1.data = S1'; H2.data = S2'; L1.data = S3';

% 50 seconds of data, original start_sec = 839544336 stopsec = 839544386;
startsec = 1; stopsec  = 50;

% GPS start and stop seconds
GPSinfo(1,1).GPSinfo.start_sec = startsec; GPSinfo(1,2).GPSinfo.start_sec = startsec;
GPSinfo(1,3).GPSinfo.start_sec = startsec;

GPSinfo(1,1).GPSinfo.stop_sec = stopsec; GPSinfo(1,2).GPSinfo.stop_sec = stopsec;
GPSinfo(1,3).GPSinfo.stop_sec = stopsec;

% save GPS info for H1 H2 L1 
H1.GPSinfo.start_sec = startsec; H2.GPSinfo.start_sec = startsec; 
L1.GPSinfo.start_sec = startsec;
H1.GPSinfo.stop_sec = stopsec; H2.GPSinfo.stop_sec = stopsec; 
L1.GPSinfo.stop_sec = stopsec;

paramfileLoc = '/gpfs1/LS0231307/Desktop/phys_res/RIDGE/output/';
paramFile = [paramfileLoc 'cond_tester'];

save(paramFile,'detectors','indatafile','H1','H2','L1','triggername','triggertype','GPSinfo','version');

clear all

load('/gpfs1/LS0231307/Desktop/phys_res/RIDGE/output/cond_tester.mat');

% standalone conditioning parameters
    inputData = 'cond_tester.mat'; % H1 H2 L1 data
    saveStandaloneName = 'testcond_standalone.mat'; % name to save at RIDGE/output/
    folder = 'output'; % RIDGE /output folder
    mkDirName = 'testcond_outputs'; % create directory with this name to store results
    %resultsDirName = 'testcond_outputs'; % name of results directory
    lineListName = 'GRB060813_H1H2L1_linelist.mat';
    identifyingTag = 'democond'; % name variables
    outputDataName = 'testcond_cond'; % Name conditioned data output variable
    
    
% begin conditioning
standalone_cond(folder,inputData,saveStandaloneName,mkDirName,lineListName,identifyingTag,outputDataName);

%%
% testing cond again
%{
cd('/gpfs1/LS0231307/Desktop/phys_res/RIDGE');
load cond_h1h2L1
cd('/gpfs1/LS0231307/Desktop/phys_res/');


cond1 = cond_h1h2L1{1,1}.data;
cond2 = cond_h1h2L1{1,2}.data;
cond3 = cond_h1h2L1{1,3}.data;


%transpose to save  
H1.data = cond1; H2.data = cond2; L1.data = cond3;

H1.fs = 2048; H2.fs = 2048; L1.fs = 2048;
% 50 seconds of data, original start_sec = 839544336 stopsec = 839544386;
startsec = 1; stopsec  = 50;

% GPS start and stop seconds
GPSinfo(1,1).GPSinfo.start_sec = startsec; GPSinfo(1,2).GPSinfo.start_sec = startsec;
GPSinfo(1,3).GPSinfo.start_sec = startsec;

GPSinfo(1,1).GPSinfo.stop_sec = stopsec; GPSinfo(1,2).GPSinfo.stop_sec = stopsec;
GPSinfo(1,3).GPSinfo.stop_sec = stopsec;

% save GPS info for H1 H2 L1 
H1.GPSinfo.start_sec = startsec; H2.GPSinfo.start_sec = startsec; 
L1.GPSinfo.start_sec = startsec;
H1.GPSinfo.stop_sec = stopsec; H2.GPSinfo.stop_sec = stopsec; 
L1.GPSinfo.stop_sec = stopsec;

paramfileLoc = '/gpfs1/LS0231307/Desktop/phys_res/RIDGE/output/';
paramFile = [paramfileLoc 'cond_tester2'];

save(paramFile,'detectors','indatafile','H1','H2','L1','triggername','triggertype','GPSinfo','version');

clear all

load('/gpfs1/LS0231307/Desktop/phys_res/RIDGE/output/cond_tester.mat');

% standalone conditioning parameters
    inputData = 'cond_tester2.mat'; % H1 H2 L1 data
    saveStandaloneName = 'testcond_standalone.mat'; % name to save at RIDGE/output/
    folder = 'output'; % RIDGE /output folder
    mkDirName = 'testcond_outputs2'; % create directory with this name to store results
    %resultsDirName = 'testcond_outputs'; % name of results directory
    lineListName = 'GRB060813_H1H2L1_linelist.mat';
    identifyingTag = 'democond'; % name variables
    outputDataName = 'testcond_cond2'; % Name conditioned data output variable
    
    
% begin conditioning
standalone_cond(folder,inputData,saveStandaloneName,mkDirName,lineListName,identifyingTag,outputDataName);

%}

%%
%cd(['/gpfs1/LS0231307/Desktop/phys_res/RIDGE/' resultsDirName]);




















