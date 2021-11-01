% Used for plotting Operational Characteristics
clear all
close all
n=1;

% wave = 's25WW_h';
% scales = 5:5:50; %s25ww

% wave = 's15_0_h';
% scales = 5:5:55; %s15_0_h

% wave = 's20_0_h';
% scales = 5:5:65; % s20

% wave = 'm15b6_h';
% scales = 45:5:110; % m15b6

% wave = 's13_0_h';
% scales = 5:5:60; %s13

%  wave = 's11WW_h';
%  scales = 15:5:80; %s11ww

% wave = 's11_2_h';
% scales = 25:5:85; %s11_2

% wave = 'nomoto15_h';
% scales = 20:5:95; %nomoto15

%wave = 'nomoto13_h';
%scales = 35:5:130; % nomoto13


% =========================================


% wave = 'data_GRW_md_h10kpc_12_1';
% scales = 30:5:75; %grw_12_1


% wave = 'data_GRW_md_h10kpc_12_2';
% scales = 25:5:70; %grw_12_2

% wave = 'data_GRW_md_h10kpc_12_3';
% scales = 5:5:50; %grw_12_3

wave = 'data_GRW_md_h10kpc_15_3';
scales = 5:5:50; %grw_15_3

% wave = 'data_GRW_md_h10kpc_15_4';
% scales = 5:5:50; %grw_15_4

% wave = 'data_GRW_md_h10kpc_20_3';
% scales = 15:5:60; %grw_20_3

% wave = 'data_GRW_md_h10kpc_40_10';
% scales = 10:5:55; %grw_40_10

% wave = 'data_GRW_md_h10kpc_40_12';
% scales = 5:5:50; %grw_40_12

% wave = 'data_GRW_md_h10kpc_40_13';
% scales = 5:5:50; %grw_40_13

% wave = 'data_GRW_md_h10kpc_40_6';
% scales = 25:5:70; %grw_40_6

% wave = 'grw_15_3_2';
% wave = 'data_GRW_md_h10kpc_15_3_2';
% scales = 20:5:65; %grw_15_3_2

% wave = 'data_GRW_md_h10kpc_12_2_2';
% scales = 40:5:85; %grw_12_2_2

% wave = 'data_GRW_md_h10kpc_15_3_4';
% scales = 20:5:65; %grw_15_3_4
% 
% wave = 'data_GRW_md_h10kpc_15_3_2';
% scales = 20:5:65; %grw_15_3_2

% wave = 'data_GRW_md_h10kpc_20_3_2';
% scales = 20:5:65; %grw_20_3_2

% wave = 'data_GRW_md_h10kpc_20_3_4';
% scales = 10:5:55; %grw_20_3_4
% 
% wave = 'data_GRW_md_h10kpc_20_3_6';
% scales = 10:5:55; %grw_20_3_6

load('murphyetal2009',wave);
% load('murphyetal2009_fix',wave);

% change this to used scale
load(['S6june11_wienerWHIT_' int2str(40) 'scale_' wave '_WienfiltS6.mat'],'secSnorm','secWien','secS6','secSN','snTime','sigPad','Sig1');
waver = 'grw\_15\_3';
radNum = 7;
SN = data_GRW_md_h10kpc_15_3(:,2);  %========



mo=1;
nm=1;

init = 0;

radcount = 1;
for m=1:2
 for i=scales
    
     
     
stepNum = m;
snrNum = i; 


% if i==0
%     
%     snrNum=1;
% end

date = 'S6june11_wienerWHIT_';
snr = 'scale_';
step = 'step';
results = '_results';
stats = 'stats_';

cd('RIDGE'); disp('Entering RIDGE folder');


strFolder = [date int2str(snrNum) snr wave '_' step int2str(stepNum)  results]

cd(strFolder); disp(['Entering: ' strFolder]);
strStats = [stats date int2str(snrNum) snr wave '_' step int2str(stepNum)]
load(strStats, 'radialdist');

% max
[maxrad,indx] = max(radialdist);  
% length
lengthDist = length(radialdist);

gw_maxrad(stepNum,nm) = maxrad;

[valS, indxS] = sort(radialdist,'descend');

%% spaghetti code
stdValS = std(valS); % std of radial distances sorted in descde
distSTDValS = 0;
            
