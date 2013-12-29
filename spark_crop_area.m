function varargout = spark_crop_area(varargin)
% SPARK_CROP_AREA MATLAB code for spark_crop_area.fig
%      SPARK_CROP_AREA, by itself, creates a new SPARK_CROP_AREA or raises the existing
%      singleton*.
%
%      H = SPARK_CROP_AREA returns the handle to a new SPARK_CROP_AREA or the handle to
%      the existing singleton*.
%
%      SPARK_CROP_AREA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPARK_CROP_AREA.M with the given input arguments.
%
%      SPARK_CROP_AREA('Property','Value',...) creates a new SPARK_CROP_AREA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before spark_crop_area_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to spark_crop_area_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help spark_crop_area

% Last Modified by GUIDE v2.5 21-Jul-2013 12:06:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spark_crop_area_OpeningFcn, ...
                   'gui_OutputFcn',  @spark_crop_area_OutputFcn, ...
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

% --- Executes just before spark_crop_area is made visible.
function spark_crop_area_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to spark_crop_area (see VARARGIN)

    % Choose default command line output for spark_crop_area
    handles.output = hObject;

    % Show the image passed from the spark_stretch_input_gui
    imshow(varargin{1}.image)

    % Store the original image in the handles structure
    handles.original_image = varargin{1}.image;
    
    % Set the editable text boxes showing the crop area.
    set(handles.xmin_edit_text,'String',varargin{1}.xmin)
    set(handles.xmax_edit_text,'String',varargin{1}.xmax)
    set(handles.ymin_edit_text,'String',varargin{1}.ymin)
    set(handles.ymax_edit_text,'String',varargin{1}.ymax)
    
    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes spark_crop_area wait for user response (see UIRESUME)
    uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = spark_crop_area_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    handles.output.xmin = get(handles.xmin_edit_text,'String');
    handles.output.xmax = get(handles.xmax_edit_text,'String');
    handles.output.ymin = get(handles.ymin_edit_text,'String');
    handles.output.ymax = get(handles.ymax_edit_text,'String');

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

% --- Executes on button press in contrast_tag.
function contrast_tag_Callback(hObject, eventdata, handles)
% hObject    handle to contrast_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Pull up the adjust contrast tool
    imcontrast(handles.axes1)

    % Update handles structure
    guidata(hObject, handles);

end

% --- Executes on button press in select_crop_area.
function select_crop_area_Callback(hObject, eventdata, handles)
% hObject    handle to select_crop_area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get the user to outline the areas of interest (AOI) by cropping 
    % the image, clicking in the bottom left corner of the AOI and the
    % upper right corner of the AOI.
    k = waitforbuttonpress;

    % Detect the button press
    point1 = get(handles.axes1,'CurrentPoint');

    % Use the rubber-band box function to draw a rectangle
    finalRect = rbbox;

    % Detect the button release
    point2 = get(handles.axes1,'CurrentPoint');

    % Extract the x and y from the point matrices
    point1 = point1(1,1:2);
    point2 = point2(1,1:2);

    % Calculate the new x and y min and max values
    xmin = floor(min(point1(1),point2(1)));
    xmax = ceil(max(point1(1),point2(1)));
    ymin = floor(min(point1(2),point2(2)));
    ymax = ceil(max(point1(2),point2(2)));
    
    % Set the editable text boxes showing the crop area.
    set(handles.xmin_edit_text,'String',num2str(xmin))
    set(handles.xmax_edit_text,'String',num2str(xmax))
    set(handles.ymin_edit_text,'String',num2str(ymin))
    set(handles.ymax_edit_text,'String',num2str(ymax))
    
    % Draw lines showing the cropped area
    line([xmin xmax],[ymin ymin],'Color','g','LineWidth',2)
    line([xmin xmax],[ymax ymax],'Color','g','LineWidth',2)
    line([xmin xmin],[ymin ymax],'Color','g','LineWidth',2)
    line([xmax xmax],[ymin ymax],'Color','g','LineWidth',2)
    
    % Update handles structure
    guidata(hObject, handles);
    
end

% --- Executes on button press in apply_edge_filtering.
function apply_edge_filtering_Callback(hObject, eventdata, handles)
% hObject    handle to apply_edge_filtering (see GCBO)
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


function xmin_edit_text_Callback(hObject, eventdata, handles)
% hObject    handle to xmin_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xmin_edit_text as text
%        str2double(get(hObject,'String')) returns contents of xmin_edit_text as a double
end

% --- Executes during object creation, after setting all properties.
function xmin_edit_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmin_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function xmax_edit_text_Callback(hObject, eventdata, handles)
% hObject    handle to xmax_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xmax_edit_text as text
%        str2double(get(hObject,'String')) returns contents of xmax_edit_text as a double
end

% --- Executes during object creation, after setting all properties.
function xmax_edit_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmax_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function ymin_edit_text_Callback(hObject, eventdata, handles)
% hObject    handle to ymin_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ymin_edit_text as text
%        str2double(get(hObject,'String')) returns contents of ymin_edit_text as a double
end

% --- Executes during object creation, after setting all properties.
function ymin_edit_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymin_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function ymax_edit_text_Callback(hObject, eventdata, handles)
% hObject    handle to ymax_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ymax_edit_text as text
%        str2double(get(hObject,'String')) returns contents of ymax_edit_text as a double
end

% --- Executes during object creation, after setting all properties.
function ymax_edit_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymax_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
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


% --- Executes on button press in outline_cropped_area.
function outline_cropped_area_Callback(hObject, eventdata, handles)
% hObject    handle to outline_cropped_area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Calculate the new x and y min and max values
    xmin = str2double(get(handles.xmin_edit_text,'String'));
    xmax = str2double(get(handles.xmax_edit_text,'String'));
    ymin = str2double(get(handles.ymin_edit_text,'String'));
    ymax = str2double(get(handles.ymax_edit_text,'String'));
    
    % Draw lines showing the cropped area
    line([xmin xmax],[ymin ymin],'Color','g','LineWidth',2)
    line([xmin xmax],[ymax ymax],'Color','g','LineWidth',2)
    line([xmin xmin],[ymin ymax],'Color','g','LineWidth',2)
    line([xmax xmax],[ymin ymax],'Color','g','LineWidth',2)
    
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


