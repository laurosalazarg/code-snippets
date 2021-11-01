% Used for plotting the following:
% TS conditioned, TS whitened, PSD conditioned, PSD HRNR, PSD whitened,
% Histograms, Specgrams conditioned, Spec HRNR, Spec whitened, PSD S5/S6
% Data, TS H1 V1 L1, PSD H1 V1 L1


%{
f1 = figure(1); plot(allStats_s25ww(3,:),allStats_s25ww(1,:));
hold on
plot(allStats_s25ww(3,:),allStats_s25ww(2,:),'red');
hold off
set(f1,'name','Operational Characteristics');
xlabel('Signal Strength (scale)');
ylabel('Pr');
legend('Network','DeNoising+Network','Location','NorthWest');
%}

%
%wave = 's25WW_h';
%scales = 5:5:50; %s25ww

%wave = 's15_0_h';
%scales = 5:5:55; %s15_0_h

%wave = 's20_0_h';
%scales = 5:5:65; % s20

%wave = 'm15b6_h';
%scales = 45:5:110; % m15b6

% wave = 's13_0_h';
% scales = 5:5:60; %s13

%wave = 's11WW_h';
%scales = 15:5:80; %s11ww

%wave = 's11_2_h';
%scales = 25:5:85; %s11_2

%wave = 'nomoto15_h';
%scales = 20:5:95; %nomoto15

%wave = 'nomoto13_h';
%scales = 35:5:130; % nomoto13


% ==============================================

wave = 'data_GRW_md_h10kpc_12_1';
scales = 30:5:75; %grw_12_1

% wave = 'data_GRW_md_h10kpc_12_2_2';
% scales = 25:5:70; %grw_12_2


% wave = 'data_GRW_md_h10kpc_12_2';
% scales = 25:5:70; %grw_12_2

% wave = 'data_GRW_md_h10kpc_12_3';
% scales = 5:5:50; %grw_12_3

% wave = 'data_GRW_md_h10kpc_15_3';
% scales = 5:5:50; %grw_15_3

% wave = 'data_GRW_md_h10kpc_15_4';
% scales = 5:5:50; %grw_15_4

% wave = 'data_GRW_md_h10kpc_20_3';
% scales = 15:5:60; %grw_20_3

% wave = 'data_GRW_md_h10kpc_40_10';
% scales = 5:5:50; %grw_40_10


% wave = 'data_GRW_md_h10kpc_40_12';
% scales = 5:5:50; %grw_40_12

% wave = 'data_GRW_md_h10kpc_40_13';
% scales = 5:5:50; %grw_40_13

% wave = 'data_GRW_md_h10kpc_40_6';
% scales = 25:5:70; %grw_40_6

%wave = 'grw_15_3_2';
% wave = 'data_GRW_md_h10kpc_15_3_2';
% scales = 20:5:65; %grw_15_3_2

% wave = 'data_GRW_md_h10kpc_12_2_2';
% scales = 40:5:85; %grw_12_2_2

% wave = 'data_GRW_md_h10kpc_15_3_4';
% scales = 20:5:65; %grw_15_3_4

% wave = 'data_GRW_md_h10kpc_20_3_2';
% scales = 20:5:65; %grw_20_3_2

% wave = 'data_GRW_md_h10kpc_20_3_4';
% scales = 10:5:55; %grw_20_3_4

% wave = 'data_GRW_md_h10kpc_20_3_6';
% scales = 10:5:55; %grw_20_3_6

load('murphyetal2009',wave);
% load('murphyetal2009_fix',wave);

for i=40
scaleNum = i;
%wave = 's25WW_h'; 
scale = 'scale'; 

load(['S6june11_wienerWHIT_' int2str(scaleNum) 'scale_' wave '_WienfiltS6.mat'],'Sig1','Sig2','Sig3','S1norm','S2norm','S3norm','esHRNR1'...
    ,'esHRNR2','esHRNR3','dat_white_DARM1','dat_white_DARM2','dat_white_DARM3','secSnorm','secWien','workspaceSaveDir','S6H1','S6V1','S6L1','secS6');

% Wiener plots

%%

% TS conditioned
fig1 = figure(1); subplot(3,1,1),plot(secSnorm, S1norm); 
                                 hold on
                                 plot(secWien, esHRNR1,'red');
                                 hold off
                          xlabel('Time (s)');
                          ylabel('Amplitude (arbitrary unit)');
                          legend('Conditioned','WienerFilter','Location','NorthEast');
                          
                  subplot(3,1,2),plot(secSnorm, S2norm); 
                                 hold on
                                 plot(secWien, esHRNR2,'red');
                                 hold off
                          xlabel('Time (s)');
                          ylabel('Amplitude (arbitrary unit)');
                          legend('Conditioned','WienerFilter','Location','NorthEast');
                          
                  subplot(3,1,3),plot(secSnorm, S3norm); 
                                 hold on
                                 plot(secWien, esHRNR3,'red');
                                 hold off
                          xlabel('Time (s)');
                          ylabel('Amplitude (arbitrary unit)');
                          legend('Conditioned','WienerFilter','Location','NorthEast');
