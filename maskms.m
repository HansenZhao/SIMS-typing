function varargout = maskms(varargin)
% MASKMS MATLAB code for maskms.fig
%      MASKMS, by itself, creates a new MASKMS or raises the existing
%      singleton*.
%
%      H = MASKMS returns the handle to a new MASKMS or the handle to
%      the existing singleton*.
%
%      MASKMS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MASKMS.M with the given input arguments.
%
%      MASKMS('Property','Value',...) creates a new MASKMS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before maskms_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to maskms_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help maskms

% Last Modified by GUIDE v2.5 08-Oct-2018 19:23:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @maskms_OpeningFcn, ...
                   'gui_OutputFcn',  @maskms_OutputFcn, ...
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


% --- Executes just before maskms is made visible.
function maskms_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to maskms (see VARARGIN)

% Choose default command line output for maskms
handles.output = hObject;
handles.SIMSData = [];
if isempty(varargin)
    handles.mask = [];
else
    handles.mask = varargin{1};
    handles.btn_loadms.BackgroundColor = [0,1,0];
end
handles.curAngle = 0;
handles.curSize = 1;
handles.offsetX = 0;
handles.offsetY = 0;
handles.angleStep = 0.1;
handles.sizeStep = 0.1;
handles.offsetXStep = 1;
handles.offsetYStep = 1;
handles.dilateValue = 1;
handles.cb_showMask.Value = 1;
% Update handles structure

handles.transMask = refreshUI(handles);
guidata(hObject, handles);
% UIWAIT makes maskms wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = maskms_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_loadMS.
function btn_loadMS_Callback(hObject, eventdata, handles)
% hObject    handle to btn_loadMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.SIMSData = SIMSTxtData();

handles.transMask = refreshUI(handles);
guidata(hObject,handles);
hObject.BackgroundColor = [0,1,0];


function edt_rotateStep_Callback(hObject, eventdata, handles)
% hObject    handle to edt_rotateStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = str2double(get(hObject,'String'));
if ~isnan(tmp) && tmp > 0
    handles.angleStep = tmp;
end

handles.transMask = refreshUI(handles);
guidata(hObject,handles);
    
% Hints: get(hObject,'String') returns contents of edt_rotateStep as text
%        str2double(get(hObject,'String')) returns contents of edt_rotateStep as a double


% --- Executes during object creation, after setting all properties.
function edt_rotateStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_rotateStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_rotRight.
function btn_rotRight_Callback(hObject, eventdata, handles)
% hObject    handle to btn_rotRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.curAngle = handles.curAngle + handles.angleStep;
handles.transMask = refreshUI(handles);
guidata(hObject,handles);

% --- Executes on button press in btn_rotLeft.
function btn_rotLeft_Callback(hObject, eventdata, handles)
% hObject    handle to btn_rotLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.curAngle = handles.curAngle - handles.angleStep;
handles.transMask = refreshUI(handles);
guidata(hObject,handles);


function edt_sizeStep_Callback(hObject, eventdata, handles)
% hObject    handle to edt_sizeStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = str2double(get(hObject,'String'));
if ~isnan(tmp) && tmp > 0
    handles.sizeStep = tmp;
end

handles.transMask = refreshUI(handles);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of edt_sizeStep as text
%        str2double(get(hObject,'String')) returns contents of edt_sizeStep as a double


% --- Executes during object creation, after setting all properties.
function edt_sizeStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_sizeStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_sizeInc.
function btn_sizeInc_Callback(hObject, eventdata, handles)
% hObject    handle to btn_sizeInc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.curSize = handles.curSize + handles.sizeStep;

handles.transMask = refreshUI(handles);
guidata(hObject,handles);

% --- Executes on button press in btn_sizeDec.
function btn_sizeDec_Callback(hObject, eventdata, handles)
% hObject    handle to btn_sizeDec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.curSize = handles.curSize - handles.sizeStep;

handles.transMask = refreshUI(handles);
guidata(hObject,handles);

% --- Executes on button press in btn_loadMask.
function btn_loadMask_Callback(hObject, eventdata, handles)
% hObject    handle to btn_loadMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    [fn,fp] = uigetfile('*.*');
    handles.mask = imread(strcat(fp,fn));
    
    handles.transMask = refreshUI(handles);
    hObject.BackgroundColor = [0.3,1,0.3];
    guidata(hObject,handles);
catch
end

