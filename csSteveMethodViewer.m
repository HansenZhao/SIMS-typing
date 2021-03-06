function varargout = csSteveMethodViewer(varargin)
% CSSTEVEMETHODVIEWER MATLAB code for csSteveMethodViewer.fig
%      CSSTEVEMETHODVIEWER, by itself, creates a new CSSTEVEMETHODVIEWER or raises the existing
%      singleton*.
%
%      H = CSSTEVEMETHODVIEWER returns the handle to a new CSSTEVEMETHODVIEWER or the handle to
%      the existing singleton*.
%
%      CSSTEVEMETHODVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CSSTEVEMETHODVIEWER.M with the given input arguments.
%
%      CSSTEVEMETHODVIEWER('Property','Value',...) creates a new CSSTEVEMETHODVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before csSteveMethodViewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to csSteveMethodViewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help csSteveMethodViewer

% Last Modified by GUIDE v2.5 16-Jun-2018 18:08:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @csSteveMethodViewer_OpeningFcn, ...
                   'gui_OutputFcn',  @csSteveMethodViewer_OutputFcn, ...
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


% --- Executes just before csSteveMethodViewer is made visible.
function csSteveMethodViewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to csSteveMethodViewer (see VARARGIN)

% Choose default command line output for csSteveMethodViewer
handles.output = hObject;
handles.curCellID = -1;
handles.maxCellID = 0;
handles.priObject = [];


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes csSteveMethodViewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = csSteveMethodViewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function ed_id_Callback(hObject, eventdata, handles)
% hObject    handle to ed_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = get(hObject,'String');
try
    tmp = round(str2double(tmp));
    if ~isnan(tmp) && tmp > 1 && tmp < handles.maxCellID
        handles.curCellID = tmp;
        guidata(hObject,handles)
        refreshFinalBorder(handles);
        return;
    end
catch
end
set(hObject,'String',num2str(handles.curCellID));
% Hints: get(hObject,'String') returns contents of ed_id as text
%        str2double(get(hObject,'String')) returns contents of ed_id as a double


% --- Executes during object creation, after setting all properties.
function ed_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_last_cell.
function btn_last_cell_Callback(hObject, eventdata, handles)
% hObject    handle to btn_last_cell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.curCellID > 1
    handles.curCellID = handles.curCellID - 1;
else
    handles.curCellID = handles.maxCellID;
end
set(handles.ed_id,'String',num2str(handles.curCellID));
guidata(hObject,handles)
refreshFinalBorder(handles);

% --- Executes on button press in btn_next_cell.
function btn_next_cell_Callback(hObject, eventdata, handles)
% hObject    handle to btn_next_cell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.curCellID < handles.maxCellID
    handles.curCellID = handles.curCellID + 1;
else
    handles.curCellID = 1;
end
set(handles.ed_id,'String',num2str(handles.curCellID));
guidata(hObject,handles)
refreshFinalBorder(handles);


function edt_border_thres_Callback(hObject, eventdata, handles)
% hObject    handle to edt_border_thres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = get(hObject,'String');
try
    tmp = str2double(tmp);
    if tmp>=0 && tmp<=1
        handles.options.Border_thres = tmp;
        refreshUI(handles);
        [mat_raw,L] = procImage(hObject,handles);
        handles.mat_raw = mat_raw;
        handles.L = L;
        handles.maxCellID = max(L(:));
        guidata(hObject,handles);
        return;
    end
catch
end
set(hObject,'String',num2str(handles.options.Border_thres));
% Hints: get(hObject,'String') returns contents of edt_border_thres as text
%        str2double(get(hObject,'String')) returns contents of edt_border_thres as a double


% --- Executes during object creation, after setting all properties.
function edt_border_thres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_border_thres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_border_is_filling.
function cb_border_is_filling_Callback(hObject, eventdata, handles)
% hObject    handle to cb_border_is_filling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    handles.options.Border_is_Filling = get(hObject,'Value');
    refreshUI(handles);
    [mat_raw,L,priObject] = procImage(hObject,handles);
    handles.mat_raw = mat_raw;
    handles.L = L;
    handles.maxCellID = max(L(:));
    handles.priObject = priObject;
    guidata(hObject,handles);
    return;
catch
end
set(hObject,'Value',handles.options.Border_is_Filling);
% Hint: get(hObject,'Value') returns toggle state of cb_border_is_filling


