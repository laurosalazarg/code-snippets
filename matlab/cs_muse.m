function varargout = cs_muse(varargin)



% Last Modified by Lauro Salazar 02-May-2010 03:28:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cs_muse_OpeningFcn, ...
                   'gui_OutputFcn',  @cs_muse_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before cs_muse is made visible.
function cs_muse_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cs_muse (see VARARGIN)

% Choose default command line output for cs_muse
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cs_muse wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(hObject,'toolbar','figure');

init_scaling = 0.2;
set(handles.scaling,'String',num2str(init_scaling));
guidata(hObject,handles);

init_coeff = 0;
set(handles.fourier_coefficients,'String',num2str(init_coeff));
guidata(hObject,handles);

axes(handles.axes1);
plot(zeros(200,1));
axis([0 154 -67 67]);

axes(handles.axes2);
plot(zeros(200,1));
axis([0 154 -67 67]);

axes(handles.axes3);
plot(zeros(200,1));
axis([0 154 -67 67]);

axes(handles.axes4);
plot(zeros(200,1));
axis([0 154 -67 67]);

axes(handles.axes5);
plot(zeros(200,1));
axis([0 154 -67 67]);

axes(handles.axes6);
plot(zeros(200,1));
axis([0 154 -67 67]);

axes(handles.axes7);
plot(zeros(200,1));
axis([0 154 -67 67]);

axes(handles.axes8);
plot(zeros(200,1));
axis([0 154 -67 67]);

axes(handles.axes9);
plot(zeros(200,1));
axis([0 154 -67 67]);

axes(handles.axes10);
plot(zeros(200,1));
axis([0 154 -67 67]);


% --- Outputs from this function are returned to the command line.
function varargout = cs_muse_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in load_image.
function load_image_Callback(hObject, eventdata, handles)
% hObject    handle to load_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global note;
global original_image;
[filename, pathname]=uigetfile('*.jpg','Load .jpeg file');
axes(handles.axes1);
[original_image,mapping] = imread([pathname filename]);
[note,map] = imread([pathname filename]);

% change to BW
level = graythresh(note);
note = im2bw(note,level);

imshow(note),title('musical note');

axis off;

% --- Executes on button press in load_image_2.
function load_image_2_Callback(hObject, eventdata, handles)
% hObject    handle to load_image_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global staff;

[filename2, pathname2]=uigetfile('*.jpg','Load .jpeg file');

axes(handles.axes2);
[staff,map2] = imread([pathname2 filename2]);

% change to BW
level2 = graythresh(staff);
staff = im2bw(staff,level2);

