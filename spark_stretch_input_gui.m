function varargout = spark_stretch_input_gui(varargin)
%SPARK_STRETCH_INPUT_GUI M-file for spark_stretch_input_gui.fig
%      SPARK_STRETCH_INPUT_GUI, by itself, creates a new SPARK_STRETCH_INPUT_GUI or raises the existing
%      singleton*.
%
%      H = SPARK_STRETCH_INPUT_GUI returns the handle to a new SPARK_STRETCH_INPUT_GUI or the handle to
%      the existing singleton*.
%
%      SPARK_STRETCH_INPUT_GUI('Property','Value',...) creates a new SPARK_STRETCH_INPUT_GUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to spark_stretch_input_gui_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SPARK_STRETCH_INPUT_GUI('CALLBACK') and SPARK_STRETCH_INPUT_GUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SPARK_STRETCH_INPUT_GUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help spark_stretch_input_gui

% Last Modified by GUIDE v2.5 09-Dec-2014 21:26:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spark_stretch_input_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @spark_stretch_input_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before spark_stretch_input_gui is made visible.
function spark_stretch_input_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no Output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

    % Choose default command line Output for spark_stretch_input_gui
    handles.output = hObject;
    
    handles.InputFileContents = varargin{1}.InputFileContents;
    
    % Initialize the various textboxes with values from the input
    % structure. If the fields in the input structure are empty, they will
    % be in the GUI as well.
    set(handles.lower_right_edge_elec,'String',handles.InputFileContents.LowerRightElectrodeY)
    set(handles.upper_right_edge_elec,'String',handles.InputFileContents.UpperRightElectrodeY)
    set(handles.right_perp_face_elec,'String',handles.InputFileContents.RightElectrodeFacePos)
    set(handles.upper_left_edge_elec,'String',handles.InputFileContents.UpperLeftElectrodeY)
    set(handles.lower_left_edge_elec,'String',handles.InputFileContents.LowerLeftElectrodeY)
    set(handles.perp_face_left_elec,'String',handles.InputFileContents.LeftElectrodeFacePos)
    set(handles.pixel_scale_textbox,'String',handles.InputFileContents.MMPerPixel)
    set(handles.duration_textbox,'String',handles.InputFileContents.Duration)
    set(handles.total_num_frames_textbox,'String',handles.InputFileContents.TotalFrames)
    set(handles.time_step_textbox,'String',handles.InputFileContents.TimeStep)
    set(handles.center_y_loc_textbox,'String',handles.InputFileContents.CenterLocY)
    set(handles.center_x_loc_textbox,'String',handles.InputFileContents.CenterLocX)
    set(handles.playback_framerate_textbox,'String',handles.InputFileContents.PlaybackFramerate)
    set(handles.filename_textbox,'String',handles.InputFileContents.Filename)
    set(handles.x_min_crop_textbox,'String',handles.InputFileContents.CropXMin)
    set(handles.x_max_crop_textbox,'String',handles.InputFileContents.CropXMax)
    set(handles.y_min_crop_textbox,'String',handles.InputFileContents.CropYMin)
    set(handles.y_max_crop_textbox,'String',handles.InputFileContents.CropYMax)
    set(handles.startframe_edit_textbox,'String',handles.InputFileContents.StartFrame)
    set(handles.endframe_edit_textbox,'String',handles.InputFileContents.EndFrame)
    set(handles.recording_framerate_edit_textbox,'String',handles.InputFileContents.RecordingFramerate)
	
    % Show the GT logo!
    imshow('buzz_gt_logo.jpg')
    
    % Store the video from the input struct in the handles struct
    handles.Video = varargin{1}.Video;
        
    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes spark_stretch_input_gui wait for user response (see UIRESUME)
    uiwait(handles.figure1);
    
end

