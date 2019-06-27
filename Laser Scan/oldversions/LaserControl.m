
function varargout = LaserControl(varargin)
% LASERCONTROL MATLAB code for LaserControl.fig
%      LASERCONTROL, by itself, creates a new LASERCONTROL or raises the existing
%      singleton*.
%
%      H = LASERCONTROL returns the handle to a new LASERCONTROL or the handle to
%      the existing singleton*.
%
%      LASERCONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LASERCONTROL.M with the given input arguments.
%
%      LASERCONTROL('Property','Value',...) creates a new LASERCONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LaserControl_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LaserControl_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LaserControl

% Last Modified by GUIDE v2.5 10-Mar-2015 20:55:31

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LaserControl_OpeningFcn, ...
                   'gui_OutputFcn',  @LaserControl_OutputFcn, ...
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


% --- Executes just before LaserControl is made visible.
function LaserControl_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LaserControl (see VARARGIN)

set(handles.edit_fw_l_wavelength,'string','1550.00');
set(handles.edit_fw_l_power,'string','1.0');
set(handles.pm_fw_l_unit,'value',2.0);
set(handles.pm_fw_l_channel,'value',2.0);
set(handles.edit_fw_display,'string','0.000');

set(handles.edit_fw_p_wavelength,'string','1550.00');
set(handles.pm_fw_p_unit,'value',1.0);
set(handles.pm_fw_p_averagetime,'value',3.0);
set(handles.edit_fw_p_slot,'string','1');
set(handles.edit_fw_p_channel,'string','0');

set(handles.pm_ls_speed,'value',4.0);
set(handles.edit_ls_start,'string','1500');
set(handles.edit_ls_stop,'string','1600');
set(handles.edit_ls_step,'string','10');
set(handles.edit_ls_power,'string','1.0');
set(handles.pm_ls_unit,'value',2.0);
set(handles.pm_ls_source,'value',1.0);
set(handles.edit_ls_range,'string','-10');
set(handles.edit_ls_channel,'string','2');
set(handles.edit_save,'string','File name');

handles.color=get(handles.b_disconnect,'backgroundcolor');

% Choose default command line output for LaserControl
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LaserControl wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LaserControl_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in b_connect.
function b_connect_Callback(hObject, eventdata, handles)
% hObject    handle to b_connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

deviceObj = icdevice('hp816x.mdd','GPIB0::20::INSTR');
connect(deviceObj)
set(hObject,'UserData',deviceObj);
set(hObject,'backgroundcolor','green');



% --- Executes on button press in b_disconnect.
function b_disconnect_Callback(hObject, eventdata, handles)
% hObject    handle to b_disconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.b_connect,'backgroundcolor',handles.color);
set(handles.b_on,'backgroundcolor',handles.color);
set(handles.b_off,'backgroundcolor',handles.color);
set(handles.b_start,'backgroundcolor',handles.color);

deviceObj=get(handles.b_connect,'UserData');
disconnect(deviceObj);
set(handles.b_connect,'UserData',NaN);



function edit_fw_display_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fw_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fw_display as text
%        str2double(get(hObject,'String')) returns contents of edit_fw_display as a double


% --- Executes during object creation, after setting all properties.
function edit_fw_display_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fw_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_fw_p_wavelength_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fw_p_wavelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fw_p_wavelength as text
%        str2double(get(hObject,'String')) returns contents of edit_fw_p_wavelength as a double


% --- Executes during object creation, after setting all properties.
function edit_fw_p_wavelength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fw_p_wavelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_fw_p_unit.
function pm_fw_p_unit_Callback(hObject, eventdata, handles)
% hObject    handle to pm_fw_p_unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_fw_p_unit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_fw_p_unit


% --- Executes during object creation, after setting all properties.
function pm_fw_p_unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_fw_p_unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String',{'dBm';'mW'});

% --- Executes on selection change in pm_fw_p_averagetime.
function pm_fw_p_averagetime_Callback(hObject, eventdata, handles)
% hObject    handle to pm_fw_p_averagetime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_fw_p_averagetime contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_fw_p_averagetime


% --- Executes during object creation, after setting all properties.
function pm_fw_p_averagetime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_fw_p_averagetime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String',{'50ms';'100ms';'200ms';'500ms';'1s'});



function edit_fw_p_slot_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fw_p_slot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fw_p_slot as text
%        str2double(get(hObject,'String')) returns contents of edit_fw_p_slot as a double


% --- Executes during object creation, after setting all properties.
function edit_fw_p_slot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fw_p_slot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_fw_p_channel_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fw_p_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fw_p_channel as text
%        str2double(get(hObject,'String')) returns contents of edit_fw_p_channel as a double


% --- Executes during object creation, after setting all properties.
function edit_fw_p_channel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fw_p_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_fw_l_wavelength_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fw_l_wavelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fw_l_wavelength as text
%        str2double(get(hObject,'String')) returns contents of edit_fw_l_wavelength as a double