imshow(staff), title 'empty staff';
axis off;
% --- Executes on button press in load_target.
function load_target_Callback(hObject, eventdata, handles)
% hObject    handle to load_target (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global target;
[filename3, pathname3]=uigetfile('*.jpg','Load .jpeg file');

axes(handles.axes5);
[target,map3] = imread([pathname3 filename3]);

% change to BW
level3 = graythresh(target);
target = im2bw(target,level3);
target = edge(target,'canny');

imshow(target),title 'template';
axis off;

% --- Executes on button press in get_isolated_note.
function get_isolated_note_Callback(hObject, eventdata, handles)
% hObject    handle to get_isolated_note (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global note;
global staff;
global isolated_note;
global noteEDGE;

isolated_note = zeros(size(note));

%substract notations other than note
isolated_note = (staff - note);
axes(handles.axes3);
imshow(isolated_note), title 'isolated note';
axis off;

noteEDGE = edge(isolated_note, 'sobel');
axes(handles.axes4);
imshow(noteEDGE), title 'input match';
axis off;


% --- Executes on button press in template_match.
function template_match_Callback(hObject, eventdata, handles)
% hObject    handle to template_match (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global original_image;
global noteEDGE;
global target;
global isolated_note;

global segmented_note;

% template matching by correlation
match = tp_matching(noteEDGE, target);

[row_match,col_match]=find(match==max(max(match)));

axes(handles.axes6);
imshow(original_image),title 'template match';
rectangle('position',[col_match(1,1) row_match(1,1) 15 35],'LineWidth',2,'EdgeColor','red');
axis off;

% segmented match

segmented_note = isolated_note(1:row_match+35 ,col_match:col_match+15);
axes(handles.axes7);
imshow( segmented_note ), title 'segmented from window';
axis off;

% histogram

[counts, x] = imhist(segmented_note,2);

axes(handles.axes8);
bar(x,counts), title 'histogram';

counts_of_1s_in_image = counts(2,1)
 
 % determine type of note ================================================
 if counts(2,1) >= 75 && counts(2,1) <= 83
     quarternote = 1
     halfnote    = 0
 
 elseif counts(2,1) >=50 && counts(2,1) <= 60
     quarternote = 0
     halfnote = 1
 end
 
function fourier_coefficients_Callback(hObject, eventdata, handles)
% hObject    handle to fourier_coefficients (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fourier_coefficients as text
%        str2double(get(hObject,'String')) returns contents of fourier_coefficients as a double
global coefficients;

coefficients = str2num(get(hObject,'String'));
set(handles.fourier_coefficients,'String',num2str(coefficients));
guidata(hObject,handles);

new_coefficients = coefficients

% --- Executes during object creation, after setting all properties.
function fourier_coefficients_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fourier_coefficients (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in get_signature.
function get_signature_Callback(hObject, eventdata, handles)
% hObject    handle to get_signature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global coefficients;
global scaling;
global noteEDGE;

%find starting pixel
[x y] = find(noteEDGE==1);
x = min(x);
noteEDGEx  = noteEDGE(x,:);
y = min(find(noteEDGEx==1));
startingPixel = [x y];
startingPixel

%find pixel locations, 'E' meaning east, clockwise
locations = bwtraceboundary(noteEDGE, startingPixel,'E');
%save locations locations

% send curve to find descriptors
[signature, x_image, y_image] = EllipticDescrp_GUI(locations, coefficients, scaling);

axes(handles.axes9);
plot(signature),title 'signature';

axes(handles.axes10);
plot(x_image,y_image),title 'curve reconstructed';



function scaling_Callback(hObject, eventdata, handles)
% hObject    handle to scaling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scaling as text
%        str2double(get(hObject,'String')) returns contents of scaling as a double
global scaling;

scaling = str2num(get(hObject,'String'));
set(handles.scaling,'String',num2str(scaling));
guidata(hObject,handles);

new_scaling = scaling


% --- Executes during object creation, after setting all properties.
function scaling_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scaling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in play_button.
function play_button_Callback(hObject, eventdata, handles)
% hObject    handle to play_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
%gets the selected option
switch get(handles.popupmenu1,'Value')   
    case 2
        [signal,freq] = wavread('./sound_files/a_soundhalf.wav');
        wavplay(signal, freq);
    case 3
        [signal,freq] = wavread('./sound_files/a_soundquarter.wav');
        wavplay(signal, freq);
    case 4
        [signal,freq] = wavread('./sound_files/a_soundwhole.wav');
        wavplay(signal, freq);
        
            case 5
        [signal,freq] = wavread('./sound_files/b_soundhalf.wav');
        wavplay(signal, freq);
    case 6
        [signal,freq] = wavread('./sound_files/b_soundquarter.wav');
        wavplay(signal, freq);
    case 7
        [signal,freq] = wavread('./sound_files/b_soundwhole.wav');
        wavplay(signal, freq);
        
            case 8
        [signal,freq] = wavread('./sound_files/c_soundhalf.wav');
        wavplay(signal, freq);
    case 9
        [signal,freq] = wavread('./sound_files/c_soundquarter.wav');
        wavplay(signal, freq);
    case 10
        [signal,freq] = wavread('./sound_files/c_soundwhole.wav');
        wavplay(signal, freq);
        
            case 11
        [signal,freq] = wavread('./sound_files/d_soundhalf.wav');
        wavplay(signal, freq);
    case 12
        [signal,freq] = wavread('./sound_files/d_soundquarter.wav');
        wavplay(signal, freq);
    case 13
        [signal,freq] = wavread('./sound_files/d_soundwhole.wav');
        wavplay(signal, freq);
        
            case 14
        [signal,freq] = wavread('./sound_files/e_soundhalf.wav');
        wavplay(signal, freq);
    case 15
        [signal,freq] = wavread('./sound_files/e_soundquarter.wav');
        wavplay(signal, freq);
    case 16
        [signal,freq] = wavread('./sound_files/e_soundwhole.wav');
        wavplay(signal, freq);
        
        
                    case 17
        [signal,freq] = wavread('./sound_files/espace_soundhalf.wav');
        wavplay(signal, freq);
    case 18
        [signal,freq] = wavread('./sound_files/espace_soundquarter.wav');
        wavplay(signal, freq);
    case 19
        [signal,freq] = wavread('./sound_files/espace_soundwhole.wav');
        wavplay(signal, freq);
        
        
                    case 20
        [signal,freq] = wavread('./sound_files/f_soundhalf.wav');
        wavplay(signal, freq);
    case 21
        [signal,freq] = wavread('./sound_files/f_soundquarter.wav');
        wavplay(signal, freq);
    case 22
        [signal,freq] = wavread('./sound_files/f_soundwhole.wav');
        wavplay(signal, freq);
        
        
                    case 23
        [signal,freq] = wavread('./sound_files/fspace_soundhalf.wav');
        wavplay(signal, freq);
    case 24
        [signal,freq] = wavread('./sound_files/fspace_soundquarter.wav');
        wavplay(signal, freq);
    case 25
        [signal,freq] = wavread('./sound_files/fspace_soundwhole.wav');
        wavplay(signal, freq);
        
                    case 26
        [signal,freq] = wavread('./sound_files/g_soundhalf.wav');
        wavplay(signal, freq);
    case 27
        [signal,freq] = wavread('./sound_files/g_soundquarter.wav');
        wavplay(signal, freq);
    case 28
        [signal,freq] = wavread('./sound_files/g_soundwhole.wav');
        wavplay(signal, freq);
        
    otherwise
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
