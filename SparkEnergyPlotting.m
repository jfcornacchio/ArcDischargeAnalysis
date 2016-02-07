%% Initialize
clearvars
clc
% close('all');

%% Inputs
SparkFileName     	= 'N:\11_1_2015\Raw Oscilloscope Data\tp_151.bin';
SparkVoltageChannel = 2;
SparkCurrentChannel = 3;
StartTime           = -7.82837E-08;
StopTime            = 108e-06;
InitialCurrent      = 4.884;
% InitialCurrent      = 0.54;

% Moving average window for the spark voltage
WindowLength = [];

% Input Bias Current Voltage Offset
InputBiasCurrentVoltageOffsetFileName	= 'N:\11_1_2015\Raw Oscilloscope Data\tp_0.bin';
% InputBiasCurrentVoltageOffsetFileName    = '';
InputBiasCurrentRefChannel              = 2;
InvertInputBiasCurrentVoltage           = false;

%% Load Data
OscilloscopeData    = importAgilentBin(SparkFileName,[1 2 3 4]);
SparkVoltageData    = OscilloscopeData(SparkVoltageChannel).dataVector;
SparkCurrentData    = OscilloscopeData(SparkCurrentChannel).dataVector;
TimeData        	= OscilloscopeData(1).timeVector;

[~,start_idx]   = min(abs(TimeData-StartTime));
[~,stop_idx]    = min(abs(TimeData-StopTime));

SparkVoltageData    = SparkVoltageData(start_idx:stop_idx);
SparkCurrentData    = SparkCurrentData(start_idx:stop_idx);
TimeData        	= TimeData(start_idx:stop_idx);

clear OscilloscopeData

% Load the input bias current offset data
if ~isempty(InputBiasCurrentVoltageOffsetFileName)
    
    InputBiasCurrentVoltageRefData	= importAgilentBin(InputBiasCurrentVoltageOffsetFileName,[1 2 3 4]);
    InputBiasCurrentVoltageOffset	= mean(InputBiasCurrentVoltageRefData(InputBiasCurrentRefChannel).dataVector);

    if InvertInputBiasCurrentVoltage
        InputBiasCurrentVoltageOffset = -1*InputBiasCurrentVoltageOffset;
    end
    
end

% Apply the input bias current offset
SparkVoltageData = SparkVoltageData-InputBiasCurrentVoltageOffset;

% If requested, filter the voltage data
if ~isempty(WindowLength)
    filter_vec          = 1/WindowLength*ones(WindowLength,1);
    SparkVoltageData    = filter(filter_vec,1,SparkVoltageData);
end

%% Process
% Calculate the instantaneous spark power
InstantaneousSparkPower = SparkVoltageData.*SparkCurrentData;
% InstantaneousSparkPower = abs(SparkVoltageData.*SparkCurrentData);

% Preallocate for speed
IncrementalSparkEnergy  = NaN(length(TimeData)-1,1);
CumulativeSparkEnergy   = NaN(length(TimeData)-1,1);

% Using the trapezoidal rule, integrate the power to calculate the
% total spark energy.
for loop = 1:length(TimeData)-1
    
    % Calculate the spark energy for this time step
    IncrementalSparkEnergy(loop) = (TimeData(loop+1)-TimeData(loop))*(InstantaneousSparkPower(loop+1)+InstantaneousSparkPower(loop))/2;
    
    % Calculate the total spark energy so far
    if loop==1
        CumulativeSparkEnergy(loop) = IncrementalSparkEnergy(loop);
    else
        CumulativeSparkEnergy(loop) = IncrementalSparkEnergy(loop)+CumulativeSparkEnergy(loop-1);
    end
    
end

% Calculate the current loss
CurrentLoss = (SparkCurrentData-InitialCurrent)/InitialCurrent;

% Prepend "zero" energy to the cumulative spark energy, which is correct,
% but also makes the arrays the correct length :)
CumulativeSparkEnergy = [0;CumulativeSparkEnergy];

%% Plot

FigHandle   = figure('Color',[1 1 1]);
AxesHandle  = gca;

plot(AxesHandle,TimeData*1e6,CumulativeSparkEnergy*1000,'LineWidth',2)
grid(AxesHandle,'on')
xlabel(AxesHandle,'Time (microseconds)','FontSize',14)
ylabel(AxesHandle,'Cumulative Spark Energy (mJ)','FontSize',14)

% plot(AxesHandle,CumulativeSparkEnergy*1000,abs(CurrentLoss)*100,'LineWidth',2)
% grid(AxesHandle,'on')
% xlabel(AxesHandle,'Spark Energy (mJ)','FontSize',14)
% ylabel(AxesHandle,'\midCurrent Loss (%)\mid','FontSize',14,'Interpreter','tex')
% set(AxesHandle,'XLim',[0 47])
% set(AxesHandle,'YLim',[-5 45])