function transMask = refreshUI(h)
    transMask = [];
    h.txt_curAngle.String = num2str(h.curAngle);
    h.txt_curSize.String = num2str(h.curSize);
    h.txt_offsetX.String = num2str(h.offsetX);
    h.txt_offsetY.String = num2str(h.offsetY);
    h.edt_angleStep.String = num2str(h.angleStep);
    h.edt_sizeStep.String = num2str(h.sizeStep);
    h.edt_offsetXStep.String = num2str(h.offsetXStep);
    h.edt_offsetYStep.String = num2str(h.offsetYStep);
    h.edt_dilate.String = num2str(h.dilateValue);
    if isempty(h.mask) || isempty(h.SIMSData)
        h.btn_rotRight.Enable = 'off';
        h.btn_rotLeft.Enable = 'off';
        h.btn_sizeInc.Enable = 'off';
        h.btn_sizeDec.Enable = 'off';
        h.btn_offsetXInc.Enable = 'off';
        h.btn_offsetXDec.Enable = 'off';
        h.btn_offsetYInc.Enable = 'off';
        h.btn_offsetYDec.Enable = 'off';
        h.edt_rotateStep.Enable = 'off';
        h.edt_sizeStep.Enable = 'off';
        h.edt_offsetXStep.Enable = 'off';
        h.edt_offsetYStep.Enable = 'off';
        h.edt_dilate.Enable = 'off';
        h.cb_showMask.Enable = 'off';
        h.cb_edge.Enable = 'off';
        h.cb_dilate.Enable = 'off';
        h.cb_fillHole.Enable = 'off';
        h.cb_clearEdge.Enable = 'off';
        h.cb_transIm.Enable = 'off';
        return;
    else
        h.btn_rotRight.Enable = 'on';
        h.btn_rotLeft.Enable = 'on';
        h.btn_sizeInc.Enable = 'on';
        h.btn_sizeDec.Enable = 'on';
        h.btn_offsetXInc.Enable = 'on';
        h.btn_offsetXDec.Enable = 'on';
        h.btn_offsetYInc.Enable = 'on';
        h.btn_offsetYDec.Enable = 'on';
        h.edt_rotateStep.Enable = 'on';
        h.edt_sizeStep.Enable = 'on';
        h.edt_offsetXStep.Enable = 'on';
        h.edt_offsetYStep.Enable = 'on';
        h.edt_dilate.Enable = 'on';
        h.cb_showMask.Enable = 'on';
        h.cb_edge.Enable = 'on';
        h.cb_dilate.Enable = 'on';
        h.cb_fillHole.Enable = 'on';
        h.cb_clearEdge.Enable = 'on';
        h.cb_transIm.Enable = 'on';
        [imMat,transMask] = procImage(h);
        imagesc(h.axes1,imMat);
        h.axes1.XTick = [];
        h.axes1.YTick = [];
    end
    
