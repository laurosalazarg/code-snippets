% standalone downsampling->conditioning
function [] = S6standalone_cond(folder,inputData,saveStandaloneName,mkDirName,lineListName,identifyingTag,outputDataName)
% % standalone params example
% %
%     inputData = 'testdata.mat'; % H1 H2 L1 data
%     saveStandaloneName = 'testcond_standalone.mat'; % name to save at RIDGE/output/
%     folder = 'output'; % RIDGE /output folder
%     mkDirName = 'testcond_outputs'; % create directory with this name to store results
%     resultsDirName = 'testcond_outputs'; % name of results directory
%     lineListName = 'GRB060813_H1H2L1_linelist.mat';
%     identifyingTag = 'democond'; % name variables
%     outputDataName = 'testcond_cond'; % Name conditioned data output variable
%
%
% %
resultsDirName = mkDirName;    
% enter RIDGE folder
cd('RIDGE');
initializeRIDGE

warning off
% 1. Providing input data, load
load(fullfile(folder, inputData));

% rename
S1 = H1; 
S2 = V1; 
S3 = L1;

clear H1 V1 L1;

% remove fields
S1 = rmfield(S1,{'GPSinfo','auxinfo'});
S2 = rmfield(S2,{'GPSinfo','auxinfo'});
S3 = rmfield(S3,{'GPSinfo','auxinfo'});

%S1

save(fullfile(folder,saveStandaloneName),'S1','S2','S3');
%clear all

%
indatafile = fullfile(folder,saveStandaloneName);

% 2. then use gendownsmpdata to create a file containing downsampled data

% diff variables, same name
S1 = struct('detector','S1','fs', 2048,'antialias_ordr',100,'antialias_a',[]);
S2 = S1; S2.detector = 'S2';
S3 = S1; S3.detector = 'S3';

% save downsampling parameters
paramfile = 'tmp_downsmp_paramS6.mat';
save(paramfile,'S1','S2','S3');
clear S1 S2 S3;

% name file to store downsampled data in
outdatafile = fullfile(folder,'testcond_downsmpS6.mat');

% downsample only one detector data
detector = {'S1','S2','S3'}; % or just one. detector = 'S1';

% downsample function
gendownsmpdata(indatafile,paramfile,detector,'train',outdatafile);

% delete fake input data file
delete(indatafile);

% contents of data file that will go as input to conditioning code
% every output file contains the name of the file that was used as input
indatafile = outdatafile;
clear detector paramfile;
load(indatafile);
%whos;

% reset indatafile again, want to use testcond_downsmp.mat
indatafile = outdatafile;

% conditioning can start with the file named in indatafile

% don't need these anymore
delete(paramfile);
clear S1 S2 S3 GPSinfo detectors paramfile outdatafile;

% show length of input
S1 = loadridgedata(indatafile,'S1');
disp(['Data length: ' int2str(length(S1.data) ) ]);
clear S1;

% 3. Set up conditioning parameters

S1 = struct('detector','S1','fs', 2048, 'linelist', [], 'traininfo',struct() );

% load,assign linelists
load(fullfile('linelists',lineListName));
S1.linelist = H1;
%disp(S1.linelist);

S2 = S1; S2.detector = 'S2'; S2.linelist = V1;
S3 = S1; S3.detector = 'S3'; S3.linelist = L1;
clear H1 V1 L1;

% supply parameter values used for training the conditioning
S1.traininfo = struct('traindat', [],...
                      'nfloor_nfftsec', 2.0,...
                      'wht_blklen', 50,...
                      'use2stage', 1,...
                      'threshbump', 20,...
                      'whtfiltordr',150,...
                      'zerophasefilt','y',...
                      'highpassordr', 100,...
                      'highpasscutf',50,...
                      'whtb1',[],...
                      'whtb2',[],...
                      'highpasscoef',[] );
% V1                  
S2.traininfo = struct('traindat', [],...
                      'nfloor_nfftsec', 2.0,...
                      'wht_blklen', 50,...
                      'use2stage', 1,...
                      'threshbump', 20,...
                      'whtfiltordr',150,...
                      'zerophasefilt','n',...
                      'highpassordr', 100,...
                      'highpasscutf',50,...
                      'whtb1',[],...
                      'whtb2',[],...
                      'highpasscoef',[] );                  
                  
% assign to other detectors           
S2.traininfo = S2.traininfo;


S3.traininfo = S1.traininfo;

% supply training data, ex: first 6 sec of data from the input data file itself
traindata = load(indatafile,'S1');
S1.traininfo.traindat = traindata.S1.data(1:floor(6*2048));


traindata = load(indatafile,'S2');
S2.traininfo.traindat = traindata.S2.data(1:floor(6*2048));

traindata = load(indatafile,'S3');
S3.traininfo.traindat = traindata.S3.data(1:floor(6*2048));
clear traindata;

% save conditioning parameters in a file, read by genconddata
detectors = {'S1','S2','S3'};
paramfile = 'tmp_cond_paramsS6.mat';
save(paramfile,'S1','S2','S3','detectors');
clear S1 S2 S3 detectors;

% create directory where the output of the conditioning will be stored
mkdir(mkDirName);
resultsdir = resultsDirName;
% identifying tag
outdatasuffix = identifyingTag;

save(paramfile,'resultsdir','outdatasuffix','-append');

%
% 4. training the conditioning

flag = struct('flag','train','dump','medium','segment',[]);

% call conditioning function, can also call just 1 detector
genconddata(indatafile,{'S1','S2','S3'},paramfile,flag,'');

load(paramfile);
%S1.traininfo
% in training mode, no conditioned output is produced
% in particular, line removal is not done

%
% 5. Perform the conditioning

flag.flag = 'condition';
% output file
outdatafile = fullfile(resultsdir,outputDataName);

genconddata(indatafile,{'S1','S2','S3'}, paramfile, flag, outdatafile);

% delete temporaries
delete(indatafile);
delete(paramfile);

%  results contents
%dir(resultsdir);
%cd(resultsdir);

cd ..

disp('Done standalone conditioning');

end





















