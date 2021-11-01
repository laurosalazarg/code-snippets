
% cs muse code, lauro salazar, 2010

function loadIM(image, image2,target,scaling)
tic
% read inputs for matching ============================
inputmatch = imread(image);
targetmatch = imread(target);
argh = imread(image);

% pre-process ====================================

note = imread(image);
level = graythresh(note);
note = im2bw(note,level);

%save note note
empty = imread(image2);
level2 = graythresh(empty);
empty = im2bw(empty,level2);

% set up new image
new = zeros(size(image));

% substract notations other than note
new = (empty - note);

% subplot(4,3,1);
% imshow(note),title 'BW original';
% 
% subplot(4,3,2);
% imshow(empty),title 'BW empty staff';
% 
% subplot(4,3,3);
% imshow(new),title 'empty substracted by original';


% find note edge ================================================

noteEDGE = edge(new, 'sobel');
%save noteEDGE noteEDGE
% subplot(4,3,4);
% imshow(noteEDGE),title 'input match';


%find target edge
level2 = graythresh(targetmatch);
targetmatch = im2bw(targetmatch,level2);
targetedge = edge(targetmatch,'canny');

%plot target edge
% subplot(4,3,5),imshow(targetedge),title 'template to match'


%template matching using correlation ======================================

match = tp_matching(noteEDGE, targetedge ); % =============

% find max of match
 [row_match,col_match]=find(match==max(max(match))); %coordinates
 %   save row_match row_match
 %   save col_match col_match    
 %plot match
%  subplot(4,3,6);
  imshow(argh),title 'Matched Image'      
  rectangle('position',[col_match(1,1) row_match(1,1) 15 35],'LineWidth',2,'EdgeColor','red');
 
 row_match(1,1);
 col_match(1,1) ;
 
 % segment match
 segmented_note = new(1:row_match+35 ,col_match:col_match+15);
%  subplot(4,3,7);
%  imshow( segmented_note ), title 'segmented from match, normalized'
 
 % get histogram ==========================================================
 
 [counts, x] = imhist(segmented_note,2);
 
% plot histogram
% subplot(4,3,8), bar(x,counts),title 'histogram';
 
counts_of_1s_in_image = counts(2,1);
 
 % determine type of note ================================================
%  if counts(2,1) >= 75 && counts(2,1) <= 83
%      quarternote = 1
%      halfnote    = 0
%  
%  elseif counts(2,1) >=50 && counts(2,1) <= 60
%      quarternote = 0
%      halfnote = 1
%  end

% sending to fourier descriptors the 'NOTE EDGE' ===========================
% the input match


%find starting pixel
[x y] = find(noteEDGE==1);
x = min(x);
noteEDGEx  = noteEDGE(x,:);
y = min(find(noteEDGEx==1));
startingPixel = [x y];
startingPixel;

%find pixel locations, 'E' meaning east, clockwise
locations = bwtraceboundary(noteEDGE, startingPixel,'E');
%save locations locations


% send curve to find descriptors
[CE,x_ima,y_ima] = EllipticDescrp(locations,scaling);

% subplot(4,3,9), plot(CE),title 'signature';
% subplot(4,3,10), plot(x_ima,y_ima),title 'curve';



 % determine type of note ================================================
 
 load c_wholenotecut_CE.mat
 load c_quarternotecut_CE.mat
 load c_halfnotecut_CE.mat
 
 load a_quarternotecut_CE.mat
 load a_halfnotecut_CE.mat
 load a_wholenotecut_CE.mat
 
  load b_quarternotecut_CE.mat
 load b_halfnotecut_CE.mat
 load b_wholenotecut_CE.mat
 
 load d_quarternotecut_CE.mat
 load d_halfnotecut_CE.mat
 load d_wholenotecut_CE.mat
 
 
  load e_quarternotecut_CE.mat
 load e_halfnotecut_CE.mat
 load e_wholenotecut_CE.mat
 

 % e space half not work
 % e space quarter not work
 load espace_wholenotecut_CE.mat
 
   load fspace_quarternotecut_CE.mat
 load fspace_halfnotecut_CE.mat
 load fspace_wholenotecut_CE.mat
 
 
 % f half not work
 % f quarter not work
 load f_wholenotecut_CE.mat
 
  load g_quarternotecut_CE.mat
 load g_halfnotecut_CE.mat
 load g_wholenotecut_CE.mat
 
 
 % c signatures
 for w=1:size(c_quarternotecut_CE)
   for p=1:size(c_halfnotecut_CE)  
       for l=1:size(c_wholenotecut_CE)                   
 % c quarter, c half, c whole notes          
 if counts(2,1) >= 78 && counts(2,1) <= 82 &&  row_match(1,1) == 1  && col_match(1,1) == 76 ...
     && c_quarternotecut_CE(1,w)
      disp('C quarter note');
      toc    
      
     [signal,freq] = wavread('./sound_files/c_soundquarter.wav');
     wavplay(signal, freq);
     
     
 elseif counts(2,1) >= 52 && counts(2,1) <= 56 &&  row_match(1,1) == 1  && col_match(1,1) == 91 ...
     && c_halfnotecut_CE(1,p)
    disp('C half note');
    toc
    
    [signal,freq] = wavread('./sound_files/c_soundhalf.wav');
     wavplay(signal, freq);
     
 elseif counts(2,1) >= 53 && counts(2,1) <= 56 &&  row_match(1,1) == 6  && col_match(1,1) == 86 ...
     && c_wholenotecut_CE(1,l)
    disp('C whole note');
    toc
    [signal,freq] = wavread('./sound_files/c_soundwhole.wav');
     wavplay(signal, freq);
         
 
 end
       end
   end
 end
 
 
 
 