% --- Outputs from this function are returned to the command line.
function varargout = spark_stretch_input_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning Output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Set the Outputs
    Output.LowerRightElectrodeY     = str2double(get(handles.lower_right_edge_elec,'String'));
    Output.UpperRightElectrodeY     = str2double(get(handles.upper_right_edge_elec,'String'));
    Output.RightElectrodeFacePos    = str2double(get(handles.right_perp_face_elec,'String'));
    Output.UpperLeftElectrodeY      = str2double(get(handles.upper_left_edge_elec,'String'));
    Output.LowerLeftElectrodeY      = str2double(get(handles.lower_left_edge_elec,'String'));
    Output.LeftElectrodeFacePos     = str2double(get(handles.perp_face_left_elec,'String'));
    Output.MMPerPixel               = str2double(get(handles.pixel_scale_textbox,'String'));
    Output.Duration                 = str2double(get(handles.duration_textbox,'String'));
    Output.TotalFrames              = str2double(get(handles.total_num_frames_textbox,'String'));
    Output.TimeStep                 = str2double(get(handles.time_step_textbox,'String'));
    Output.CenterLocY               = str2double(get(handles.center_y_loc_textbox,'String'));
    Output.CenterLocX               = str2double(get(handles.center_x_loc_textbox,'String'));
    Output.PlaybackFramerate        = str2double(get(handles.playback_framerate_textbox,'String'));
    Output.Filename                 = get(handles.filename_textbox,'String');
    Output.CropXMin                 = str2double(get(handles.x_min_crop_textbox,'String'));
    Output.CropXMax                 = str2double(get(handles.x_max_crop_textbox,'String'));
    Output.CropYMin                 = str2double(get(handles.y_min_crop_textbox,'String'));
    Output.CropYMax                 = str2double(get(handles.y_max_crop_textbox,'String'));
    Output.StartFrame               = str2double(get(handles.startframe_edit_textbox,'String'));
    Output.EndFrame                 = str2double(get(handles.endframe_edit_textbox,'String'));
    Output.RecordingFramerate       = str2double(get(handles.recording_framerate_edit_textbox,'String'));
        
    % Get default command line Output from handles structure
    varargout{1} = handles.Output;

    % The figure can now be deleted
    delete(handles.figure1);
    
end


function startframe_edit_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to startframe_edit_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startframe_edit_textbox as text
%        str2double(get(hObject,'String')) returns contents of startframe_edit_textbox as a double
end

% --- Executes during object creation, after setting all properties.
function startframe_edit_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startframe_edit_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function endframe_edit_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to endframe_edit_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endframe_edit_textbox as text
%        str2double(get(hObject,'String')) returns contents of endframe_edit_textbox as a double
end

% --- Executes during object creation, after setting all properties.
function endframe_edit_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endframe_edit_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function recording_framerate_edit_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to recording_framerate_edit_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of recording_framerate_edit_textbox as text
%        str2double(get(hObject,'String')) returns contents of recording_framerate_edit_textbox as a double
end

% --- Executes during object creation, after setting all properties.
function recording_framerate_edit_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to recording_framerate_edit_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Make sure that the required inputs are available
    upper_left_electrode_y_coord    = str2double(get(handles.upper_left_edge_elec,'String'));
    lower_left_electrode_y_coord    = str2double(get(handles.lower_left_edge_elec,'String'));
    upper_right_electrode_y_coord   = str2double(get(handles.upper_right_edge_elec,'String'));
    lower_right_electrode_y_coord   = str2double(get(handles.lower_right_edge_elec,'String'));
    nom_electrode_diam              = str2double(get(handles.electrode_diam_edit_textbox,'String'));
    
    if ~all([upper_left_electrode_y_coord lower_left_electrode_y_coord upper_right_electrode_y_coord lower_right_electrode_y_coord nom_electrode_diam ])
        warn = warndlg('At least one of the electrode dimensions OR the nominal electrode dimensions is zero. Please enter a value for all of these entries.','WARNING!');
        uiwait(warn)
        return; 
    end
    
    % Using the average diameter of the left and right electrodes (measured
    % in pixels) and the nominal electrode diameter, determine the scale of
    % the image, in mm/pixel.
    mm_per_pixel = nom_electrode_diam/mean([(lower_left_electrode_y_coord-upper_left_electrode_y_coord),(lower_right_electrode_y_coord-upper_right_electrode_y_coord)]);
    
    % Get the duration of the video
    duration = get(handles.Video,'Duration');

    % Get the total number of frames in the video
    total_frames = get(handles.Video,'NumberOfFrames');

    % Get the framerate
    framerate = get(handles.Video,'FrameRate');

    % Calculate the time step, in milliseconds
    time_step_per_frame = 1/str2double(get(handles.recording_framerate_edit_textbox,'String'))*1000;

    if isempty(time_step_per_frame)
        warn = warndlg('The recording framerate has not been entered. Please enter this value and try again.','WARNING!');
        uiwait(warn)
        return;  
    end
    
    % Using the mean of the center of the two electrodes, determine the
    % center of the image, measured in pixels. We round the value to the
    % nearest integer, because we can't have partial pixels!
    center_y = round(mean(mean(upper_left_electrode_y_coord,lower_left_electrode_y_coord), mean(upper_right_electrode_y_coord,lower_right_electrode_y_coord)));
    
    % Using the average of the left and right electrode faces, let's
    % calculate the x-coordinate for the center of the image.
    left_electrode_face_pos     = str2double(get(handles.perp_face_left_elec,'String'));
    right_electrode_face_pos    = str2double(get(handles.right_perp_face_elec,'String'));
    
    if ~all([left_electrode_face_pos right_electrode_face_pos])
        warn = warndlg('The left or right electrode face positions has not been entered properly. Please enter the value(s) again.','WARNING!');
        uiwait(warn)
        return; 
    end
    
    % Calculate the x-coordinate of the center
    center_x = round(mean([left_electrode_face_pos,right_electrode_face_pos]));
    
    % Set the textboxes in the calculations section
    set(handles.pixel_scale_textbox,'String',num2str(mm_per_pixel));
    set(handles.time_step_textbox,'String',num2str(time_step_per_frame));
    set(handles.duration_textbox,'String',num2str(duration));
    set(handles.total_num_frames_textbox,'String',num2str(total_frames));
    set(handles.playback_framerate_textbox,'String',num2str(framerate));
    set(handles.center_y_loc_textbox,'String',num2str(center_y));
    set(handles.center_x_loc_textbox,'String',num2str(center_x));
    
    % Update handles structure
    guidata(hObject, handles);

