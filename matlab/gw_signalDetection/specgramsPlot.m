scale = 5;
wave ='40_13';
workspaceSaveDir = ['may7_wienerWHIT_' num2str(scale) 'scale_grw_' wave '_Wienfilt'];
load([workspaceSaveDir '.mat'],'esHRNR1','esHRNR2','esHRNR3','secWien','sigPad','secS4','dat_white_DARM1','dat_white_DARM2','dat_white_DARM3','S1norm','S2norm','S3norm','Sig1','Sig2','Sig3');

set(0,'DefaultTextFontname', 'Times New Roman')
set(0,'DefaultTextFontSize', 12)

gap =[.08 .003];
margin_h = [.05 .03];
margin_w = [.1 .01];
lim1 = 17.8; lim2 = 27.1;
%{
%% Specgrams Raw
[ B F T] = specgram(Sig1, 16384, 16384, hann(256), 128 );
[ B2 F2 T2] = specgram(Sig2, 16384, 16384, hann(256), 128 );
[ B3 F3 T3] = specgram(Sig3, 16384, 16384, hann(256), 128 );

caxisVals = [25.2274 49.8222];
% caxisVals = [31.7368 49.8222];
rawFig = figure(1);plot(3,1,1);imagesc(T,F,20*log10(abs(B))), axis xy, colormap(jet);
%                 imcontrast(fig);
                title('Spectrogram SN+S4 H1 Data')
                xlabel('Time (s)');
                ylabel('Frequency (Hz)');
                caxis(caxisVals);
                colorbar('location','eastoutside');
                
         plot(3,1,2); imagesc(T2,F2,20*log10(abs(B2))),axis xy;
         title('Spectrogram SN+S4 H2 Data')
           xlabel('Time (s)');
              ylabel('Frequency (Hz)');
%            imcontrast(fig);
           caxis(caxisVals);
           colorbar('location','eastoutside');
           
           plot(3,1,3);imagesc(T3,F3,20*log10(abs(B3))), axis xy;
           title('Spectrogram SN+S4 L1 Data')
           xlabel('Time (s)');
              ylabel('Frequency (Hz)');
%            imcontrast(fig);
           caxis(caxisVals);
           colorbar('location','eastoutside');
          set(rawFig,'DefaultTextFontname', 'Times New Roman') 
          
          %}
