%% Initialize
clc
clearvars
close('all')

%% Inputs
% SparkFileName       = 'C:\Users\Jim Cornacchio\Documents\Dissertation\Spark Generator Design\Triple HV Switch Board Tests\8_22_2015\Raw Oscilloscope Data\tp_81.bin';
SparkFileName       = 'N:\tp_1.bin';
SparkChannel        = 1;
% StartTime           = -0.000000176;
% StopTime            = 0.000011872;
StartTime           = 0;
StopTime            = 1;
YAxisTitle          = 'Input Bias Current Voltage';

%% Load the data
OscilloscopeData    = importAgilentBin(SparkFileName,[1 2 3 4]);
SparkData           = OscilloscopeData(SparkChannel).dataVector;
TimeData        	= OscilloscopeData(1).timeVector;

% Find the indices most close to the start and stop time
[~,start_idx]   = min(abs(TimeData-StartTime));
[~,stop_idx]    = min(abs(TimeData-StopTime));

% Clip the data
SparkData  	= SparkData(start_idx:stop_idx);
TimeData 	= TimeData(start_idx:stop_idx);

% Calculate the sampling frequency
samplingFrequency = 1/(TimeData(2)-TimeData(1));

clear OscilloscopeData

%% Calculate the FFT of the Data

% Determine the length of the data
dataLength = length(SparkData);

NFFT        = 2^nextpow2(dataLength);
FFTSignal   = fft(SparkData,NFFT)/dataLength;
freq        = samplingFrequency/2*linspace(0,1,NFFT/2+1);

%% Plot single-sided amplitude spectrum.
FFTFigHandle    = figure('Color',[1 1 1]);
FFTAxesHandle   = gca;

plot(FFTAxesHandle,freq(2:end),2*abs(FFTSignal(2:NFFT/2+1))) 
title(['Single-Sided Amplitude Spectrum of ' YAxisTitle])
xlabel('Frequency (Hz)')
ylabel(['|' YAxisTitle '|'])

%% Plot the original signal
OrigSignalFigHandle    = figure('Color',[1 1 1]);
OrigSignalAxesHandle   = gca;

plot(OrigSignalAxesHandle,TimeData,SparkData) 
xlabel('Time (s)')
ylabel(YAxisTitle)

