function varargout = OscilloscopeSetupFileToExcel_GUI(varargin)
% OSCILLOSCOPESETUPFILETOEXCEL_GUI MATLAB code for OscilloscopeSetupFileToExcel_GUI.fig
%      OSCILLOSCOPESETUPFILETOEXCEL_GUI, by itself, creates a new OSCILLOSCOPESETUPFILETOEXCEL_GUI or raises the existing
%      singleton*.
%
%      H = OSCILLOSCOPESETUPFILETOEXCEL_GUI returns the handle to a new OSCILLOSCOPESETUPFILETOEXCEL_GUI or the handle to
%      the existing singleton*.
%
%      OSCILLOSCOPESETUPFILETOEXCEL_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OSCILLOSCOPESETUPFILETOEXCEL_GUI.M with the given input arguments.
%
%      OSCILLOSCOPESETUPFILETOEXCEL_GUI('Property','Value',...) creates a new OSCILLOSCOPESETUPFILETOEXCEL_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OscilloscopeSetupFileToExcel_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OscilloscopeSetupFileToExcel_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OscilloscopeSetupFileToExcel_GUI

% Last Modified by GUIDE v2.5 05-Feb-2015 20:12:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OscilloscopeSetupFileToExcel_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @OscilloscopeSetupFileToExcel_GUI_OutputFcn, ...
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


% --- Executes just before OscilloscopeSetupFileToExcel_GUI is made visible.
function OscilloscopeSetupFileToExcel_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OscilloscopeSetupFileToExcel_GUI (see VARARGIN)

    % Choose default command line output for OscilloscopeSetupFileToExcel_GUI
    handles.output = hObject;
    
    if ~isempty(varargin) && isfield(varargin{1},'HomeFolder')
        % Store the home folder location in the handles struct.
        handles.HomeFolder = varargin{1}.HomeFolder;
        
    end
    
    % Initialize the setup file table
    setup_table_data = {'';'';'';'';''};
    
    set(handles.setup_file_table,'Data',setup_table_data)   
    
    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes OscilloscopeSetupFileToExcel_GUI wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    
end


% --- Outputs from this function are returned to the command line.
function varargout = OscilloscopeSetupFileToExcel_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
    
end


% --- Executes on button press in browse_setup_files_button.
function browse_setup_files_button_Callback(hObject, eventdata, handles)
% hObject    handle to browse_setup_files_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    % Provide the user with a GUI to select the files.
    if isfield(handles,'BinarySetupPath')
        [FileNames,PathName] = uigetfile(fullfile(handles.BinarySetupPath,'*.txt'),'Please Select Setup Files to Process','MultiSelect','on');
    elseif isfield(handles,'HomeFolder')
        [FileNames,PathName] = uigetfile(fullfile(handles.HomeFolder,'*.txt'),'Please Select Setup Files to Process','MultiSelect','on');
    else
        [FileNames,PathName] = uigetfile('*.txt','Please Select Setup Files to Process','MultiSelect','on');
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
    set(handles.setup_file_table,'Data',FileNames);
    handles.BinarySetupPath = PathName;
    
    % Update handles structure
    guidata(hObject, handles);
    
end


