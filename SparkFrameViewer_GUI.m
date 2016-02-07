function varargout = SparkFrameViewer_GUI(varargin)
% SPARKFRAMEVIEWER_GUI MATLAB code for SparkFrameViewer_GUI.fig
%      SPARKFRAMEVIEWER_GUI, by itself, creates a new SPARKFRAMEVIEWER_GUI or raises the existing
%      singleton*.
%
%      H = SPARKFRAMEVIEWER_GUI returns the handle to a new SPARKFRAMEVIEWER_GUI or the handle to
%      the existing singleton*.
%
%      SPARKFRAMEVIEWER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPARKFRAMEVIEWER_GUI.M with the given input arguments.
%
%      SPARKFRAMEVIEWER_GUI('Property','Value',...) creates a new SPARKFRAMEVIEWER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SparkFrameViewer_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SparkFrameViewer_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SparkFrameViewer_GUI

% Last Modified by GUIDE v2.5 25-Sep-2013 20:57:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SparkFrameViewer_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SparkFrameViewer_GUI_OutputFcn, ...
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


% --- Executes just before SparkFrameViewer_GUI is made visible.
function SparkFrameViewer_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SparkFrameViewer_GUI (see VARARGIN)

    % Choose default command line output for SparkFrameViewer_GUI
    handles.output = hObject;
    
    % Assign inputs to handles struct
    handles.RootFolder = varargin{1}.RootFolder;    
    
    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes SparkFrameViewer_GUI wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    
end


% --- Outputs from this function are returned to the command line.
function varargout = SparkFrameViewer_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
    
end


function filename_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to filename_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename_textbox as text
%        str2double(get(hObject,'String')) returns contents of filename_textbox as a double
end


% --- Executes during object creation, after setting all properties.
function filename_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in next_frame_button.
function next_frame_button_Callback(hObject, eventdata, handles)
% hObject    handle to next_frame_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    if handles.CurrentFrame+1<=handles.EndFrame
        handles.CurrentFrame = handles.CurrentFrame+1;
    else
        % There are no more frames!
        h = msgbox('This is the last frame!');
        uiwait(h)
        return
    end
    
    % Update the displayed image
    update_image(handles)
    
    % Update handles structure
    guidata(hObject, handles);
    
end


% --- Executes on button press in previous_frame_button.
function previous_frame_button_Callback(hObject, eventdata, handles)
% hObject    handle to previous_frame_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    if handles.CurrentFrame-1>=handles.StartFrame
        handles.CurrentFrame = handles.CurrentFrame-1;
    else
        % There are no more frames!
        h = msgbox('This is the first frame!');
        uiwait(h)
        return;
    end
    
    % Update the displayed image
    update_image(handles)
    
    % Update handles structure
    guidata(hObject, handles);

end


% --- Executes on button press in peak_location_checkbox.
function peak_location_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to peak_location_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of peak_location_checkbox
end


% --- Executes on button press in edge_outline_checkbox.
function edge_outline_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to edge_outline_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of edge_outline_checkbox
end


