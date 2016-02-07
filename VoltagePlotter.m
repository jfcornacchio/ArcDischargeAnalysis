%% Initialize
clc
clearvars
close('all')

%% Inputs

% Select files for plotting
[OscilloscopeFileNames,OscilloscopeFileDirectory] = uigetfile('C:\Users\Jim Cornacchio\Documents\Dissertation\Spark Generator Design\Triple HV Switch Board Tests\9_6_2015\Raw Oscilloscope Data\*.bin','Choose Oscilloscope Binary Files','Multiselect','on');

if isnumeric(OscilloscopeFileNames) && OscilloscopeFileNames==0
    return
end

if ~iscell(OscilloscopeFileNames)
    OscilloscopeFileNames = {OscilloscopeFileNames};
end

% Choose the channels to read on the oscilloscope
OscilloscopeChannels = [1 2 3 4];

% Input Bias Current Voltage Offset
InputBiasCurrentVoltageOffsetFileName  	= 'C:\Users\Jim Cornacchio\Documents\Dissertation\Spark Generator Design\Triple HV Switch Board Tests\9_6_2015\Raw Oscilloscope Data\tp_0.bin';
% InputBiasCurrentVoltageOffsetFileName    = '';
InputBiasCurrentRefChannel              = 2;
InvertInputBiasCurrentVoltage           = false;

% Provide the time steps for the histograms
% TimeSteps           = [2e-6;5e-6;8e-6];
TimeSteps           = [15e-6];
NumberOfTimeSteps   = length(TimeSteps);

% Provide the moving average step. The moving average will be applied in
% both the forward and reverse directions to eliminate any phase shift.
WindowLength = 64;

% Voltage channel
VoltageChannel = 2;

% Invert voltage/current?
InvertVoltage = 0;
InvertCurrent = 0;

% Voltage Histogram Limits
VoltageHistogramXLimits = [-50 800];
VoltageHistogramYLimits = [0 15];

% Power Histogram Limits
PowerHistogramXLimits = [0 400];
PowerHistogramYLimits = [0 15];

% Voltage Plots Limits
VoltageXLimits = [-2e-6 50e-6];
VoltageYLimits = [-50 800];

% Filtered voltage histogram limits
FilteredVoltageHistogramXLimits = [0 800];
FilteredVoltageHistogramYLimits = [];

% Power Plots Limits
PowerXLimits = [-2e-6 50e-6];
PowerYLimits = [-20 400];

% Prellocate memory
VoltageMatrix           = NaN(length(OscilloscopeFileNames),NumberOfTimeSteps);
FilteredVoltageMatrix   = NaN(length(OscilloscopeFileNames),NumberOfTimeSteps);
AveragedVoltageMatrix   = NaN(length(OscilloscopeFileNames),NumberOfTimeSteps);
PowerMatrix             = NaN(length(OscilloscopeFileNames),NumberOfTimeSteps);
CurrentMatrix           = NaN(length(OscilloscopeFileNames),NumberOfTimeSteps);

% Initialize waitbars
multiWaitbar('CloseAll');
multiWaitbar('Overall Progress',0,'Color',[1 1 1]);

%% Load Oscilloscope data and create plots

% Create figures and axes
VoltageFigureHandle = figure('Visible','off');
set(VoltageFigureHandle,'Color',[1 1 1]);
VoltageAxesHandle = gca;
hold(VoltageAxesHandle,'on')

% FilteredVoltageFigureHandle = figure('Visible','off');
% set(FilteredVoltageFigureHandle,'Color',[1 1 1]);
% FilteredVoltageAxesHandle = gca;
% hold(FilteredVoltageAxesHandle,'on')

PowerFigureHandle = figure('Visible','off');
set(PowerFigureHandle,'Color',[1 1 1]);
PowerAxesHandle = gca;
hold(PowerAxesHandle,'on')

if ~isempty(InputBiasCurrentVoltageOffsetFileName)
   % Load the input bias current offset data
    InputBiasCurrentVoltageRefData	= importAgilentBin(InputBiasCurrentVoltageOffsetFileName,[1 2 3 4]);
    InputBiasCurrentVoltageOffset	= mean(InputBiasCurrentVoltageRefData(InputBiasCurrentRefChannel).dataVector);

    if InvertInputBiasCurrentVoltage
        InputBiasCurrentVoltageOffset = -1*InputBiasCurrentVoltageOffset;
    end
    
