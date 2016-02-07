function varargout = OscilloscopeDataProcessor_GUI(varargin)
% OSCILLOSCOPEDATAPROCESSOR_GUI MATLAB code for OscilloscopeDataProcessor_GUI.fig
%      OSCILLOSCOPEDATAPROCESSOR_GUI, by itself, creates a new OSCILLOSCOPEDATAPROCESSOR_GUI or raises the existing
%      singleton*.
%
%      H = OSCILLOSCOPEDATAPROCESSOR_GUI returns the handle to a new OSCILLOSCOPEDATAPROCESSOR_GUI or the handle to
%      the existing singleton*.
%
%      OSCILLOSCOPEDATAPROCESSOR_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OSCILLOSCOPEDATAPROCESSOR_GUI.M with the given input arguments.
%
%      OSCILLOSCOPEDATAPROCESSOR_GUI('Property','Value',...) creates a new OSCILLOSCOPEDATAPROCESSOR_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OscilloscopeDataProcessor_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OscilloscopeDataProcessor_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OscilloscopeDataProcessor_GUI

% Last Modified by GUIDE v2.5 19-Jul-2015 17:24:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OscilloscopeDataProcessor_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @OscilloscopeDataProcessor_GUI_OutputFcn, ...
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

% --- Executes just before OscilloscopeDataProcessor_GUI is made visible.
function OscilloscopeDataProcessor_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OscilloscopeDataProcessor_GUI (see VARARGIN)

    % Choose default command line output for OscilloscopeDataProcessor_GUI
    handles.output = hObject;
    
    % Store the home folder location in the handles struct.
    handles.HomeFolder = varargin{1}.HomeFolder;
    
    % Initialize the binary file and oscilloscope channel tables
    scope_channel_table_data    = {'' ''; '' '';'' ''};
    binary_table_data           = {'';'';'';'';''};
    
    set(handles.binary_file_table,'Data',binary_table_data)
    set(handles.scope_channel_table,'Data',scope_channel_table_data)
    
    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes OscilloscopeDataProcessor_GUI wait for user response (see UIRESUME)
    uiwait(handles.figure1);
    
end


% --- Outputs from this function are returned to the command line.
function varargout = OscilloscopeDataProcessor_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
    
    % The figure can now be deleted
    delete(handles.figure1);
    
end


% --- Executes on button press in browse_binary_files_button.
function browse_binary_files_button_Callback(hObject, eventdata, handles)
% hObject    handle to browse_binary_files_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Provide the user with a GUI to select the files.
    if isfield(handles,'BinaryFilePath')
        [FileNames,PathName] = uigetfile(fullfile(handles.BinaryFilePath,'*.bin'),'Please Select Binary Files to Process','MultiSelect','on');
    else
        [FileNames,PathName] = uigetfile(fullfile(handles.HomeFolder,'*.bin'),'Please Select Binary Files to Process','MultiSelect','on');
    end
    
    if isequal(FileNames,0) || isequal(PathName,0)
        % The user hit the cancel button
        return
    end
    
    % Make sure that FileNames is a cell. It will be a string if only 1
    % file was selected.
    if ~iscell(FileNames)
        FileNames = {FileNames};
    end
    
    % Make sure that FileNames is a row array.
    if isrow(FileNames)
        FileNames = FileNames';
    end
    
    % Store the pathname in the handles struct and store the file names in
    % the table
    set(handles.binary_file_table,'Data',FileNames);
    handles.BinaryFilePath = PathName;
    
    % Update handles structure
    guidata(hObject, handles);
    
end


% --- Executes on button press in browse_setup_file_location_button.
function browse_setup_file_location_button_Callback(hObject, eventdata, handles)
% hObject    handle to browse_setup_file_location_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


end

% --- Executes on selection change in spark_voltage_channel_popupmenu.
function spark_voltage_channel_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to spark_voltage_channel_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns spark_voltage_channel_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from spark_voltage_channel_popupmenu
end


% --- Executes during object creation, after setting all properties.
function spark_voltage_channel_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spark_voltage_channel_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end


% --- Executes on selection change in spark_current_channel_popupmenu.
function spark_current_channel_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to spark_current_channel_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns spark_current_channel_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from spark_current_channel_popupmenu
end


% --- Executes during object creation, after setting all properties.
function spark_current_channel_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spark_current_channel_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end