end

% --- Executes on button press in choose_crop_area.
function choose_crop_area_Callback(hObject, eventdata, handles)
% hObject    handle to choose_crop_area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Read the first frame of the video
    electrode_background_rgb = read(handles.Video,1);

    % Convert the RGB image to a grayscale image
    electrode_background_gray = rgb2gray(electrode_background_rgb);
    
    % Open a GUI to help the user outline the area of interest. First,
    % initialize a struct with the necesssary inputs
    x_min_crop = get(handles.x_min_crop_textbox,'String');
    x_max_crop = get(handles.x_max_crop_textbox,'String');
    y_min_crop = get(handles.y_min_crop_textbox,'String');
    y_max_crop = get(handles.y_max_crop_textbox,'String');
    
    crop_area_input_struct = struct('image',electrode_background_gray,'xmin',...
                                x_min_crop,...
                                'xmax',x_max_crop,...
                                'ymin',y_min_crop,...
                                'ymax',y_max_crop);

    crop_area_out_struct = spark_crop_area(crop_area_input_struct);
        
    % Set the crop area in the GUI using the results from the "Crop Area"
    % tool
    set(handles.x_min_crop_textbox,'String',crop_area_out_struct.xmin);
    set(handles.x_max_crop_textbox,'String',crop_area_out_struct.xmax);
    set(handles.y_min_crop_textbox,'String',crop_area_out_struct.ymin);
    set(handles.y_max_crop_textbox,'String',crop_area_out_struct.ymax);

    % Update handles structure
    guidata(hObject, handles);
    
end

