%% Initialize parameters
clc
clearvars

% List of files containing data to be plotted
FileList = {
%             'C:\Users\Jim Cornacchio\Documents\Dissertation\HighSpeedVideoProcessing\SchlierenVideoProcessing\ProcessedData\ProcessedData_GT2011_1.mat';
%             'C:\Users\Jim Cornacchio\Documents\Dissertation\HighSpeedVideoProcessing\SchlierenVideoProcessing\ProcessedData\ProcessedData_GT2011_2.mat';
%             'C:\Users\Jim Cornacchio\Documents\Dissertation\HighSpeedVideoProcessing\SchlierenVideoProcessing\ProcessedData\ProcessedData_GT2011_3.mat';
%             'C:\Users\Jim Cornacchio\Documents\Dissertation\HighSpeedVideoProcessing\SchlierenVideoProcessing\ProcessedData\ProcessedData_GT2011_4.mat';
%             'C:\Users\Jim Cornacchio\Documents\Dissertation\HighSpeedVideoProcessing\SchlierenVideoProcessing\ProcessedData\ProcessedData_GT2011_5.mat';
%             'C:\Users\Jim Cornacchio\Documents\Dissertation\HighSpeedVideoProcessing\SchlierenVideoProcessing\ProcessedData\ProcessedData_GT2011_6.mat';
            'C:\Users\Jim Cornacchio\Documents\Dissertation\HighSpeedVideoProcessing\SchlierenVideoProcessing\ProcessedData\ProcessedData_GT2011_7.mat';
            'C:\Users\Jim Cornacchio\Documents\Dissertation\HighSpeedVideoProcessing\SchlierenVideoProcessing\ProcessedData\ProcessedData_GT2011_8.mat';
%             'C:\Users\Jim Cornacchio\Documents\Dissertation\HighSpeedVideoProcessing\SchlierenVideoProcessing\ProcessedData\ProcessedData_GT2011_9.mat';
            };

% X and Y variable names
YVariableName  	= 'UpperCenterLineRadius_cm';
XVariableName   = 'Time';

% X and Y limits
YLimitSetting   = 'Auto';
XLimitSetting   = 'Auto';
YLimit          = [0 1000];
XLimit          = [0 8];

% X and Y Axes Label Font Sizes
YLabelFontSize = 18;
XLabelFontSize = 18;

% Axes Font Size
AxesFontSize = 16;

% Initialize waitbars
multiWaitbar('Loading Data',0,'Color',[0 0 1]);

%% Plot Setup
FigureHandle    = figure('Visible','off');
AxesHandle      = gca;
hold all
xlabel('Time(ms)','FontSize',XLabelFontSize)
ylabel('Radius (cm)','FontSize',YLabelFontSize)
title('Centerline Radius vs. Time, 6mm Spark Gap','FontSize',24)

set(AxesHandle,'FontSize',AxesFontSize)

%% Plot Data

for loop = 1:length(FileList)
    
    % Load the file
    Data = load(FileList{loop});
    
    if Data.ProcessedData.NominalSparkGap==6
        markercolor = 'g';
    elseif Data.ProcessedData.NominalSparkGap==2
        markercolor = 'k';
    elseif Data.ProcessedData.NominalSparkGap==10
        markercolor = 'g';
    else
        markercolor = 'm';
    end
    
    plot(AxesHandle,Data.ProcessedData.(XVariableName),Data.ProcessedData.(YVariableName),'Marker','o','MarkerEdgeColor','k','MarkerFaceColor',markercolor,'LineStyle','none')
   
    % Update the waitbar
    multiWaitbar('Loading Data',loop/length(FileList));
    
end

% Set the axes scales
switch YLimitSetting
    case 'Manual'
        set(AxesHandle,'YLim',YLimit)
    otherwise
end

switch XLimitSetting
    case 'Manual'
        set(AxesHandle,'XLim',XLimit)
    otherwise
end

% Turn the grid on
grid on

% Make the figure visible
set(FigureHandle,'Visible','on')

% Close all waitbars
multiWaitbar('CloseAll');