% --- Executes on button press in cb_border_is_open.
function cb_border_is_open_Callback(hObject, eventdata, handles)
% hObject    handle to cb_border_is_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    handles.options.Border_is_Opening = get(hObject,'Value');
    refreshUI(handles);
    [mat_raw,L,priObject] = procImage(hObject,handles);
    handles.mat_raw = mat_raw;
    handles.L = L;
    handles.maxCellID = max(L(:));
    handles.priObject = priObject;
    guidata(hObject,handles);
    return;
catch
end
set(hObject,'Value',handles.options.Border_is_Opening);
% Hint: get(hObject,'Value') returns toggle state of cb_border_is_open



function edt_border_open_radius_Callback(hObject, eventdata, handles)
% hObject    handle to edt_border_open_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = get(hObject,'String');
try
    tmp = str2double(tmp);
    if tmp>=0
        handles.options.Border_Open_Radius = tmp;
        refreshUI(handles);
        [mat_raw,L,priObject] = procImage(hObject,handles);
        handles.mat_raw = mat_raw;
        handles.L = L;
        handles.maxCellID = max(L(:));
        handles.priObject = priObject;
        guidata(hObject,handles);
        return;
    end
catch
end
set(hObject,'String',num2str(handles.options.Border_Open_Radius));
% Hints: get(hObject,'String') returns contents of edt_border_open_radius as text
%        str2double(get(hObject,'String')) returns contents of edt_border_open_radius as a double


% --- Executes during object creation, after setting all properties.
function edt_border_open_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_border_open_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_border_is_eleminate.
function cb_border_is_eleminate_Callback(hObject, eventdata, handles)
% hObject    handle to cb_border_is_eleminate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    handles.options.Border_is_Eleminating = get(hObject,'Value');
    refreshUI(handles);
    [mat_raw,L,priObject] = procImage(hObject,handles);
    handles.mat_raw = mat_raw;
    handles.L = L;
    handles.maxCellID = max(L(:));
    handles.priObject = priObject;
    guidata(hObject,handles);
    return;
catch
end
set(hObject,'Value',handles.options.Border_is_Eleminating);
% Hint: get(hObject,'Value') returns toggle state of cb_border_is_eleminate



function edt_border_eleminate_thres_Callback(hObject, eventdata, handles)
% hObject    handle to edt_border_eleminate_thres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = get(hObject,'String');
try
    tmp = str2double(tmp);
    if tmp>=0
        handles.options.Border_Eleminating = tmp;
        refreshUI(handles);
        [mat_raw,L] = procImage(hObject,handles);
        handles.mat_raw = mat_raw;
        handles.L = L;
        handles.maxCellID = max(L(:));
        guidata(hObject,handles);
        return;
    end
catch
end
set(hObject,'String',num2str(handles.options.Border_Eleminating));
% Hints: get(hObject,'String') returns contents of edt_border_eleminate_thres as text
%        str2double(get(hObject,'String')) returns contents of edt_border_eleminate_thres as a double


% --- Executes during object creation, after setting all properties.
function edt_border_eleminate_thres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_border_eleminate_thres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_is_clahe.
function cb_is_clahe_Callback(hObject, eventdata, handles)
% hObject    handle to cb_is_clahe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    handles.options.is_CLAHE = get(hObject,'Value');
    refreshUI(handles);
    [mat_raw,L,priObject] = procImage(hObject,handles);
    handles.mat_raw = mat_raw;
    handles.L = L;
    handles.maxCellID = max(L(:));
    handles.priObject = priObject;
    guidata(hObject,handles);
    return;
catch
end
set(hObject,'Value',handles.options.is_CLAHE);
% Hint: get(hObject,'Value') returns toggle state of cb_is_clahe



