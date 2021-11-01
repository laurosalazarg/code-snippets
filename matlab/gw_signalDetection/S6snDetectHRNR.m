
function S6snDetectHRNR(SNo,snTime,scale,paramFileName, resultsFolderName1, HRNRParamFileName, resultsFolderName2, workspaceSaveDir )

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
 
% star collapse wave edit
%SNo = SNo*(1e-20);

% scale
SN = SNo*scale;

% ridge detectors data
% S6H1 = H1.data'; S6V1 = H2.data'; S6L1 = L1.data';
% S6 Data
S6H1 = H1_s6'; S6V1 = V1_s6'; S6L1 = L1_s6';
% sampling
samplesSN = length(SN); % S11WW  89485 , 
                        % nomoto 895596
                        % s13    111271
S6dataL = length(S6H1); %819201

ridgeFs = 16384;

% Downsample =====

Fsn = floor(samplesSN/snTime); 

SNresh = resample(SN,ridgeFs/2, Fsn);

% seconds, SN signal
secSN = 0:(1/Fsn):( (samplesSN-1)/Fsn );
% seconds, S6 data
secS6 = 0:(1/ridgeFs):( (S6dataL-1)/ridgeFs );

% prepare for padding
sigPad = zeros(1,S6dataL); tempsig = zeros(1,S6dataL);

% inserting and padding 1 SN signal (sgw,samples,location)
tempsig = paddSignal_gw(SNresh,S6dataL,369680);
sigPad = sigPad+tempsig;

%%

% add to S6 data
Sig1 = sigPad+S6H1;  
Sig2 = sigPad+S6V1;  
Sig3 = sigPad+S6L1;  

%% plots
% S6 data + SN signal (red)
fig1 = figure(1); plot(secS6,S6H1);
hold on
plot(secS6,sigPad,'red');
hold off
set(fig1,'name','S6 Data + SN Signal (red)');
xlabel('Time (s)');
ylabel('Amplitude (arbitrary unit)');


%% SNR

% max amp of SN
maxSig1 = max(SN); 
% std noise H1 H2 L1
stdSig1 = std(S6H1); stdSig2 = std(S6V1); stdSig3 = std(S6L1);
% calc snr
snrSig1 = (maxSig1/stdSig1)*100; 
snrSig2 = (maxSig1/stdSig2)*100;
snrSig3 = (maxSig1/stdSig3)*100;

disp(['SNRs ' num2str(snrSig1) ' ' num2str(snrSig2) ' ' num2str(snrSig3)]);

% Calculates SNR
% nm = scale;
% while snrSig3 <= 0.07
%     
%     SN = SNo*nm;
%     
%     
%     
%     
% %    max amp of SN
% maxSig1 = max(SN); 
% %std noise H1 V1 L1
% stdSig1 = std(S6H1); stdSig2 = std(S6V1); stdSig3 = std(S6L1);
% %calc snr
% snrSig1 = (maxSig1/stdSig1)*100; 
% snrSig2 = (maxSig1/stdSig2)*100;
% snrSig3 = (maxSig1/stdSig3)*100;
% 
% disp(['SNRs ' num2str(snrSig1) ' ' num2str(snrSig2) ' ' num2str(snrSig3)]);
% 
% nm = nm+1;
% 
% end
% 
% nm

%
%% normalize 
Sig1 = (Sig1-mean(Sig1))/std(Sig1);
Sig2 = (Sig2-mean(Sig2))/std(Sig2);
Sig3 = (Sig3-mean(Sig3))/std(Sig3);

%% plots
% H1 H2 L1 inj signal

fig2 = figure(2); subplot(3,1,1), plot(secS6, Sig1);
                  hold on
                  plot(secS6,sigPad,'red');
                  hold off
                  xlabel('Time (s)');
                  ylabel('Amplitude (arbitrary unit)');
                  
                  subplot(3,1,2), plot(secS6, Sig2);
                  hold on
                  plot(secS6,sigPad,'red');
                  hold off
                  xlabel('Time (s)');
                  ylabel('Amplitude (arbitrary unit)');                  
                  
                  subplot(3,1,3), plot(secS6, Sig3);
                  hold on
                  plot(secS6,sigPad,'red');
                  hold off
                  xlabel('Time (s)');
                  ylabel('Amplitude (arbitrary unit)');
                  
