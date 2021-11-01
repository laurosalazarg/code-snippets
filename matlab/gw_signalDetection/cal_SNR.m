% cal snrs
function cal_SNR(SNo,snTime,scale,paramFileName, resultsFolderName1, HRNRParamFileName, resultsFolderName2, workspaceSaveDir )

% example run: snDetect(s11WW_h, 1.447, 14,'testdata_feb5_14snr_s11','feb5_14snr_s11_step1'
%                       ,'testdata_feb5_14snr_s11_MUK','feb5_14snr_s11_step3','feb5_14snr_s11')

%%
warning off
% load sample testdata to modify later
load('/gpfs1/LS0231307/Desktop/phys_res/RIDGE/output/testdata.mat');

SNo = SNo(:,2)';

% star collapse wave editl
%SNo = SNo*(1e-20);

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
Fsn = floor(samplesSN/snTime);

SNresh = resample(SN,ridgeFs/2, Fsn);

% samples resampled SN
samplesSNresampled = length(SNresh);
% Freq resampled Fsn
Fsnresampled = floor(samplesSNresampled/snTime);

% seconds, SN signal
secSN = 0:(1/Fsn):( (samplesSN-1)/Fsn );

% resampled SN seconds
secSNresampled =  0:(1/Fsnresampled):( ( samplesSNresampled-1)/Fsnresampled );

% seconds, s4 data
secS4 = 0:(1/ridgeFs):( (s4dataL-1)/ridgeFs );


% figure,plot(secSN,SN);
% figure,plot(secSNresampled,SNresh);
% prepare for padding
sigPad = zeros(1,s4dataL); tempsig = zeros(1,s4dataL);

% inserting and padding 1 SN signal (sgw,samples,location)
tempsig = paddSignal_gw(SNresh,s4dataL,369680);
sigPad = sigPad+tempsig;

%%

% add SN to s4 data
Sig1 = sigPad+s4h1;  
Sig2 = sigPad+s4h2;  
Sig3 = sigPad+s4L1;  

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
top = sqrt(sum(sigPad.^2)); % SN resampled
lengthSN = length(sigPad);
sPrim = top/lengthSN;
snrH1 = sPrim/std(s4h1);
snrH2 = sPrim/std(s4h2);
snrL1 = sPrim/std(s4L1);

disp(['SNRs ' 'scale ' num2str(scale) ' | ' num2str(snrH1) ' | ' num2str(snrH2) ' | ' num2str(snrL1)]);

%% test snr

% resample SN to 16384
SNreshNEW = resample(SN,ridgeFs, Fsn);
disp(['SN Orig Freq | ' num2str(Fsn) ]);
% length of resampled SN
LSN = length(SNreshNEW);
disp(['SN Length Orig | ' num2str(samplesSN) ]);
disp(['SN Length resampled | ' num2str(LSN) ]);
disp(['S4 Length  | ' num2str(length(s4h1)) ]);
% Frequency of resampled SN
FsnNew = floor(LSN/snTime);
disp(['SN Resampled Freq | ' num2str(FsnNew) ]);
disp(['S4 Freq | ' num2str(ridgeFs) ]);
% duration of resampled SN
secSNNEW = 0:(1/FsnNew):( (LSN-1)/FsnNew );

 
% fft SN at 8192
fftSN = fft(SNreshNEW,ridgeFs/2);
% abs.^2
absFFT = abs(fftSN).^2;

% PSD
[pxxh1,wh1]=psd(s4h1,2*8192-2,16384,[]);
pxx_med_esth1=rngmed2(pxxh1,16384/2); %% Median estimated.

[pxxh2,wh2]=psd(s4h2,2*8192-2,16384,[]);
pxx_med_esth2=rngmed2(pxxh2,16384/2); %% Median estimated.

[pxxL1,wL1]=psd(s4L1,2*8192-2,16384,[]);
pxx_med_estL1=rngmed2(pxxL1,16384/2); %% Median estimated.


disp(['absFFT length | ' num2str(length(absFFT)) ]);
disp(['pxxh1 length | ' num2str(length(pxxh1)) ]);

% SNR
SNRNEWH1 = sqrt(2*(sum(absFFT./pxx_med_esth1') ) );
SNRNEWH2 = sqrt(2*(sum(absFFT./pxx_med_esth2') ) );
SNRNEWL1 = sqrt(2*(sum(absFFT./pxx_med_estL1') ) );

disp(['New  SNR ' 'scale ' num2str(scale) ' | ' num2str(SNRNEWH1) ' | ' num2str(SNRNEWH2) ' | ' num2str(SNRNEWL1)]);
 



SNRNEWH1/scale









