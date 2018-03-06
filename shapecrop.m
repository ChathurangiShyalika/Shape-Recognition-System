function varargout = shapecrop(varargin)
% SHAPECROP MATLAB code for shapecrop.fig
%      SHAPECROP, by itself, creates a new SHAPECROP or raises the existing
%      singleton*.
%
%      H = SHAPECROP returns the handle to a new SHAPECROP or the handle to
%      the existing singleton*.
%
%      SHAPECROP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHAPECROP.M with the given input arguments.
%
%      SHAPECROP('Property','Value',...) creates a new SHAPECROP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before shapecrop_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to shapecrop_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help shapecrop

% Last Modified by GUIDE v2.5 22-Apr-2017 12:53:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @shapecrop_OpeningFcn, ...
                   'gui_OutputFcn',  @shapecrop_OutputFcn, ...
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


% --- Executes just before shapecrop is made visible.
function shapecrop_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to shapecrop (see VARARGIN)

% Choose default command line output for shapecrop
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes shapecrop wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = shapecrop_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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
countElA=histc(a,unqA);

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



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% close current figure
closereq;

% open the new one
shaperec();


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files'},'Please Select an Image');
image = imread([PathName FileName]);
imshow(image) %needed to use imellipse
user_defined_ellipse = imrect(gca, []); % creates user defined ellipse object.
wait(user_defined_ellipse);% You need to click twice to continue.
MASK = double(user_defined_ellipse.createMask());
new_image_name = [PathName 'Cropped_Image_' FileName];
new_image_name = new_image_name(1:strfind(new_image_name,'.')-1); %removing the .jpg, .tiff, etc
new_image_name = [new_image_name '.png']; % making the image .png so it can be transparent
imwrite(image, new_image_name,'png','Alpha',MASK);
msg = msgbox(['The image was written to ' new_image_name],'New Image Path');
waitfor(msg);


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
