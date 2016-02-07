%% Ayrton Equation plotting tool

% Initialize
clc
clearvars
close('all')

% Initialize waitbars
multiWaitbar('Loading Summary Table',0,'Color',[0 0 1]);
multiWaitbar('Loading Binary Files',0,'Color',[0 0 1]);

%% Inputs

% Input Bias Current Voltage Offset
InputBiasCurrentVoltageOffsetFileName	= 'C:\Users\Jim Cornacchio\Documents\Dissertation\Spark Generator Design\Triple HV Switch Board Tests\7_14_2015\Raw Oscilloscope Data\tp_0.bin';
% InputBiasCurrentVoltageOffsetFileName    = '';
InputBiasCurrentRefChannel              = 2;
InvertInputBiasCurrentVoltage           = true;

% Home folder
HomeFolder = 'C:\Users\Jim Cornacchio\Documents\Dissertation\Spark Generator Design\Triple HV Switch Board Tests\7_14_2015';

% Load the spark summary table
[~,~,raw] = xlsread(fullfile(HomeFolder,'SparkSummaryTable.xlsx'));

% Convert the cell array to a structure
SparkDataStruct = cell2struct(raw(2:end,:), raw(1,:),2);

% Update the waitbar
multiWaitbar('Loading Summary Table',1);

% Create a list of files in the spark summary table that the user could
% select.
[Selection,ok]= listdlg('ListString',{SparkDataStruct.FileName},...
                        'SelectionMode','multiple',...
                        'Name','File Selection',...
                        'PromptString','Select files for Ayrton Plot:');

% Check to make sure that the user made a selection
if ok==0
    % The user hit the cancel button
   return; 
end

% Store the selected file names in a cella rray.
OscilloscopeFileNames = {SparkDataStruct(Selection).FileName};

% Spark gap, in millimeters
ElectrodeSeparation = 2;

% Invert voltage/current?
InvertVoltage = 0;
InvertCurrent = 0;

% Constants of the Ayrton Equation	
a = 15.2;
b = 10.7;
c = 21.4;
d = 3;

% Range of currents to be plotted
MinSparkCurrent = 0.1;
MaxSparkCurrent = 5;
CurrentStep     = 0.05;

OscilloscopeChannels = [1 2 3];

%% Load the oscilloscope data and create the plots

% Create a figure and axes for plotting
FigureHandle = figure('Visible','off');
set(FigureHandle,'Color',[1 1 1]);
AxesHandle = gca;
hold on

% Create an array of current values using the supplied min/max/step
AyrtonCurrent = MinSparkCurrent:CurrentStep:MaxSparkCurrent;

if ~isempty(InputBiasCurrentVoltageOffsetFileName)
   % Load the input bias current voltage offset data
    InputBiasCurrentVoltageRefData	= importAgilentBin(InputBiasCurrentVoltageOffsetFileName,[1 2 3 4]);
    InputBiasCurrentVoltageOffset	= mean(InputBiasCurrentVoltageRefData(InputBiasCurrentRefChannel).dataVector);

    if InvertInputBiasCurrentVoltage
        InputBiasCurrentVoltageOffset = -1*InputBiasCurrentVoltageOffset;
    end
    
end

% Reset the waitbar
multiWaitbar('Loading Binary Files','Reset');

for loop = 1:length(OscilloscopeFileNames)
    % Load the data from the file
    try
        OscilloscopeData = importAgilentBin(fullfile(HomeFolder,'Raw Oscilloscope Data',OscilloscopeFileNames{loop}),OscilloscopeChannels);
    catch
        % Warn the user that an error was encountered!
        warn = warndlg(['File ' OscilloscopeFileNames{loop} 'could not be read. There may have been an error writing data from the oscilloscope.'],'WARNING!');
        continue
    end
    
    % Invert voltage and current, if necessary.
    switch SparkDataStruct(Selection(loop)).InvertSparkVoltage
        
        case 'Yes'
            OscilloscopeData(2).dataVector = -1*OscilloscopeData(2).dataVector;
        otherwise
            
    end
    
    % Apply the input bias current voltage offset, if requested.
    if ~isempty(CommonModeOffsetFileName)
        OscilloscopeData(2).dataVector = OscilloscopeData(2).dataVector-InputBiasCurrentVoltageOffset;
    end
    
    switch SparkDataStruct(Selection(loop)).InvertSparkCurrent
        
        case 'Yes'
            OscilloscopeData(3).dataVector = -1*OscilloscopeData(3).dataVector;
        otherwise
            
    end
    
    % Get the spark start and stop times and convert them to array indices
%     [~,StartTimeIdx]	= min(abs(OscilloscopeData(1).timeVector-SparkDataStruct(Selection(loop)).SparkStartTime));
%     [~,StopTimeIdx]     = min(abs(OscilloscopeData(1).timeVector-SparkDataStruct(Selection(loop)).SparkStopTime));
    
    [~,StartTimeIdx]	= min(abs(OscilloscopeData(1).timeVector-10e-6));
    [~,StopTimeIdx]     = min(abs(OscilloscopeData(1).timeVector-50e-6));
    
    % Plot the voltage data
    plot(AxesHandle,OscilloscopeData(3).dataVector(StartTimeIdx:StopTimeIdx),OscilloscopeData(2).dataVector(StartTimeIdx:StopTimeIdx),'.k','LineWidth',0.5)
    
    % Update waitbar
    multiWaitbar('Loading Binary Files',loop/length(OscilloscopeFileNames));
    
end

% Plot the V-I curve from the Ayrton equation
AyrtonVoltage = a+c*ElectrodeSeparation+(c+d*ElectrodeSeparation)./AyrtonCurrent;
plot(AxesHandle,AyrtonCurrent,AyrtonVoltage,'-b','LineWidth',2)

%% Clean-up

% Make the figure visible
set(FigureHandle,'Visible','on')
grid on

set(AxesHandle,'FontSize',14)
xlabel(AxesHandle,'Spark Current (amps)','FontSize',16)
ylabel(AxesHandle,'Spark Voltage (V)','FontSize',16)

% Close all waitbars
multiWaitbar('CloseAll');

