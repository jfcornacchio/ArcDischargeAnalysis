function varargout = SparkVideoDataProcessing_GUI(varargin)
% SPARKVIDEODATAPROCESSING_GUI MATLAB code for SparkVideoDataProcessing_GUI.fig
%      SPARKVIDEODATAPROCESSING_GUI, by itself, creates a new SPARKVIDEODATAPROCESSING_GUI or raises the existing
%      singleton*.
%
%      H = SPARKVIDEODATAPROCESSING_GUI returns the handle to a new SPARKVIDEODATAPROCESSING_GUI or the handle to
%      the existing singleton*.
%
%      SPARKVIDEODATAPROCESSING_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPARKVIDEODATAPROCESSING_GUI.M with the given input arguments.
%
%      SPARKVIDEODATAPROCESSING_GUI('Property','Value',...) creates a new SPARKVIDEODATAPROCESSING_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SparkVideoDataProcessing_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SparkVideoDataProcessing_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SparkVideoDataProcessing_GUI

% Last Modified by GUIDE v2.5 29-Sep-2013 15:40:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SparkVideoDataProcessing_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SparkVideoDataProcessing_GUI_OutputFcn, ...
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


% --- Executes just before SparkVideoDataProcessing_GUI is made visible.
function SparkVideoDataProcessing_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SparkVideoDataProcessing_GUI (see VARARGIN)

    % Choose default command line output for SparkVideoDataProcessing_GUI
    handles.output = hObject;
    
    % Initialize the root folder text box to be blank
    set(handles.root_folder_editable_textbox,'String','')
    
    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes SparkVideoDataProcessing_GUI wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    
end


% --- Outputs from this function are returned to the command line.
function varargout = SparkVideoDataProcessing_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
    
end


function root_folder_editable_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to root_folder_editable_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of root_folder_editable_textbox as text
%        str2double(get(hObject,'String')) returns contents of root_folder_editable_textbox as a double
end


% --- Executes during object creation, after setting all properties.
function root_folder_editable_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to root_folder_editable_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end


% --- Executes on button press in browse_for_rootfolder_button.
function browse_for_rootfolder_button_Callback(hObject, eventdata, handles)
% hObject    handle to browse_for_rootfolder_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    if isfield(handles,'RootFolder')
       % The user has already chosen a root folder. Use this choice as the 
       % default selection in the "uigetdir" function.
        
        % Get the root folder from the user
        handles.RootFolder = uigetdir(handles.RootFolder,'Select the root folder');
    else
        
        % Get the root folder from the user
        handles.RootFolder = uigetdir('C:\Users\Jim Cornacchio\Documents\Dissertation\HighSpeedVideoProcessing\SchlierenVideoProcessing','Select the root folder');

        % Exit cleanly if the user hits the "cancel" button
        if ~handles.RootFolder
            return;
        end

        % Make sure that the root folder ends with a blackslash...
        if handles.RootFolder(end)~='\'
            handles.RootFolder(end+1) = '\';        
        end        
        
    end
    
    % Set the textbox to read the selection
    set(handles.root_folder_editable_textbox,'String',handles.RootFolder)
        
    % Update handles structure
    guidata(hObject, handles);
    
end

