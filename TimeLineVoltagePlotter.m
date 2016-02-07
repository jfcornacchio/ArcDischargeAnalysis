%% Initialize
clc
clearvars

%% Hard-Coded Inputs

HomeFolder  = 'C:\Users\jfc03001\Documents\Data_Cornacchio\9_13_2015';
FileNumbers = 2:141;

% Choose the channels to read on the oscilloscope
OscilloscopeChannels    = [1 2 3 4];
VoltageChannel          = 2;
TimeStepToReadVoltage   = 5e-6;

% Input Bias Current Voltage Offset
InputBiasCurrentVoltageOffsetFileName  	= 'C:\Users\jfc03001\Documents\Data_Cornacchio\9_13_2015\Raw Oscilloscope Data\tp_1.bin';
InputBiasCurrentRefChannel              = 2;
InvertInputBiasCurrentVoltage           = false;

YLimits = [0 800];

% Initialize waitbars
multiWaitbar('Overall Progress',0,'Color',[0 0 1]);

%% If requested, load the input bias current offset voltage file

if ~isempty(InputBiasCurrentVoltageOffsetFileName)
   % Load the input bias current offset data
    InputBiasCurrentVoltageRefData	= importAgilentBin(InputBiasCurrentVoltageOffsetFileName,[1 2 3 4]);
    InputBiasCurrentVoltageOffset	= mean(InputBiasCurrentVoltageRefData(InputBiasCurrentRefChannel).dataVector);

    if InvertInputBiasCurrentVoltage
        InputBiasCurrentVoltageOffset = -1*InputBiasCurrentVoltageOffset;
    end
    
end

%% Process Data

NumberOfFiles       = length(FileNumbers);
VoltageArray        = NaN(NumberOfFiles,1);
NumberOfChannels    = length(OscilloscopeChannels);
limitsExceeded      = false(NumberOfFiles,1);

