function varargout = IgnitionDashboard(varargin)
% IGNITIONDASHBOARD MATLAB code for IgnitionDashboard.fig
%      IGNITIONDASHBOARD, by itself, creates a new IGNITIONDASHBOARD or raises the existing
%      singleton*.
%
%      H = IGNITIONDASHBOARD returns the handle to a new IGNITIONDASHBOARD or the handle to
%      the existing singleton*.
%
%      IGNITIONDASHBOARD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IGNITIONDASHBOARD.M with the given input arguments.
%
%      IGNITIONDASHBOARD('Property','Value',...) creates a new IGNITIONDASHBOARD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IgnitionDashboard_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IgnitionDashboard_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IgnitionDashboard

% Last Modified by GUIDE v2.5 26-Apr-2015 17:58:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IgnitionDashboard_OpeningFcn, ...
                   'gui_OutputFcn',  @IgnitionDashboard_OutputFcn, ...
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


% --- Executes just before IgnitionDashboard is made visible.
function IgnitionDashboard_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IgnitionDashboard (see VARARGIN)

    % Choose default command line output for IgnitionDashboard
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes IgnitionDashboard wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    
end


% --- Outputs from this function are returned to the command line.
function varargout = IgnitionDashboard_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
    
end


% --- Executes on button press in process_test_point_button.
function process_test_point_button_Callback(hObject, eventdata, handles)
% hObject    handle to process_test_point_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in browse_home_folder_textbox.
function browse_home_folder_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to browse_home_folder_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    
    if isfield(handles,'HomeFolder')
       % The user has already chosen a home folder. Use this choice as the 
       % default selection in the "uigetdir" function.
        
        % Get the home folder from the user
        handles.HomeFolder = uigetdir(handles.HomeFolder,'Select a home folder');
    else
        
        % Get the home folder from the user
        handles.HomeFolder = uigetdir('C:\Users\Jim Cornacchio\Documents\Dissertation\','Please Select a Home Folder');

        % Exit cleanly if the user hits the "cancel" button
        if ~handles.HomeFolder
            return
        end   
        
    end
    
    % Set the textbox to read the selection
    set(handles.home_folder_textbox,'String',handles.HomeFolder)
        
    % Update handles structure
    guidata(hObject, handles);
    
end


function home_folder_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to home_folder_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of home_folder_textbox as text
%        str2double(get(hObject,'String')) returns contents of home_folder_textbox as a double
end


% --- Executes during object creation, after setting all properties.
function home_folder_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to home_folder_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end


% --- Executes on button press in open_processed_spark_video_viewing_tool_button.
function open_processed_spark_video_viewing_tool_button_Callback(hObject, eventdata, handles)
% hObject    handle to open_processed_spark_video_viewing_tool_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    % Check to make sure that the user selected a valid home folder
    if ~isfield(handles,'HomeFolder') || ~isdir(handles.HomeFolder)
        error = errordlg('Please select a valid home folder.','ERROR');
        uiwait(error)
        return
    end
    
    % Store the required inputs
    input.HomeFolder = handles.HomeFolder;
    
    % Call the processed spark video viewer
    SparkFrameViewer_GUI(input);
    
    % Update handles structure
    guidata(hObject, handles);

end


% --- Executes on button press in process_scope_data_button.
function process_scope_data_button_Callback(hObject, eventdata, handles)
% hObject    handle to process_scope_data_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Check to make sure that the user selected a valid home folder
    if ~isfield(handles,'HomeFolder') || ~isdir(handles.HomeFolder)
        error = errordlg('Please select a valid home folder.','ERROR');
        uiwait(error)
        return
    end
    
    % Store the required inputs
    input.HomeFolder = handles.HomeFolder;
    
    % Call the oscilloscope data processor
    OscilloscopeDataProcessor_GUI(input)
    
    % Update handles structure
    guidata(hObject, handles);
    
end


% --- Executes on button press in create_oscilloscope_setup_file_summary_button.
function create_oscilloscope_setup_file_summary_button_Callback(hObject, eventdata, handles)
% hObject    handle to create_oscilloscope_setup_file_summary_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    % Check to make sure that the user selected a valid home folder
    if isfield(handles,'HomeFolder') 
        input.HomeFolder = handles.HomeFolder;
        
        % Call the oscilloscope setup file GUI
        OscilloscopeSetupFileToExcel_GUI(input)
        
    else
        % Call the oscilloscope setup file GUI
        OscilloscopeSetupFileToExcel_GUI
        
    end   
        
    % Update handles structure
    guidata(hObject, handles);
    
end


% --- Executes on button press in create_empty_home_folder_button.
function create_empty_home_folder_button_Callback(hObject, eventdata, handles)
% hObject    handle to create_empty_home_folder_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        
    % Get the new home folder location from the user
    NewHomeFolder = uigetdir('C:\Users\Jim Cornacchio\Documents\Dissertation\','Please Select a Home Folder');

    % Exit cleanly if the user hits the "cancel" button
    if ~NewHomeFolder
        return
    end   
	
    % Create the setup file folder
    if ~isdir(fullfile(NewHomeFolder,'Oscilloscope Setup Files'))
        mkdir(fullfile(NewHomeFolder,'Oscilloscope Setup Files'));
    end
    
    % Create the raw data folder
    if ~isdir(fullfile(NewHomeFolder,'Raw Oscilloscope Data'))
        mkdir(fullfile(NewHomeFolder,'Raw Oscilloscope Data'));
    end
    
    % Set the current home folder to this new home folder
    handles.HomeFolder = NewHomeFolder;
    
    % Update the textbox
    set(handles.home_folder_textbox,'String',handles.HomeFolder)
        
    % Update handles structure
    guidata(hObject, handles);

end