set(fig2,'name','S6 Data + SN Signal (red)');

%% plots histogram noise only

[histS6H1,xhistS6H1] = hist(S6H1,512);
[histS6V1,xhistS6V1] = hist(S6V1,512);
[histS6L1,xhistS6L1] = hist(S6L1,512);

fig3 = figure(3); subplot(3,1,1), bar(xhistS6H1,histS6H1,'histc');
                  subplot(3,1,2), bar(xhistS6V1,histS6V1,'histc');
                  subplot(3,1,3), bar(xhistS6L1,histS6L1,'histc');
set(fig3,'name','Histograms S6 ( noise only)');

%% 
%
% Condition pt 2

%transpose to save  
H1.data = Sig1'; V1.data = Sig2'; L1.data = Sig3';
% 50 seconds of data, original start_sec = 839544336 stopsec = 839544386;
startsec = 0; stopsec  = 60;
% GPS start and stop seconds
GPSinfo(1,1).GPSinfo.start_sec = startsec; GPSinfo(1,2).GPSinfo.start_sec = startsec; GPSinfo(1,3).GPSinfo.start_sec = startsec;
GPSinfo(1,1).GPSinfo.stop_sec = stopsec; GPSinfo(1,2).GPSinfo.stop_sec = stopsec; GPSinfo(1,3).GPSinfo.stop_sec = stopsec;
% save GPS info for H1 V1 L1 
H1.GPSinfo.start_sec = startsec; V1.GPSinfo.start_sec = startsec; 
L1.GPSinfo.start_sec = startsec;
H1.GPSinfo.stop_sec = stopsec; V1.GPSinfo.stop_sec = stopsec; 
L1.GPSinfo.stop_sec = stopsec;
paramfileLoc = '/gpfs1/LS0231307/Desktop/phys_res/RIDGE/output/';
paramFile = [paramfileLoc 'cond_pt3S6'];
save(paramFile,'detectors','indatafile','H1','V1','L1','triggername','triggertype','GPSinfo','version');

% standalone conditioning parameters
    inputData = 'cond_pt3S6.mat'; % H1 V1 L1 data
    saveStandaloneName = 'testcond_standalone_pt3S6.mat'; % name to save at RIDGE/output/
    folder = 'output'; % RIDGE /output folder
    mkDirName = 'testcond_outputs_pt3S6'; % create directory with this name to store results
    %resultsDirName = 'testcond_outputs'; % name of results directory
    lineListName = 'S6_H1L1V1_linelist_fix.mat'; % use created linelists
    identifyingTag = 'democond_pt3S6'; % name variables
    outputDataName = 'cond_pt3S6'; % Name conditioned data output variable
    
% begin conditioning
S6standalone_cond(folder,inputData,saveStandaloneName,mkDirName,lineListName,identifyingTag,outputDataName);

% load conditioning outputs
load('/gpfs1/LS0231307/Desktop/phys_res/RIDGE/testcond_outputs_pt3S6/cond_pt3S6.mat','S1','S2','S3');

%%
% Normalize conditioned 

% take data files
S1c = S1.data'; S2c = S2.data'; S3c = S3.data';
clear S1 S2 S3;
% normalize
S1norm = (S1c-mean(S1c))/std(S1c); S2norm = (S2c-mean(S2c))/std(S2c); S3norm = (S3c-mean(S3c))/std(S3c);


% f1 = figure(1); subplot(3,1,1), specgram(S1norm,2*2048,2048); 
%            subplot(3,1,2), specgram(S2norm,2*2048,2048);
%            subplot(3,1,3), specgram(S3norm,2*2048,2048);
% set(f1,'name','Specgram Conditioned, norm');

maxS1norm = max(S1norm);
maxS2norm = max(S2norm);
maxS3norm = max(S3norm);
disp(['Max S norm ' num2str(maxS1norm) ' ' num2str(maxS2norm) ' ' num2str(maxS3norm) ]);

% seconds, S normalized 
S1cL = length(S1c);
secSnorm = 0:(1/2048):( (S1cL-1)/2048 );

