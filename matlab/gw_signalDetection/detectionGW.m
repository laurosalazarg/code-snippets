% Main Program, Automated detections
% Lauro Salazar
%
% Instructions
% 1. Uncomment only GW wave and time to run algorithm on that case
% 2. Specify RIDGE output folder name in OutputFolderName=
% 3. Give unique name for RIDGE parameter file to be used in paramf1=
%    _step1 is the clean test, _step2 is with HRNR
% 4. Specify scaling to test, for example 5:5:100
%    This will run the algorithm increasing scale of GW to test out HRNR
%    efficiency
% 5. Have to specify wave name in wave=  for the wave being tested, this
%    unique name for the test runs is used to create the name of the RIDGE
%    output results folder.
% 6. If no errors { have some coffee, work on other things, return in a few hours, 
%    check results as they are created under the phyes_res/RIDGE/ folder }
% 7. MATLAB workspaces are saved to check if correct values were used or
%    for future plotting. They end in either _clean, or _HRNR, can be edited
%    at the end of the snDetect functions.
%
tic

% load GW wave
%load s25WW_h 
%load nomoto15_h
%load m15b6_h 
%load s11_2_h
%load s15_0_h
%load s20_0_h
%load s11WW_h
%load s13_0_h
%load nomoto13_h

%  waves, murphy
% Refer to murphyetal2009.mat for a list of the GWs 
load('murphyetal2009','data_GRW_md_h10kpc_15_4');
% load('murphyetal2009_fix','data_GRW_md_h10kpc_20_3_6');
% SN scaling
scale=25;
for i=scale 
% Name of wave, used for results output    
wave = 'data_GRW_md_h10kpc_15_4';
snrNum = i; 
% Ott et al. wave times
%Time = 1.045; % s11ww
%Time = 1.447; %s13
%Time = 1.110; %s25ww
%Time = 1.725; %nomoto15
%Time = 0.927; %m15b6
%Time = 1.496; %s11_2_h
%Time = 1.404;  %s15_0_h
%Time = 1.715; %s20_0_h
%Time = 1.237; %nomoto13

% Murphy et al. wave times
% Time = 0.9883; % grw_12_1
% Time = 0.87; % grw_12_2
% Time = 0.7750; % grw_12_3
% Time = 1.2812; %grw_15_3
Time = 1.19; %grw_15_4
% Time = 1.2834; %grw_20_3
% Time = 1.2769; % grw_40_10
% Time = 1.1150; %grw_40_12
% Time = 0.79; %grw_40_13
% Time = 1.2042; %grw_40_6
% Time = 1.0452; %grw_12_2_2
% Time = 1.2573; %grw_15_3_4
% Time = 1.282;%grw_15_3_2
% Time = 1.2568;% grw_20_3_2
% Time = 1.2605; %grw_20_3_4
% Time = 1.2571;%grw_20_3_6

% set up input parameters
paramf1 = 'S62networkTest'; snr = 'scale_'; space = '_'; 
fullParamFile = [paramf1 int2str(snrNum) snr wave];
OutputFolderName = 'S62networkTestDiv';
results1 = [OutputFolderName int2str(snrNum) snr wave '_step1']; %Clean step
fullParamFile_HRNR = [paramf1 int2str(snrNum) snr wave '_HRNR'];
results2 = [OutputFolderName int2str(snrNum) snr wave '_step2']; % HRNR step
workspaceStr = [OutputFolderName int2str(snrNum) snr wave];  

disp('Starting Routine');
disp(['Current scale: '  int2str(snrNum) ]);

% Only uncomment tests that are going to be run
% Using S4 Data

% % % % Clean
% snDetect4v1(data_GRW_md_h10kpc_20_3, Time, snrNum, fullParamFile,results1,...
%  fullParamFile_HRNR,results2, workspaceStr);
% 
% % Using HRNR
% snDetectHRNR(data_GRW_md_h10kpc_20_3, Time, snrNum, fullParamFile,results1,...
%     fullParamFile_HRNR,results2, workspaceStr);


% Only essentials inside to test HRNR on C++ using MEX, (not finished)
snDetectHRNRMEXTEST(data_GRW_md_h10kpc_15_4, Time, snrNum, fullParamFile,results1,...
    fullParamFile_HRNR,results2, workspaceStr);


% Using S6 Data

% % Clean
% S6snDetect(data_GRW_md_h10kpc_15_4, Time, snrNum, fullParamFile,results1,...
%  fullParamFile_HRNR,results2, workspaceStr);
% % Using HRNR
% S6snDetectHRNR(data_GRW_md_h10kpc_15_4, Time, snrNum, fullParamFile,results1,...
%     fullParamFile_HRNR,results2, workspaceStr);

% disp(' S4 ');
% cal_SNR(data_GRW_md_h10kpc_15_4, Time, snrNum, fullParamFile,results1,...
%     fullParamFile_HRNR,results2, workspaceStr);

% disp(' S6 ');
% cal_SNRS6(data_GRW_md_h10kpc_15_4, Time, snrNum, fullParamFile,results1,...
%     fullParamFile_HRNR,results2, workspaceStr);
end
toc
