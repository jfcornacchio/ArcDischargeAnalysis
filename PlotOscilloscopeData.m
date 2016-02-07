%% Initialize
clc
clearvars

%% Inputs

% Select files for plotting
[OscilloscopeFileNames,OscilloscopeFileDirectory] = uigetfile('C:\Users\Jim Cornacchio\Documents\Dissertation\Spark Generator Design\Triple HV Switch Board Tests\7_27_2015\*.bin','Choose Oscilloscope Binary Files','Multiselect','on');

if isnumeric(OscilloscopeFileNames) && OscilloscopeFileNames==0
    return
end

if ~iscell(OscilloscopeFileNames)
    OscilloscopeFileNames = {OscilloscopeFileNames};
end

% Select folder to place the plots
PlotSaveDirectory = uigetdir('C:\Users\Jim Cornacchio\Documents\Dissertation\Spark Generator Design\Triple HV Switch Board Tests\7_27_2015\Raw Data Plots','Select Folder Location for Plots');

% Check to make sure that the user selected a folder for the plots
if isnumeric(PlotSaveDirectory) && PlotSaveDirectory==0
   return 
end

% Choose the channels to read on the oscilloscope
OscilloscopeChannels = [2];

% Set the Y-limits
YLimits     = [0 1000];
YTickMarks  = YLimits(1):100:YLimits(2);

% Choose if all signals are displayed on the same plot
SamePlot = false;

% Initialize waitbars
multiWaitbar('Overall Progress',0,'Color',[0 0 1]);
multiWaitbar('Loading Binary File',0,'Color',[0 0 1]);
multiWaitbar('Plotting Data',0,'Color',[0 0 1]);

%% Load Oscilloscope data and create plots

if ~isdir(PlotSaveDirectory)
    mkdir(PlotSaveDirectory);
end

for loop = 1:length(OscilloscopeFileNames)
    
    % Update waitbar
    multiWaitbar('Loading Binary File',0);
    
    % Load the data from the file
    try
        OscilloscopeData = importAgilentBin(fullfile(OscilloscopeFileDirectory,OscilloscopeFileNames{loop}),OscilloscopeChannels);
    catch
        % Warn the user that an error was encountered!
        warn = warndlg(['File ' OscilloscopeFileNames{loop} 'could not be read. There may have been an error writing data from the oscilloscope.'],'WARNING!');
        continue
    end
    
    % Update waitbar
    multiWaitbar('Loading Binary File',1);
    
    % Get the file name, without the extension
    [~,temp_name] = fileparts(OscilloscopeFileNames{loop});
    
    % Create a figure and axes
    FigureHandle = figure('Visible','off');

    set(FigureHandle,'Color',[1 1 1]);
    AxesHandle = gca;
    set(AxesHandle,'FontSize',14)
    
    % Plot the data
    for loop2 = OscilloscopeChannels
        
        % Reinitialize waitbars
        multiWaitbar('Plotting Data',0);
        
        plot(AxesHandle,OscilloscopeData(1).timeVector,OscilloscopeData(loop2).dataVector,'LineWidth',1)
        
        xlabel(AxesHandle,OscilloscopeData(loop2).xUnits,'FontSize',16')
        ylabel(AxesHandle,OscilloscopeData(loop2).yUnits,'FontSize',16')
        grid on
        
        % Set the Y-Limits
        if ~isempty(YLimits)
           set(AxesHandle,'YLim',YLimits(loop,:))
        end
        
        if ~isempty(YTickMarks)
            set(AxesHandle,'YTick',YTickMarks(loop,:))
        end
        
        if ~SamePlot
            % Save the plot
            print(FigureHandle,fullfile(PlotSaveDirectory,[temp_name ', Channel' int2str(loop2)]),'-dpng');
            
        else
            hold(AxesHandle,'all')
        end
        
        % Update waitbar
        multiWaitbar('Plotting Data',1);
        
    end
    
    if SamePlot
        print(FigureHandle,fullfile(PlotSaveDirectory,temp_name),'-dpng');
        cla(AxesHandle,'reset')
    end
    
    % Update waitbar
    multiWaitbar('Overall Progress',loop/length(OscilloscopeFileNames));
    
end

% Close the figure
close(FigureHandle)

% Close waitbars
multiWaitbar('CloseAll');