end

for loop = 1:length(OscilloscopeFileNames)
    
    % Load the data from the file
    try
        OscilloscopeData = importAgilentBin(fullfile(OscilloscopeFileDirectory,OscilloscopeFileNames{loop}),OscilloscopeChannels);
    catch
        % Warn the user that an error was encountered!
        warn = warndlg(['File ' OscilloscopeFileNames{loop} 'could not be read. There may have been an error writing data from the oscilloscope.'],'WARNING!');
        continue
    end
    
    % Invert voltage and current, if necessary.
    if InvertVoltage
        OscilloscopeData(VoltageChannel).dataVector = -1*OscilloscopeData(VoltageChannel).dataVector;
    end
    
    if InvertCurrent
        OscilloscopeData(3).dataVector = -1*OscilloscopeData(3).dataVector;
    end
    
    % Apply the input bias current voltage offset, if requested.
    if ~isempty(InputBiasCurrentVoltageOffsetFileName)
        OscilloscopeData(VoltageChannel).dataVector = OscilloscopeData(VoltageChannel).dataVector-InputBiasCurrentVoltageOffset;
    end
    
    % Calculate moving average for the spark voltage
    filter_vec      = 1/WindowLength*ones(WindowLength,1);
    FilteredVoltage = filter(filter_vec,1,OscilloscopeData(VoltageChannel).dataVector);
    FilteredVoltage = filter(filter_vec,1,flipud(FilteredVoltage));
    FilteredVoltage = flipud(FilteredVoltage);
    
     % Calculate the spark power
%     InstantaneousSparkPower = OscilloscopeData(VoltageChannel).dataVector.*OscilloscopeData(3).dataVector;
    InstantaneousSparkPower = FilteredVoltage.*OscilloscopeData(3).dataVector;
    
    % Plot the power data
    plot(PowerAxesHandle,OscilloscopeData(1).timeVector,InstantaneousSparkPower,'r','LineWidth',0.5)
    
    % Plot the voltage data
    plot(VoltageAxesHandle,OscilloscopeData(1).timeVector,FilteredVoltage,'b','LineWidth',0.5)
%     plot(OscilloscopeData(1).timeVector,OscilloscopeData(VoltageChannel).dataVector,'b','LineWidth',0.5)
    
    % Determine the index that most closely matches the time steps provided
    % and store those values in the matrices.
    for loop2 = 1:NumberOfTimeSteps
        [~,time_idx]                        = min(abs(TimeSteps(loop2)-OscilloscopeData(1).timeVector));
        VoltageMatrix(loop,loop2)           = OscilloscopeData(VoltageChannel).dataVector(time_idx);
        PowerMatrix(loop,loop2)             = InstantaneousSparkPower(time_idx);
        CurrentMatrix(loop,loop2)           = OscilloscopeData(3).dataVector(time_idx);
        FilteredVoltageMatrix(loop,loop2)   = FilteredVoltage(time_idx);
%         AveragedVoltageMatrix(loop,loop2)   = mean(OscilloscopeData(VoltageChannel).dataVector(time_idx-32:time_idx+32));
        
    end
    
    % Update waitbar
    multiWaitbar('Overall Progress',loop/length(OscilloscopeFileNames));
    
end