% a signatures ==========================================================
for wa=1:size(a_quarternotecut_CE)
       for pa=1:size(a_halfnotecut_CE)  
       for la=1:size(a_wholenotecut_CE)  

     % a quarter, a half, a whole notes   
  if counts(2,1) >= 78 && counts(2,1) <= 82 &&  row_match(1,1) == 11  && col_match(1,1) == 91 ...
     && a_quarternotecut_CE(1,w)
      disp('A quarter note');
      toc    
      
     [signal,freq] = wavread('./sound_files/a_soundquarter.wav');
     wavplay(signal, freq);
     
 elseif counts(2,1) >= 52 && counts(2,1) <= 56 &&  row_match(1,1) == 11  && col_match(1,1) == 116 ...
     && a_halfnotecut_CE(1,pa)
    disp('A half note');
    toc
    
    [signal,freq] = wavread('./sound_files/a_soundhalf.wav');
     wavplay(signal, freq);
     
 elseif counts(2,1) >= 53 && counts(2,1) <= 56 &&  row_match(1,1) == 11  && col_match(1,1) == 81 ...
     && a_wholenotecut_CE(1,la)
    disp('A whole note');
    toc
    [signal,freq] = wavread('./sound_files/a_soundwhole.wav');
     wavplay(signal, freq);
         
 
 end
       end
   end
end


% b signatures ==========================================================
for wb=1:size(b_quarternotecut_CE)
       for pb=1:size(b_halfnotecut_CE)  
       for lb=1:size(b_wholenotecut_CE)  

     % b quarter, b half, b whole notes   
  if counts(2,1) >= 78 && counts(2,1) <= 82 &&  row_match(1,1) == 6  && col_match(1,1) == 91 ...
     && b_quarternotecut_CE(1,wb)
      disp('B quarter note');
      toc    
      
     [signal,freq] = wavread('./sound_files/b_soundquarter.wav');
     wavplay(signal, freq);
     
 elseif counts(2,1) >= 52 && counts(2,1) <= 56 &&  row_match(1,1) == 6  && col_match(1,1) == 106 ...
     && b_halfnotecut_CE(1,pb)
    disp('B half note');
    toc
    
    [signal,freq] = wavread('./sound_files/b_soundhalf.wav');
     wavplay(signal, freq);
     
 elseif counts(2,1) >= 53 && counts(2,1) <= 56 &&  row_match(1,1) == 11  && col_match(1,1) == 76 ...
     && b_wholenotecut_CE(1,lb)
    disp('B whole note');
    toc
    [signal,freq] = wavread('./sound_files/b_soundwhole.wav');
     wavplay(signal, freq);
         
 
 end
       end
   end
end



% d signatures ==========================================================
for wd=1:size(d_quarternotecut_CE)
       for pd=1:size(d_halfnotecut_CE)  
       for ld=1:size(d_wholenotecut_CE)  

     % d quarter, d half, d whole notes   
  if counts(2,1) >= 78 && counts(2,1) <= 82 &&  row_match(1,1) == 1  && col_match(1,1) == 91 ...
     && d_quarternotecut_CE(1,wd)
      disp('D quarter note');
      toc    
      
     [signal,freq] = wavread('./sound_files/d_soundquarter.wav');
     wavplay(signal, freq);
     
 elseif counts(2,1) >= 52 && counts(2,1) <= 56 &&  row_match(1,1) == 1  && col_match(1,1) == 96 ...
     && d_halfnotecut_CE(1,pd)
    disp('D half note');
    toc
    
    [signal,freq] = wavread('./sound_files/d_soundhalf.wav');
     wavplay(signal, freq);
     
 elseif counts(2,1) >= 53 && counts(2,1) <= 56 &&  row_match(1,1) == 11  && col_match(1,1) == 106 ...
     && d_wholenotecut_CE(1,ld)
    disp('D whole note');
    toc
    [signal,freq] = wavread('./sound_files/d_soundwhole.wav');
     wavplay(signal, freq);
         
 
 end
       end
   end
end
 