%% plots condition+normalized

% TS
fig4 = figure(4); subplot(3,1,1), plot(secSnorm, S1norm); 
                  xlabel('Time (s)');
                  ylabel('Amplitude (arbitrary unit)');
                  
                  subplot(3,1,2), plot(secSnorm, S2norm);
                  xlabel('Time (s)');
                  ylabel('Amplitude (arbitrary unit)');
                  
                  subplot(3,1,3), plot(secSnorm, S3norm);
                  xlabel('Time (s)');
                  ylabel('Amplitude (arbitrary unit)');
                  
set(fig4,'name','Conditioned+Normalized TS');                  
% PSD
fig5 = figure(5); subplot(3,1,1), psd(S1norm,2*2048,2048);                
                  subplot(3,1,2), psd(S2norm,2*2048,2048);  
                  subplot(3,1,3), psd(S3norm,2*2048,2048);                
set(fig5,'name','PSD Conditioned+Normalized');     

% Histogram                  
[histS1norm,xS1norm] = hist(S1norm,512);
[histS2norm,xS2norm] = hist(S2norm,512);
[histS3norm,xS3norm] = hist(S3norm,512);

fig6 = figure(6); subplot(3,1,1), bar(xS1norm,histS1norm,'histc');
                  subplot(3,1,2), bar(xS2norm,histS2norm,'histc');
                  subplot(3,1,3), bar(xS3norm,histS3norm,'histc');                  
                  
set(fig6,'name','Histogram Conditioned+Normalized');


%% save figures
folderS = '/gpfs1/LS0231307/Desktop/phys_res/networkTestFigures/';
saveas(fig1,[folderS workspaceSaveDir '_fig1'],'fig');
saveas(fig2,[folderS workspaceSaveDir '_fig2_ts_h1v1L1'],'fig');
saveas(fig3,[folderS workspaceSaveDir '_fig3_hist_S6data'],'fig');
saveas(fig4,[folderS workspaceSaveDir '_fig4_ts_condNorm'],'fig');
saveas(fig5,[folderS workspaceSaveDir '_fig5_psd_condNorm'],'fig');
saveas(fig6,[folderS workspaceSaveDir '_fig6_hist_condNorm'],'fig');
           


