function varargout = ProcessList_GUI(varargin)
% PROCESSLIST_GUI MATLAB code for ProcessList_GUI.fig
%      PROCESSLIST_GUI, by itself, creates a new PROCESSLIST_GUI or raises the existing
%      singleton*.
%
%      H = PROCESSLIST_GUI returns the handle to a new PROCESSLIST_GUI or the handle to
%      the existing singleton*.
%
%      PROCESSLIST_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROCESSLIST_GUI.M with the given input arguments.
%
%      PROCESSLIST_GUI('Property','Value',...) creates a new PROCESSLIST_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ProcessList_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ProcessList_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ProcessList_GUI

% Last Modified by GUIDE v2.5 21-Sep-2013 16:20:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ProcessList_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ProcessList_GUI_OutputFcn, ...
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


% --- Executes just before ProcessList_GUI is made visible.
function ProcessList_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ProcessList_GUI (see VARARGIN)

    % Choose default command line output for ProcessList_GUI
    handles.output = hObject;
    
    % Using the list of all filenames and the list of filenames that have
    % already been processed, create the main table.
    
    % Initialize the main table cell array
    tabledata = cell(length(varargin{1}.PreprocessedFiles),3);
    
    % Initialize the checkboxes to false
    tabledata(:,1) = deal({false});
    
    % Initialize the second column to the filenames from the input file
    tabledata(:,2) = varargin{1}.PreprocessedFiles(:);
    
    % Determine which files in the input filelist have already been
    % processed by comparing them to the list of processed files.
    for loop = 1:length(varargin{1}.ProcessedFiles)
        test = strcmpi(varargin{1}.ProcessedFiles{loop},varargin{1}.PreprocessedFiles);
        if any(test)
           tabledata(test==1,3) = {true}; 
        end
        
    end
    
    % Set the main table data
    set(handles.process_main_table,'Data',tabledata)
    
    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes ProcessList_GUI wait for user response (see UIRESUME)
    uiwait(handles.figure1);
    
end


% --- Outputs from this function are returned to the command line.
function varargout = ProcessList_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    % Pack the table selections into the output struct
    tabledata = get(handles.process_main_table,'Data');
    
    % Get the "Process File?" checkboxes and see which ones are set to
    % "true"
    checkboxes = tabledata(:,1);
    checkboxes = cell2mat(checkboxes);
    tabledata = tabledata(checkboxes==1,:);
    
    % Check to make sure that at least one checkbox was set to true
    if ~isempty(tabledata)
        % Store the filenames of the data to be processed in the output
        % struct
        handles.output.FileNamesToProcess = tabledata(:,2);
        
    else
        handles.output.FileNamesToProcess = [];
    end
    
    % Get default command line output from handles structure
    varargout{1} = handles.output;
    
    % The figure can now be deleted
    delete(handles.figure1);
    
end


% --- Executes on button press in select_all_button.
function select_all_button_Callback(hObject, eventdata, handles)
% hObject    handle to select_all_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get the table data
    tabledata = get(handles.process_main_table,'Data');
    
    % Set all the "Process File?" checkboxes to true
    tabledata(:,1) = deal({true});
    
    % Set the data back into the table
    set(handles.process_main_table,'Data',tabledata)
    
    % Update handles structure
    guidata(hObject, handles);

end


% --- Executes on button press in deselect_all_button.
function deselect_all_button_Callback(hObject, eventdata, handles)
% hObject    handle to deselect_all_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    % Get the table data
    tabledata = get(handles.process_main_table,'Data');
    
    % Set all the "Process File?" checkboxes to false
    tabledata(:,1) = deal({false});
    
    % Set the data back into the table
    set(handles.process_main_table,'Data',tabledata)
    
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


% --- Executes on button press in process_selections_button.
function process_selections_button_Callback(hObject, eventdata, handles)
% hObject    handle to process_selections_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    close(handles.figure1)
    
end