set(fig1,'name','TS Conditioned Outputs');


% TS Wiener
% fig2 = figure(2); subplot(3,1,1),plot(secWien, esHRNR1);
%                           xlabel('Time (s)');
%                           ylabel('Amplitude (arbitrary unit)');
%                   subplot(3,1,2),plot(secWien, esHRNR2);
%                           xlabel('Time (s)');
%                           ylabel('Amplitude (arbitrary unit)');
%                           
%                   subplot(3,1,3),plot(secWien, esHRNR3);
%                           xlabel('Time (s)');
%                           ylabel('Amplitude (arbitrary unit)');
% set(fig2,'name','TS WienerNoiseReduction Outputs');


% TS Darm
fig3 = figure(3); subplot(3,1,1),plot(secWien, dat_white_DARM1);
                          xlabel('Time (s)');
                          ylabel('Amplitude (arbitrary unit)');
                  subplot(3,1,2),plot(secWien, dat_white_DARM2);
                          xlabel('Time (s)');
                          ylabel('Amplitude (arbitrary unit)');
                          
                  subplot(3,1,3),plot(secWien, dat_white_DARM3);
                          xlabel('Time (s)');
                          ylabel('Amplitude (arbitrary unit)');
set(fig3,'name','TS Darm Outputs');

%%
% ==== PSD =====


% PSD Conditioned
fig4 = figure(4); subplot(3,1,1),psd(S1norm,2*2048,2048);
                  subplot(3,1,2),psd(S2norm,2*2048,2048);
                  subplot(3,1,3),psd(S3norm,2*2048,2048);
                         
set(fig4,'name','PSD Conditioned Outputs'); 


% PSD wiener
fig5 = figure(5); subplot(3,1,1),psd(esHRNR1,2*2048,2048);
                  subplot(3,1,2),psd(esHRNR2,2*2048,2048);
                  subplot(3,1,3),psd(esHRNR3,2*2048,2048);
                         
set(fig5,'name','PSD WienerNoiseReduction Outputs');   

% PSD Darm
fig6 = figure(6); subplot(3,1,1),psd(dat_white_DARM1,2*2048,2048);
                  subplot(3,1,2),psd(dat_white_DARM2,2*2048,2048);
                  subplot(3,1,3),psd(dat_white_DARM3,2*2048,2048);
                         
set(fig6,'name','PSD Darm Outputs');  


% PSD Orig
fig11 = figure(11); subplot(3,1,1),psd(Sig1,2*16384,16384);
                  subplot(3,1,2),psd(Sig2,2*16384,16384);
                  subplot(3,1,3),psd(Sig3,2*16384,16384);
                         
set(fig11,'name','PSD GW+S4 Data Outputs'); 


%%

% === Histogram ====


% Histogram conditioned
[histS1norm,xhistS1norm] = hist(S1norm,512);
[histS2norm,xhistS2norm] = hist(S2norm,512);
[histS3norm,xhistS3norm] = hist(S3norm,512);

% Histogram wiener                  
[histWien1,xhistWien1] = hist(esHRNR1,512);
[histWien2,xhistWien2] = hist(esHRNR2,512);
[histWien3,xhistWien3] = hist(esHRNR3,512);

% Histogram whitened DARM
[histDarm1,xhistDarm1] = hist(dat_white_DARM1,512);
[histDarm2,xhistDarm2] = hist(dat_white_DARM2,512);
[histDarm3,xhistDarm3] = hist(dat_white_DARM3,512);


fig7 = figure(7); subplot(3,1,1), b1 = bar(xhistS1norm,histS1norm,'histc'); 
                                  hold on
                                  b2 = bar(xhistWien1,histWien1,'histc'); set(b2, 'FaceColor', 'r');
                                  hold off
                                  xlabel('Frequency');
                                  ylabel('Count');
                                  legend('Conditioned','WienerFilter','Location','NorthEast');
