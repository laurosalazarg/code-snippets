
function S6snDetect(SNo,snTime,scale,paramFileName, resultsFolderName1, HRNRParamFileName, resultsFolderName2, workspaceSaveDir )

% example run: snDetect(s11WW_h, 1.447, 14,'testdata_feb5_14snr_s11','feb5_14snr_s11_step1'
%                       ,'testdata_feb5_14snr_s11_MUK','feb5_14snr_s11_step3','feb5_14snr_s11')

%%
warning off
% load sample testdata to modify later
load('/gpfs1/LS0231307/Desktop/phys_res/RIDGE/output/S6_testdata_fix.mat');
load('/gpfs1/LS0231307/Desktop/phys_res/RIDGE/output/S6_H1L1V1_data.mat');

SNo = SNo(:,2)';

% detectors{2} = 'V1'; 
 %V1.detector = 'V1'; 
% GPSinfo(1,1).detector = 'V1';


% scale
SN = SNo*scale;

% ridge detectors data
%S6H1 = H1.data'; S6V1 = H2.data'; S6L1 = L1.data';

% S6 Data
S6H1 = H1_s6'; S6V1 = V1_s6'; S6L1 = L1_s6';

% sampling
samplesSN = length(SN); % S11WW  89485 , 
                        % nomoto 895596
                        % s13    111271
s6dataL = length(S6H1); %819201

ridgeFs = 16384;

% Downsample =====

Fsn = floor(samplesSN/snTime); 

%Fsn = floor(samplesSN/snTime);  %nomoto13

SNresh = resample(SN,ridgeFs/2, Fsn);

% seconds, SN signal
secSN = 0:(1/Fsn):( (samplesSN-1)/Fsn );
% seconds, s4 data
secS4 = 0:(1/ridgeFs):( (s6dataL-1)/ridgeFs );

% prepare for padding
sigPad = zeros(1,s6dataL); tempsig = zeros(1,s6dataL);

% inserting and padding 1 SN signal (sgw,samples,location)
tempsig = paddSignal_gw(SNresh,s6dataL,369680);
sigPad = sigPad+tempsig;

%%

% add to S6 data
Sig1 = sigPad+S6H1;  
Sig2 = sigPad+S6V1;  
Sig3 = sigPad+S6L1;  
figure,plot(secS4,Sig1);
%% SNR

% max amp of SN
maxSig1 = max(SN); 
% std noise H1 V1 L1
stdSig1 = std(S6H1); stdSig2 = std(S6V1); stdSig3 = std(S6L1);
% calc snr
snrSig1 = (maxSig1/stdSig1)*100; 
snrSig2 = (maxSig1/stdSig2)*100;
snrSig3 = (maxSig1/stdSig3)*100;

disp(['SNRs ' num2str(snrSig1) ' ' num2str(snrSig2) ' ' num2str(snrSig3)]);


%% normalize 
Sig1 = (Sig1-mean(Sig1))/std(Sig1);
Sig2 = (Sig2-mean(Sig2))/std(Sig2);
Sig3 = (Sig3-mean(Sig3))/std(Sig3);

%%
% RIDGE
%
disp('Running RIDGE clean, S6 ');
% 1. prepare data for RIDGE

%transpose to save  
H1.data = Sig1'; V1.data = Sig2'; L1.data = Sig3';

% figure,plot(H1.data);
% figure,plot(V1.data);figure,plot(L1.data);

% 50 seconds of data, original start_sec = 839544336 stopsec = 839544386;
startsec = 0; stopsec  = 60;

% GPS start and stop seconds
GPSinfo(1,1).GPSinfo.start_sec = startsec; GPSinfo(1,2).GPSinfo.start_sec = startsec;
GPSinfo(1,3).GPSinfo.start_sec = startsec;

GPSinfo(1,1).GPSinfo.stop_sec = stopsec; GPSinfo(1,2).GPSinfo.stop_sec = stopsec;
GPSinfo(1,3).GPSinfo.stop_sec = stopsec;


% save GPS info for H1 V1 L1 
H1.GPSinfo.start_sec = startsec; V1.GPSinfo.start_sec = startsec; 
L1.GPSinfo.start_sec = startsec;
H1.GPSinfo.stop_sec = stopsec; V1.GPSinfo.stop_sec = stopsec; 
L1.GPSinfo.stop_sec = stopsec;

%saving to RIDGE output folder
paramfileLoc = '/gpfs1/LS0231307/Desktop/phys_res/RIDGE/output/';
paramFile = [paramfileLoc paramFileName];

save(paramFile,'detectors','indatafile','H1','V1','L1','triggername','triggertype','GPSinfo','version');

% 3. change dir to RIDGE
cd('RIDGE');

% initialize if needed
initializeRIDGE

% 5. load RIDGE parameters for nov 7 (high resolution skymaps used)
load may22

% change to the test data that is being used
paramFileLoc2 = 'output/';
paramFile2 = [paramFileLoc2 paramFileName '.mat'];

s(1).ifodatafile = paramFile2;
s(1).linelistfile = 'linelists/S6_H1L1V1_linelist_fixNOV.mat';

s(1).usenetwork(1,2).detector = 'V1';

% parameters
s(1).overlapfrac = 0;
% skymaps = chunklen/skymapseglen
s(1).chunklen = 10;
s(1).skymapseglen = 0.5;  %0.1
% [ ] is length of first detector
%s(1).lensmapgen = [];
%s(1).startsmapgen = []; originally = 5

s(1).startsmapgen = 3;
s(1).doconditioning = 'y';
s(1).dodownsampling = 'y';

% 6. start RIDGE
RIDGEtrigg(resultsFolderName1,s(1));


% == end ==

% close all

disp('RIDGE clean');

cd('/gpfs1/LS0231307/Desktop/phys_res');

disp('Done all');
%
save([workspaceSaveDir '_cleanS6'],'*');
%}








end