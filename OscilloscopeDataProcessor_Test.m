%% Initialize
clearvars
close all
clc

%% Inputs

% Filename
BinaryFileName = 'C:\Users\Jim Cornacchio\Documents\Dissertation\Spark Generator Design\Double HV Switch Board Tests\1_31_2015\Raw Oscilloscope Data\tp_302.bin';

% Current reading channel
CurrentChannel = 3;

% Voltage reading channel
VoltageChannel = 2;

% % Spark start and stop time
% SparkStartTime  = 2.4e-8;
% SparkStopTime   = 1.076e-5;

%% Load the data from the file
OscilloscopeData = importAgilentBin(BinaryFileName,[1 2 3]);

%% Process data

% Calculate the instantaneous spark power
InstantaneousSparkPower = OscilloscopeData(VoltageChannel).dataVector.*OscilloscopeData(CurrentChannel).dataVector;

% Integrate the instantaneous spark power to get the total spark energy.
% First, create an array that is the absolute value of the spark power.
InstantaneousSparkPower_Positive = abs(InstantaneousSparkPower);

% Get the indices of the waveform that correspond to the spark start and
% stop times.
% [~,spark_start_idx] = min(abs(SparkStartTime-OscilloscopeData(1).timeVector));
% [~,spark_stop_idx]  = min(abs(SparkStopTime-OscilloscopeData(1).timeVector));

% Using the trapezoidal rule, integrate the power.
SparkEnergy = trapz(OscilloscopeData(1).timeVector,InstantaneousSparkPower_Positive);

% SparkEnergyTest = trapz(OscilloscopeData(1).timeVector(spark_start_idx:spark_stop_idx),InstantaneousSparkPower_Positive(spark_start_idx:spark_stop_idx));

%% Plot data

% Plot the spark voltage
fig_handle = figure;
set(fig_handle,'Color',[1 1 1],'units','inches','Position',[0 0 9 3]);
axeshandle = gca;
plot(axeshandle,OscilloscopeData(1).timeVector,OscilloscopeData(VoltageChannel).dataVector)

xlabel('Time (s)','FontSize',14)
ylabel('Spark Voltage (V)','FontSize',14)

set(axeshandle,'FontSize',16)
grid on

% Plot the spark current
fig_handle = figure;
set(fig_handle,'Color',[1 1 1],'units','inches','Position',[0 0 9 3]);
axeshandle = gca;
plot(axeshandle,OscilloscopeData(1).timeVector,OscilloscopeData(CurrentChannel).dataVector)

xlabel('Time (s)','FontSize',14)
ylabel('Spark Current (amps)','FontSize',14)

set(axeshandle,'FontSize',16)
grid on

% Plot the spark power
fig_handle = figure;
set(fig_handle,'Color',[1 1 1],'units','inches','Position',[0 0 9 3]);
axeshandle = gca;
plot(axeshandle,OscilloscopeData(1).timeVector,InstantaneousSparkPower)

xlabel('Time (s)','FontSize',14)
ylabel('Spark Power (W)','FontSize',14)

set(axeshandle,'FontSize',16)
grid on