% --- Executes on button press in process_data_button.
function process_data_button_Callback(hObject, eventdata, handles)
% hObject    handle to process_data_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Check to make sure that at least one binary file was selected.
    BinaryFileList              = get(handles.binary_file_table,'Data');
    empty_idx                   = cellfun('isempty',BinaryFileList);
    BinaryFileList(empty_idx)   = [];
    
    if isempty(BinaryFileList)
       error = errordlg('Please provide at least one file to process.','ERROR!');
       uiwait(error)
       return
    end
        
    % Get the oscilloscope channel table
    ScopeChannelTable = get(handles.scope_channel_table,'Data');
    
    % Make sure that both the spark current and the spark voltage channel
    % channels were select and that the user has chosen to invert the data,
    % or not.
    empty_idx = cellfun('isempty',ScopeChannelTable);
    
    if any(empty_idx)
       error = errordlg('You must provide all inputs in Step 2.','ERROR!');
       uiwait(error)
       return
    end
    
    % Parse the scope channel table
    SparkVoltageChannel_Clamped     = str2double(ScopeChannelTable{1,1});
    InvertSparkVoltage_Clamped      = ScopeChannelTable{1,2};
    SparkVoltageChannel_FullSignal  = str2double(ScopeChannelTable{2,1});
    InvertSparkVoltage_FullSignal   = ScopeChannelTable{2,2};
    SparkCurrentChannel             = str2double(ScopeChannelTable{3,1});
    InvertSparkCurrent              = ScopeChannelTable{3,2};
    
    % Check to see if the user would like to use a input bias current
    % voltage offset reference file.
    if get(handles.input_bias_current_voltage_ref_checkbox,'Value')
        % The user wants to use a input bias current voltage offset
        
        % Make sure they provided a reference file name
        InputBiasCurrentVoltageOffsetFileName = get(handles.input_bias_current_voltage_ref_file_edittextbox,'String');
        
        if isempty(InputBiasCurrentVoltageOffsetFileName)
            error = errordlg('Please provide a input bias current voltage offset reference file','ERROR!');
            uiwait(error)
            return
        end
        
        % Get the scope channel number for the input bias current voltage
        % offset
        temp_string                             = get(handles.input_bias_cur_volt_ref_scope_chan_popupmenu,'String');
        temp_val                                = get(handles.input_bias_cur_volt_ref_scope_chan_popupmenu,'Value');
        InputBiasCurrentVoltageOffsetChannel    = str2double(temp_string{temp_val});
        
        % Check to see whether the user wants to invert the input bias
        % current voltage offset signal
        temp_string                         = get(handles.invert_input_bias_cur_volt_ref_popupmenu,'String');
        temp_val                            = get(handles.invert_input_bias_cur_volt_ref_popupmenu,'Value');
        InvertInputBiasCurrentVoltageOffset = temp_string{temp_val};
        
    else
        % The user doesn't want to use a input bias current voltage offset
        InputBiasCurrentVoltageOffsetFileName	= '';
        InputBiasCurrentVoltageOffsetChannel   	= [];
        InvertInputBiasCurrentVoltageOffset     = '';
    end
    
    % Get the spark gap, electrode diameter and electrode material strings
    % and make sure they were provided.
    SparkGap            = str2double(get(handles.spark_gap_textbox,'String'));
    ElectrodeDiameter   = str2double(get(handles.electrode_diameter_textbox,'String'));
    ElectrodeMaterial   = get(handles.electrode_material_textbox,'String');
    
    if isempty(SparkGap) || isnan(SparkGap)
        error = errordlg('Please provide a valid spark gap.','ERROR!');
        uiwait(error)
        return
    end
    
    if isempty(ElectrodeDiameter) || isnan(ElectrodeDiameter)
        error = errordlg('Please provide a valid electrode diameter.','ERROR!');
        uiwait(error)
        return
    end
    
    if isempty(ElectrodeMaterial)
        error = errordlg('Please provide a valid electrode material.','ERROR!');
        uiwait(error)
        return
    end
    
    % Get the name of the signals to be used for the spark start/stop
    % determination
    temp_idx        = get(handles.start_time_determination_source_listbox,'Value');
    temp_string     = get(handles.start_time_determination_source_listbox,'String');
    StartSignalName = temp_string{temp_idx};
    
    temp_idx        = get(handles.stop_time_determination_source_listbox,'Value');
    temp_string     = get(handles.stop_time_determination_source_listbox,'String');
    StopSignalName  = temp_string{temp_idx};
    
    % Get the start and stop threshold values
    SparkStartThreshold = str2double(get(handles.spark_start_threshold_textbox,'String'));
    SparkStopThreshold  = str2double(get(handles.spark_stop_threshold_textbox,'String'));
    
    if isempty(SparkStartThreshold) || isnan(SparkStartThreshold)
        error = errordlg('Please provide a valid starting threshold value.','ERROR!');
        uiwait(error)
        return
    end
    
    if isempty(SparkStopThreshold) || isnan(SparkStopThreshold)
        error = errordlg('Please provide a valid stopping threshold value.','ERROR!');
        uiwait(error)
        return
    end
    
    % Check to see if the user wants to use default values if the threshold
    % tests fail for the start and stop times.
    if get(handles.use_default_time_index_start_time_checkbox,'Value')
        % The user wants to use either the default time or index.
        
        if get(handles.default_start_time_radiobutton,'Value')
            % The user has provided us with a default time.
            DefaultStartTime    = str2double(get(handles.default_start_time_index_textbox,'String'));
            DefaultStartIndex   = [];
            
            if isempty(DefaultStartTime) || isnan(DefaultStartTime)
                error = errordlg('Please provide a valid default start time.','ERROR!');
                uiwait(error)
                return
            end
            
        else
            % The user has provided us with a default index.
            DefaultStartIndex   = str2double(get(handles.default_start_time_index_textbox,'String'));
            DefaultStartTime    = [];
            
            if isempty(DefaultStartIndex) || isnan(DefaultStartIndex)
                error = errordlg('Please provide a valid default start index.','ERROR!');
                uiwait(error)
                return
            end
            
        end
        
    else
        % The user does not wish to use any defaults.
        DefaultStartTime   	= [];
        DefaultStartIndex	= [];
        
    end
    
    if get(handles.use_default_time_index_stop_time_checkbox,'Value')
        % The user wants to use either the default time or index.
        if get(handles.default_stop_time_radiobutton,'Value')
            % The user has provided us with a default time.
            DefaultStopTime    = str2double(get(handles.default_stop_time_index_textbox,'String'));
            DefaultStopIndex   = [];
            
            if isempty(DefaultStopTime) || isnan(DefaultStopTime)
                error = errordlg('Please provide a valid default stop time.','ERROR!');
                uiwait(error)
                return
            end
            
        else
            % The user has provided us with a default index.
            DefaultStopIndex   = str2double(get(handles.default_stop_time_index_textbox,'String'));
            DefaultStopTime    = [];
            
            if isempty(DefaultStopIndex) || isnan(DefaultStopIndex)
                error = errordlg('Please provide a valid default stop index.','ERROR!');
                uiwait(error)
                return
            end
            
        end
        
    else
        % The user does not wish to use any defaults.
        DefaultStopTime   	= [];
        DefaultStopIndex	= [];
    end
    
    % Call the spark data processing function.
    OscilloscopeDataProcessor(handles.HomeFolder,...
                                handles.BinaryFilePath,...
                                BinaryFileList,...
                                SparkGap,...
                                ElectrodeDiameter,...
                                ElectrodeMaterial,...
                                SparkVoltageChannel_Clamped,...
                                InvertSparkVoltage_Clamped,...
                                SparkVoltageChannel_FullSignal,...
                                InvertSparkVoltage_FullSignal,...
                                SparkCurrentChannel,...
                                InvertSparkCurrent,...
                                StartSignalName,...
                                StopSignalName,...
                                SparkStartThreshold,...
                                SparkStopThreshold,...
                                DefaultStartTime,...
                                DefaultStartIndex,...
                                DefaultStopTime,...
                                DefaultStopIndex,...
                                InputBiasCurrentVoltageOffsetFileName,...
                                InputBiasCurrentVoltageOffsetChannel,...
                                InvertInputBiasCurrentVoltageOffset);
                            
    % Update handles structure
    guidata(hObject, handles);
    