function [im,curMask] = procImage(h)
    msIm = adapthisteq(h.SIMSData.rawMat/max(h.SIMSData.rawMat(:)));
    if h.cb_transIm.Value
        im = repmat(msIm',[1,1,3]);
    else
        im = repmat(msIm,[1,1,3]);
    end
    if h.cb_showMask.Value
        curMask = h.mask;
        if h.cb_clearEdge.Value
            curMask = imclearborder(curMask,8);
        end
        if h.cb_dilate.Value
            curMask = imdilate(curMask,strel('disk',h.dilateValue));
        end
        if h.cb_fillHole.Value
            curMask = imfill(curMask,'holes');
        end
        curMask = imrotate(curMask,h.curAngle);
        curMask = imresize(curMask,h.curSize,'nearest');
        L = size(curMask,1);
        initOffset = round(h.SIMSData.imageSize/2) - round(L/2);
        [X,Y,V] = find(curMask);
        X = X + initOffset + h.offsetX;
        Y = Y + initOffset + h.offsetY;
        I = and(and(X>0,X<h.SIMSData.imageSize),and(Y>0,Y<h.SIMSData.imageSize));
        curMask = full(sparse(X(I),Y(I),double(V(I))));
        [nr,nc] = size(curMask);
        tmp = zeros(h.SIMSData.imageSize);
        tmp(1:nr,1:nc) = curMask;
        curMask = tmp;
        if h.cb_clearEdge.Value
            curMask = imclearborder(curMask,8);
        end 
        if h.cb_edge.Value
            im = imoverlay(im,bwperim(curMask),[1,0,0]);
        else
            im = imoverlay(im,curMask,[1,0,0]);
        end
    end
    
function edt_offsetXStep_Callback(hObject, eventdata, handles)
% hObject    handle to edt_offsetXStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = round(str2double(get(hObject,'String')));
if ~isnan(tmp) && tmp > 0
    handles.offsetXStep = tmp;
end

handles.transMask = refreshUI(handles);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of edt_offsetXStep as text
%        str2double(get(hObject,'String')) returns contents of edt_offsetXStep as a double


% --- Executes during object creation, after setting all properties.
function edt_offsetXStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_offsetXStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_offsetXInc.
function btn_offsetXInc_Callback(hObject, eventdata, handles)
% hObject    handle to btn_offsetXInc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.offsetX = handles.offsetX + handles.offsetXStep;

handles.transMask = refreshUI(handles);
guidata(hObject,handles);

% --- Executes on button press in btn_offsetXDec.
function btn_offsetXDec_Callback(hObject, eventdata, handles)
% hObject    handle to btn_offsetXDec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.offsetX = handles.offsetX - handles.offsetXStep;

handles.transMask = refreshUI(handles);
guidata(hObject,handles);


function edt_offsetYStep_Callback(hObject, eventdata, handles)
% hObject    handle to edt_offsetYStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = round(str2double(get(hObject,'String')));
if ~isnan(tmp) && tmp > 0
    handles.offsetYStep = tmp;
end

handles.transMask = refreshUI(handles);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of edt_offsetYStep as text
%        str2double(get(hObject,'String')) returns contents of edt_offsetYStep as a double


% --- Executes during object creation, after setting all properties.
function edt_offsetYStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_offsetYStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_offsetYInc.
function btn_offsetYInc_Callback(hObject, eventdata, handles)
% hObject    handle to btn_offsetYInc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.offsetY = handles.offsetY + handles.offsetYStep;

handles.transMask = refreshUI(handles);
guidata(hObject,handles);

% --- Executes on button press in btn_offsetYDec.
function btn_offsetYDec_Callback(hObject, eventdata, handles)
% hObject    handle to btn_offsetYDec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.offsetY = handles.offsetY - handles.offsetYStep;

handles.transMask = refreshUI(handles);
guidata(hObject,handles);


% --- Executes on button press in cb_showMask.
function cb_showMask_Callback(hObject, eventdata, handles)
% hObject    handle to cb_showMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.transMask = refreshUI(handles);
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of cb_showMask


% --- Executes on button press in cb_edge.
function cb_edge_Callback(hObject, eventdata, handles)
% hObject    handle to cb_edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.transMask = refreshUI(handles);
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of cb_edge


% --- Executes on button press in cb_fillHole.
function cb_fillHole_Callback(hObject, eventdata, handles)
% hObject    handle to cb_fillHole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.transMask = refreshUI(handles);
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of cb_fillHole


% --- Executes on button press in cb_dilate.
function cb_dilate_Callback(hObject, eventdata, handles)
% hObject    handle to cb_dilate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.transMask = refreshUI(handles);
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of cb_dilate



function edt_dilate_Callback(hObject, eventdata, handles)
% hObject    handle to edt_dilate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = str2double(get(hObject,'String'));
if ~isnan(tmp)
    handles.dilateValue = tmp;
    
    handles.transMask = refreshUI(handles);
    guidata(hObject,handles);
end
% Hints: get(hObject,'String') returns contents of edt_dilate as text
%        str2double(get(hObject,'String')) returns contents of edt_dilate as a double


% --- Executes during object creation, after setting all properties.
function edt_dilate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_dilate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_done.
function btn_done_Callback(hObject, eventdata, handles)
% hObject    handle to btn_done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.cb_transIm.Value
    assignin('base','transMask',handles.transMask');
else
    assignin('base','transMask',handles.transMask);
end

% --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key release with focus on figure1 and none of its controls.
function figure1_KeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)
if ~(isempty(handles.mask) || isempty(handles.SIMSData))
    switch eventdata.Key
        case 'w'
            btn_sizeInc_Callback(handles.btn_sizeInc,[],handles);
        case 's'
            btn_sizeDec_Callback(handles.btn_sizeDec,[],handles);
        case 'a'
            btn_rotRight_Callback(handles.btn_rotRight,[],handles);         
        case 'd'
            btn_rotLeft_Callback(handles.btn_rotLeft,[],handles);
        case 'downarrow'
            btn_offsetXInc_Callback(handles.btn_offsetXInc,[],handles);           
        case 'leftarrow'
            btn_offsetYDec_Callback(handles.btn_offsetYDec,[],handles);            
        case 'rightarrow'
            btn_offsetYInc_Callback(handles.btn_offsetYInc,[],handles);
        case 'uparrow'
            btn_offsetXDec_Callback(handles.btn_offsetXDec,[],handles);
    end
end


% --- Executes on button press in cb_clearEdge.
function cb_clearEdge_Callback(hObject, eventdata, handles)
% hObject    handle to cb_clearEdge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.transMask = refreshUI(handles);
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of cb_clearEdge


% --- Executes on button press in cb_transIm.
function cb_transIm_Callback(hObject, eventdata, handles)
% hObject    handle to cb_transIm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.transMask = refreshUI(handles);
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of cb_transIm
