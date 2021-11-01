%  waves, murphy                                  % luminosity
load('murphyetal2009','data_GRW_md_h10kpc_12_1'); % 1.8
load('murphyetal2009','data_GRW_md_h10kpc_12_2'); % 2.8
load('murphyetal2009_fix','data_GRW_md_h10kpc_12_2_2');
load('murphyetal2009','data_GRW_md_h10kpc_12_3'); % 3.2

load('murphyetal2009','data_GRW_md_h10kpc_15_3'); % 3.7
load('murphyetal2009_fix','data_GRW_md_h10kpc_15_3_2');
load('murphyetal2009_fix','data_GRW_md_h10kpc_15_3_4');
load('murphyetal2009','data_GRW_md_h10kpc_15_4'); % 4.0

load('murphyetal2009','data_GRW_md_h10kpc_20_3'); %3.8
load('murphyetal2009_fix','data_GRW_md_h10kpc_20_3_2');
load('murphyetal2009_fix','data_GRW_md_h10kpc_20_3_4');
load('murphyetal2009_fix','data_GRW_md_h10kpc_20_3_6');

load('murphyetal2009','data_GRW_md_h10kpc_40_10');
load('murphyetal2009','data_GRW_md_h10kpc_40_12');
load('murphyetal2009','data_GRW_md_h10kpc_40_13');
load('murphyetal2009','data_GRW_md_h10kpc_40_6'); %6.0

% Murphy et al. wave times
Time12_1 = 0.9883; % grw_12_1
Time12_2 = 0.87; % grw_12_2
Time12_3 = 0.7750; % grw_12_3
Time15_3 = 1.2812; %grw_15_3
Time15_4 = 1.19; %grw_15_4
Time20_3 = 1.2834; %grw_20_3
Time40_10 = 1.2769; % grw_40_10
Time40_12 = 1.1150; %grw_40_12
Time40_13 = 0.79; %grw_40_13
Time40_6 = 1.2042; %grw_40_6
Time12_2_2 = 1.0452; %grw_12_2_2
Time15_3_4 = 1.2573; %grw_15_3_4
Time15_3_2 = 1.282;%grw_15_3_2
Time20_3_2 = 1.2568;% grw_20_3_2
Time20_3_4 = 1.2605; %grw_20_3_4
Time20_3_6 = 1.2571;%grw_20_3_6

% samples
% Freq
Fsn1 = floor(length(data_GRW_md_h10kpc_12_1(:,2))/Time12_1); secSN1 = 0:(1/Fsn1):( (length(data_GRW_md_h10kpc_12_1(:,2))-1)/Fsn1 );
Fsn2 = floor(length(data_GRW_md_h10kpc_12_2(:,2))/Time12_2); secSN2 = 0:(1/Fsn2):( (length(data_GRW_md_h10kpc_12_2(:,2))-1)/Fsn2 );
Fsn3 = floor(length(data_GRW_md_h10kpc_12_2_2(:,2))/Time12_2_2); secSN3 = 0:(1/Fsn3):( (length(data_GRW_md_h10kpc_12_2_2(:,2))-1)/Fsn3 );
Fsn4 = floor(length(data_GRW_md_h10kpc_12_3(:,2))/Time12_3); secSN4 = 0:(1/Fsn4):( (length(data_GRW_md_h10kpc_12_3(:,2))-1)/Fsn4 );

Fsn5 = ceil(length(data_GRW_md_h10kpc_15_3(:,2))/Time15_3); secSN5 = 0:(1/Fsn5):( (length(data_GRW_md_h10kpc_15_3(:,2))-1)/Fsn5 );
Fsn6 = floor(length(data_GRW_md_h10kpc_15_3_2(:,2))/Time15_3_2); secSN6 = 0:(1/Fsn6):( (length(data_GRW_md_h10kpc_15_3_2(:,2))-1)/Fsn6 );
Fsn7 = ceil(length(data_GRW_md_h10kpc_15_3_4(:,2))/Time15_3_4); secSN7 = 0:(1/Fsn7):( (length(data_GRW_md_h10kpc_15_3_4(:,2))-1)/Fsn7 );
Fsn8 = floor(length(data_GRW_md_h10kpc_15_4(:,2))/Time15_4); secSN8 = 0:(1/Fsn8):( (length(data_GRW_md_h10kpc_15_4(:,2))-1)/Fsn8 );