% --- Executes on button press in create_excel_file_button.
function create_excel_file_button_Callback(hObject, eventdata, handles)
% hObject    handle to create_excel_file_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Make sure that at least one setup file has been selected.
    SetupFileList = get(handles.setup_file_table,'Data');
    
    if all(cellfun('isempty',SetupFileList))
        error = errordlg('Please provide at least one setup file to process.','ERROR!');
        uiwait(error)
        return
    end
    
    % Make sure that the Excel summary file location has been provided.
    ExcelFileLocation = get(handles.excel_file_location_textbox,'String');
    
    if isempty(ExcelFileLocation)
       error = errordlg('Please provide an Excel file location.','ERROR!');
       uiwait(error)
       return
    end
        
    % Initialize waitbars
    multiWaitbar('Loading Setup Files',0,'Color',[0 1 0]);
    multiWaitbar('Writing Summary File',0,'Color',[0 1 0]);
    
    % Preallocate a struct to hold all the setup file data
    for loop = 1:length(SetupFileList)
        
        SetupDataStruct(loop).FileName                  = '';
        
        SetupDataStruct(loop).Channel1Scale             = [];
        SetupDataStruct(loop).Channel1Resolution        = [];
        SetupDataStruct(loop).Channel1ChannelPosition 	= '';
        SetupDataStruct(loop).Channel1ChannelCoupling  	= '';
        SetupDataStruct(loop).Channel1ChannelBWLimit   	= '';
        SetupDataStruct(loop).Channel1ChannelInvert    	= '';
        SetupDataStruct(loop).Channel1ChannelImpedance 	= '';
        SetupDataStruct(loop).Channel1ChannelProbeRatio	= '';
        SetupDataStruct(loop).Channel1ChannelSkew     	= '';
        
        SetupDataStruct(loop).Channel2Scale             = [];
        SetupDataStruct(loop).Channel2Resolution        = [];
        SetupDataStruct(loop).Channel2ChannelPosition 	= '';
        SetupDataStruct(loop).Channel2ChannelCoupling  	= '';
        SetupDataStruct(loop).Channel2ChannelBWLimit   	= '';
        SetupDataStruct(loop).Channel2ChannelInvert    	= '';
        SetupDataStruct(loop).Channel2ChannelImpedance 	= '';
        SetupDataStruct(loop).Channel2ChannelProbeRatio	= '';
        SetupDataStruct(loop).Channel2ChannelSkew     	= '';
        
        SetupDataStruct(loop).Channel3Scale             = [];
        SetupDataStruct(loop).Channel3Resolution        = [];
        SetupDataStruct(loop).Channel3ChannelPosition 	= '';
        SetupDataStruct(loop).Channel3ChannelCoupling  	= '';
        SetupDataStruct(loop).Channel3ChannelBWLimit   	= '';
        SetupDataStruct(loop).Channel3ChannelInvert    	= '';
        SetupDataStruct(loop).Channel3ChannelImpedance 	= '';
        SetupDataStruct(loop).Channel3ChannelProbeRatio	= '';
        SetupDataStruct(loop).Channel3ChannelSkew     	= '';
        
        SetupDataStruct(loop).Channel4Scale             = [];
        SetupDataStruct(loop).Channel4Resolution        = [];
        SetupDataStruct(loop).Channel4ChannelPosition 	= '';
        SetupDataStruct(loop).Channel4ChannelCoupling  	= '';
        SetupDataStruct(loop).Channel4ChannelBWLimit   	= '';
        SetupDataStruct(loop).Channel4ChannelInvert    	= '';
        SetupDataStruct(loop).Channel4ChannelImpedance 	= '';
        SetupDataStruct(loop).Channel4ChannelProbeRatio	= '';
        SetupDataStruct(loop).Channel4ChannelSkew     	= '';
        
        SetupDataStruct(loop).TriggerSweepMode          = '';
        SetupDataStruct(loop).TriggerCoupling           = '';
        SetupDataStruct(loop).TriggerNoiseRejection     = '';
        SetupDataStruct(loop).TriggerHFRejection        = '';
        SetupDataStruct(loop).TriggerHoldoff            = '';
        SetupDataStruct(loop).TriggerMode               = '';
        SetupDataStruct(loop).TriggerSource             = '';
        SetupDataStruct(loop).TriggerSlope              = '';
        SetupDataStruct(loop).TriggerLevel              = '';

        SetupDataStruct(loop).HorizontalScale           = '';
        SetupDataStruct(loop).HorizontalReference       = '';
        SetupDataStruct(loop).HorizontalMainScale       = '';
        SetupDataStruct(loop).HorizontalMainDelay       = '';

        SetupDataStruct(loop).AcqusitionMode            = '';
        SetupDataStruct(loop).AcqusitionRealtime        = '';
        SetupDataStruct(loop).AcqusitionVectors         = '';
        SetupDataStruct(loop).AcqusitionPersistence     = '';
            
    end
	
    % Loop over all files and fill the struct that will be converted into
    % a cell array, then written into the Excel file.
    for loop = 1:length(SetupFileList)
        
        SetupDataStruct(loop).FileName = SetupFileList{loop};
        
        % Read the setup file
        SetupFileOutput = ReadAgilentSetupFile(fullfile(handles.BinarySetupPath,SetupFileList{loop}));
            
        % Place the details of the setup in the output data struct.
        SetupDataStruct(loop).Channel1Scale             = SetupFileOutput.AnalogConfiguration(1).Scale;
        SetupDataStruct(loop).Channel1ChannelPosition 	= SetupFileOutput.AnalogConfiguration(1).Position;
        SetupDataStruct(loop).Channel1ChannelCoupling  	= SetupFileOutput.AnalogConfiguration(1).Coupling;
        SetupDataStruct(loop).Channel1ChannelBWLimit   	= SetupFileOutput.AnalogConfiguration(1).BWLimit;
        SetupDataStruct(loop).Channel1ChannelInvert    	= SetupFileOutput.AnalogConfiguration(1).Invert;
        SetupDataStruct(loop).Channel1ChannelImpedance 	= SetupFileOutput.AnalogConfiguration(1).Impedance;
        SetupDataStruct(loop).Channel1ChannelProbeRatio	= SetupFileOutput.AnalogConfiguration(1).ProbeRatio;
        SetupDataStruct(loop).Channel1ChannelSkew     	= SetupFileOutput.AnalogConfiguration(1).Skew;
        
        SetupDataStruct(loop).Channel2Scale             = SetupFileOutput.AnalogConfiguration(2).Scale;
        SetupDataStruct(loop).Channel2ChannelPosition 	= SetupFileOutput.AnalogConfiguration(2).Position;
        SetupDataStruct(loop).Channel2ChannelCoupling  	= SetupFileOutput.AnalogConfiguration(2).Coupling;
        SetupDataStruct(loop).Channel2ChannelBWLimit   	= SetupFileOutput.AnalogConfiguration(2).BWLimit;
        SetupDataStruct(loop).Channel2ChannelInvert    	= SetupFileOutput.AnalogConfiguration(2).Invert;
        SetupDataStruct(loop).Channel2ChannelImpedance 	= SetupFileOutput.AnalogConfiguration(2).Impedance;
        SetupDataStruct(loop).Channel2ChannelProbeRatio	= SetupFileOutput.AnalogConfiguration(2).ProbeRatio;
        SetupDataStruct(loop).Channel2ChannelSkew     	= SetupFileOutput.AnalogConfiguration(2).Skew;
        
        SetupDataStruct(loop).Channel3Scale             = SetupFileOutput.AnalogConfiguration(3).Scale;
        SetupDataStruct(loop).Channel3ChannelPosition 	= SetupFileOutput.AnalogConfiguration(3).Position;
        SetupDataStruct(loop).Channel3ChannelCoupling  	= SetupFileOutput.AnalogConfiguration(3).Coupling;
        SetupDataStruct(loop).Channel3ChannelBWLimit   	= SetupFileOutput.AnalogConfiguration(3).BWLimit;
        SetupDataStruct(loop).Channel3ChannelInvert    	= SetupFileOutput.AnalogConfiguration(3).Invert;
        SetupDataStruct(loop).Channel3ChannelImpedance 	= SetupFileOutput.AnalogConfiguration(3).Impedance;
        SetupDataStruct(loop).Channel3ChannelProbeRatio	= SetupFileOutput.AnalogConfiguration(3).ProbeRatio;
        SetupDataStruct(loop).Channel3ChannelSkew     	= SetupFileOutput.AnalogConfiguration(3).Skew;
        
        SetupDataStruct(loop).Channel4Scale             = SetupFileOutput.AnalogConfiguration(4).Scale;
        SetupDataStruct(loop).Channel4ChannelPosition 	= SetupFileOutput.AnalogConfiguration(4).Position;
        SetupDataStruct(loop).Channel4ChannelCoupling  	= SetupFileOutput.AnalogConfiguration(4).Coupling;
        SetupDataStruct(loop).Channel4ChannelBWLimit   	= SetupFileOutput.AnalogConfiguration(4).BWLimit;
        SetupDataStruct(loop).Channel4ChannelInvert    	= SetupFileOutput.AnalogConfiguration(4).Invert;
        SetupDataStruct(loop).Channel4ChannelImpedance 	= SetupFileOutput.AnalogConfiguration(4).Impedance;
        SetupDataStruct(loop).Channel4ChannelProbeRatio	= SetupFileOutput.AnalogConfiguration(4).ProbeRatio;
        SetupDataStruct(loop).Channel4ChannelSkew     	= SetupFileOutput.AnalogConfiguration(4).Skew;
        
        SetupDataStruct(loop).TriggerSweepMode      = SetupFileOutput.TriggerConfiguration.SweepMode;
        SetupDataStruct(loop).TriggerCoupling       = SetupFileOutput.TriggerConfiguration.Coupling;
        SetupDataStruct(loop).TriggerNoiseRejection	= SetupFileOutput.TriggerConfiguration.NoiseRejection;
        SetupDataStruct(loop).TriggerHFRejection	= SetupFileOutput.TriggerConfiguration.HFRejection;
        SetupDataStruct(loop).TriggerHoldoff        = SetupFileOutput.TriggerConfiguration.Holdoff;
        SetupDataStruct(loop).TriggerMode           = SetupFileOutput.TriggerConfiguration.Mode;
        SetupDataStruct(loop).TriggerSource         = SetupFileOutput.TriggerConfiguration.Source;
        SetupDataStruct(loop).TriggerSlope          = SetupFileOutput.TriggerConfiguration.Slope;
        SetupDataStruct(loop).TriggerLevel          = SetupFileOutput.TriggerConfiguration.Level;

        SetupDataStruct(loop).HorizontalScale       = SetupFileOutput.HorizontalConfiguration.Scale;
        SetupDataStruct(loop).HorizontalReference   = SetupFileOutput.HorizontalConfiguration.Reference;
        SetupDataStruct(loop).HorizontalMainScale   = SetupFileOutput.HorizontalConfiguration.MainScale;
        SetupDataStruct(loop).HorizontalMainDelay   = SetupFileOutput.HorizontalConfiguration.MainDelay;

        SetupDataStruct(loop).AcqusitionMode       	= SetupFileOutput.AcquisitionConfiguration.Mode;
        SetupDataStruct(loop).AcqusitionRealtime   	= SetupFileOutput.AcquisitionConfiguration.Realtime;
        SetupDataStruct(loop).AcqusitionVectors    	= SetupFileOutput.AcquisitionConfiguration.Vectors;
        SetupDataStruct(loop).AcqusitionPersistence	= SetupFileOutput.AcquisitionConfiguration.Persistence;

        % Calculate the resolution of the spark voltage, in volts, and
        % the resolution of the spark current, in amps. This
        % oscilloscope has 8-bit resolution, and a total of 8 vertical
        % divisions. 8-bits corresponds to 256 steps. However, in "high
        % resolution" mode, the resolution of the oscilloscope is
        % effectively increased - the amount increased depends on the
        % horizontal scale.
        switch SetupDataStruct(loop).AcqusitionMode

            case 'Normal'
                VerticalBits = 8;

            case 'HighRes'
                % The horizontal scale must be calculated.
                TimePerDiv  = regexp(SetupFileOutput.HorizontalConfiguration.MainScale,'[0-9\.]+','match');
                TimePerDiv  = TimePerDiv{:};
                TimeUnits   = SetupFileOutput.HorizontalConfiguration.MainScale(length(TimePerDiv)+1:end);
                TimePerDiv  = str2double(TimePerDiv);

                % Calculate the magnitude of the time per div
                switch TimeUnits

                    case 's'
                        TimePerDiv = TimePerDiv;

                    case 'ms'
                        TimePerDiv = TimePerDiv/1000;

                    case 'us'
                        TimePerDiv = TimePerDiv/1000000;

                    case 'ns'
                        TimePerDiv = TimePerDiv/1000000000;

                    otherwise
                        % Unknown units!
                end

                % Using the calculated horizontal scale, calculate the
                % effective number of bits used in the vertical scale.
                if TimePerDiv<=1e-6
                    VerticalBits = 8;

                elseif TimePerDiv==2e-6
                    VerticalBits = 9;

                elseif TimePerDiv==5e-6
                    VerticalBits = 10;

                elseif TimePerDiv==10e-6
                    VerticalBits = 11;

                elseif TimePerDiv>=20e-6
                    VerticalBits = 12;
                else
                   % Error!

                end

            otherwise

        end
        
        % Determine which channels are present.
        AvailableChannels                           = [SetupFileOutput.AnalogConfiguration.ChannelNumber];
        AvailableChannels(isnan(AvailableChannels)) = [];
        
        % Make sure that the AvailableChannels is a row array, otherwise it
        % cannot be used to index the coming for loop.
        if ~isrow(AvailableChannels)
            AvailableChannels = AvailableChannels';
        end
        
        for loop2 = AvailableChannels
            % Using the channel scale, determine the number of units per
            % division and the unit labels.
            SignalPerDiv    = regexp(SetupDataStruct(loop).(['Channel' int2str(loop2) 'Scale']),'[0-9\.]+','match');
            SignalPerDiv	= SignalPerDiv{:};
            SignalUnits 	= SetupDataStruct(loop).(['Channel' int2str(loop2) 'Scale'])(length(SignalPerDiv)+1:end);
            SignalPerDiv    = str2double(SignalPerDiv);

            % Determine the channel resolution
            switch SignalUnits

                case 'kV'
                    SetupDataStruct(loop).(['Channel' int2str(loop2) 'Resolution']) = SignalPerDiv*1000*10/2^VerticalBits;

                case 'V'
                    SetupDataStruct(loop).(['Channel' int2str(loop2) 'Resolution']) = SignalPerDiv*10/2^VerticalBits;

                case 'mV'
                    SetupDataStruct(loop).(['Channel' int2str(loop2) 'Resolution']) = SignalPerDiv/1000*10/2^VerticalBits;
                
                case 'kA'
                    SetupDataStruct(loop).(['Channel' int2str(loop2) 'Resolution']) = SignalPerDiv*1000*10/2^VerticalBits;
                    
                case 'A'
                    SetupDataStruct(loop).(['Channel' int2str(loop2) 'Resolution']) = SignalPerDiv*10/2^VerticalBits;
                    
                case 'mA'
                    SetupDataStruct(loop).(['Channel' int2str(loop2) 'Resolution']) = SignalPerDiv/1000*10/2^VerticalBits;
                    
                otherwise
                    % Unknown units!
            end
        
        end
        
        % Update waitbar
        multiWaitbar('Loading Setup Files',loop/length(SetupFileList));
        
    end
    
    %% Convert the structure to a cell and write the Excel file
    
    % Convert the structure to a cell array
    output_cell_temp    = struct2cell(SetupDataStruct);
    output_cell_headers = fieldnames(SetupDataStruct);
    output_cell         = cell(size(output_cell_temp,3),size(output_cell_temp,1));
    
    for loop = 1:size(output_cell_temp,3)
        output_cell(loop,:) = output_cell_temp(:,1,loop);
    end
    
    % Add the header row
    output_cell = [output_cell_headers';output_cell];
    
    % Write the Excel file
    try
        xlswrite(ExcelFileLocation,output_cell,'Sheet1','A1')
        
    catch
        % There was an issue writing the Excel file. Warn the user and
        % allow them to try again.
        error = errordlg('There was an error writing the Spark Summary Table. Please check that the file is not open and try again.','ERROR!');
        uiwait(error)
        
        % Try again
        xlswrite(ExcelFileLocation,output_cell,'Sheet1','A1')
        
    end
    
    % Update waitbar
    multiWaitbar('Writing Summary File',1);
    pause(0.5)

%% Clean-up
    % Close all waitbars
    multiWaitbar('CloseAll');
    
    % Update handles structure
    guidata(hObject, handles);
    
end


% --- Executes on button press in choose_excel_file_name_button.
function choose_excel_file_name_button_Callback(hObject, eventdata, handles)
% hObject    handle to choose_excel_file_name_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    if isfield(handles,'ExcelFilePath')
        [ExcelFileName,ExcelFilePath] = uiputfile(fullfile(handles.ExcelFilePath,'*.xlsx'),'Setup File Summary',fullfile(handles.ExcelFilePath,handles.ExcelFileName));
        
    elseif isfield(handles,'HomeFolder')
        [ExcelFileName,ExcelFilePath] = uiputfile(fullfile(handles.HomeFolder,'*.xlsx'),'Setup File Summary',fullfile(handles.HomeFolder,'OscilloscopeSetupFileSummary.xlsx'));
        
    else
        [ExcelFileName,ExcelFilePath] = uiputfile('*.xlsx','Setup File Summary','OscilloscopeSetupFileSummary.xlsx');
        
    end
    
    % Make sure that the user made a selection
	if isequal(ExcelFileName,0) || isequal(ExcelFilePath,0)
        return
    end
    
    handles.ExcelFilePath = ExcelFilePath;
    handles.ExcelFileName = ExcelFileName;
    
    set(handles.excel_file_location_textbox,'String',fullfile(ExcelFilePath,ExcelFileName))
    
    % Update handles structure
    guidata(hObject, handles);
    
end


function excel_file_location_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to excel_file_location_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of excel_file_location_textbox as text
%        str2double(get(hObject,'String')) returns contents of excel_file_location_textbox as a double
end


% --- Executes during object creation, after setting all properties.
function excel_file_location_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to excel_file_location_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

