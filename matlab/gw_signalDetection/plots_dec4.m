%load dec4_1e2_workspace.mat

figure(1),plot(secSN,SN);
figure(2),plot(SNresh);

figure(3),plot(secS4,s4h1);

figure(4),psd(SNresh);
figure(5),psd(s4h1);


figure(6),specgram(S1);
figure(7),psd(S1);


figure(8),plot(outdatacond_dec4_30{1,1}.data');
figure(9),specgram(outdatacond_dec4_30{1,1}.data');

% figure(10),plot(outdatacond_dec4_30{1,2}.data');
% figure(11),specgram(outdatacond_dec4_25{1,2}.data');
% 
% 
% figure(12),plot(outdatacond_dec4_25{1,3}.data');
% figure(13),specgram(outdatacond_dec4_25{1,3}.data');