Fsn9 = ceil(length(data_GRW_md_h10kpc_20_3(:,2))/Time20_3); secSN9 = 0:(1/Fsn9):( (length(data_GRW_md_h10kpc_20_3(:,2))-1)/Fsn9 );
Fsn10 = floor(length(data_GRW_md_h10kpc_20_3_2(:,2))/Time20_3_2); secSN10 = 0:(1/Fsn10):( (length(data_GRW_md_h10kpc_20_3_2(:,2))-1)/Fsn10 );
Fsn11 = floor(length(data_GRW_md_h10kpc_20_3_4(:,2))/Time20_3_4); secSN11 = 0:(1/Fsn11):( (length(data_GRW_md_h10kpc_20_3_4(:,2))-1)/Fsn11 );
Fsn12 = floor(length(data_GRW_md_h10kpc_20_3_6(:,2))/Time20_3_6); secSN12 = 0:(1/Fsn12):( (length(data_GRW_md_h10kpc_20_3_6(:,2))-1)/Fsn12 );

Fsn13 = ceil(length(data_GRW_md_h10kpc_40_10(:,2))/Time40_10); secSN13 = 0:(1/Fsn13):( (length(data_GRW_md_h10kpc_40_10(:,2))-1)/Fsn13 );
Fsn14 = ceil(length(data_GRW_md_h10kpc_40_12(:,2))/Time40_12); secSN14 = 0:(1/Fsn14):( (length(data_GRW_md_h10kpc_40_12(:,2))-1)/Fsn14 );
Fsn15 = floor(length(data_GRW_md_h10kpc_40_13(:,2))/Time40_13); secSN15 = 0:(1/Fsn15):( (length(data_GRW_md_h10kpc_40_13(:,2))-1)/Fsn15 );
Fsn16 = floor(length(data_GRW_md_h10kpc_40_6(:,2))/Time40_6); secSN16 = 0:(1/Fsn16):( (length(data_GRW_md_h10kpc_40_6(:,2))-1)/Fsn16);



N = 16;
ha = tight_subplot(8,2,[.06 .03],[.1 .03],[.01 .01])
         axes(ha(1)); plot(secSN1, data_GRW_md_h10kpc_12_1(:,2));
         title('GRW\_12, 1.8 Luminosity');
         axis tight
         axes(ha(2)); plot(secSN3, data_GRW_md_h10kpc_12_2_2(:,2));
         title('GRW\_12, 2.2 Luminosity');
         axis tight
         axes(ha(3)); plot(secSN2, data_GRW_md_h10kpc_12_2(:,2));
         title('GRW\_12, 2.8 Luminosity');
         axis tight
         axes(ha(4)); plot(secSN4, data_GRW_md_h10kpc_12_3(:,2));
         title('GRW\_12, 3.2 Luminosity');
         axis tight
         
         axes(ha(5)); plot(secSN6, data_GRW_md_h10kpc_15_3_2(:,2));
         title('GRW\_15, 3.2 Luminosity');
         axis tight
         axes(ha(6)); plot(secSN7, data_GRW_md_h10kpc_15_3_4(:,2));
         title('GRW\_15, 3.4 Luminosity');
         axis tight
         axes(ha(7)); plot(secSN5, data_GRW_md_h10kpc_15_3(:,2));
         title('GRW\_15, 3.7 Luminosity');
         axis tight
         axes(ha(8)); plot(secSN8, data_GRW_md_h10kpc_15_4(:,2));
         title('GRW\_15, 4.0 Luminosity');
         axis tight
         
        
         axes(ha(9)); plot(secSN10, data_GRW_md_h10kpc_20_3_2(:,2));
         title('GRW\_20, 3.2 Luminosity');
         axis tight
         axes(ha(10)); plot(secSN11, data_GRW_md_h10kpc_20_3_4(:,2));
         title('GRW\_20, 3.4 Luminosity');
         axis tight
         axes(ha(11)); plot(secSN12, data_GRW_md_h10kpc_20_3_6(:,2));
         title('GRW\_20, 3.6 Luminosity');
         axis tight
          axes(ha(12)); plot(secSN9, data_GRW_md_h10kpc_20_3(:,2));
         title('GRW\_20, 3.8 Luminosity');
         axis tight

         axes(ha(13)); plot(secSN16, data_GRW_md_h10kpc_40_6(:,2));
         title('GRW\_40, 6.0 Luminosity');
         axis tight
         axes(ha(14)); plot(secSN13, data_GRW_md_h10kpc_40_10(:,2));
         title('GRW\_40, 10.0 Luminosity');
         axis tight
         axes(ha(15)); plot(secSN14, data_GRW_md_h10kpc_40_12(:,2));
         title('GRW\_40, 12.0 Luminosity');
         axis tight
         xlabel('Time (s)'); 
         axes(ha(16)); plot(secSN15, data_GRW_md_h10kpc_40_13(:,2));
         title('GRW\_40, 13.0 Luminosity');
         xlabel('Time (s)');
        axis tight
         xlabel('Time (s)');  
          
%           set(ha(1:14),'XTickLabel',''); set(ha,'YTickLabel','')
set(ha(1:16),'YGrid','on','Box','off','FontName','Times New Roman','FontSize', 8);
          
          


