% --- Executes on button press in setup_inputs_button.
function setup_inputs_button_Callback(hObject, eventdata, handles)
% hObject    handle to setup_inputs_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Check to make sure that the user selected a valid root folder
    if ~isfield(handles,'RootFolder') || ~isdir(handles.RootFolder)
        warn = warndlg('Please select a valid root folder.','WARNING');
        uiwait(warn)
        return;
    end

    % Check to see if an input file exists. If it does not, inform the user
    % that they must make one.
    if ~exist([handles.RootFolder 'Input_File.xlsx'],'file')
        % The input file does not exist
        warn = warngld('An input file has not yet been created for this root folder. Please create one and try again.','WARNING!');
        uiwait(warn)
        return;        
    end

    % Load the existing input file data
    [~,~,input_file] = xlsread([handles.RootFolder 'Input_File.xlsx'],'Inputs');
    
    % Get the input file column headers, assuming that they're on the first
    % row
    input_col_headers = input_file(1,:);
    
    % Delete the headers from the input file
    input_file(1,:) = [];
    
    % Load the input file into a struct
    input_struct = cell2struct(input_file,input_col_headers,2);
    
    % Get the list of files that have not yet had their input files setup 
    CurrentFiles = {input_struct(:).Filename};
    
    % Get a list of all raw videos in the "RawVideos" folder
    RawFileList = dir([handles.RootFolder 'RawVideos']);
    RawFileList = {RawFileList.name};
    
    % Make sure that the list of raw files does not include any files with
    % names less than 3 characters. These are most likely garbage names
    % (I've seen names like "." and ".."
    temp_idx    = find(cellfun('length',RawFileList)>3);
    RawFileList = RawFileList(temp_idx);
    
    % Compare the list of files that are in the RawVideos folder to the
    % list of files that have already had the inputs calculated. For any
    % files that do NOT have inputs already, call the setup GUI.
    FilesToSetup = setdiff(RawFileList,CurrentFiles);
    
    % Check to see that at least one file in the RawVideos folder does NOT
    % have its inputs setup already
    if isempty(FilesToSetup)
        % All videos are in the input file
        warn = warndlg('All videos in the RawVideos folder are already listed in the input file.','WARNING!');
        uiwait(warn)
        return;
    end
    
    % Call the input setup GUI for each file not in the input sheet.
    % Initialize a counter to determine the number of input rows that have
    % been created for the input file. Create a backup every 5 entries in
    % case the code crashes.
    
    input_counter = 1;
    
    for loop = 1:length(FilesToSetup)
        
        % Use VideoReader to load the movie
        vid = VideoReader([handles.RootFolder 'RawVideos\' FilesToSetup{loop}]);

        % Setup an input struct to send to the input GUI.
        input_struct(size(input_struct,1)+1).Filename = FilesToSetup{loop};
        
        gui_input = struct('Video',vid,...
                            'InputFileContents',input_struct(end));
        
        % Call the input GUI
        spark_stretch_output = spark_stretch_input_gui(gui_input);
        
        % Write the information into the default settings file cell
        % array

        % Get the current number of rows in the input file cell array
        % so that we know which row to write the new data to
        num_rows_input_cell_array = size(input_file,1);
        for loop2 = 1:length(input_col_headers)
            input_file(num_rows_input_cell_array+1,loop2) = {spark_stretch_output.(input_col_headers{loop2})};
        end
            
        % Increment the counter
        input_counter = input_counter + 1;

        % Every 5th entry, we are going to save a backup input file. 
        % This makes the process a bit slower, but it also reduces the
        % likelihood that we'll mess something up and break the code 20
        % movies in, and lose all the inputs!
        if rem(input_counter,5)==0
            % Initialize a waitbar
            backup_wait = waitbar(0,'Creating a backup file...');
                        
            xlswrite([handles.RootFolder 'Backup_Input_File.xlsx'],input_file,'Inputs');
            
            % Update and close the waitbar
            waitbar(1,backup_wait,'Backup file created!')
            close(backup_wait)
        end
        
    end    
    
%% Write the inputs to the input file
    
    % Initialize a waitbar
    write_inputs_wait = waitbar(0,'Updating input file...');

    xlswrite([handles.RootFolder 'Input_File.xlsx'],input_file,'Inputs');
    
    % Update and close the waitbar
    waitbar(1,write_inputs_wait,'Input File Updated!')
    close(write_inputs_wait)
    
    % Update handles structure
    guidata(hObject, handles);
    
end


% --- Executes on button press in modify_inputs_button.
function modify_inputs_button_Callback(hObject, eventdata, handles)
% hObject    handle to modify_inputs_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Check to see if the user has setup a root folder already. If not,
    % prompt them to, and exit.
    if ~isfield(handles,'RootFolder') || ~isdir(handles.RootFolder)
        warn = warndlg('Please select a valid root folder.','WARNING');
        uiwait(warn)
        return;
    end
    
    % Check to see if an input file exists. If it does not, inform the user
    % that they must make one.
    if ~exist([handles.RootFolder 'Input_File.xlsx'],'file')
        % The input file does not exist
        warn = warngld('An input file has not yet been created for this root folder. Please create one and try again.','WARNING!');
        uiwait(warn)
        return;        
    end
    
    % Load the existing input file data
    [~,~,input_file] = xlsread([handles.RootFolder 'Input_File.xlsx'],'Inputs');
    
    % Check to make sure that the number of rows is greater than one, which
    % would indicate that there is no data in the input file!
    if size(input_file,1)<2
       % There is no data stored in the input file!
       warn = warndlg('There are no inputs in the input file!','WARNING!');
       uiwait(warn)
       return;        
    end
    
    % Get the input file column headers, assuming that they're on the first
    % row
    input_col_headers = input_file(1,:);
    
    % Delete the headers from the input file
    input_file(1,:) = [];
    
    % Replace any NaN fields in the input struct with empty strings
    temp_idx                = cellfun(@(x) any(isnan(x(:))),input_file,'UniformOutput',false);
    temp_idx                = cell2mat(temp_idx);
    input_file(temp_idx==1) = {''};
    
    % Load the input file into a struct
    input_struct = cell2struct(input_file,input_col_headers,2);
    
    % Get the list of files that have not yet had their input files setup 
    CurrentFiles = {input_struct(:).Filename};
    
    % Call a GUI to help the user select which video files will have their
    % input files modified
    [Selection,ok]= listdlg('ListString',CurrentFiles,...
                            'SelectionMode','multiple',...
                            'Name','Input File Modification Selection',...
                            'PromptString','Select files to modify inputs:');

	% Check to make sure that the user made a selection
    if ok==0
        % The user hit the cancel button
       return; 
    end
    
    % Initialize a counter to determine the number of input rows that have
    % been created for the input file. Create a backup every 5 entries in
    % case the code crashes.
    input_counter = 1;
    
    % For every file selected above, call the input file generation GUI
    for loop = Selection
        
        % Use VideoReader to load the movie
        vid = VideoReader([handles.RootFolder 'RawVideos\' CurrentFiles{loop}]);
        
        gui_input = struct('Video',vid,...
                            'InputFileContents',input_struct(loop));
        
        % Call the input GUI
        spark_stretch_output = spark_stretch_input_gui(gui_input);
        
        % Get the fieldnames of the input struct
        input_fieldnames = fieldnames(input_struct);
        
        % Load the data from the input GUI into the input struct. There may
        % be an easier way to do this...but for now it's in a for loop.
        for loop2 = 1:length(fieldnames(input_struct))
           input_struct(loop).(input_fieldnames{loop2}) = spark_stretch_output.(input_fieldnames{loop2});
        end
        
        % Increment the counter
        input_counter = input_counter + 1;
        
        % Every 5th entry, we are going to save a backup input file. 
        % This makes the process a bit slower, but it also reduces the
        % likelihood that we'll mess something up and break the code 20
        % movies in, and lose all the inputs!
        if rem(input_counter,5)==0
            % Initialize a waitbar
            backup_wait = waitbar(0,'Creating a backup file...');
            
            % Write the input structure back into the Excel input file
            output_cell = struct2cell(input_struct)';

            % Concatenate the headers back onto the cell array
            output_cell = [input_col_headers; output_cell];
            
            % Write the data
            xlswrite([handles.RootFolder 'Backup_Input_File.xlsx'],output_cell,'Inputs');
            
            % Update and close the waitbar
            waitbar(1,backup_wait,'Backup file created!')
            close(backup_wait)
        end
        
    end
    
    % Write the input structure back into the Excel input file
    output_cell = struct2cell(input_struct)';
    
    % Concatenate the headers back onto the cell array
    output_cell = [input_col_headers; output_cell];
    
    % Initialize a waitbar
    write_inputs_wait = waitbar(0,'Updating input file...');

    % Write the data
    xlswrite([handles.RootFolder 'Input_File.xlsx'],output_cell,'Inputs');
    
    % Update and close the waitbar
    waitbar(1,write_inputs_wait,'Input File Updated!')
    close(write_inputs_wait)
    
    % Update handles structure
    guidata(hObject, handles);
    
end

% --- Executes on button press in preprocess_button.
function preprocess_button_Callback(hObject, eventdata, handles)
% hObject    handle to preprocess_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    % Check to make sure that the user selected a valid root folder
    if ~isfield(handles,'RootFolder') || ~isdir(handles.RootFolder)
        warn = warndlg('Please select a valid root folder.','WARNING');
        uiwait(warn)
        return;
    end
    
    % Display a table showing which files have input data associated with
    % them already and are eligible to be preprocessed. In addition, show
    % whether the data has been preprocessed already (the user can still
    % select these files).
    
    % Get a list of the video files that have had their inputs setup
    [~,~,input_file] = xlsread([handles.RootFolder 'Input_File.xlsx'],'Inputs');
    
    % Check to make sure that the number of rows is greater than one, which
    % would indicate that there is no data in the input file!
    if size(input_file,1)<2
       % There is no data stored in the input file!
       warn = warndlg('There are no inputs in the input file!','WARNING!');
       uiwait(warn)
       return;        
    end
    
    % Get a list of the .mat files in the preprocessed folder
    PreprocessedFileList = dir([handles.RootFolder 'PreprocessedData\*.mat']);
    
    if ~isempty(PreprocessedFileList)
        % Preprocessed data files were found
        PreprocessedFileList = {PreprocessedFileList.name};

        % The standard prefix to the preprocessed data files is 
        % "PreprocessedData_". Delete this from the list of preprocessed files.
        % First, remove the file extension
        PreprocessedFileList = strtok(PreprocessedFileList,'.');

        % Next, remove "PreprocessedData_" from the front.
        PreprocessedFileList = strrep(PreprocessedFileList,'PreprocessedData_','');
    else
        % Preprocessed data files were NOT found
        PreprocessedFileList={''};
    end
    
    % Get the input file column headers, assuming that they're on the first
    % row
    input_col_headers = input_file(1,:);
    
    % Delete the headers from the input file
    input_file(1,:) = [];
    
    % Replace any NaN fields in the input struct with empty strings
    temp_idx                = cellfun(@(x) any(isnan(x(:))),input_file,'UniformOutput',false);
    temp_idx                = cell2mat(temp_idx);
    input_file(temp_idx==1) = {''};
    
    % Load the input file into a struct
    input_struct = cell2struct(input_file,input_col_headers,2);
    
    % Get the list of files that have had their input files setup 
    CurrentFiles = {input_struct(:).Filename};
    
    % Split the list of current files at the ".", which is the file
    % extension
    [CurrentFiles,FileExtensions] = strtok(CurrentFiles,'.');
    
    % Create the input struct for the preprocessing selection tables
    preprocess_gui_struct = struct('Filenames',{CurrentFiles},...
                                    'PreprocessedFiles',{PreprocessedFileList});
                                
    % Call the preprocessing selection table GUI
    preprocessing_output = PreprocessList_GUI(preprocess_gui_struct);

    % Get the list of files that the user would like to preprocess from the
    % output struct
    FilesToPreprocess = preprocessing_output.FileNamesToPreprocess;
    
    % Check to make sure at least one file has been selected for
    % preprocessing.
    if isempty(FilesToPreprocess)
        return;
    end
    
    % Call the preprocessor for the selected files.
    
    % Setup the waitbar
    wait_preprocess = waitbar(0,'Preprocessing File');
    for loop=1:length(FilesToPreprocess)
                
        % Update the waitbar
        waitbar((loop-1)/length(FilesToPreprocess),wait_preprocess,['Preprocessing File ' FilesToPreprocess{loop}]);
        
        % Find the index of the file to be processed in the "CurrentFiles"
        % cell array, which is a list of files already in the input file.
        input_idx = find(strcmpi(FilesToPreprocess{loop},CurrentFiles)==1);
        
        % Load all of the input data into a struct so that we can more easily
        % access the data
        preprocess_input_data_struct = input_struct(input_idx);

        % Load the video
        vid = VideoReader([handles.RootFolder 'RawVideos\' FilesToPreprocess{loop} FileExtensions{input_idx}]);
        
        % Run the preprocessing routine
        PreprocessedData = preprocessor(preprocess_input_data_struct,vid);
        
        % Save the preprocessed data in a file
        save([handles.RootFolder 'PreprocessedData\' 'PreprocessedData_' FilesToPreprocess{loop} '.mat'],'PreprocessedData')
        
        % Update the waitbar
        waitbar(loop/length(FilesToPreprocess),wait_preprocess,['Preprocessing File ' FilesToPreprocess{loop}]);
    end

    % Close the waitbar
    close(wait_preprocess)
    
    % Update handles structure
    guidata(hObject, handles);

end


% --- Executes on button press in process_button.
function process_button_Callback(hObject, eventdata, handles)
% hObject    handle to process_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    % Close all open waitbars
    multiWaitbar('CloseAll');

    % Initialize waitbars
    multiWaitbar('Loading Input File',0,'Color',[0 0 1]);
    multiWaitbar('Creating List of Processed Data',0,'Color',[0 0 1]);
    multiWaitbar('Processing Requested Files',0,'Color',[0 0 1]);
    
    % Check to make sure that the user selected a valid root folder
    if ~isfield(handles,'RootFolder') || ~isdir(handles.RootFolder)
        error = errordlg('Please select a valid root folder.','ERROR');
        uiwait(error)
        
        % Close all waitbars and exit
        multiWaitbar('CloseAll');
        return
    end
    
    % Get a list of the video files that have had their inputs setup
    [~,~,input_file] = xlsread([handles.RootFolder 'Input_File.xlsx'],'Inputs');
    
    % Update waitbar
    multiWaitbar('Loading Input File',1);
    
    % Check to make sure that the number of rows is greater than one, which
    % would indicate that there is no data in the input file!
    if size(input_file,1)<2
       % There is no data stored in the input file!
       warn = warndlg('There are no inputs in the input file!','WARNING!');
       uiwait(warn)
       
        % Close all waitbars and exit
        multiWaitbar('CloseAll');
       return
    end
    
    % Get the input file column headers, assuming that they're on the first
    % row
    input_col_headers = input_file(1,:);
    
    % Delete the headers from the input file
    input_file(1,:) = [];
    
    % Replace any NaN fields in the input struct with empty strings
    temp_idx                = cellfun(@(x) any(isnan(x(:))),input_file,'UniformOutput',false);
    temp_idx                = cell2mat(temp_idx);
    input_file(temp_idx==1) = {''};
    
    % Load the input file into a struct
    input_struct = cell2struct(input_file,input_col_headers,2);
    
    % Get the list of files that have had their input files setup 
    FilesWithInputs = {input_struct(:).Filename};
    
    % Split the list of current files at the ".", which is the file
    % extension
    [FilesWithInputs,InputFileExtensions] = strtok(FilesWithInputs,'.');
    
    % Get a list of the .mat files in the processed folder
    ProcessedFileList = dir([handles.RootFolder 'ProcessedData/*.mat']);
    
    % Update waitbar
    multiWaitbar('Creating List of Processed Data',0);
    
    if ~isempty(ProcessedFileList)
       % No processed data was found
       ProcessedFileList = {ProcessedFileList.name};
    
        % The standard prefix to the processed data files is 
        % "ProcessedData_". Delete this from the list of processed 
        % files. First, remove the file extension        
        [ProcessedFileList,~] = strtok(ProcessedFileList,'.');
        
        % Next, remove "ProcessedData_" from the front.
        ProcessedFileList = strrep(ProcessedFileList,'ProcessedData_','');
    else
        ProcessedFileList = {''};
    end
    
    % Get a list of the .mat files in the preprocessed folder
    PreprocessedFileList = dir([handles.RootFolder 'PreprocessedData/*.mat']);
    
    % Update the waitbar
    multiWaitbar('Creating List of Processed Data',1);
    
    if ~isempty(PreprocessedFileList)
        % Preprocessed data files were found
        PreprocessedFileList = {PreprocessedFileList.name};

        % The standard prefix to the preprocessed data files is 
        % "PreprocessedData_". Delete this from the list of preprocessed files.
        % First, remove the file extension
        PreprocessedFileList = strtok(PreprocessedFileList,'.');

        % Next, remove "PreprocessedData_" from the front.
        PreprocessedFileList = strrep(PreprocessedFileList,'PreprocessedData_','');
    else
        % Preprocessed data files were NOT found
        PreprocessedFileList = {''};
    end
    
    % Create the input struct for the processing selection tables
    process_gui_struct = struct('ProcessedFiles',{ProcessedFileList},...
                                    'PreprocessedFiles',{PreprocessedFileList});
                                
    % Display a table showing which files have input data associated with
    % them already and also have been preprocessed already. These files are
    % eligible to be processed. In addition, show whether the data has been
    % processed already (the user can still select these files).
    processing_output = ProcessList_GUI(process_gui_struct);
    
    % Get the list of files that the user would like to process from the
    % output struct
    FilesToProcess = processing_output.FileNamesToProcess;
    
    % Check to make sure at least one file has been selected for
    % preprocessing.
    if isempty(FilesToProcess)
        % Close all waitbars and exit
        
        % Close all waitbars and exit
        multiWaitbar('CloseAll');
        return;
    end
    
    % Call the processor for the selected files.    
    for loop = 1:length(FilesToProcess)

        % Find the index of the file to be processed in the "CurrentFiles"
        % cell array, which is a list of files already in the input file.
        input_idx = find(strcmpi(FilesToProcess{loop},FilesWithInputs)==1);
        
        % Load all of the input data into a struct so that we can more easily
        % access the data
        process_input_data_struct = input_struct(input_idx);
        
        % Load the preprocessed data
        preprocessed_data_struct = load([handles.RootFolder 'PreprocessedData\' 'PreprocessedData_' FilesToProcess{loop} '.mat']);
        
        % Run the processing routine
        ProcessedData = processor(process_input_data_struct,preprocessed_data_struct.PreprocessedData);
        
        % Save the processed data in a file
        save([handles.RootFolder 'ProcessedData\' 'ProcessedData_' FilesToProcess{loop} '.mat'],'ProcessedData')
        
        % Update the waitbar
         multiWaitbar('Processing Requested Files',loop/length(FilesToProcess));
    end
    
    % Close all waitbars
    multiWaitbar('CloseAll');
    
    % Update handles structure
    guidata(hObject, handles);
    
end


% --- Executes on button press in postprocess_button.
function postprocess_button_Callback(hObject, eventdata, handles)
% hObject    handle to postprocess_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Check to make sure that the user selected a valid root folder
    if ~isfield(handles,'RootFolder') || ~isdir(handles.RootFolder)
        warn = warndlg('Please select a valid root folder.','WARNING');
        uiwait(warn)
        return;
    end
    
    % Get a list of the video files that have had their inputs setup
    [~,~,input_file] = xlsread([handles.RootFolder 'Input_File.xlsx'],'Inputs');
    
    % Check to make sure that the number of rows is greater than one, which
    % would indicate that there is no data in the input file!
    if size(input_file,1)<2
       % There is no data stored in the input file!
       warn = warndlg('There are no inputs in the input file!','WARNING!');
       uiwait(warn)
       return;        
    end
    
    % Get the input file column headers, assuming that they're on the first
    % row
    input_col_headers = input_file(1,:);
    
    % Delete the headers from the input file
    input_file(1,:) = [];
    
    % Replace any NaN fields in the input struct with empty strings
    temp_idx                = cellfun(@(x) any(isnan(x(:))),input_file,'UniformOutput',false);
    temp_idx                = cell2mat(temp_idx);
    input_file(temp_idx==1) = {''};
    
    % Load the input file into a struct
    input_struct = cell2struct(input_file,input_col_headers,2);
    
    % Get the list of files that have had their input files setup 
    FilesWithInputs = {input_struct(:).Filename};
    
    % Split the list of current files at the ".", which is the file
    % extension
    [FilesWithInputs,InputFileExtensions] = strtok(FilesWithInputs,'.');
    
    % Get a list of the .mat files in the processed folder
    ProcessedFileList = dir([handles.RootFolder 'ProcessedData/*.mat']);
    
    if ~isempty(ProcessedFileList)
        % No processed data was found
        ProcessedFileList = {ProcessedFileList.name};
    
        % The standard prefix to the processed data files is 
        % "ProcessedData_". Delete this from the list of processed 
        % files. First, remove the file extension        
        [ProcessedFileList,~] = strtok(ProcessedFileList,'.');
        
        % Next, remove "ProcessedData_" from the front.
        ProcessedFileList = strrep(ProcessedFileList,'ProcessedData_','');
    else
        ProcessedFileList = {''};
    end
    
    % Get a list of the .mat files in the preprocessed folder
    PreprocessedFileList = dir([handles.RootFolder 'PreprocessedData/*.mat']);
    
    if ~isempty(PreprocessedFileList)
        % Preprocessed data files were found
        PreprocessedFileList = {PreprocessedFileList.name};

        % The standard prefix to the preprocessed data files is 
        % "PreprocessedData_". Delete this from the list of preprocessed files.
        % First, remove the file extension
        PreprocessedFileList = strtok(PreprocessedFileList,'.');

        % Next, remove "PreprocessedData_" from the front.
        PreprocessedFileList = strrep(PreprocessedFileList,'PreprocessedData_','');
    else
        % Preprocessed data files were NOT found
        PreprocessedFileList={''};
    end
    
    % Create the input struct for the processing selection tables
    postprocess_gui_struct = struct('ProcessedFiles',{ProcessedFileList},...
                                    'PreprocessedFiles',{PreprocessedFileList},...
                                    'InputStruct',input_struct);
     
	% Call the post-process GUI
    post_processing_output = PostProcess_GUI(postprocess_gui_struct);
    
    % Update handles structure
    guidata(hObject, handles);

end


% --- Executes on button press in datavisualization_button.
function datavisualization_button_Callback(hObject, eventdata, handles)
% hObject    handle to datavisualization_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Check to make sure that the user selected a valid root folder
    if ~isfield(handles,'RootFolder') || ~isdir(handles.RootFolder)
        warn = warndlg('Please select a valid root folder.','WARNING');
        uiwait(warn)
        return;
    end
    
    spark_viewer_input = struct('RootFolder',handles.RootFolder);
    
    sparkviewer_output = SparkFrameViewer_GUI(spark_viewer_input);
    
    % Update handles structure
    guidata(hObject, handles);
    
end