% calculate distance from std radialdist to sorted radialdistances
for mo=1:lengthDist
        distSTDValS(mo) = dist(stdValS, valS(mo));        
end
% sort to find closest value to std radialdist
[valSdist, indxSdist] = sort(distSTDValS,'ascend');
    
% use this index to find distance to max radialdist
dista(m,nm) = dist(maxrad,valS(indxSdist(1)));



%plot radial distances with line
% bn = figure; scatter(1:lengthDist,radialdist);
%         hold on
%         hline = refline([0 valS(indxSdist(1))]);
%         hold off
%         set(hline,'Color','r');
%         set(bn,'name',[ 'step ' int2str(m) ' scale ' int2str(i) ]);
%
if init==0;
    radialD_step1{1} = zeros(1,lengthDist);
    radialD_step2{1} = zeros(1,lengthDist);
    init=1;
end

if m==1
    radialD_step1{radcount,1} = radialdist;
    radialD_step1{radcount,2} = i;
end
if m==2
    radialD_step2{radcount,1} = radialdist;
     radialD_step2{radcount,2} = i;
end
lengthDD = length(dista(1,:));




radcount=radcount+1;
    
nm=nm+1;


 cd('/gpfs1/LS0231307/Desktop/phys_res');
 end
nm=1;

radcount=1;
end


% change fonts

% plot OP
f1=figure;



f1,subplot(2,3,1),
plot(scales,dista(1,:),'b--o','linewidth',1);
hold on
plot(scales,dista(2,:),'r--o','linewidth',1);
hold off

title('Operational Characteristics');
set(f1,'name','Operational Characteristics');
xlabel('Signal Strength (scale)');
ylabel('Detection SNR');
legend('Network','DeNoising+Network','Location','NorthWest');




%
% plot wave
text('interpreter','none');
h0 = subplot(2,3,2); plot(secSN,SN);   %=========================
title(['Gravitational Wave: ' waver]);
xlabel('Time (seconds)');
ylabel('Amplitude');


% plot signal+noise
sigPad = sigPad*(1e18);

subplot(2,3,3), plot(secS6,Sig1);
hold on
plot(secS6,sigPad,'red');
hold off
title('H1 GW Signal + Noise');
xlabel('Time (seconds)');
ylabel('Amplitude');
legend('S4 data','Injected signal','Location','NorthWest');

% plot radial stats with and without
Fsn = ceil(lengthDist/60);
secRad1 = 0:(1/Fsn):( (   (length(radialD_step1{1,1})  )-1)/Fsn );
secRad2 = 0:(1/Fsn):( (   (length(radialD_step2{1,1})  )-1)/Fsn );

% radnum

h1 = subplot(2,3,4); scatter(secRad1,radialD_step1{radNum,:} , '+','SizeData',60);

title(['Radial Distance at scale ' int2str(radialD_step1{radNum,2})]);
xlabel('Time (seconds)');

h2 = subplot(2,3,5); scatter(secRad2,radialD_step2{radNum,:} ,'+','SizeData',60);

title(['Radial Distance (with DeNoising) at scale ' int2str(radialD_step2{radNum,2})]);
xlabel('Time (seconds)');

set(h0,'position',[0.416583529644962 0.583837209302325 0.213405797101449 0.341162790697674]);
set(h1,'position',[0.275728723319464 0.143333333333333 0.213405797101449 0.341162790697674]);
set(h2,'position',[0.583033723322929 0.143333333333333 0.213405797101449 0.341162790697674]);

flog = figure;

flog,subplot(2,1,1),semilogy(dista(1,:),'-s'); 
title('Operational Characteristics in Log');
subplot(2,1,2),semilogy(dista(2,:),'-s','Color','r');
% grid on

% xlabel('Signal Strength (scale)');
% ylabel('Detection SNR');
% subplot(2,1,2),loglog(scales,dista(2,:),'-s' ,'Color','r');
% grid on
% set(flog,'name','Operational Characteristics Log');
% xlabel('Signal Strength (scale)');
% ylabel('Detection SNR');

folderS = '/gpfs1/LS0231307/Desktop/phys_res/S6june11_op/';
saveas(f1,[folderS wave '_op'],'fig');
saveas(flog,[folderS wave '_log'],'fig');
% save radial stats
save([folderS 'radialD_step1_' wave],'radialD_step1');
save([folderS 'radialD_step2_' wave],'radialD_step2');


%}