%                                   hold on
%                                   b3 = bar(xhistDarm1,histDarm1,'histc'); set(b3, 'FaceColor', 'g');
%                                   hold off
                                  
                  subplot(3,1,2), b3 = bar(xhistS2norm,histS2norm,'histc'); 
                                  hold on
                                  b4 = bar(xhistWien2,histWien2,'histc'); set(b4, 'FaceColor', 'r');
                                  hold off
                                   xlabel('Frequency');
                                  ylabel('Count');
                                  legend('Conditioned','WienerFilter','Location','NorthEast');
                                  
                  subplot(3,1,3), b5 = bar(xhistS3norm,histS3norm,'histc'); 
                                  hold on
                                  b6 = bar(xhistWien3,histWien3,'histc'); set(b6, 'FaceColor', 'r');
                                  hold off  
                                   xlabel('Frequency');
                                  ylabel('Count');
                                  legend('Conditioned','WienerFilter','Location','NorthEast');
                  
set(fig7,'name','Histogram Conditioned and Wiener Filter');

%%

% specgram thresholds
threshLower = 35; threshHigher = 60;


% Specgrams conditioned
fig8 = figure(8);   subplot(3,1,1),specgram(S1norm,2*2048,2048);
                    

                    subplot(3,1,2),specgram(S2norm,2*2048,2048);
                    subplot(3,1,3),specgram(S3norm,2*2048,2048);
                         
set(fig8,'name','Specgram Conditioned Outputs'); 

% Specgrams wiener
fig9 = figure(9);   subplot(3,1,1),specgram(esHRNR1,2*2048,2048);
                    subplot(3,1,2),specgram(esHRNR2,2*2048,2048);
                    subplot(3,1,3),specgram(esHRNR3,2*2048,2048);
                         
set(fig9,'name','Specgram WienerNoiseReduction Outputs'); 

% Specgrams darml


%[b1,f1,t1] =  specgram(dat_white_DARM1(1500:length(dat_white_DARM1)),2*2048,2048);
   
fig10 = figure(10);   subplot(3,1,1),specgram(dat_white_DARM1(1500:length(dat_white_DARM1)),2*2048,2048);

                    subplot(3,1,2),specgram(dat_white_DARM2(1500:length(dat_white_DARM2)),2*2048,2048);
                    
                    subplot(3,1,3),specgram(dat_white_DARM3(1500:length(dat_white_DARM3)),2*2048,2048);
                         
set(fig10,'name','Specgram Whitened Outputs'); 



fig12 = figure(12);   subplot(3,1,1),plot(secS6,S6H1);
                        xlabel('Time (s)');
                        ylabel('Amplitude');
                        title('S6H1');

                    subplot(3,1,2),plot(secS6,S6V1);
                     xlabel('Time (s)');
                        ylabel('Amplitude');
                        title('S6V1');
                    
                    subplot(3,1,3),plot(secS6,S6L1);
                     xlabel('Time (s)');
                        ylabel('Amplitude');
                        title('S6L1');
                         
set(fig12,'name','Specgram Whitened Outputs');


% PSD H1 V1 L1
fig13 = figure(13); subplot(3,1,1),psd(S6H1,2*16384,16384);
                  subplot(3,1,2),psd(S6V1,2*16384,16384);
                  subplot(3,1,3),psd(S6L1,2*16384,16384);
                         
set(fig13,'name','PSD H1 V1 L1'); 



%%

subfold = [wave '_' int2str(scaleNum) scale  '/'];
mkdir(['/gpfs1/LS0231307/Desktop/phys_res/figuresfinal_june11S6/' subfold ] );
% save plots
folderS = ['/gpfs1/LS0231307/Desktop/phys_res/figuresfinal_june11S6/' subfold];
saveas(fig1,[folderS workspaceSaveDir '_fig1_ts_cond'],'fig');
%saveas(fig2,[folderS workspaceSaveDir '_fig2_ts_wien'],'fig');
saveas(fig3,[folderS workspaceSaveDir '_fig3_ts_darm'],'fig');
saveas(fig4,[folderS workspaceSaveDir '_fig4_psd_cond'],'fig');
saveas(fig5,[folderS workspaceSaveDir '_fig5_psd_wien'],'fig');
saveas(fig6,[folderS workspaceSaveDir '_fig6_psd_darm'],'fig');
saveas(fig7,[folderS workspaceSaveDir '_fig7_hist'],'fig');
saveas(fig8,[folderS workspaceSaveDir '_fig8_spec_cond'],'fig');
saveas(fig9,[folderS workspaceSaveDir '_fig9_spec_wien'],'fig');
saveas(fig10,[folderS workspaceSaveDir '_fig10_spec_darm'],'fig');
saveas(fig11,[folderS workspaceSaveDir '_fig11_psd_gw_s4'],'fig');
saveas(fig12,[folderS workspaceSaveDir '_fig12_TS_H1V1L1'],'fig');
saveas(fig13,[folderS workspaceSaveDir '_fig12_PSD_H1V1L1'],'fig');
%clear all
close all


end

%}