% mkdir(['E:\RESEARCH_FUTURO_RIDGE_DATA\mat files\figures_paper_oct232013\' wave]);
% mkdir(['E:\RESEARCH_FUTURO_RIDGE_DATA\mat files\figures_paper_oct232013\' wave '\specgrams']);
% folderS = ['E:\RESEARCH_FUTURO_RIDGE_DATA\mat files\figures_paper_oct232013\' wave '\specgrams\'];
% saveas(rawFig,[folderS workspaceSaveDir '_specgramRaw'],'fig'); 
close all



%% Specgrams Conditioning
fig1 = figure(1);
[ B F T] = specgram(S1norm, 2*2048, 2048, hann(256), 128 );
[ B2 F2 T2] = specgram(S2norm, 2*2048, 2048, hann(256), 128 );
[ B3 F3 T3] = specgram(S3norm, 2*2048, 2048, hann(256), 128 );

% Specgrams HRNR
[ Bh Fh Th] = specgram(esHRNR1, 2*2048, 2048, hann(256), 128 );
[ B2h F2h T2h] = specgram(esHRNR2, 2*2048, 2048, hann(256), 128 );
[ B3h F3h T3h] = specgram(esHRNR3, 2*2048, 2048, hann(256), 128 );

caxisVals = [25.2274 49.8222];
% caxisVals = [31.7368 49.8222];

Condax = tight_subplot(3,2,gap, margin_h, margin_w);
                        % left 1
  axes(Condax(1)) ;imagesc(T,F,20*log10(abs(B))), axis xy, colormap(jet);
%                 imcontrast(fig);
                xlabel('Time (s)');
                ylabel('Frequency (Hz)');
                caxis(caxisVals);
                title('Spectrogram Traditional Conditioning H1');
                colorbar('location','eastoutside');
             
                % right 1
                axes(Condax(2));  imagesc(Th,Fh,20*log10(abs(Bh))), axis xy, colormap(jet);
%                 
                xlabel('Time (s)');
                ylabel('Frequency (Hz)');
                caxis(caxisVals);
                 title('Spectrogram HRNR H1');
                colorbar('location','eastoutside');
                
                
                % left 2
          axes(Condax(3));   imagesc(T2,F2,20*log10(abs(B2))), axis xy;
           xlabel('Time (s)');
               ylabel('Frequency (Hz)');
%            imcontrast(fig);
           caxis(caxisVals);
            title('Spectrogram Traditional Conditioning H2');
           colorbar('location','eastoutside');
           
           % right 2
            axes(Condax(4));   imagesc(T2h,F2h,20*log10(abs(B2h))), axis xy;
           xlabel('Time (s)');
               ylabel('Frequency (Hz)');
%            imcontrast(fig);
           caxis(caxisVals);
           title('Spectrogram HRNR H2');
           colorbar('location','eastoutside');
           
           
           % left 3
            axes(Condax(5));   imagesc(T3,F3,20*log10(abs(B3))), axis xy;
           xlabel('Time (s)');
               ylabel('Frequency (Hz)');
%            imcontrast(fig);
           caxis(caxisVals);
            title('Spectrogram Traditional Conditioning L1');
           colorbar('location','eastoutside');
           
           % right 3
            axes( Condax(6));  imagesc(T3h,F3h,20*log10(abs(B3h))), axis xy;
           xlabel('Time (s)');
                ylabel('Frequency (Hz)');
%            imcontrast(fig);
           caxis(caxisVals);
           title('Spectrogram HRNR L1');
           colorbar('location','eastoutside');
          
linkaxes(Condax,'x');
set(Condax(1:6),'XLim',[lim1 lim2]);
% saveas(fig1(1),[folderS workspaceSaveDir '_specgram_CondandHRNR'],'fig'); 
%  close all
%{
%% Specgrams HRNR
[ B F T] = specgram(esHRNR1, 2*2048, 2048, hann(256), 128 );
[ B2 F2 T2] = specgram(esHRNR2, 2*2048, 2048, hann(256), 128 );
[ B3 F3 T3] = specgram(esHRNR3, 2*2048, 2048, hann(256), 128 );

caxisVals = [25.2274 49.8222];
% caxisVals = [31.7368 49.8222];

HRNRfig = figure(3);  HRNRax(1) = plot(3,1,1);imagesc(T,F,20*log10(abs(B))), axis xy, colormap(jet);
%                 imcontrast(fig);
                xlabel('Time (s)');
                ylabel('Frequency (Hz)');
                caxis(caxisVals);
                 title('Spectrogram HRNR H1');
                colorbar('location','eastoutside');
        HRNRax(2) = plot(3,1,2); imagesc(T2,F2,20*log10(abs(B2))), axis xy;
           xlabel('Time (s)');
               ylabel('Frequency (Hz)');
%            imcontrast(fig);
           caxis(caxisVals);
           title('Spectrogram HRNR H2');
           colorbar('location','eastoutside');
           
          HRNRax(3) = plot(3,1,3); imagesc(T3,F3,20*log10(abs(B3))), axis xy;
           xlabel('Time (s)');
                ylabel('Frequency (Hz)');
%            imcontrast(fig);
           caxis(caxisVals);
           title('Spectrogram HRNR L1');
           colorbar('location','eastoutside');
           
linkaxes(HRNRax,'x');
set(HRNRax(1:3),'XLim',[lim1 lim2]); 
saveas(HRNRfig,[folderS workspaceSaveDir '_specgramHRNR'],'fig'); 
close all


%}
% %% Specgrams DARM
% [ B F T] = specgram(dat_white_DARM1, 2*2048, 2048, hann(256), 128 );
% [ B2 F2 T2] = specgram(dat_white_DARM2, 2*2048, 2048, hann(256), 128 );
% [ B3 F3 T3] = specgram(dat_white_DARM3, 2*2048, 2048, hann(256), 128 );
% 
% caxisVals = [25.2274 49.8222];
% % caxisVals = [31.7368 49.8222];
% DARMfig = figure(2);  DARMax(1) = subplot(3,1,1); imagesc(T,F,20*log10(abs(B))), axis xy, colormap(jet);
% %                 imcontrast(fig);
%                 xlabel('Time (s)');
%                 ylabel('Frequency (Hz)');
%                 caxis(caxisVals);
%                  title('Spectrogram HRNR+Whitening H1');
%                 colorbar('location','eastoutside');
%         DARMax(2)= subplot(3,1,2); imagesc(T2,F2,20*log10(abs(B2))), axis xy;
%            xlabel('Time (s)');
%                 ylabel('Frequency (Hz)');
% %            imcontrast(fig);
%            caxis(caxisVals);
%             title('Spectrogram HRNR+Whitening H2');
%            colorbar('location','eastoutside');
%           DARMax(3)= subplot(3,1,3); imagesc(T3,F3,20*log10(abs(B3))), axis xy;
%            xlabel('Time (s)');
%                ylabel('Frequency (Hz)');
% %            imcontrast(fig);
%            caxis(caxisVals);
%            title('Spectrogram HRNR+Whitening L1');
%            colorbar('location','eastoutside');
%           
%            
% linkaxes(DARMax,'x');
% set(DARMax(1:3),'XLim',[19 30]);           
% saveas(DARMfig,[folderS workspaceSaveDir '_specgramDARM'],'fig');    

%%
% close all
% clear all
%}
