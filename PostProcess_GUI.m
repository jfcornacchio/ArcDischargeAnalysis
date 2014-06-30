function varargout = PostProcess_GUI(varargin)
% PostProcess_GUI MATLAB code for PostProcess_GUI.fig
%      PostProcess_GUI, by itself, creates a new PostProcess_GUI or raises the existing
%      singleton*.
%
%      H = PostProcess_GUI returns the handle to a new PostProcess_GUI or the handle to
%      the existing singleton*.
%
%      PostProcess_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PostProcess_GUI.M with the given input arguments.
%
%      PostProcess_GUI('Property','Value',...) creates a new PostProcess_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PostProcess_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PostProcess_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PostProcess_GUI

% Last Modified by GUIDE v2.5 29-Sep-2013 18:49:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PostProcess_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @PostProcess_GUI_OutputFcn, ...
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


% --- Executes just before PostProcess_GUI is made visible.
function PostProcess_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PostProcess_GUI (see VARARGIN)

    % Choose default command line output for PostProcess_GUI
    handles.output = hObject;

%% Set the data into the main table

    % Load the input file
    handles.ProcessedFiles      = varargin{1}.ProcessedFiles;
    handles.PreprocessedFiles   = varargin{1}.PreprocessedFiles;
    handles.InputStruct         = varargin{1}.InputStruct;

    % Get the list of files that have had their input files setup 
    FilesWithInputs = {handles.InputStruct(:).Filename};
    
    % Split the list of current files at the ".", which is the file
    % extension
    [FilesWithInputs,~] = strtok(FilesWithInputs,'.');
    
    % Using the inputs, fill in the main table
    tabledata = cell(length(handles.InputStruct),13); handles.InputStruct.Filename;
    
    for loop = 1:size(tabledata,1)
        
        % Check to see if this file was preprocessed
        if any(strcmpi(FilesWithInputs{loop},handles.PreprocessedFiles))
            preprocessed = true;
        else
            preprocessed = false;
        end
        
        % Check to see if this file was processed
        if any(strcmpi(FilesWithInputs{loop},handles.ProcessedFiles))
            processed = true;
        else
            processed = false;
        end
        
        tabledata(loop,:) = {false...
                                handles.InputStruct(loop).Filename...
                                preprocessed...
                                processed...
                                handles.InputStruct(loop).InitialTemperature...
                                handles.InputStruct(loop).InitialPressure...
                                handles.InputStruct(loop).AverageSparkPower...
                                handles.InputStruct(loop).SparkEnergy...
                                handles.InputStruct(loop).BreakdownVoltage...
                                handles.InputStruct(loop).IgnitionStatus...
                                handles.InputStruct(loop).NominalSparkGap...
                                handles.InputStruct(loop).Fuel...
                                handles.InputStruct(loop).Oxidizer};
    end

    set(handles.main_selection_table,'Data',tabledata)
    
    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes PostProcess_GUI wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = PostProcess_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end