% --- Executes during object creation, after setting all properties.
function edit_fw_l_wavelength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fw_l_wavelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_fw_l_power_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fw_l_power (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fw_l_power as text
%        str2double(get(hObject,'String')) returns contents of edit_fw_l_power as a double


% --- Executes during object creation, after setting all properties.
function edit_fw_l_power_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fw_l_power (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_fw_l_unit.
function pm_fw_l_unit_Callback(hObject, eventdata, handles)
% hObject    handle to pm_fw_l_unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_fw_l_unit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_fw_l_unit


% --- Executes during object creation, after setting all properties.
function pm_fw_l_unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_fw_l_unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String',{'dBm';'mW'});


% --- Executes on selection change in pm_fw_l_channel.
function pm_fw_l_channel_Callback(hObject, eventdata, handles)
% hObject    handle to pm_fw_l_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_fw_l_channel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_fw_l_channel


% --- Executes during object creation, after setting all properties.
function pm_fw_l_channel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_fw_l_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String',{'High power';'low SSE'});

% % --- Executes on button press in pushbutton4.
% function pushbutton4_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton4 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)


function edit_ls_power_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ls_power (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ls_power as text
%        str2double(get(hObject,'String')) returns contents of edit_ls_power as a double


% --- Executes during object creation, after setting all properties.
function edit_ls_power_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ls_power (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_ls_unit.
function pm_ls_unit_Callback(hObject, eventdata, handles)
% hObject    handle to pm_ls_unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_ls_unit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_ls_unit


% --- Executes during object creation, after setting all properties.
function pm_ls_unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_ls_unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String',{'dBm';'mW'});


function edit_ls_channel_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ls_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ls_channel as text
%        str2double(get(hObject,'String')) returns contents of edit_ls_channel as a double


% --- Executes during object creation, after setting all properties.
function edit_ls_channel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ls_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ls_range_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ls_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ls_range as text
%        str2double(get(hObject,'String')) returns contents of edit_ls_range as a double


% --- Executes during object creation, after setting all properties.
function edit_ls_range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ls_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_ls_start_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ls_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ls_start as text
%        str2double(get(hObject,'String')) returns contents of edit_ls_start as a double


% --- Executes during object creation, after setting all properties.
function edit_ls_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ls_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ls_stop_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ls_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ls_stop as text
%        str2double(get(hObject,'String')) returns contents of edit_ls_stop as a double


% --- Executes during object creation, after setting all properties.
function edit_ls_stop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ls_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ls_step_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ls_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ls_step as text
%        str2double(get(hObject,'String')) returns contents of edit_ls_step as a double


% --- Executes during object creation, after setting all properties.
function edit_ls_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ls_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_ls_speed.
function pm_ls_speed_Callback(hObject, eventdata, handles)
% hObject    handle to pm_ls_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_ls_speed contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_ls_speed


% --- Executes during object creation, after setting all properties.
function pm_ls_speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_ls_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String',{'80';'40';'20';'10';'5';'0.5'});

% --- Executes on selection change in pm_ls_source.
function pm_ls_source_Callback(hObject, eventdata, handles)
% hObject    handle to pm_ls_source (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_ls_source contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_ls_source


% --- Executes during object creation, after setting all properties.
function pm_ls_source_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_ls_source (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String',{'High power';'low SSE'});


% --- Executes on button press in b_on.
function b_on_Callback(hObject, eventdata, handles)
% hObject    handle to b_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of b_on
set(hObject,'backgroundcolor','green');
set(handles.b_off,'backgroundcolor',handles.color);

Fixwavelength(handles);


% --- Executes on button press in b_off.
function b_off_Callback(hObject, eventdata, handles)
% hObject    handle to b_off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

deviceObj=get(handles.b_connect,'UserData');
TLSmodule=get(deviceObj, 'Tunablelasersources');
invoke(TLSmodule,'settlslaserstate',0,0);

set(hObject,'Value',0);

set(handles.b_on,'backgroundcolor',handles.color);
set(hObject,'backgroundcolor','green')


% --- Executes on button press in b_start.
function b_start_Callback(hObject, eventdata, handles)
% hObject    handle to b_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject,'backgroundcolor','green');
pause(0.2);

Lamdascan(handles);

set(hObject,'backgroundcolor',handles.color);


% --- Executes on button press in p_save.
function p_save_Callback(hObject, eventdata, handles)
% hObject    handle to p_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=get(handles.edit_save,'string');
a=get(handles.p_save,'UserData');
spec = figure;
plot(a(1,:),a(2,:),'Marker','.')
xlabel('Wavelength (nm)');
ylabel('Power (dBm)');
grid on
%%
TimeStamp=clock;
dlmwrite('test.csv',TimeStamp,'delimiter',',','-append');
%%
s2 = datestr(now,'dd-mmm-yyyy,HH-MM-SS');
saveas(spec,[filename '_' s2],'fig');
% save(filename,'a');


function edit_save_Callback(hObject, eventdata, handles)
% hObject    handle to edit_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_save as text
%        str2double(get(hObject,'String')) returns contents of edit_save as a double


% --- Executes during object creation, after setting all properties.
function edit_save_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