% --- Executes on button press in choose_electrode_position.
function choose_electrode_position_Callback(hObject, eventdata, handles)
% hObject    handle to choose_electrode_position (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Check to see if the user has filled out the basic image cropping
    % section. If not, warn the user that the cropping step must be
    % completed first, then exit this function
    x_min_crop = str2double(get(handles.x_min_crop_textbox,'String'));
    x_max_crop = str2double(get(handles.x_max_crop_textbox,'String'));
    y_min_crop = str2double(get(handles.y_min_crop_textbox,'String'));
    y_max_crop = str2double(get(handles.y_max_crop_textbox,'String'));
    
    % Make sure they're not the default values (zeros), exit if they are
    % and warn the user
    if ~all([x_min_crop,x_max_crop,y_min_crop,y_max_crop])
        warn = warndlg('You must set crop the image before setting the electrode positions.','WARNING!');
        uiwait(warn)
        return;
    end
    
    % Read the first frame of the video
    electrode_background_rgb = read(handles.Video,1);

    % Convert the RGB image to a grayscale image
    electrode_background_gray = rgb2gray(electrode_background_rgb);
    
    % Crop the image as requested by the user
    electrode_background_gray = electrode_background_gray(y_min_crop:y_max_crop, x_min_crop:x_max_crop,:);
    
    % Open a GUI to help the user outline the area of interest. First,
    % initialize a struct with the necesssary inputs
    left_elect_top = get(handles.upper_left_edge_elec,'String');
    left_elect_bot = get(handles.lower_left_edge_elec,'String');
    left_elect_face = get(handles.perp_face_left_elec,'String');
    right_elect_top = get(handles.upper_right_edge_elec,'String');
    right_elect_bot = get(handles.lower_right_edge_elec,'String');
    right_elect_face = get(handles.right_perp_face_elec,'String');

    % Setup the input structure array to send to the electrode selection
    % GUI.
    electrode_pos_input_struct = struct('left_electrode_top',left_elect_top,...
                                        'left_electrode_bot',left_elect_bot,...
                                        'left_electrode_face',left_elect_face,...
                                        'right_electrode_top',right_elect_top,...
                                        'right_electrode_bot',right_elect_bot,...
                                        'right_electrode_face',right_elect_face,...
                                        'image',electrode_background_gray);
	
    electrode_pos_Output_struct = electrode_outline_gui(electrode_pos_input_struct);
    
	% Set the crop area in the GUI using the results 
    set(handles.upper_left_edge_elec,'String',electrode_pos_Output_struct.left_electrode_top_coord);
    set(handles.lower_left_edge_elec,'String',electrode_pos_Output_struct.left_electrode_bot_coord);
    set(handles.perp_face_left_elec,'String',electrode_pos_Output_struct.left_electrode_face_coord);
    set(handles.upper_right_edge_elec,'String',electrode_pos_Output_struct.right_electrode_top_coord);
    set(handles.lower_right_edge_elec,'String',electrode_pos_Output_struct.right_electrode_bot_coord);
    set(handles.right_perp_face_elec,'String',electrode_pos_Output_struct.right_electrode_face_coord);

    % Update handles structure
    guidata(hObject, handles);
    
end


% --- Executes on button press in load_presets.
function load_presets_Callback(hObject, eventdata, handles)
% hObject    handle to load_presets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Check to make sure that there is at least some data in the input file
    if size(handles.InputFileContents,1)==1
        warn = warndlg('There is no data in the input file.','WARNING!');
        uiwait(warn)
        return;
    end

    % Give the user a dialog box to choose the filename from which inputs
    % should be auto-loaded
    [Selection,ok]= listdlg('ListString',{handles.InputFileContents{2:end,1}},...
                            'SelectionMode','single',...
                            'Name','Input Preloader File Selection',...
                            'PromptString','Choose a video filename:');
    
	% Check to make sure that the user made a selection
    if ok==0
        % The user hit the cancel button
       return
    end
    
    % Get the index of the selected filename in the input file contents
    input_file_idx = find(strcmp(handles.InputFileContents{Selection+1,1},handles.InputFileContents(1:end,1))==1);

    % Dynamically assign fieldnames to the temporary struct and
    % simultaneously load them with data corresponding to those fields
    for loop = 1:size(handles.InputFileContents,2)
        temp_struct.(handles.InputFileContents{1,loop}) = handles.InputFileContents{input_file_idx,loop};        
    end
    
    % Set the various textboxes in the GUI using the preloaded inputs
    set(handles.sparkgap_edit_textbox,'String',temp_struct.NominalSparkGap)
    set(handles.electrode_diam_edit_textbox,'String',temp_struct.NomElectrodeDiam)
    set(handles.recording_framerate_edit_textbox,'String',temp_struct.RecordingFramerate)
    set(handles.x_min_crop_textbox,'String',temp_struct.CropXMin)
    set(handles.x_max_crop_textbox,'String',temp_struct.CropXMax)
    set(handles.y_min_crop_textbox,'String',temp_struct.CropYMin)
    set(handles.y_max_crop_textbox,'String',temp_struct.CropYMax)
    set(handles.lower_right_edge_elec,'String',temp_struct.LowerRightElectrodeY)
    set(handles.upper_right_edge_elec,'String',temp_struct.UpperRightElectrodeY)
    set(handles.right_perp_face_elec,'String',temp_struct.RightElectrodeFacePos)
    set(handles.upper_left_edge_elec,'String',temp_struct.UpperLeftElectrodeY)
    set(handles.lower_left_edge_elec,'String',temp_struct.LowerLeftElectrodeY)
    set(handles.perp_face_left_elec,'String',temp_struct.LeftElectrodeFacePos)
    
    % Update handles structure
    guidata(hObject, handles);
    
end

% --- Executes on button press in save_data.
function save_data_Callback(hObject, eventdata, handles)
% hObject    handle to save_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    close(handles.figure1)

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
