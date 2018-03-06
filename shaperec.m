function varargout = shaperec(varargin)
% SHAPEREC MATLAB code for shaperec.fig
%      SHAPEREC, by itself, creates a new SHAPEREC or raises the existing
%      singleton*.
%
%      H = SHAPEREC returns the handle to a new SHAPEREC or the handle to
%      the existing singleton*.
%
%      SHAPEREC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHAPEREC.M with the given input arguments.
%
%      SHAPEREC('Property','Value',...) creates a new SHAPEREC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before shaperec_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to shaperec_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help shaperec

% Last Modified by GUIDE v2.5 22-Apr-2017 12:13:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @shaperec_OpeningFcn, ...
                   'gui_OutputFcn',  @shaperec_OutputFcn, ...
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


% --- Executes just before shaperec is made visible.
function shaperec_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to shaperec (see VARARGIN)

% Choose default command line output for shaperec
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes shaperec wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = shaperec_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'imgData')
    % grab the image data from handles
    i = handles.imgData;
    ig = rgb2gray(i);
    threshold = graythresh(ig);
    BW = im2bw(ig, threshold);
    
    BW = ~ BW;
    axes(handles.axes2);
    imshow(BW);

end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if isfield(handles,'imgData')
    % grab the image data from handles
    i = handles.imgData;
    ig = rgb2gray(i);
   axes(handles.axes2);
    imshow(ig);
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'imgData')
    % grab the image data from handles
    i = handles.imgData;
    ig = rgb2gray(i);
    threshold = graythresh(ig);
    BW = im2bw(ig, threshold);
    axes(handles.axes2);
    imshow(BW);
    
end

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Step 5: Find the boundaries Concentrate only on the exterior boundaries.
% Option 'noholes' will accelerate the processing by preventing
% bwboundaries from searching for inner contours. 

if isfield(handles,'imgData')
    % grab the image data from handles
    i = handles.imgData;
    ig = rgb2gray(i);
    threshold = graythresh(ig);
    BW = im2bw(ig, threshold);
    BW = ~ BW;
    axes(handles.axes2);
    imshow(BW);

    [B,L] = bwboundaries(BW, 'noholes');

    % Step 5: Find the boundaries Concentrate only on the exterior boundaries.
    % Option 'noholes' will accelerate the processing by preventing
    % bwboundaries from searching for inner contours. 
    [B,L] = bwboundaries(BW, 'noholes');
    % Step 6: Determine objects properties
    STATS = regionprops(L, 'all'); % we need 'BoundingBox' and 'Extent'

    % Step 7: Classify Shapes according to properties
    % Square = 3 = (1 + 2) = (X=Y + Extent+ = 1)
    % Rectangular = 2 = (0 + 2) = (only Extent = 1)
    % Circle = 1 = (1 + 0) = (X=Y , Extent < 1)
    % UNKNOWN = 0

    figure,
    imshow(i),
    title('Results');
    hold on
    for i = 1 : length(STATS)
        W(i) = uint8(abs(STATS(i).BoundingBox(3)-STATS(i).BoundingBox(4)) < 0.1);
        W(i) = W(i) + 2 * uint8((STATS(i).Extent - 1) == 0 );
        centroid = STATS(i).Centroid;

         
        
        switch W(i)
            case 1
                plot(centroid(1),centroid(2),'wO');
            case 2
                plot(centroid(1),centroid(2),'wX');
            case 3
                plot(centroid(1),centroid(2),'wS');
               
        end
        
        
    end
    
   
end
a=unique(W,'rows')
%c=unique(a,'stable')
%b=cellfun(@(x) sum(ismember(a,x)),c,'un',0)
%disp(b);
unqA=unique(a);
countElA=histc(a, unqA);

b=unique(countElA,'rows')

%B={'Other Shapes','Circles','Rectangles','Squares'};
%disp(B);
fprintf(' Other\n Shapes,Circles,Rectangles,Squares\n');
disp(countElA);


A1=double(b(:,1));
A2=double(b(:,2));
A3=double(b(:,3));
A4=double(b(:,4));

set(handles.text6,'string',A2);
set(handles.text4,'string',A4);
set(handles.text7,'string',A3);
set(handles.text8,'string',A1);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName]=uigetfile({'*.BMP;*.jpg;*.png'},'Select an Image')
fullfilename =fullfile(PathName,FileName);
set(handles.edit2,'String',fullfilename);

i = imread(fullfilename);
axes(handles.axes1)
imshow(i);
% now update the handles structure with the image
handles.imgData = i;
% save the updated handles object
guidata(hObject,handles);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'imgData')
    % grab the image data from handles
    img = handles.imgData;
   
    
    grayy=rgb2gray(img);
    gr=graythresh(grayy);
    handles.bw=im2bw(grayy,gr);
    
    handles.output=hObject;
    inverse_binary=not(handles.bw);
    [handles.L handles.Num_object]=bwlabel(inverse_binary);    
    set(handles.text2,'string',handles.Num_object);
    imshow(handles.L,'Parent',handles.axes2);

end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Collect some of the measurements into individual arrays.

if isfield(handles,'imgData')
    % grab the image data from handles
    i = handles.imgData;
    ig = rgb2gray(i);
    threshold = graythresh(ig);
    BW = im2bw(ig, threshold);
    BW = ~ BW;
   
    
[labeledImage numberOfObjects] = bwlabel(BW);
blobMeasurements = regionprops(labeledImage,...
	'Perimeter', 'Area', 'FilledArea', 'Solidity', 'Centroid'); 

% Get the outermost boundaries of the objects, just for fun.
filledImage = imfill(BW, 'holes');
boundaries = bwboundaries(filledImage);

perimeters = [blobMeasurements.Perimeter];
areas = [blobMeasurements.Area];
filledAreas = [blobMeasurements.FilledArea];
solidities = [blobMeasurements.Solidity];
% Calculate circularities:
circularities = perimeters .^2 ./ (4 * pi * filledAreas);
% Print to command window.
fprintf('#, Perimeter,        Area, Filled Area, Solidity, Circularity\n');
for blobNumber = 1 : numberOfObjects
	fprintf('%d, %9.3f, %11.3f, %11.3f, %8.3f, %11.3f\n', ...
		blobNumber, perimeters(blobNumber), areas(blobNumber), ...
		filledAreas(blobNumber), solidities(blobNumber), circularities(blobNumber));
end
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% close current figure
closereq;

% open the new one
shapecrop();


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