% Set the voltage plot axes properties
xlabel(VoltageAxesHandle,'Time (s)','FontSize',16')
ylabel(VoltageAxesHandle,'Voltage','FontSize',16')
set(VoltageAxesHandle,'FontSize',14)

if ~isempty(VoltageXLimits)
    set(VoltageAxesHandle,'XLim',VoltageXLimits)
    
end

if ~isempty(VoltageYLimits)
    set(VoltageAxesHandle,'YLim',VoltageYLimits)
    
end
grid(VoltageAxesHandle,'on')

% Make the figure visible
set(VoltageFigureHandle,'Visible','on');

% Set the power plot axes properties
xlabel(PowerAxesHandle,'Time (s)','FontSize',16')
ylabel(PowerAxesHandle,'Power (Watts)','FontSize',16')
set(PowerAxesHandle,'FontSize',14)

if ~isempty(PowerXLimits)
    set(PowerAxesHandle,'XLim',PowerXLimits)
    
end

if ~isempty(PowerYLimits)
    set(PowerAxesHandle,'YLim',PowerYLimits)
    
end
grid(PowerAxesHandle,'on')

% Make the figure visible
set(PowerFigureHandle,'Visible','on');

% Plot the voltage histograms
for loop = 1:NumberOfTimeSteps
    figurehandle = figure('Color',[1 1 1]); 
	hist(VoltageMatrix(:,loop),20)
    grid on
    xlabel('Voltage')
    ylabel('Frequency')
    title(['Spark Voltage at '  num2str(TimeSteps(loop)) ' Seconds'])
    
    if isempty(VoltageHistogramXLimits)
        XLimitsXLimits = get(gca,'XLim');

        if xLimits(1)>0
            set(gca,'XLim',[0 VoltageHistogramXLimits(2)])
        end
    else
        set(gca,'XLim',VoltageHistogramXLimits)
        
    end
    
    if ~isempty(VoltageHistogramYLimits)
        
        set(gca,'YLim',VoltageHistogramYLimits)
        
    end
    
end

% Plot the filtered voltage histograms
for loop = 1:NumberOfTimeSteps
    figurehandle = figure('Color',[1 1 1]); 
	hist(FilteredVoltageMatrix(:,loop),20)
    grid on
    xlabel('Filtered Voltage')
    ylabel('Frequency')
    title(['Filtered Spark Voltage at '  num2str(TimeSteps(loop)) ' Seconds'])
    xLimits = get(gca,'XLim');
    
    if xLimits(1)>0
        set(gca,'XLim',[0 xLimits(2)])
    end
        
    if isempty(FilteredVoltageHistogramXLimits)
        XLimitsXLimits = get(gca,'XLim');

        if xLimits(1)>0
            set(gca,'XLim',[0 FilteredVoltageHistogramXLimits(2)])
        end
    else
        set(gca,'XLim',FilteredVoltageHistogramXLimits)
        
    end
    
    if ~isempty(FilteredVoltageHistogramYLimits)
        
        set(gca,'YLim',FilteredVoltageHistogramYLimits)
        
    end

end

% % Plot the averaged voltage histograms
% for loop = 1:NumberOfTimeSteps
%     figurehandle = figure('Color',[1 1 1]); 
% 	hist(AveragedVoltageMatrix(:,loop),20)
%     grid on
%     xlabel('Averaged Voltage')
%     ylabel('Frequency')
%     title(['Filtered Spark Voltage at '  num2str(TimeSteps(loop)) ' Seconds'])
%     xLimits = get(gca,'XLim');
%     
%     if xLimits(1)>0
%         set(gca,'XLim',[0 xLimits(2)])
%     end
%     
% end

% Plot the power histograms
for loop = 1:NumberOfTimeSteps
    figurehandle = figure('Color',[1 1 1]); 
	hist(PowerMatrix(:,loop),20)
    grid on
    xlabel('Power (Watts)')
    ylabel('Frequency')
    title(['Spark Power at '  num2str(TimeSteps(loop)) ' Seconds'])
    
    if isempty(PowerHistogramXLimits)
        XLimitsXLimits = get(gca,'XLim');

        if xLimits(1)>0
            set(gca,'XLim',[0 PowerHistogramXLimits(2)])
        end
    else
        set(gca,'XLim',PowerHistogramXLimits)
        
    end
    
    if ~isempty(PowerHistogramYLimits)
        
        set(gca,'YLim',PowerHistogramYLimits)
        
    end
    
end

% % Plot the current histograms
% for loop = 1:NumberOfTimeSteps
%     figurehandle = figure('Color',[1 1 1]); 
% 	hist(CurrentMatrix(:,loop),20)
%     grid on
%     xlabel('Current (amps)')
%     ylabel('Frequency')
%     title(['Spark Current at '  num2str(TimeSteps(loop)) ' Seconds'])
%     set(gca,'XLim',[0 3])
% end

% Close waitbars
multiWaitbar('CloseAll');
