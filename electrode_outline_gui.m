function varargout = electrode_outline_gui(varargin)
% ELECTRODE_OUTLINE_GUI MATLAB code for electrode_outline_gui.fig
%      ELECTRODE_OUTLINE_GUI, by itself, creates a new ELECTRODE_OUTLINE_GUI or raises the existing
%      singleton*.
%
%      H = ELECTRODE_OUTLINE_GUI returns the handle to a new ELECTRODE_OUTLINE_GUI or the handle to
%      the existing singleton*.
%
%      ELECTRODE_OUTLINE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ELECTRODE_OUTLINE_GUI.M with the given input arguments.
%
%      ELECTRODE_OUTLINE_GUI('Property','Value',...) creates a new ELECTRODE_OUTLINE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before electrode_outline_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to electrode_outline_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help electrode_outline_gui

% Last Modified by GUIDE v2.5 21-Jul-2013 22:39:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @electrode_outline_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @electrode_outline_gui_OutputFcn, ...
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

% --- Executes just before electrode_outline_gui is made visible.
function electrode_outline_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to electrode_outline_gui (see VARARGIN)

    % Choose default command line output for electrode_outline_gui
    handles.output = hObject;

    % Show the image passed from the spark_stretch_input_gui
    imshow(varargin{1}.image)
    
    % Store the original image in the handles structure
    handles.original_image = varargin{1}.image;
    
    % Set the editable text boxes showing the electrode position
    set(handles.left_electrode_top_coords_textbox,'String',varargin{1}.left_electrode_top)
    set(handles.left_electrode_bot_coords_textbox,'String',varargin{1}.left_electrode_bot)
    set(handles.left_electrode_face_coords_textbox,'String',varargin{1}.left_electrode_face)
    set(handles.right_electrode_top_coords_textbox,'String',varargin{1}.right_electrode_top)
    set(handles.right_electrode_bot_coords_textbox,'String',varargin{1}.right_electrode_bot)
    set(handles.right_electrode_face_coords_textbox,'String',varargin{1}.right_electrode_face)
    
    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes electrode_outline_gui wait for user response (see UIRESUME)
    uiwait(handles.figure1);
    
end

% --- Outputs from this function are returned to the command line.
function varargout = electrode_outline_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get the coordinates specifying the location of the left and right 
    % electrodes
    handles.output.right_electrode_top_coord = get(handles.right_electrode_top_coords_textbox,'String');
    handles.output.right_electrode_bot_coord = get(handles.right_electrode_bot_coords_textbox,'String');
    handles.output.right_electrode_face_coord = get(handles.right_electrode_face_coords_textbox,'String');
    handles.output.left_electrode_top_coord = get(handles.left_electrode_top_coords_textbox,'String');
    handles.output.left_electrode_bot_coord = get(handles.left_electrode_bot_coords_textbox,'String');
    handles.output.left_electrode_face_coord = get(handles.left_electrode_face_coords_textbox,'String');

    % Get default command line output from handles structure
    varargout{1} = handles.output;
    
    % The figure can now be deleted
    delete(handles.figure1);
    
end

% --- Executes on button press in save_and_close.
function save_and_close_Callback(hObject, eventdata, handles)
% hObject    handle to save_and_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    close(handles.figure1)

end


function right_electrode_top_coords_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to right_electrode_top_coords_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of right_electrode_top_coords_textbox as text
%        str2double(get(hObject,'String')) returns contents of right_electrode_top_coords_textbox as a double
end

% --- Executes during object creation, after setting all properties.
function right_electrode_top_coords_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to right_electrode_top_coords_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function right_electrode_bot_coords_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to right_electrode_bot_coords_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of right_electrode_bot_coords_textbox as text
%        str2double(get(hObject,'String')) returns contents of right_electrode_bot_coords_textbox as a double
end