% e signatures ==========================================================
for we=1:size(e_quarternotecut_CE)
       for pe=1:size(e_halfnotecut_CE)  
       for le=1:size(e_wholenotecut_CE)  

     % e quarter, e half, e whole notes   
  if counts(2,1) >= 78 && counts(2,1) <= 82 &&  row_match(1,1) == 21  && col_match(1,1) == 91 ...
     && e_quarternotecut_CE(1,we)
      disp('E quarter note');
      toc    
      
     [signal,freq] = wavread('./sound_files/e_soundquarter.wav');
     wavplay(signal, freq);
     
 elseif counts(2,1) >= 52 && counts(2,1) <= 56 &&  row_match(1,1) == 26  && col_match(1,1) == 96 ...
     && e_halfnotecut_CE(1,pe)
    disp('E half note');
    toc
    
    [signal,freq] = wavread('./sound_files/e_soundhalf.wav');
     wavplay(signal, freq);
     
 elseif counts(2,1) >= 53 && counts(2,1) <= 56 &&  row_match(1,1) == 26  && col_match(1,1) == 81 ...
     && e_wholenotecut_CE(1,le)
    disp('E whole note');
    toc
    [signal,freq] = wavread('./sound_files/e_soundwhole.wav');
     wavplay(signal, freq);
         
 
 end
       end
   end
end

% e space signatures ==========================================================
for les=1:size(espace_wholenotecut_CE)

     % e space whole  
  if counts(2,1) >= 53 && counts(2,1) <= 56 &&  row_match(1,1) == 16  && col_match(1,1) == 111 ...
     && espace_wholenotecut_CE(1,les)
      disp('Espace whole note');
      toc    
      
     [signal,freq] = wavread('./sound_files/espace_soundwhole.wav');
     wavplay(signal, freq);
  end
  
end


 % f  signatures ==========================================================
for wf=1:size(f_wholenotecut_CE)

     % f whole  
  if counts(2,1) >= 53 && counts(2,1) <= 56 &&  row_match(1,1) == 1  && col_match(1,1) == 86 ...
     && f_wholenotecut_CE(1,wf)
      disp('F  whole note');
      toc    
      
     [signal,freq] = wavread('./sound_files/f_soundwhole.wav');
     wavplay(signal, freq);

  end
end

 % f space signatures ==========================================================
for wfs=1:size(fspace_quarternotecut_CE)
       for pfs=1:size(fspace_halfnotecut_CE)  
       for lfs=1:size(fspace_wholenotecut_CE)  

     % f s quarter, f s half, f swhole notes   
  if counts(2,1) >= 78 && counts(2,1) <= 82 &&  row_match(1,1) == 16  && col_match(1,1) == 91 ...
     && fspace_quarternotecut_CE(1,wfs)
      disp('F space quarter note');
      toc    
      
     [signal,freq] = wavread('./sound_files/fspace_soundquarter.wav');
     wavplay(signal, freq);
     
 elseif counts(2,1) >= 52 && counts(2,1) <= 56 &&  row_match(1,1) == 16  && col_match(1,1) == 96 ...
     && fspace_halfnotecut_CE(1,pfs)
    disp('F space half note');
    toc
    
    [signal,freq] = wavread('./sound_files/fspace_soundhalf.wav');
     wavplay(signal, freq);
     
 elseif counts(2,1) >= 53 && counts(2,1) <= 56 &&  row_match(1,1) == 21 && col_match(1,1) == 81 ...
     && fspace_wholenotecut_CE(1,lfs)
    disp('F space whole note');
    toc
    [signal,freq] = wavread('./sound_files/fspace_soundwhole.wav');
     wavplay(signal, freq);
         
 
 end
       end
   end
end
 


 % g signatures ==========================================================
for wg=1:size(g_quarternotecut_CE)
       for pg=1:size(g_halfnotecut_CE)  
       for lg=1:size(g_wholenotecut_CE)  

     % g quarter, g half, g whole notes   
  if counts(2,1) >= 78 && counts(2,1) <= 82 &&  row_match(1,1) == 16  && col_match(1,1) == 116 ...
     && g_quarternotecut_CE(1,wg)
      disp('G quarter note');
      toc    
      
     [signal,freq] = wavread('./sound_files/g_soundquarter.wav');
     wavplay(signal, freq);
     
 elseif counts(2,1) >= 52 && counts(2,1) <= 56 &&  row_match(1,1) == 16  && col_match(1,1) == 76 ...
     && g_halfnotecut_CE(1,pg)
    disp('G half note');
    toc
    
    [signal,freq] = wavread('./sound_files/g_soundhalf.wav');
     wavplay(signal, freq);
     
 elseif counts(2,1) >= 53 && counts(2,1) <= 56 &&  row_match(1,1) == 21 && col_match(1,1) == 106 ...
     && g_wholenotecut_CE(1,lg)
    disp('G whole note');
    toc
    [signal,freq] = wavread('./sound_files/g_soundwhole.wav');
     wavplay(signal, freq);
         
 
 end
       end
   end
end
 
 
 
 














end