% --- Executes on button press in browse_preprocessed_files_button.
function browse_preprocessed_files_button_Callback(hObject, eventdata, handles)
% hObject    handle to browse_preprocessed_files_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Call the uigetdir function to locate video files to process.
    [filename,~,~] = uigetfile([handles.RootFolder 'PreprocessedData\'],'Select a Preprocessed File for Examination','MultiSelect','off');
    
    % Make sure that the user selected a file
    if ~filename
        % The user did not select a file
        return;
    end
    
    % Initialize the waitbar
    loading_data_wait = waitbar(0,'Loading Data');
    
    % If the FileList is not a cell array (e.g. when it only lists one 
    % file, it's a character array), make it one so that it's always a cell 
    % array. This makes comparisons and such easier later in the code.
    if ~iscell(filename)
        PreprocessedFile = {filename};
    else
        PreprocessedFile = filename;
    end
    
    % Remove the file extension
    PreprocessedFile = strtok(PreprocessedFile,'.');

    % The standard prefix to the preprocessed data files is 
    % "PreprocessedData_". Delete this from the list of preprocessed files.
    PreprocessedFile = strrep(PreprocessedFile,'PreprocessedData_','');
    
    % Open the default settings file. If it is determined that some of the 
    % files require us to write inputs, we will use this cell array to hold
    % the new inputs and only write back to the excel file at the end.
    [~,~,input_file] = xlsread([handles.RootFolder '\Input_File.xlsx'],'Inputs');
    
    % Get the input file column headers
    input_col_headers = input_file(1,:);

    % Delete the headers from the input file
    input_file(1,:) = [];
    
    % Replace any NaN fields in the input struct with empty strings
    temp_idx = cellfun(@(x) any(isnan(x(:))),input_file,'UniformOutput',false);
    temp_idx = cell2mat(temp_idx);
    input_file(temp_idx==1) = {''};
        
    % Load the input file into a struct
    input_struct = cell2struct(input_file,input_col_headers,2);
    
    % Get the list of files that have had their input files setup 
    FilesWithInputs = {input_struct(:).Filename};
    
    % Split the list of current files at the ".", which is the file
    % extension
    [FilesWithInputs,InputFileExtensions] = strtok(FilesWithInputs,'.');
    
    % Find the index of the file to be processed in the "CurrentFiles"
    % cell array, which is a list of files already in the input file.
    input_idx = find(strcmpi(PreprocessedFile,FilesWithInputs)==1);
    
    % Load the video
    vid = VideoReader([handles.RootFolder 'RawVideos\' FilesWithInputs{input_idx} InputFileExtensions{input_idx}]);
    
    % Load all relevant input data into the handles strucure
    handles.CropYMin                = input_struct(input_idx).CropYMin;
    handles.CropYMax                = input_struct(input_idx).CropYMax;
    handles.CropXMin                = input_struct(input_idx).CropXMin;
    handles.CropXMax                = input_struct(input_idx).CropXMax;
    handles.EndFrame                = input_struct(input_idx).EndFrame;
    handles.StartFrame              = input_struct(input_idx).StartFrame;
    handles.Video                   = vid;
    handles.LowerLeftElectrodeY     = input_struct(input_idx).LowerLeftElectrodeY;
    handles.UpperLeftElectrodeY     = input_struct(input_idx).UpperLeftElectrodeY;
    handles.LeftElectrodeFacePos    = input_struct(input_idx).LeftElectrodeFacePos;
    handles.LowerRightElectrodeY    = input_struct(input_idx).LowerRightElectrodeY;
    handles.UpperRightElectrodeY    = input_struct(input_idx).UpperRightElectrodeY;
    handles.RightElectrodeFacePos   = input_struct(input_idx).RightElectrodeFacePos;
    
    % Load the preprocessed data
    temp_struct                 = load([handles.RootFolder 'PreprocessedData\' filename]);
    handles.PreprocessedData    = temp_struct.PreprocessedData;
    
    % Update the waitbar and pause to display the message
    waitbar(1,loading_data_wait,'Data Loading Complete!')
    pause(0.75)
    
    % Close the waitbar
    close(loading_data_wait)
    
    % Set the file name
    set(handles.filename_textbox,'String',PreprocessedFile{:});
    
    % Set the initial frame number and show the first frame
    handles.CurrentFrame = handles.StartFrame;
    update_image(handles)
    
    % Update handles structure
    guidata(hObject, handles);
    
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);

end


% --- Executes on button press in close_tool_button.
function close_tool_button_Callback(hObject, eventdata, handles)
% hObject    handle to close_tool_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    close(handles.figure1)

end


function update_image(handles)
% This function is used by various parts of the GUI to update the image
% displayed

    % Get the image to be displayed
    temp_frame = read(handles.Video,handles.CurrentFrame);
    temp_frame = rgb2gray(temp_frame(handles.CropYMin:handles.CropYMax, handles.CropXMin:handles.CropXMax,:));

    % Show the image
    imshow(temp_frame,'Parent', handles.axes1)
    hold on
    
    % Find the frame index, relative to the starting frame (e.g. the start
    % frame is "1" and the 35th frame relative to the start frame is "35", 
    % even though the "first" frame in the video could be frame 129.
    frame_idx = handles.CurrentFrame-handles.StartFrame+1;
    
    % Check to see if the user requested that the electrodes be outlined,
    % the point cloud shown or the edge shown
    if get(handles.peak_location_checkbox,'Value')
        % Show the peak locations
        plot(handles.PreprocessedData(frame_idx).BinaryPeaksCoord(:,1),...
            handles.PreprocessedData(frame_idx).BinaryPeaksCoord(:,2),'ok',...
            'MarkerSize',3,...
            'MarkerFaceColor','y')
    end
    
    % Check to see if the user would like to 
    if get(handles.edge_outline_checkbox,'Value')
        % The user would like to see the edge outlines
        for loop = 1:length(handles.PreprocessedData(frame_idx).ContourCoord)
            % Show the edge outline
            plot(handles.PreprocessedData(frame_idx).ContourCoord(loop).ContourCoordX,...
                handles.PreprocessedData(frame_idx).ContourCoord(loop).ContourCoordY,...
                '-m',...
                'LineWidth',2)
        end
    end
    
    if get(handles.electrode_outline_checkbox,'Value')
        
        % Get the image from the axes handles
        image = getimage(handles.axes1);
    
        % Show the outline of the right electrode
        line([handles.RightElectrodeFacePos size(image,1)],[handles.LowerRightElectrodeY handles.LowerRightElectrodeY],'Color','b','LineWidth',2)
        line([handles.RightElectrodeFacePos size(image,1)],[handles.UpperRightElectrodeY handles.UpperRightElectrodeY],'Color','b','LineWidth',2)
        line([handles.RightElectrodeFacePos handles.RightElectrodeFacePos],[handles.LowerRightElectrodeY handles.UpperRightElectrodeY],'Color','b','LineWidth',2)
        
        % Show the outline of the left electrode
        line([0 handles.LeftElectrodeFacePos],[handles.LowerLeftElectrodeY handles.LowerLeftElectrodeY],'Color','b','LineWidth',2)
        line([0 handles.LeftElectrodeFacePos],[handles.UpperLeftElectrodeY handles.UpperLeftElectrodeY],'Color','b','LineWidth',2)
        line([handles.LeftElectrodeFacePos handles.LeftElectrodeFacePos],[handles.LowerLeftElectrodeY handles.UpperLeftElectrodeY],'Color','b','LineWidth',2)

    end
    
    % Show whatever features were requested

    % Turn "hold" off
    hold off

end


% --- Executes on button press in go_to_last_button.
function go_to_last_button_Callback(hObject, eventdata, handles)
% hObject    handle to go_to_last_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Set the initial frame number and show the first frame
    handles.CurrentFrame = handles.EndFrame;
    update_image(handles)
    
    % Update handles structure
    guidata(hObject, handles);

end



% --- Executes on button press in go_to_first_button.
function go_to_first_button_Callback(hObject, eventdata, handles)
% hObject    handle to go_to_first_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Set the initial frame number and show the first frame
    handles.CurrentFrame = handles.StartFrame;
    update_image(handles)
    
    % Update handles structure
    guidata(hObject, handles);
    
end



% --- Executes on button press in electrode_outline_checkbox.
function electrode_outline_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to electrode_outline_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of electrode_outline_checkbox
end


% --- Executes on button press in refresh_frame_button.
function refresh_frame_button_Callback(hObject, eventdata, handles)
% hObject    handle to refresh_frame_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Refresh the current frame
    update_image(handles)

end
