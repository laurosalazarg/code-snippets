% cal snrs
function cal_SNRS6(SNo,snTime,scale,paramFileName, resultsFolderName1, HRNRParamFileName, resultsFolderName2, workspaceSaveDir )

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

% star collapse wave edit
%SNo = SNo*(1e-20);

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

%% plots
% s4 data + SN signal (red)
% fig1 = figure(1); plot(secS4,s4h1);
% hold on
% plot(secS4,sigPad,'red');
% hold off
% set(fig1,'name','S4 Data + SN Signal (red)');
% xlabel('Time (s)');
% ylabel('Amplitude (arbitrary unit)');


%% SNR


top = sum(SNresh.^2); % SN resampled
lengthSN = length(SNresh);
sPrim = top;
snrH1 = sPrim/std(S6H1);
snrV1 = sPrim/std(S6V1);
snrL1 = sPrim/std(S6L1);

disp(['SNRs ' 'scale ' num2str(scale) ' | ' num2str(snrH1) ' | ' num2str(snrV1) ' | ' num2str(snrL1)]);

%% test snr

% resample SN to 16384
SNreshNEW = resample(SN,ridgeFs, Fsn);
disp(['SN Orig Freq | ' num2str(Fsn) ]);
% length of resampled SN
LSN = length(SNreshNEW);
disp(['SN Length Orig | ' num2str(samplesSN) ]);
disp(['SN Length resampled | ' num2str(LSN) ]);
disp(['S6 Length  | ' num2str(length(S6H1)) ]);
% Frequency of resampled SN
FsnNew = floor(LSN/snTime);
disp(['SN Resampled Freq | ' num2str(FsnNew) ]);
disp(['S6 Freq | ' num2str(ridgeFs) ]);
% duration of resampled SN
secSNNEW = 0:(1/FsnNew):( (LSN-1)/FsnNew );

 
% fft SN at 8192
fftSN = fft(SNreshNEW,ridgeFs/2);
% abs.^2
absFFT = abs(fftSN).^2;

% PSD
[pxxh1,wh1]=psd(S6H1,2*8192-2,16384,[]);
pxx_med_esth1=rngmed2(pxxh1,16384/2); %% Median estimated.

[pxxh2,wh2]=psd(S6V1,2*8192-2,16384,[]);
pxx_med_esth2=rngmed2(pxxh2,16384/2); %% Median estimated.

[pxxL1,wL1]=psd(S6L1,2*8192-2,16384,[]);
pxx_med_estL1=rngmed2(pxxL1,16384/2); %% Median estimated.


disp(['absFFT length | ' num2str(length(absFFT)) ]);
disp(['pxxh1 length | ' num2str(length(pxxh1)) ]);

% SNR
SNRNEWH1 = sqrt(2*(sum(absFFT./pxx_med_esth1') ) );
SNRNEWH2 = sqrt(2*(sum(absFFT./pxx_med_esth2') ) );
SNRNEWL1 = sqrt(2*(sum(absFFT./pxx_med_estL1') ) );

disp(['New  SNR ' 'scale ' num2str(scale) ' | ' num2str(SNRNEWH1) ' | ' num2str(SNRNEWH2) ' | ' num2str(SNRNEWL1)]);
 



SNRNEWH1/scale