end


function spark_gap_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to spark_gap_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spark_gap_textbox as text
%        str2double(get(hObject,'String')) returns contents of spark_gap_textbox as a double
end


% --- Executes during object creation, after setting all properties.
function spark_gap_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spark_gap_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function electrode_material_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to electrode_material_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of electrode_material_textbox as text
%        str2double(get(hObject,'String')) returns contents of electrode_material_textbox as a double
end

% --- Executes during object creation, after setting all properties.
function electrode_material_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to electrode_material_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function electrode_diameter_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to electrode_diameter_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of electrode_diameter_textbox as text
%        str2double(get(hObject,'String')) returns contents of electrode_diameter_textbox as a double
end


% --- Executes during object creation, after setting all properties.
function electrode_diameter_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to electrode_diameter_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in exit_button.
function exit_button_Callback(hObject, eventdata, handles)
% hObject    handle to exit_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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


% --- Executes on selection change in start_time_determination_source_listbox.
function start_time_determination_source_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to start_time_determination_source_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns start_time_determination_source_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from start_time_determination_source_listbox
end


% --- Executes during object creation, after setting all properties.
function start_time_determination_source_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_time_determination_source_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on selection change in stop_time_determination_source_listbox.
function stop_time_determination_source_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to stop_time_determination_source_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns stop_time_determination_source_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from stop_time_determination_source_listbox
end