for loop = 1:NumberOfFiles
        
    % Load the data from the file
    try
        OscilloscopeData = importAgilentBin(fullfile(HomeFolder,'Raw Oscilloscope Data',['tp_' int2str(loop) '.bin']),OscilloscopeChannels);
    catch
        % Warn the user that an error was encountered!
        warn = warndlg(['File ' fullfile(HomeFolder,'Raw Oscilloscope Data',['tp_' int2str(loop) '.bin']) 'could not be read. There may have been an error writing data from the oscilloscope.'],'WARNING!');
        return
    end
    
    % Load the corresponding setup file
    try
        SetupFileOutput = ReadAgilentSetupFile(fullfile(HomeFolder,'Oscilloscope Setup Files',['tp_' int2str(loop) '.txt']));
    catch
        % Warn the user that an error was encountered!
        warn = warndlg(['File ' fullfile(HomeFolder,'Oscilloscope Setup Files',['tp_' int2str(loop) '.txt']) 'could not be read. There may have been an error writing data from the oscilloscope.'],'WARNING!');
        return
    end
        
    % Check to see if any channels exceeded +/-4 divisions on the
    % oscilloscope screen
	
    % Initialize a channel counter to account for channels that are not
    % recording.
    channelCount = 1;
    
    for loop2 = 1:NumberOfChannels
        
        if isnan(SetupFileOutput.AnalogConfiguration(OscilloscopeChannels(loop2)).ChannelNumber)
            % This channel was not turned on
            continue            
        end
        
        % Only check if we haven't already exceeded a limit.
        if limitsExceeded(loop)
           continue 
        end
        
        % Using the channel scale, determine the number of units per
        % division and the unit labels.
        SignalPerDiv    = regexp(SetupFileOutput.AnalogConfiguration(OscilloscopeChannels(loop2)).Scale,'[0-9\.]+','match');
        SignalPerDiv	= SignalPerDiv{:};
        SignalUnits 	= SetupFileOutput.AnalogConfiguration(OscilloscopeChannels(loop2)).Scale(length(SignalPerDiv)+1:end);
        SignalPerDiv    = str2double(SignalPerDiv);
        
        % Get the position
        positionValue = regexp(SetupFileOutput.AnalogConfiguration(OscilloscopeChannels(loop2)).Position,'[\-0-9\.]+','match');
        positionValue = positionValue{:};
        positionUnits = SetupFileOutput.AnalogConfiguration(OscilloscopeChannels(loop2)).Position(length(positionValue)+1:end);
        positionValue = str2double(positionValue);
        
        % Determine the signal and position multipliers
        switch SignalUnits

            case 'kV'
                signalMultiplier = 1000;
                
            case 'V'
                signalMultiplier = 1;
                
            case 'mV'
                signalMultiplier = 0.001;

            case 'kA'
                signalMultiplier = 1000;

            case 'A'
                signalMultiplier = 1;

            case 'mA'
                signalMultiplier = 0.001;

            otherwise
                % Unknown units!
                error = errordlg('Unknown units!','ERROR!');
                uiwait(error)
                return
        end
        
        switch positionUnits

            case 'kV'
                positionMultiplier = 1000;
                
            case 'V'
                positionMultiplier = 1;
                
            case 'mV'
                positionMultiplier = 0.001;
                
            case 'kA'
                positionMultiplier = 1000;
                
            case 'A'
                positionMultiplier = 1;
                
            case 'mA'
                positionMultiplier = 0.001;
                
            otherwise
                % Unknown units!
                error = errordlg('Unknown units!','ERROR!');
                uiwait(error)
                return
        end
        
        % Calculate the min and max allowable reading
        maxReading = 4*SignalPerDiv*signalMultiplier-positionValue*positionMultiplier;
        minReading = -1*4*SignalPerDiv*signalMultiplier-positionValue*positionMultiplier;
        
        % Check to see if the either the minimum or the maximum values were
        % exceeded
        if any(OscilloscopeData(channelCount).dataVector>maxReading) || any(OscilloscopeData(channelCount).dataVector<minReading)
            % Either the minimum or maximum reading was surpassed.
            limitsExceeded(loop) = true;
            
        end
        
        % Increment the channel counter
        channelCount = channelCount+1;
        
    end
    
    % Find the time index closest to the requested time and the
    % corresponding voltage value
    [~,time_idx]       	= min(abs(TimeStepToReadVoltage-OscilloscopeData(1).timeVector));
    VoltageMatrix(loop)	= OscilloscopeData(VoltageChannel).dataVector(time_idx);
    
    % Apply the input bias current voltage offset, if requested.
    if ~isempty(InputBiasCurrentVoltageOffsetFileName)
        VoltageMatrix(loop) = VoltageMatrix(loop)-InputBiasCurrentVoltageOffset;
    end
    
    % Update the waitbar
    multiWaitbar('Overall Progress',loop/NumberOfFiles);
    
end

%% Create the plot

FigHandle   = figure('Color',[1 1 1]);
AxesHandle  = gca;

% Create the x-values
XValues = 1:NumberOfFiles;

% plot(AxesHandle,XValues(~limitsExceeded),VoltageMatrix(~limitsExceeded),'o')
plot(AxesHandle,XValues,VoltageMatrix,'o')
hold(AxesHandle,'on')

% plot(AxesHandle,XValues(limitsExceeded),VoltageMatrix(limitsExceeded),'o','MarkerEdgeColor','k','MarkerFaceColor','r')

set(AxesHandle,'FontSize',14)
xlabel(AxesHandle,'Spark Number','FontSize',16)
ylabel(AxesHandle,['Spark Voltage at ' num2str(TimeStepToReadVoltage) 's'],'FontSize',16)

if ~isempty(YLimits)
    set(AxesHandle,'YLim',YLimits)
    
end

%% Clean-up

% Close waitbars
multiWaitbar('CloseAll');