%% HRNR
SPin = .25; alphaIN = 0.3;
[esTSNR1, esHRNR1] = WienerNoiseReduction(S1norm', 2048, 100,SPin,alphaIN); 
[esTSNR2, esHRNR2] = WienerNoiseReduction(S2norm', 2048, 100,.25,.3); 
[esTSNR3, esHRNR3] = WienerNoiseReduction(S3norm', 2048, 100,SPin,alphaIN);

% seconds, Wiener Filt 
esL = length(esHRNR1);
secWien = 0:(1/2048):( (esL-1)/2048 );

%% normalize filter
esHRNR1 = esHRNR1';
esHRNR1 = (esHRNR1-mean(esHRNR1))/std(esHRNR1);

esHRNR2 = esHRNR2';
esHRNR2 = (esHRNR2-mean(esHRNR2))/std(esHRNR2);

esHRNR3 = esHRNR3';
esHRNR3 = (esHRNR3-mean(esHRNR3))/std(esHRNR3);

%% filter plots

% TS
fig7 = figure(7); subplot(3,1,1),plot(secWien, esHRNR1);
                          xlabel('Time (s)');
                          ylabel('Amplitude (arbitrary unit)');
                  subplot(3,1,2),plot(secWien, esHRNR2);
                          xlabel('Time (s)');
                          ylabel('Amplitude (arbitrary unit)');
                          
                  subplot(3,1,3),plot(secWien, esHRNR3);
                          xlabel('Time (s)');
                          ylabel('Amplitude (arbitrary unit)');
set(fig7,'name','TS WienerNoiseReduction Outputs');

% PSD
fig8 = figure(8); subplot(3,1,1),psd(esHRNR1,2*2048,2048);
                  subplot(3,1,2),psd(esHRNR2,2*2048,2048);
                  subplot(3,1,3),psd(esHRNR3,2*2048,2048);
                         
set(fig8,'name','PSD WienerNoiseReduction Outputs');    


% Histogram                  
[histWien1,xhistWien1] = hist(esHRNR1,512);
[histWien2,xhistWien2] = hist(esHRNR2,512);
[histWien3,xhistWien3] = hist(esHRNR3,512);

fig9 = figure(9); subplot(3,1,1), bar(xhistWien1,histWien1,'histc');
                  subplot(3,1,2), bar(xhistWien2,histWien2,'histc');
                  subplot(3,1,3), bar(xhistWien3,histWien3,'histc');                  
                  
set(fig9,'name','Histogram Wiener Filter+Normalized');

% Specgrams
fig10 = figure(10); subplot(3,1,1),specgram(esHRNR1,2*2048,2048);
                    subplot(3,1,2),specgram(esHRNR2,2*2048,2048);
                    subplot(3,1,3),specgram(esHRNR3,2*2048,2048);
                         
set(fig10,'name','Specgram WienerNoiseReduction Outputs'); 
                          
%% save plots
folderS = '/gpfs1/LS0231307/Desktop/phys_res/networkTestFigures/';
saveas(fig7,[folderS workspaceSaveDir '_fig7_ts_wiener'],'fig');
saveas(fig8,[folderS workspaceSaveDir '_fig8_psd_wiener'],'fig');
saveas(fig9,[folderS workspaceSaveDir '_fig9_hist_wiener'],'fig');
saveas(fig10,[folderS workspaceSaveDir '_fig10_specgrams_wiener'],'fig');
close all

%


%% whiten  HRNR
filtordr = 10000;

fs1=2048;
t=0:1/fs1:(length(esHRNR1)-1)/fs1;
[pxx,f]=psd(esHRNR1,2*fs1,fs1,[]);
pxx_med_est=rngmed2(pxx,fs1/4); %% Median estimated.



freq=0:1/fs1:1;
bfilt=fir2(filtordr,freq',1./sqrt(pxx_med_est) );
dat_white_DARM1=fftfilt(bfilt,esHRNR1);

fs1=2048;
t=0:1/fs1:(length(esHRNR2)-1)/fs1;
[pxx,f]=psd(esHRNR2,2*fs1,fs1,[]);

pxx_med_est=rngmed2(pxx,fs1/4); %% Median estimated.

% nm = mean(pxx_med_est);
% submeanPXX = nm - pxx_med_est;

freq=0:1/fs1:1;
bfilt=fir2(filtordr,freq',1./sqrt(pxx_med_est) );

dat_white_DARM2=fftfilt(bfilt,esHRNR2);

fs1=2048;
t=0:1/fs1:(length(esHRNR3)-1)/fs1;
[pxx,f]=psd(esHRNR3,2*fs1,fs1,[]);
pxx_med_est=rngmed2(pxx,fs1/4); %% Median estimated.
freq=0:1/fs1:1;
bfilt=fir2(filtordr,freq',1./sqrt(pxx_med_est) );
dat_white_DARM3=fftfilt(bfilt,esHRNR3);



%% normalize filter whit

dat_white_DARM1 = (dat_white_DARM1-mean(dat_white_DARM1))/std(dat_white_DARM1);
dat_white_DARM2 = (dat_white_DARM2-mean(dat_white_DARM2))/std(dat_white_DARM2);
dat_white_DARM3 = (dat_white_DARM3-mean(dat_white_DARM3))/std(dat_white_DARM3);

% % passband corner freq, cutoff
% Wp = [60 800]/(2048/2); 
% % stopband
% Ws = [50 810]/(2048/2);
% % passband riple in db
% Rp = 8; 
% % stopband attenuation in db
% Rs = 10;
% 
% [n, Wn] = buttord(Wp,Ws,Rp,Rs);
% [B,A] = butter(n,Wn,'bandpass');
% 
% filt1 = filter(B,A,dat_white_DARM1);
% filt2 = filter(B,A,dat_white_DARM2);
% filt3 = filter(B,A,dat_white_DARM3);
% 
% %% nomalize filt
% 
% filt1 = (filt1-mean(filt1))/std(filt1);
% filt2 = (filt2-mean(filt2))/std(filt2);
% filt3 = (filt3-mean(filt3))/std(filt3);


%% plots whitened 2

% ts
fig11 = figure(11); subplot(3,1,1),plot(secWien,dat_white_DARM1);
                    subplot(3,1,2),plot(secWien,dat_white_DARM2);
                    subplot(3,1,3),plot(secWien,dat_white_DARM3);
% psd
fig12 = figure(12); subplot(3,1,1),psd(dat_white_DARM1,2*2048,2048);
                    subplot(3,1,2),psd(dat_white_DARM2,2*2048,2048);
                    subplot(3,1,3),psd(dat_white_DARM3,2*2048,2048);

% Specgrams
fig13 = figure(13); subplot(3,1,1),specgram(dat_white_DARM1,2*2048,2048);
                    subplot(3,1,2),specgram(dat_white_DARM2,2*2048,2048);
                    subplot(3,1,3),specgram(dat_white_DARM3,2*2048,2048);
                    
saveas(fig11,[folderS workspaceSaveDir '_fig11_ts_wien_whit'],'fig');
saveas(fig12,[folderS workspaceSaveDir '_fig12_psd_wien_whit'],'fig');
saveas(fig13,[folderS workspaceSaveDir '_fig13_specgrams_wien_whit'],'fig');
close all

%%
% RIDGE
%
disp('Running RIDGE with HRNR, S6 ');
% 1. prepare data for RIDGE

%transpose to save  
H1.data = dat_white_DARM1'; V1.data = dat_white_DARM2'; L1.data = dat_white_DARM3';
% 50 seconds of data, original start_sec = 839544336 stopsec = 839544386;
startsec = 0; stopsec  = 60;
% GPS start and stop seconds
GPSinfo(1,1).GPSinfo.start_sec = startsec; GPSinfo(1,2).GPSinfo.start_sec = startsec;
GPSinfo(1,3).GPSinfo.start_sec = startsec;
GPSinfo(1,1).GPSinfo.stop_sec = stopsec; GPSinfo(1,2).GPSinfo.stop_sec = stopsec;
GPSinfo(1,3).GPSinfo.stop_sec = stopsec;
% save GPS info for H1 H2 L1 
H1.GPSinfo.start_sec = startsec; V1.GPSinfo.start_sec = startsec; 
L1.GPSinfo.start_sec = startsec;
H1.GPSinfo.stop_sec = stopsec; V1.GPSinfo.stop_sec = stopsec; 
L1.GPSinfo.stop_sec = stopsec;
% change freq
H1.fs = 2048; V1.fs = 2048; L1.fs = 2048;

%saving to RIDGE output folder
paramfileLoc = '/gpfs1/LS0231307/Desktop/phys_res/RIDGE/output/';
paramFile = [paramfileLoc HRNRParamFileName];
save(paramFile,'detectors','indatafile','H1','V1','L1','triggername','triggertype','GPSinfo','version');

% 3. change dir to RIDGE
cd('RIDGE');

% initialize if needed
initializeRIDGE

% 5. load RIDGE parameters for nov 7 (high resolution skymaps used)
load may22

s(1).linelistfile = 'linelists/S6_H1L1V1_linelist_fixNOV.mat';

% change to the test data that is being used
paramFileLoc2 = 'output/';
paramFile2 = [paramFileLoc2 HRNRParamFileName '.mat'];
s(1).usenetwork(1,2).detector = 'V1';
s(1).ifodatafile = paramFile2;

% parameters
s(1).overlapfrac = 0;
% skymaps = chunklen/skymapseglen
s(1).chunklen = 10;
s(1).skymapseglen = 0.5;  %0.1
% [ ] is length of first detector
%s(1).lensmapgen = [];
s(1).doconditioning = 'n';
s(1).dodownsampling = 'n';
s(1).startsmapgen = 3; % start skymap generation after GPS sec

% 6. start RIDGE
RIDGEtrigg(resultsFolderName2,s(1));


% == end ==

% close all

disp('RIDGE HRNR finished');

% load conditioned
%load cond_h1h2L1
%disp('Loaded conditioned data');

% 7. going back to phys_res folder
cd('/gpfs1/LS0231307/Desktop/phys_res');

disp('Done all');
%}
save([workspaceSaveDir '_HRNRS6'],'*');
%}








end