% --- Executes during object creation, after setting all properties.
function right_electrode_bot_coords_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to right_electrode_bot_coords_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function right_electrode_face_coords_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to right_electrode_face_coords_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of right_electrode_face_coords_textbox as text
%        str2double(get(hObject,'String')) returns contents of right_electrode_face_coords_textbox as a double
end

% --- Executes during object creation, after setting all properties.
function right_electrode_face_coords_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to right_electrode_face_coords_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in reset_right_coords.
function reset_right_coords_Callback(hObject, eventdata, handles)
% hObject    handle to reset_right_coords (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Reset the right electrode textboxes to default values
    set(handles.right_electrode_top_coords_textbox,'String','0')
    set(handles.right_electrode_bot_coords_textbox,'String','0')
    set(handles.right_electrode_face_coords_textbox,'String','0')
    
    % Update handles structure
    guidata(hObject, handles);
    
end

% --- Executes on button press in show_right_electrode_outline.
function show_right_electrode_outline_Callback(hObject, eventdata, handles)
% hObject    handle to show_right_electrode_outline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get the coordinates that outline the left electrode
    ytop = str2double(get(handles.right_electrode_top_coords_textbox,'String'));
    ybot = str2double(get(handles.right_electrode_bot_coords_textbox,'String'));
    xface = str2double(get(handles.right_electrode_face_coords_textbox,'String'));

    % Get the image from the axes handles
    image = getimage(handles.axes1);
    
    % Draw three lines that outline the right electrode
    line([xface size(image,1)],[ybot ybot],'Color','g','LineWidth',2)
    line([xface size(image,1)],[ytop ytop],'Color','g','LineWidth',2)
    line([xface xface],[ybot ytop],'Color','g','LineWidth',2)
    
    % Update handles structure
    guidata(hObject, handles);
    
end

% --- Executes on button press in right_electrode_top.
function right_electrode_top_Callback(hObject, eventdata, handles)
% hObject    handle to right_electrode_top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get the graphical input from the user
    [~,y] = ginput(1);

    % Store the value in the appropriate left electrode textbox
    set(handles.right_electrode_top_coords_textbox,'String',num2str(round(y)))

    % Update handles structure
    guidata(hObject, handles);
    
end

% --- Executes on button press in right_electrode_bot.
function right_electrode_bot_Callback(hObject, eventdata, handles)
% hObject    handle to right_electrode_bot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get the graphical input from the user
    [~,y] = ginput(1);

    % Store the value in the appropriate left electrode textbox
    set(handles.right_electrode_bot_coords_textbox,'String',num2str(round(y)))

    % Update handles structure
    guidata(hObject, handles);
    
end

% --- Executes on button press in right_electrode_face.
function right_electrode_face_Callback(hObject, eventdata, handles)
% hObject    handle to right_electrode_face (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get the graphical input from the user
    [x,~] = ginput(1);

    % Store the value in the appropriate left electrode textbox
    set(handles.right_electrode_face_coords_textbox,'String',num2str(round(x)))

    % Update handles structure
    guidata(hObject, handles);
    
end


function left_electrode_top_coords_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to left_electrode_top_coords_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of left_electrode_top_coords_textbox as text
%        str2double(get(hObject,'String')) returns contents of left_electrode_top_coords_textbox as a double
end

% --- Executes during object creation, after setting all properties.
function left_electrode_top_coords_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to left_electrode_top_coords_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function left_electrode_bot_coords_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to left_electrode_bot_coords_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of left_electrode_bot_coords_textbox as text
%        str2double(get(hObject,'String')) returns contents of left_electrode_bot_coords_textbox as a double
end

% --- Executes during object creation, after setting all properties.
function left_electrode_bot_coords_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to left_electrode_bot_coords_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function left_electrode_face_coords_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to left_electrode_face_coords_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of left_electrode_face_coords_textbox as text
%        str2double(get(hObject,'String')) returns contents of left_electrode_face_coords_textbox as a double
end

% --- Executes during object creation, after setting all properties.
function left_electrode_face_coords_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to left_electrode_face_coords_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in left_electrode_top.
function left_electrode_top_Callback(hObject, eventdata, handles)
% hObject    handle to left_electrode_top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get the graphical input from the user
    [~,y] = ginput(1);

    % Store the value in the appropriate left electrode textbox
    set(handles.left_electrode_top_coords_textbox,'String',num2str(ceil(y)))

    % Update handles structure
    guidata(hObject, handles);

end

% --- Executes on button press in left_electrode_bot.
function left_electrode_bot_Callback(hObject, eventdata, handles)
% hObject    handle to left_electrode_bot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get the graphical input from the user
    [~,y] = ginput(1);

    % Store the value in the appropriate left electrode textbox
    set(handles.left_electrode_bot_coords_textbox,'String',num2str(ceil(y)))

    % Update handles structure
    guidata(hObject, handles);
    
end

% --- Executes on button press in left_electrode_face.
function left_electrode_face_Callback(hObject, eventdata, handles)
% hObject    handle to left_electrode_face (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get the graphical input from the user
    [x,~] = ginput(1);

    % Store the value in the appropriate left electrode textbox
    set(handles.left_electrode_face_coords_textbox,'String',num2str(round(x)))

    % Update handles structure
    guidata(hObject, handles);
    
end

% --- Executes on button press in reset_left_coords.
function reset_left_coords_Callback(hObject, eventdata, handles)
% hObject    handle to reset_left_coords (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Reset the right electrode textboxes to default values
    set(handles.left_electrode_top_coords_textbox,'String','0')
    set(handles.left_electrode_bot_coords_textbox,'String','0')
    set(handles.left_electrode_face_coords_textbox,'String','0')
    
    % Update handles structure
    guidata(hObject, handles);
    
end

% --- Executes on button press in show_left_electrode_outline.
function show_left_electrode_outline_Callback(hObject, eventdata, handles)
% hObject    handle to show_left_electrode_outline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get the coordinates that outline the right electrode
    ytop = str2double(get(handles.left_electrode_top_coords_textbox,'String'));
    ybot = str2double(get(handles.left_electrode_bot_coords_textbox,'String'));
    xface = str2double(get(handles.left_electrode_face_coords_textbox,'String'));
    
    % Draw three lines that outline the left electrode
    line([0 xface],[ybot ybot],'Color','g','LineWidth',2)
    line([0 xface],[ytop ytop],'Color','g','LineWidth',2)
    line([xface xface],[ybot ytop],'Color','g','LineWidth',2)

    % Update handles structure
    guidata(hObject, handles);
    
end

% --- Executes on button press in apply_edge_filter.
function apply_edge_filter_Callback(hObject, eventdata, handles)
% hObject    handle to apply_edge_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get the image
    electrode_background_gray = getimage(handles.axes1);

    % User Canny edge-filtering to get the boundaries
    electrode_edges = edge(electrode_background_gray,'canny');

    % Display the edge-filtered image
    imshow(electrode_edges)
    
    % Update handles structure
    guidata(hObject, handles);
    
end

% --- Executes on button press in adjust_contrast.
function adjust_contrast_Callback(hObject, eventdata, handles)
% hObject    handle to adjust_contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Check to see if the image is NOT a binary image. If it is, warn the user
    % and exit
    if islogical(getimage(handles.axes1))
        warn = warndlg('A binary image cannot have its contrast adjusted! Reset the image if you would like to adjust the contrast.','WARNING!');
        uiwait(warn)
        return;
    end

    % Pull up the adjust contrast tool
    imcontrast(handles.axes1)

    % Update handles structure
    guidata(hObject, handles);

end

% --- Executes on button press in reset_image.
function reset_image_Callback(hObject, eventdata, handles)
% hObject    handle to reset_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    imshow(handles.original_image)

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
