function varargout = ManualTimeSelection_GUI(varargin)
% MANUALTIMESELECTION_GUI MATLAB code for ManualTimeSelection_GUI.fig
%      MANUALTIMESELECTION_GUI, by itself, creates a new MANUALTIMESELECTION_GUI or raises the existing
%      singleton*.
%
%      H = MANUALTIMESELECTION_GUI returns the handle to a new MANUALTIMESELECTION_GUI or the handle to
%      the existing singleton*.
%
%      MANUALTIMESELECTION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANUALTIMESELECTION_GUI.M with the given input arguments.
%
%      MANUALTIMESELECTION_GUI('Property','Value',...) creates a new MANUALTIMESELECTION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ManualTimeSelection_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ManualTimeSelection_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ManualTimeSelection_GUI

% Last Modified by GUIDE v2.5 17-Mar-2015 19:37:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ManualTimeSelection_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ManualTimeSelection_GUI_OutputFcn, ...
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
end


% --- Executes just before ManualTimeSelection_GUI is made visible.
function ManualTimeSelection_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ManualTimeSelection_GUI (see VARARGIN)

    % Choose default command line output for ManualTimeSelection_GUI
    handles.output = hObject;
    
    % Store the X and Y data in the handles struct
    handles.XData           = varargin{1}.XData;
    handles.YData           = varargin{1}.YData;
    handles.XLabel          = varargin{1}.XLabel;
    handles.YLabel          = varargin{1}.YLabel;
    handles.Instructions    = varargin{1}.Instructions;
    handles.FileName        = varargin{1}.FileName;
    
    % Add the standard toolbar
	set(handles.figure1,'ToolBar','figure')
    
    % Plot the data
    plot(handles.main_axes,handles.XData,handles.YData,'LineWidth',2)
    
    % Set the x and y labels
    xlabel(handles.main_axes,handles.XLabel,'FontSize',16)
    ylabel(handles.main_axes,handles.YLabel,'FontSize',16)
    
    % Set remaining axes properties
    set(handles.main_axes,'FontSize',14)
    grid(handles.main_axes,'on')
	
    % Set the "Time that we're finding" textbox so that the user knows what
    % feature they're supposed to find.
    set(handles.instructions_textbox,'String',handles.Instructions)
    
    % Set the file name into the appropriate textbox
	set(handles.filename_textbox,'String',handles.FileName)
    
    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes ManualTimeSelection_GUI wait for user response (see UIRESUME)
    uiwait(handles.figure1);
    
end


% --- Outputs from this function are returned to the command line.
function varargout = ManualTimeSelection_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    % Get the coordinates from the textbox
    Output.Index = get(handles.index_textbox,'String');
    
    varargout{1} = Output;
    
    % The figure can now be deleted
    delete(handles.figure1);
    
end


% --- Executes on button press in save_and_exit_button.
function save_and_exit_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_and_exit_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    % Check to make sure that the user actually providefd a value
    output = get(handles.index_textbox,'String');
    
    if isempty(output)
        error = errordlg('Please select a point and generate the index before proceeding!','ERROR!');
        uiwait(error)
        return
    end

    % Close the figure and enter the output function
    close(handles.figure1)
    
end


% --- Executes on button press in data_cursor_mode_button.
function data_cursor_mode_button_Callback(hObject, eventdata, handles)
% hObject    handle to data_cursor_mode_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    handles.DataCursorModeObject = datacursormode(handles.figure1);
    set(handles.DataCursorModeObject,'Enable','on')
    
    % Update handles structure
    guidata(hObject, handles);

end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    if isequal(get(hObject,'waitstatus'),'waiting')
        % The GUI is still in UIWAIT, so we will UIRESUME
        uiresume(hObject);
    else
        % Hint: delete(hObject) closes the figure
        delete(hObject);
    end
    
end


% --- Executes on button press in return_index_textbox.
function return_index_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to return_index_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    % Check to make sure that data cursor mode was enabled
    if isfield(handles,'DataCursorModeObject')
        info_struct = getCursorInfo(handles.DataCursorModeObject);
        
        set(handles.index_textbox,'String',num2str(info_struct.DataIndex))
        
        % Now that we've gotten the position, remove the data cursor mode
        % handle from the handles struct and disable data cursor mode
        handles = rmfield(handles,'DataCursorModeObject');
        datacursormode(handles.figure1);
        
    else
        % Data cursor mode was not enabled
        error = errordlg('Data Cursor Mode has not been enabled!','ERROR!');
        uiwait(error)
        return
        
    end
    
    % Update handles structure
    guidata(hObject, handles);
    
end


function index_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to index_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of index_textbox as text
%        str2double(get(hObject,'String')) returns contents of index_textbox as a double
end


% --- Executes during object creation, after setting all properties.
function index_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to index_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function instructions_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to instructions_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of instructions_textbox as text
%        str2double(get(hObject,'String')) returns contents of instructions_textbox as a double
end


% --- Executes during object creation, after setting all properties.
function instructions_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to instructions_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