function edt_H_Callback(hObject, eventdata, handles)
% hObject    handle to edt_H (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = get(hObject,'String');
try
    tmp = str2double(tmp);
    if tmp>=0 && tmp<=1
        handles.options.H = tmp;
        refreshUI(handles);
        [mat_raw,L] = procImage(hObject,handles);
        handles.mat_raw = mat_raw;
        handles.L = L;
        handles.maxCellID = max(L(:));
        guidata(hObject,handles);
        return;
    end
catch
end
set(hObject,'String',num2str(handles.options.H));
% Hints: get(hObject,'String') returns contents of edt_H as text
%        str2double(get(hObject,'String')) returns contents of edt_H as a double


% --- Executes during object creation, after setting all properties.
function edt_H_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_H (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_object_is_closing.
function cb_object_is_closing_Callback(hObject, eventdata, handles)
% hObject    handle to cb_object_is_closing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    handles.options.Object_is_Closing = get(hObject,'Value');
    refreshUI(handles);
    [mat_raw,L] = procImage(hObject,handles);
    handles.mat_raw = mat_raw;
    handles.L = L;
    handles.maxCellID = max(L(:));
    guidata(hObject,handles);
    return;
catch
end
set(hObject,'Value',handles.options.Object_is_Closing);
% Hint: get(hObject,'Value') returns toggle state of cb_object_is_closing


% --- Executes on button press in cb_object_is_filling.
function cb_object_is_filling_Callback(hObject, eventdata, handles)
% hObject    handle to cb_object_is_filling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    handles.options.Object_is_Filling = get(hObject,'Value');
    refreshUI(handles);
    [mat_raw,L,priObject] = procImage(hObject,handles);
    handles.mat_raw = mat_raw;
    handles.L = L;
    handles.maxCellID = max(L(:));
    handles.priObject = priObject;
    guidata(hObject,handles);
    return;
catch
end
set(hObject,'Value',handles.options.Object_is_Filling);
% Hint: get(hObject,'Value') returns toggle state of cb_object_is_filling



function edt_object_closing_radius_Callback(hObject, eventdata, handles)
% hObject    handle to edt_object_closing_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = get(hObject,'String');
try
    tmp = str2double(tmp);
    if tmp>=0
        handles.options.Object_Closing_Radius = tmp;
        refreshUI(handles);
        [mat_raw,L] = procImage(hObject,handles);
        handles.mat_raw = mat_raw;
        handles.L = L;
        handles.maxCellID = max(L(:));
        guidata(hObject,handles);
        return;
    end
catch
end
set(hObject,'String',num2str(handles.options.Object_Closing_Radius));
% Hints: get(hObject,'String') returns contents of edt_object_closing_radius as text
%        str2double(get(hObject,'String')) returns contents of edt_object_closing_radius as a double


% --- Executes during object creation, after setting all properties.
function edt_object_closing_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_object_closing_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_load_file.
function btn_load_file_Callback(hObject, eventdata, handles)
% hObject    handle to btn_load_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.SIMSData = SIMSTxtData();
handles.options = genDefaultSteveOption;
refreshUI(handles);
[mat_raw,L,priObject] = procImage(hObject,handles);
handles.mat_raw = mat_raw;
handles.L = L;
handles.priObject = priObject;
handles.maxCellID = max(L(:));
guidata(hObject,handles);


% --- Executes on button press in btn_clear.
function btn_clear_Callback(hObject, eventdata, handles)
% hObject    handle to btn_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.SIMSData = [];
handles.curCellID = -1;
handles.maxCellID = 0;
handles.mat_raw = [];
handles.L = [];
handles.priObject = [];
cla(handles.axes_raw);
cla(handles.axes_pri);
cla(handles.axes_border);
cla(handles.axes_mod);
cla(handles.axes_final_border);
cla(handles.axes_label);
guidata(hObject,handles);

% --- Executes on button press in btn_load_option.
function btn_load_option_Callback(hObject, eventdata, handles)
% hObject    handle to btn_load_option (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,fp] = uigetfile('*.mat');
res = load(strcat(fp,fn));
handles.options = res.opt;
refreshUI(handles);
[mat_raw,L,priObject] = procImage(hObject,handles);
handles.mat_raw = mat_raw;
handles.L = L;
handles.maxCellID = max(L(:));
handles.priObject = priObject;
guidata(hObject,handles);



% --- Executes on button press in btn_save.
function btn_save_Callback(hObject, eventdata, handles)
% hObject    handle to btn_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
res = inputdlg({'include background','is excute border cell','append sample name'},'SMM',1,{'0','0','0'});
if ~isempty(res)
    if str2double(res{1})
        startID = 1;
    else
        startID = 2;
    end
    borderThes = str2double(res{2});
    if res{3}=='0'
        appSampleName = [];
    elseif res{3} == 's'
        appSampleName = handles.SIMSData.sampleName;
    else
        appSampleName = res{3};
    end
    path = uigetdir();
    L = handles.maxCellID - startID + 1;
    sampleName = cell(L,1);
    msdata = zeros(L,handles.msAssem.nMS);
    pos = zeros(L,2);
    labelData = zeros(handles.SIMSData.imageSize,handles.SIMSData.imageSize,L);
    doneNum = 1;
    for m = startID:handles.maxCellID
        [b,xy] = isInborder(handles.L==m,borderThes);
        if ~b
            if isempty(appSampleName)
                sampleName{doneNum} = num2str(m);
            else
                sampleName{doneNum} = sprintf('%s-%d',appSampleName,m);
            end
            handles.curCellID = m;
            guidata(hObject,handles)
            refreshFinalBorder(handles);
            labelData(:,:,doneNum) = handles.L==handles.curCellID;
            [~,intens] = handles.msAssem.getMSByIndex(handles.L==handles.curCellID);
            msdata(doneNum,:) = intens';
            pos(doneNum,:) = xy;
            
            f = getframe(handles.axes_final_border);

            imwrite(f.cdata,sprintf('%s//%s.png',path,sampleName{doneNum}),'png');   
            
            doneNum = doneNum + 1;
        end
    end
    msdata(doneNum:end,:) = [];
    pos(doneNum:end,:) = [];
    labelData(:,:,doneNum:end) = [];
    sampleName(doneNum:end) = [];
    mz = handles.msAssem.mz;
    priObject = handles.priObject;
    opt = handles.options;
    save(sprintf('%s//option.mat',path),'opt');
    save(sprintf('%s//data.mat',path),'msdata','mz','sampleName','pos','labelData','priObject');
end

function [b,xy] = isInborder(L,thres)
    len = size(L,1);
    coverNum = sum(L(:));
    [x,y] = find(L);
    isBorder = or(x==1|x==len,y==1|y==len);
    if thres >= 1
        b = sum(isBorder) > thres;
    elseif thres > 0
        b = sum(isBorder)/coverNum > thres;
    else
        b = 0;
    end
    xy = mean([x,y]);


% --- Executes on button press in btn_save_option.
function btn_save_option_Callback(hObject, eventdata, handles)
% hObject    handle to btn_save_option (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,fp] = uiputfile('*.mat');
opt = handles.options;
save(strcat(fp,fn),'opt');


function refreshUI(handles)
    handles.cb_is_clahe.Value = handles.options.is_CLAHE;
    handles.edt_H.String = num2str(handles.options.H);
    handles.tx_cellnum.String = num2str(handles.maxCellID);
    
    handles.cb_object_is_closing.Value = handles.options.Object_is_Closing;
    handles.edt_object_closing_radius.String = handles.options.Object_Closing_Radius;
    if handles.cb_object_is_closing.Value
        handles.edt_object_closing_radius.Enable = 'on';
    else
        handles.edt_object_closing_radius.Enable = 'off';
    end
    
    handles.cb_object_is_filling.Value = handles.options.Object_is_Filling;
    handles.edt_border_thres.String = num2str(handles.options.Border_thres);
    handles.border_is_filling = handles.options.Border_is_Filling;
    
    handles.cb_border_is_open.Value = handles.options.Border_is_Opening;
    handles.edt_border_open_radius.String = handles.options.Border_Open_Radius;
    if handles.cb_border_is_open.Value
        handles.edt_border_open_radius.Enable = 'on';
    else
        handles.edt_border_open_radius.Enable = 'off';
    end
    
    handles.cb_border_is_eleminate.Value = handles.options.Border_is_Eleminating;
    handles.edt_border_eleminate_thres.String = handles.options.Border_Eleminating;
    if handles.cb_border_is_eleminate.Value
        handles.edt_border_eleminate_thres.Enable = 'on';
    else
        handles.edt_border_eleminate_thres.Enable = 'off';
    end
    
    handles.cb_semiauto.Value = handles.options.is_Semiauto;
    if handles.cb_semiauto.Value
        handles.btn_add.Enable = 'on';
        handles.btn_minus.Enable = 'on';
    else
        handles.btn_add.Enable = 'off';
        handles.btn_minus.Enable = 'off';
    end
    
    handles.ed_id.String = num2str(handles.curCellID);
    
function [mat_raw,L,priObject] = procImage(hObject,handles)
    [L,~,~,mat_raw,mat_pri,mat_border,mat_mod,priObject] = csSteveMethod(...
                                  handles.SIMSData.rawMat,handles.options,handles.priObject);
    imagesc(handles.axes_raw,mat_raw); colormap('gray');
    imagesc(handles.axes_pri,mat_pri);
    imagesc(handles.axes_border,mat_border);
    imagesc(handles.axes_mod,mat_mod);
    imagesc(handles.axes_label,label2rgb(L));
    
    handles.axes_raw.XTick =[];
    handles.axes_raw.YTick =[];
    handles.axes_pri.XTick =[];
    handles.axes_pri.YTick =[];
    handles.axes_border.XTick =[];
    handles.axes_border.YTick =[];
    handles.axes_mod.XTick =[];
    handles.axes_mod.YTick =[];
    handles.axes_label.XTick =[];
    handles.axes_label.YTick =[];
    handles.axes_final_border.XTick =[];
    handles.axes_final_border.YTick =[];
    
    handles.maxCellID = max(L(:));
    handles.mat_raw = mat_raw;
    handles.L = L;
    guidata(hObject,handles);
    refreshFinalBorder(handles);
    

function refreshFinalBorder(handles)
    imFinalBorder = imoverlay(handles.mat_raw,handles.L==0|handles.L==handles.curCellID,[1,.3,.3]);
    imagesc(handles.axes_final_border,imFinalBorder);
    handles.axes_final_border.XTick =[];
    handles.axes_final_border.YTick =[];

    


% --- Executes on button press in cb_semiauto.
function cb_semiauto_Callback(hObject, eventdata, handles)
% hObject    handle to cb_semiauto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    handles.options.is_Semiauto = get(hObject,'Value');
    refreshUI(handles);
    [mat_raw,L,priObject] = procImage(hObject,handles);
    handles.mat_raw = mat_raw;
    handles.L = L;
    handles.maxCellID = max(L(:));
    handles.priObject = priObject;
    guidata(hObject,handles);
    return;
catch
end
set(hObject,'Value',handles.options.is_Semiauto);
% Hint: get(hObject,'Value') returns toggle state of cb_semiauto


% --- Executes on button press in btn_add.
function btn_add_Callback(hObject, eventdata, handles)
% hObject    handle to btn_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hf = figure;
h = roipoly(handles.axes_pri.Children.CData);
close(hf);
handles.priObject = handles.priObject | h;
[mat_raw,L,priObject] = procImage(hObject,handles);
handles.mat_raw = mat_raw;
handles.L = L;
handles.maxCellID = max(L(:));
handles.priObject = priObject;
guidata(hObject,handles);

% --- Executes on button press in btn_minus.
function btn_minus_Callback(hObject, eventdata, handles)
% hObject    handle to btn_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hf = figure;
h = roipoly(handles.axes_pri.Children.CData);
close(hf);
handles.priObject = handles.priObject & (~h);
[mat_raw,L,priObject] = procImage(hObject,handles);
handles.mat_raw = mat_raw;
handles.L = L;
handles.maxCellID = max(L(:));
handles.priObject = priObject;
guidata(hObject,handles);

% --- Executes on button press in btn_excell.
function btn_excell_Callback(hObject, eventdata, handles)
% hObject    handle to btn_excell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    handles.L(handles.L==handles.curCellID) = 1;
    guidata(hObject,handles);
    refreshFinalBorder(handles);
catch
end


% --- Executes on button press in btn_loadms.
function btn_loadms_Callback(hObject, eventdata, handles)
% hObject    handle to btn_loadms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    [fn,fp] = listFile('*.txt',handles.SIMSData.fp(1:(end-1)));
    L = length(fn);
    handles.msAssem = SIMSDataAssem();
    guidata(hObject,handles);
    hbar = waitbar(0,'loading...');
    for m = 1:1:L
        %disp(m);
        handles.msAssem.addFile(fp{m},fn{m});
        waitbar(m/L,hbar);
    end
    close(hbar);
    handles.msAssem.sortMS();
    guidata(hObject,handles);
catch e
    rethrow(e);
    warndlg('loading failed');
end


% --- Executes on button press in btn_cellprofile.
function btn_cellprofile_Callback(hObject, eventdata, handles)
% hObject    handle to btn_cellprofile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    [mz,intens] = handles.msAssem.getMSByIndex(handles.L==handles.curCellID);
    figure;
    plot(mz,intens);
catch
end