% --- Executes during object creation, after setting all properties.
function stop_time_determination_source_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stop_time_determination_source_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function spark_start_threshold_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to spark_start_threshold_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spark_start_threshold_textbox as text
%        str2double(get(hObject,'String')) returns contents of spark_start_threshold_textbox as a double
end


% --- Executes during object creation, after setting all properties.
function spark_start_threshold_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spark_start_threshold_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function spark_stop_threshold_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to spark_stop_threshold_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spark_stop_threshold_textbox as text
%        str2double(get(hObject,'String')) returns contents of spark_stop_threshold_textbox as a double
end


% --- Executes during object creation, after setting all properties.
function spark_stop_threshold_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spark_stop_threshold_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in use_default_time_index_stop_time_checkbox.
function use_default_time_index_stop_time_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to use_default_time_index_stop_time_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of use_default_time_index_stop_time_checkbox
end


% --- Executes on button press in use_default_time_index_start_time_checkbox.
function use_default_time_index_start_time_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to use_default_time_index_start_time_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of use_default_time_index_start_time_checkbox
end


function default_start_time_index_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to default_start_time_index_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of default_start_time_index_textbox as text
%        str2double(get(hObject,'String')) returns contents of default_start_time_index_textbox as a double
end


% --- Executes during object creation, after setting all properties.
function default_start_time_index_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to default_start_time_index_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function default_stop_time_index_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to default_stop_time_index_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of default_stop_time_index_textbox as text
%        str2double(get(hObject,'String')) returns contents of default_stop_time_index_textbox as a double
end


% --- Executes during object creation, after setting all properties.
function default_stop_time_index_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to default_stop_time_index_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in browse_input_bias_curr_volt_ref_file_button.
function browse_input_bias_curr_volt_ref_file_button_Callback(hObject, eventdata, handles)
% hObject    handle to browse_input_bias_curr_volt_ref_file_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    % Provide the user with a GUI to select the files.
    if isfield(handles,'BinaryFilePath')
        [FileName,PathName] = uigetfile(fullfile(handles.BinaryFilePath,'*.bin'),'Select Binary File for Common Mode Voltage Offset','MultiSelect','off');
    else
        [FileName,PathName] = uigetfile(fullfile(handles.HomeFolder,'*.bin'),'Select Binary File for Common Mode Voltage Offset','MultiSelect','off');
    end
    
    if isequal(FileName,0) || isequal(PathName,0)
        % The user hit the cancel button
        return
    end
    
    % Place the selected file in the textbox
    set(handles.input_bias_current_voltage_ref_file_edittextbox,'String',fullfile(PathName,FileName))
    
end


function input_bias_current_voltage_ref_file_edittextbox_Callback(hObject, eventdata, handles)
% hObject    handle to input_bias_current_voltage_ref_file_edittextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_bias_current_voltage_ref_file_edittextbox as text
%        str2double(get(hObject,'String')) returns contents of input_bias_current_voltage_ref_file_edittextbox as a double
end


% --- Executes during object creation, after setting all properties.
function input_bias_current_voltage_ref_file_edittextbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_bias_current_voltage_ref_file_edittextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on selection change in input_bias_cur_volt_ref_scope_chan_popupmenu.
function input_bias_cur_volt_ref_scope_chan_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to input_bias_cur_volt_ref_scope_chan_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns input_bias_cur_volt_ref_scope_chan_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from input_bias_cur_volt_ref_scope_chan_popupmenu

end


% --- Executes during object creation, after setting all properties.
function input_bias_cur_volt_ref_scope_chan_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_bias_cur_volt_ref_scope_chan_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in input_bias_current_voltage_ref_checkbox.
function input_bias_current_voltage_ref_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to input_bias_current_voltage_ref_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of input_bias_current_voltage_ref_checkbox

end


% --- Executes on selection change in invert_input_bias_cur_volt_ref_popupmenu.
function invert_input_bias_cur_volt_ref_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to invert_input_bias_cur_volt_ref_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns invert_input_bias_cur_volt_ref_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from invert_input_bias_cur_volt_ref_popupmenu

end


% --- Executes during object creation, after setting all properties.
function invert_input_bias_cur_volt_ref_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to invert_input_bias_cur_volt_ref_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
