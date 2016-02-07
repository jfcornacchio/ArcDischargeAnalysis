function OscilloscopeDataProcessor(HomeFolder,BinaryFilePath,BinaryFileList,SparkGap,ElectrodeDiameter,ElectrodeMaterial,ClampedSparkVoltageChannel,InvertClampedSparkVoltage,FullSignalSparkVoltageChannel,InvertFullSignalSparkVoltage,SparkCurrentChannel,InvertSparkCurrent,StartSignalName,StopSignalName,SparkStartThreshold,SparkStopThreshold,DefaultStartTime,DefaultStartIndex,DefaultStopTime,DefaultStopIndex,InputBiasCurrentVoltageOffsetFileName,InputBiasCurrentRefChannel,InvertInputBiasCurrentVoltage)
    
    % Initialize waitbars
    multiWaitbar('CloseAll');
    multiWaitbar('Loading Summary Table',0,'Color',[0 0 1]);
    multiWaitbar('Loading Binary Files',0,'Color',[0 0 1]);
    multiWaitbar('Loading Setup Files',0,'Color',[0 0 1]);
    multiWaitbar('Writing Summary File',0,'Color',[0 0 1]);
    
    % Check to see if a spark summary file exists. If so, load it; if not,
    % we will create it.
    if exist(fullfile(HomeFolder,'SparkSummaryTable.xlsx'),'file')==2
        % The file exists already.
        [~,~,raw] = xlsread(fullfile(HomeFolder,'SparkSummaryTable.xlsx'));
        
        % Convert the cell array to a structure
        SparkDataStruct = cell2struct(raw(2:end,:), raw(1,:),2);
        
    else
        % The file does not exist.
        
        % Create a structure to hold all the outputs that will be written
        % into the Excel summary file.
        for loop = 1:length(BinaryFileList)
            SparkDataStruct(loop).FileName                                  = BinaryFileList{loop};
            SparkDataStruct(loop).InputBiasCurrentReferenceVoltageFileName  = InputBiasCurrentVoltageOffsetFileName;
            SparkDataStruct(loop).InputBiasCurrentReferenceVoltageChannel   = InputBiasCurrentRefChannel;
            SparkDataStruct(loop).InputBiasCurrentMeanReferenceVoltage    	= [];
            SparkDataStruct(loop).SparkEnergy                               = [];
            SparkDataStruct(loop).SparkStartTime                            = [];
            SparkDataStruct(loop).SparkStopTime                             = [];
            SparkDataStruct(loop).SparkDuration                             = [];
            SparkDataStruct(loop).MeanClampedSparkVoltage                   = [];
            SparkDataStruct(loop).ModeClampedSparkVoltage                   = [];
            SparkDataStruct(loop).MaxClampedSparkVoltage                    = [];
            SparkDataStruct(loop).MinClampedSparkVoltage                    = [];
            
            SparkDataStruct(loop).MaxFullSignalSparkVoltage               	= [];
            SparkDataStruct(loop).MinFullSignalSparkVoltage              	= [];
            
            SparkDataStruct(loop).MeanSparkCurrent                          = [];
            SparkDataStruct(loop).ModeSparkCurrent                          = [];
            SparkDataStruct(loop).MeanSparkPower                            = [];
            SparkDataStruct(loop).ModeSparkPower                            = [];
            SparkDataStruct(loop).ClampedSparkVoltage_25PercDuration        = [];
            SparkDataStruct(loop).ClampedSparkVoltage_50PercDuration        = [];
            SparkDataStruct(loop).ClampedSparkVoltage_75PercDuration        = [];
            SparkDataStruct(loop).SparkCurrent_25PercDuration               = [];
            SparkDataStruct(loop).SparkCurrent_50PercDuration               = [];
            SparkDataStruct(loop).SparkCurrent_75PercDuration               = [];
            SparkDataStruct(loop).SparkPower_25PercDuration                 = [];
            SparkDataStruct(loop).SparkPower_50PercDuration                 = [];
            SparkDataStruct(loop).SparkPower_75PercDuration                 = [];
            
            SparkDataStruct(loop).SparkGap                                  = SparkGap;
            SparkDataStruct(loop).ElectrodeDiameter                         = ElectrodeDiameter;
            SparkDataStruct(loop).ElectrodeMaterial                         = ElectrodeMaterial;
            SparkDataStruct(loop).ClampedSparkVoltageChannel                = ClampedSparkVoltageChannel;
            SparkDataStruct(loop).InvertClampedSparkVoltage                 = InvertClampedSparkVoltage;
            SparkDataStruct(loop).FullSignalSparkVoltageChannel             = FullSignalSparkVoltageChannel;
            SparkDataStruct(loop).InvertFullSignalSparkVoltage              = InvertFullSignalSparkVoltage;
            SparkDataStruct(loop).SparkCurrentChannel                       = SparkCurrentChannel;
            SparkDataStruct(loop).InvertSparkCurrent                        = InvertSparkCurrent;

            SparkDataStruct(loop).ClampedSparkVoltageChannelScale           = '';
            SparkDataStruct(loop).ClampedSparkVoltageResolution             = [];
            SparkDataStruct(loop).ClampedSparkVoltageChannelPosition        = '';
            SparkDataStruct(loop).ClampedSparkVoltageChannelCoupling        = '';
            SparkDataStruct(loop).ClampedSparkVoltageChannelBWLimit         = '';
            SparkDataStruct(loop).ClampedSparkVoltageChannelInvert          = '';
            SparkDataStruct(loop).ClampedSparkVoltageChannelImpedance       = '';
            SparkDataStruct(loop).ClampedSparkVoltageChannelProbeRatio      = '';
            SparkDataStruct(loop).ClampedSparkVoltageChannelSkew            = '';
            
            SparkDataStruct(loop).FullSignalSparkVoltageChannelScale    	= '';
            SparkDataStruct(loop).FullSignalSparkVoltageResolution          = [];
            SparkDataStruct(loop).FullSignalSparkVoltageChannelPosition 	= '';
            SparkDataStruct(loop).FullSignalSparkVoltageChannelCoupling  	= '';
            SparkDataStruct(loop).FullSignalSparkVoltageChannelBWLimit   	= '';
            SparkDataStruct(loop).FullSignalSparkVoltageChannelInvert    	= '';
            SparkDataStruct(loop).FullSignalSparkVoltageChannelImpedance 	= '';
            SparkDataStruct(loop).FullSignalSparkVoltageChannelProbeRatio	= '';
            SparkDataStruct(loop).FullSignalSparkVoltageChannelSkew     	= '';

            SparkDataStruct(loop).SparkCurrentChannelScale                  = '';
            SparkDataStruct(loop).SparkCurrentResolution                    = [];
            SparkDataStruct(loop).SparkCurrentChannelPosition               = '';
            SparkDataStruct(loop).SparkCurrentChannelCoupling               = '';
            SparkDataStruct(loop).SparkCurrentChannelBWLimit                = '';
            SparkDataStruct(loop).SparkCurrentChannelInvert                 = '';
            SparkDataStruct(loop).SparkCurrentChannelImpedance              = '';
            SparkDataStruct(loop).SparkCurrentChannelProbeRatio             = '';
            SparkDataStruct(loop).SparkCurrentChannelSkew                   = '';

            SparkDataStruct(loop).TriggerSweepMode                          = '';
            SparkDataStruct(loop).TriggerCoupling                           = '';
            SparkDataStruct(loop).TriggerNoiseRejection                     = '';
            SparkDataStruct(loop).TriggerHFRejection                        = '';
            SparkDataStruct(loop).TriggerHoldoff                            = '';
            SparkDataStruct(loop).TriggerMode                               = '';
            SparkDataStruct(loop).TriggerSource                             = '';
            SparkDataStruct(loop).TriggerSlope                              = '';
            SparkDataStruct(loop).TriggerLevel                              = '';

            SparkDataStruct(loop).HorizontalScale                           = '';
            SparkDataStruct(loop).HorizontalReference                       = '';
            SparkDataStruct(loop).HorizontalMainScale                       = '';
            SparkDataStruct(loop).HorizontalMainDelay                       = '';

            SparkDataStruct(loop).AcqusitionMode                            = '';
            SparkDataStruct(loop).AcqusitionRealtime                        = '';
            SparkDataStruct(loop).AcqusitionVectors                         = '';
            SparkDataStruct(loop).AcqusitionPersistence                     = '';
            
        end
        
    end
    
    % Update waitbar
    multiWaitbar('Loading Summary Table',1);
    
    % If requested, load the input bias current voltage reference file
    if ~isempty(InputBiasCurrentVoltageOffsetFileName)
        
        try
            InputBiasCurrentVoltageRefData = importAgilentBin(InputBiasCurrentVoltageOffsetFileName,[1 2 3 4]);
        catch
            error = errordlg(['The file ' fullfile(InputBiasCurrentVoltageOffsetFileName) ' could not be read for the input bias current voltage offset.'],'ERROR!');
            uiwait(error)
            return
        end
        
        % Calculate the input bias current voltage offset
        InputBiasCurrentMeanReferenceVoltage = mean(InputBiasCurrentVoltageRefData(InputBiasCurrentRefChannel).dataVector);
        
        % Check to see if the user wants to invert the input bias current
        % voltage offset
        switch InvertInputBiasCurrentVoltage
            case 'Yes'
                InputBiasCurrentMeanReferenceVoltage = -1*InputBiasCurrentMeanReferenceVoltage;
            otherwise
                
        end
                
        % Clear the input bias current voltage reference data
        clear InputBiasCurrentVoltageRefData
        
    else
        % We will not be applying a voltage offset
        InputBiasCurrentMeanReferenceVoltage = 0;
        
    end
    
    % Loop through all the oscilloscope files
    for loop = 1:length(BinaryFileList)
        
        % Check to see if this file has been processed before. If it has,
        % modify the existing entry. If not, add it to the end of the
        % structure.
        file_idx = strcmp(BinaryFileList{loop},{SparkDataStruct.FileName});
        
        if ~any(file_idx)
            file_idx = length({SparkDataStruct.FileName})+1;
        end
        
        SparkDataStruct(file_idx).FileName = BinaryFileList{loop};
        
%% Read the binary and setup files
        try
            OscilloscopeData = importAgilentBin(fullfile(BinaryFilePath,BinaryFileList{loop}),[1 2 3 4]);
        catch
            warn = warndlg(['The file ' fullfile(BinaryFilePath,BinaryFileList{loop}) ' could not be read.'],'Error Reading File!');
            continue
        end
        
        % Update waitbar
        multiWaitbar('Loading Binary Files',loop/length(BinaryFileList));
        
        % Create the file name for the setup file
        [~,file_name] = fileparts(fullfile(BinaryFilePath,BinaryFileList{loop}));
        
        SetupFileName = fullfile(HomeFolder,'Oscilloscope Setup Files',[file_name '.txt']);
        
        % Read the setup file, if it exists.
        if exist(SetupFileName,'file')==2
            % The setup file exists. Read the file.
            SetupFileOutput = ReadAgilentSetupFile(SetupFileName);
            
            % Place the details of the setup in the output data struct.
            SparkDataStruct(file_idx).ClampedSparkVoltageChannelScale     	= SetupFileOutput.AnalogConfiguration(ClampedSparkVoltageChannel).Scale;
            SparkDataStruct(file_idx).ClampedSparkVoltageChannelPosition  	= SetupFileOutput.AnalogConfiguration(ClampedSparkVoltageChannel).Position;
            SparkDataStruct(file_idx).ClampedSparkVoltageChannelCoupling  	= SetupFileOutput.AnalogConfiguration(ClampedSparkVoltageChannel).Coupling;
            SparkDataStruct(file_idx).ClampedSparkVoltageChannelBWLimit   	= SetupFileOutput.AnalogConfiguration(ClampedSparkVoltageChannel).BWLimit;
            SparkDataStruct(file_idx).ClampedSparkVoltageChannelInvert    	= SetupFileOutput.AnalogConfiguration(ClampedSparkVoltageChannel).Invert;
            SparkDataStruct(file_idx).ClampedSparkVoltageChannelImpedance	= SetupFileOutput.AnalogConfiguration(ClampedSparkVoltageChannel).Impedance;
            SparkDataStruct(file_idx).ClampedSparkVoltageChannelProbeRatio	= SetupFileOutput.AnalogConfiguration(ClampedSparkVoltageChannel).ProbeRatio;
            SparkDataStruct(file_idx).ClampedSparkVoltageChannelSkew     	= SetupFileOutput.AnalogConfiguration(ClampedSparkVoltageChannel).Skew;
            
            SparkDataStruct(file_idx).FullSignalSparkVoltageChannelScale    	= SetupFileOutput.AnalogConfiguration(FullSignalSparkVoltageChannel).Scale;
            SparkDataStruct(file_idx).FullSignalSparkVoltageChannelPosition 	= SetupFileOutput.AnalogConfiguration(FullSignalSparkVoltageChannel).Position;
            SparkDataStruct(file_idx).FullSignalSparkVoltageChannelCoupling  	= SetupFileOutput.AnalogConfiguration(FullSignalSparkVoltageChannel).Coupling;
            SparkDataStruct(file_idx).FullSignalSparkVoltageChannelBWLimit   	= SetupFileOutput.AnalogConfiguration(FullSignalSparkVoltageChannel).BWLimit;
            SparkDataStruct(file_idx).FullSignalSparkVoltageChannelInvert    	= SetupFileOutput.AnalogConfiguration(FullSignalSparkVoltageChannel).Invert;
            SparkDataStruct(file_idx).FullSignalSparkVoltageChannelImpedance 	= SetupFileOutput.AnalogConfiguration(FullSignalSparkVoltageChannel).Impedance;
            SparkDataStruct(file_idx).FullSignalSparkVoltageChannelProbeRatio	= SetupFileOutput.AnalogConfiguration(FullSignalSparkVoltageChannel).ProbeRatio;
            SparkDataStruct(file_idx).FullSignalSparkVoltageChannelSkew     	= SetupFileOutput.AnalogConfiguration(FullSignalSparkVoltageChannel).Skew;
            
            SparkDataStruct(file_idx).SparkCurrentChannelScale     	= SetupFileOutput.AnalogConfiguration(SparkCurrentChannel).Scale;
            SparkDataStruct(file_idx).SparkCurrentChannelPosition 	= SetupFileOutput.AnalogConfiguration(SparkCurrentChannel).Position;
            SparkDataStruct(file_idx).SparkCurrentChannelCoupling 	= SetupFileOutput.AnalogConfiguration(SparkCurrentChannel).Coupling;
            SparkDataStruct(file_idx).SparkCurrentChannelBWLimit   	= SetupFileOutput.AnalogConfiguration(SparkCurrentChannel).BWLimit;
            SparkDataStruct(file_idx).SparkCurrentChannelInvert    	= SetupFileOutput.AnalogConfiguration(SparkCurrentChannel).Invert;
            SparkDataStruct(file_idx).SparkCurrentChannelImpedance 	= SetupFileOutput.AnalogConfiguration(SparkCurrentChannel).Impedance;
            SparkDataStruct(file_idx).SparkCurrentChannelProbeRatio	= SetupFileOutput.AnalogConfiguration(SparkCurrentChannel).ProbeRatio;
            SparkDataStruct(file_idx).SparkCurrentChannelSkew     	= SetupFileOutput.AnalogConfiguration(SparkCurrentChannel).Skew;
            
            SparkDataStruct(file_idx).TriggerSweepMode      = SetupFileOutput.TriggerConfiguration.SweepMode;
            SparkDataStruct(file_idx).TriggerCoupling       = SetupFileOutput.TriggerConfiguration.Coupling;
            SparkDataStruct(file_idx).TriggerNoiseRejection	= SetupFileOutput.TriggerConfiguration.NoiseRejection;
            SparkDataStruct(file_idx).TriggerHFRejection	= SetupFileOutput.TriggerConfiguration.HFRejection;
            SparkDataStruct(file_idx).TriggerHoldoff        = SetupFileOutput.TriggerConfiguration.Holdoff;
            SparkDataStruct(file_idx).TriggerMode           = SetupFileOutput.TriggerConfiguration.Mode;
            SparkDataStruct(file_idx).TriggerSource         = SetupFileOutput.TriggerConfiguration.Source;
            SparkDataStruct(file_idx).TriggerSlope          = SetupFileOutput.TriggerConfiguration.Slope;
            SparkDataStruct(file_idx).TriggerLevel          = SetupFileOutput.TriggerConfiguration.Level;
            
            SparkDataStruct(file_idx).HorizontalScale       = SetupFileOutput.HorizontalConfiguration.Scale;
            SparkDataStruct(file_idx).HorizontalReference   = SetupFileOutput.HorizontalConfiguration.Reference;
            SparkDataStruct(file_idx).HorizontalMainScale   = SetupFileOutput.HorizontalConfiguration.MainScale;
            SparkDataStruct(file_idx).HorizontalMainDelay   = SetupFileOutput.HorizontalConfiguration.MainDelay;
            
            SparkDataStruct(file_idx).AcqusitionMode       	= SetupFileOutput.AcquisitionConfiguration.Mode;
            SparkDataStruct(file_idx).AcqusitionRealtime   	= SetupFileOutput.AcquisitionConfiguration.Realtime;
            SparkDataStruct(file_idx).AcqusitionVectors    	= SetupFileOutput.AcquisitionConfiguration.Vectors;
            SparkDataStruct(file_idx).AcqusitionPersistence	= SetupFileOutput.AcquisitionConfiguration.Persistence;
            
            % Calculate the resolution of the spark voltage, in volts, and
            % the resolution of the spark current, in amps. This
            % oscilloscope has 8-bit resolution, and a total of 8 vertical
            % divisions. 8-bits corresponds to 256 steps. However, in "high
            % resolution" mode, the resolution of the oscilloscope is
            % effectively increased - the amount increased depends on the
            % horizontal scale.
            switch SparkDataStruct(file_idx).AcqusitionMode
                
                case 'Normal'
                    VerticalBits = 8;
                    
                case 'HighRes'
                    % The horizontal scale must be calculated.
                    TimePerDiv  = regexp(SetupFileOutput.HorizontalConfiguration.MainScale,'[0-9\.]+','match');
                    TimePerDiv  = TimePerDiv{:};
                    TimeUnits   = SetupFileOutput.HorizontalConfiguration.MainScale(length(TimePerDiv)+1:end);
                    TimePerDiv  = str2double(TimePerDiv);
                    
                    % Calculate the magnitude of the time per div
                    switch TimeUnits
                        
                        case 's'
                            TimePerDiv = TimePerDiv;
                            
                        case 'ms'
                            TimePerDiv = TimePerDiv/1000;
                            
                        case 'us'
                            TimePerDiv = TimePerDiv/1000000;
                            
                        case 'ns'
                            TimePerDiv = TimePerDiv/1000000000;
                            
                        otherwise
                            % Unknown units!
                    end
                    
                    % Using the calculated horizontal scale, calculate the
                    % effective number of bits used in the vertical scale.
                    
                    if TimePerDiv<=1e-6
                        VerticalBits = 8;
                        
                    elseif TimePerDiv==2e-6
                        VerticalBits = 9;
                        
                    elseif TimePerDiv==5e-6
                        VerticalBits = 10;
                        
                    elseif TimePerDiv==10e-6
                        VerticalBits = 11;
                        
                    elseif TimePerDiv>=20e-6
                        VerticalBits = 12;
                    else
                       % Error!
                       
                    end
                    
                otherwise
                    
            end
            
            % First, get the clamped voltage scale
            ClampedVoltagePerDiv    = regexp(SparkDataStruct(file_idx).ClampedSparkVoltageChannelScale,'[0-9\.]+','match');
            ClampedVoltagePerDiv	= ClampedVoltagePerDiv{:};
            ClampedVoltageUnits 	= SparkDataStruct(file_idx).ClampedSparkVoltageChannelScale(length(ClampedVoltagePerDiv)+1:end);
            ClampedVoltagePerDiv    = str2double(ClampedVoltagePerDiv);
            
            % Next, get the full signal voltage scale
            FullSignalVoltagePerDiv	= regexp(SparkDataStruct(file_idx).FullSignalSparkVoltageChannelScale,'[0-9\.]+','match');
            FullSignalVoltagePerDiv	= FullSignalVoltagePerDiv{:};
            FullSignalVoltageUnits 	= SparkDataStruct(file_idx).FullSignalSparkVoltageChannelScale(length(FullSignalVoltagePerDiv)+1:end);
            FullSignalVoltagePerDiv	= str2double(FullSignalVoltagePerDiv);
            
            CurrentPerDiv   = regexp(SparkDataStruct(file_idx).SparkCurrentChannelScale,'[0-9\.]+','match');
            CurrentPerDiv   = CurrentPerDiv{:};
            CurrentUnits    = SparkDataStruct(file_idx).SparkCurrentChannelScale(length(CurrentPerDiv)+1:end);
            CurrentPerDiv   = str2double(CurrentPerDiv);
            
            % Determine the clamped spark voltage scale units
            switch ClampedVoltageUnits
                
                case 'kV'
                    SparkDataStruct(file_idx).ClampedSparkVoltageResolution = ClampedVoltagePerDiv*1000*10/2^VerticalBits;
                    
                case 'V'
                    SparkDataStruct(file_idx).ClampedSparkVoltageResolution = ClampedVoltagePerDiv*10/2^VerticalBits;
                    
                case 'mV'
                    SparkDataStruct(file_idx).ClampedSparkVoltageResolution = ClampedVoltagePerDiv/1000*10/2^VerticalBits;
                    
                otherwise
                    % Unknown units!
            end
            
            % Determine the full signal spark voltage scale units
            switch FullSignalVoltageUnits
                
                case 'kV'
                    SparkDataStruct(file_idx).FullSignalSparkVoltageResolution = FullSignalVoltagePerDiv*1000*10/2^VerticalBits;
                    
                case 'V'
                    SparkDataStruct(file_idx).FullSignalSparkVoltageResolution = FullSignalVoltagePerDiv*10/2^VerticalBits;
                    
                case 'mV'
                    SparkDataStruct(file_idx).FullSignalSparkVoltageResolution = FullSignalVoltagePerDiv/1000*10/2^VerticalBits;
                    
                otherwise
                    % Unknown units!
            end
            
            % Determine the spark current scale units
            switch CurrentUnits
                
                case 'kA'
                    SparkDataStruct(file_idx).SparkCurrentResolution = CurrentPerDiv*1000*10/2^VerticalBits;
                    
                case 'A'
                    SparkDataStruct(file_idx).SparkCurrentResolution = CurrentPerDiv*10/2^VerticalBits;
                    
                case 'mA'
                    SparkDataStruct(file_idx).SparkCurrentResolution = CurrentPerDiv/1000*10/2^VerticalBits;
                    
                otherwise
                    % Unknown units!
            end
            
        end
        
        % Update the waitbar
        multiWaitbar('Loading Setup Files',loop/length(BinaryFileList));
                
%% Process data
        
        % Check to see if the spark voltage needs to be inverted from what
        % is recorded in the binary file (although the original data may be
        % inverted).
        switch InvertClampedSparkVoltage
            case 'Yes'
                ClampedSparkVoltageData = -1*OscilloscopeData(ClampedSparkVoltageChannel).dataVector;
                
            otherwise
                ClampedSparkVoltageData = OscilloscopeData(ClampedSparkVoltageChannel).dataVector;
        end
        
        switch InvertFullSignalSparkVoltage
            case 'Yes'
                FullSignalSparkVoltageData = -1*OscilloscopeData(FullSignalSparkVoltageChannel).dataVector;
                
            otherwise
                FullSignalSparkVoltageData = OscilloscopeData(FullSignalSparkVoltageChannel).dataVector;
        end
        
        % Apply the input bias current voltage offset
        ClampedSparkVoltageData     = ClampedSparkVoltageData-InputBiasCurrentMeanReferenceVoltage;
        FullSignalSparkVoltageData  = FullSignalSparkVoltageData-InputBiasCurrentMeanReferenceVoltage;
        
        % Store the input bias current reference voltage file name and
        % channel in the struct
        SparkDataStruct(file_idx).InputBiasCurrentReferenceVoltageFileName  = InputBiasCurrentVoltageOffsetFileName;
        SparkDataStruct(file_idx).InputBiasCurrentReferenceVoltageChannel   = InputBiasCurrentRefChannel;
        SparkDataStruct(file_idx).InputBiasCurrentMeanReferenceVoltage      = InputBiasCurrentMeanReferenceVoltage;
        
        switch InvertSparkCurrent
            case 'Yes'
                SparkCurrentData = -1*OscilloscopeData(SparkCurrentChannel).dataVector;
                
            otherwise
                SparkCurrentData = OscilloscopeData(SparkCurrentChannel).dataVector;
        end
        
        % Get the time vector
        TimeData = OscilloscopeData(1).timeVector;
        
        % Clear the oscilloscope data file
        clear OscilloscopeData
        
        % Calculate the instantaneous spark power
        InstantaneousSparkPower = ClampedSparkVoltageData.*SparkCurrentData;
        
        % Calculate the instantaneous spark resistance
        InstantaneousSparkResistance = ClampedSparkVoltageData./SparkCurrentData;
        
        % Calculate the start and stop times for the spark discharge using
        % the method specified by the user.
        switch StartSignalName
            
            case 'Spark Voltage'
                StartTimeData = ClampedSparkVoltageData;
                
            case 'Spark Current'
                StartTimeData = SparkCurrentData;
                
            case 'Spark Power'
                StartTimeData = InstantaneousSparkPower;
                
            otherwise
                % Unknown option selected! Warn the user.
                
        end
        
        % Determine when the start time data was first above the threshold,
        % then work backwords in time to find the closest time to that time
        % where the current was zero.      
        threshold_idx 	= find(StartTimeData>SparkStartThreshold,1,'first');
        SparkStart_Idx	= find(StartTimeData(1:threshold_idx)<=0,1,'last');

        % Check to make sure that a start time was found.
        if isempty(SparkStart_Idx)
            % A start time was not found.
            if ~isempty(DefaultStartTime)
                % The user has provided a default start time to use in the
                % event that a start time could not be found.
                [~,SparkStart_Idx] = min(abs(TimeData-DefaultStartTime));
                
            elseif ~isempty(DefaultStartIndex)
                SparkStart_Idx = DefaultStartIndex;
                
            else
                % Ask the user to determine the start time manually.
                input.XData        	= TimeData;
                input.YData        	= StartTimeData;
                input.XLabel      	= 'Time (s)';
                input.YLabel       	= StartSignalName;
                input.Instructions	= 'Spark Start Time';
                input.FileName      = BinaryFileList{loop};
                Output           	= ManualTimeSelection_GUI(input);

                SparkStart_Idx = str2double(Output.Index);
                
                clear input
            end
            
        end
        
        % Assign the spark start time
        SparkDataStruct(file_idx).SparkStartTime = TimeData(SparkStart_Idx);
        
        clear StartTimeData
                        
        switch StopSignalName
            case 'Spark Voltage'
                StopTimeData = ClampedSparkVoltageData;
                
            case 'Spark Current'
                StopTimeData = SparkCurrentData;
                
            case 'Spark Power'
                StopTimeData = InstantaneousSparkPower;
                
            otherwise
                % Unknown option selected! Warn the user.
                
        end
        
        % Determine when the stop time data was first above the threshold,
        % then work backwords in time to find the closest time to that time
        % where the current was zero.
        threshold_idx  	= find(StopTimeData>SparkStopThreshold,1,'last');
        stop_idx_temp  	= find(StopTimeData(threshold_idx:end)<=0,1,'first');
        SparkStop_Idx	= threshold_idx+stop_idx_temp-1;
        
        % Check to make sure that a start time was found.
        if isempty(SparkStop_Idx)
            % A stop time was not found.
            
            if ~isempty(DefaultStopTime)
                % The user has provided a default start time to use in the
                % event that a start time could not be found.
                [~,SparkStop_Idx] = min(abs(TimeData-DefaultStopTime));
                
            elseif ~isempty(DefaultStopIndex)
                SparkStop_Idx = DefaultStopIndex;
                
            else
                            
                % Ask the user to determine the stop time manually.
                input.XData       	= TimeData;
                input.YData       	= StopTimeData;
                input.XLabel      	= 'Time (s)';
                input.YLabel     	= StopSignalName;
                input.Instructions 	= 'Spark Stop Time';
                input.FileName      = BinaryFileList{loop};
                Output            	= ManualTimeSelection_GUI(input);
                
                SparkStop_Idx = str2double(Output.Index);
                
                clear input
            end
            
        end
        
        clear StopTimeData
        
        SparkDataStruct(file_idx).SparkStopTime	= TimeData(SparkStop_Idx);
        
        % Determine the duration of the spark
        SparkDataStruct(file_idx).SparkDuration = SparkDataStruct(file_idx).SparkStopTime-SparkDataStruct(file_idx).SparkStartTime;
        
        % Calculate the instantaneous spark power
        InstantaneousSparkPower = InstantaneousSparkPower(SparkStart_Idx:SparkStop_Idx);
        
        % Using the trapezoidal rule, integrate the power to calculate the
        % total spark energy.
        SparkDataStruct(file_idx).SparkEnergy = trapz(TimeData(SparkStart_Idx:SparkStop_Idx),InstantaneousSparkPower);
        
        % Calculate the indices corresponding to 25%, 50% and 75% of the
        % spark duration.
        TotalIndices 	= length(InstantaneousSparkPower);
        Idx_25Percent   = round((TotalIndices+SparkStart_Idx-1)*0.25);
        Idx_50Percent   = round((TotalIndices+SparkStart_Idx-1)*0.50);
        Idx_75Percent   = round((TotalIndices+SparkStart_Idx-1)*0.75);
        
        % Calculate some basic statistics for the spark voltage, current
        % and power.
        SparkDataStruct(file_idx).MeanClampedSparkVoltage               = mean(ClampedSparkVoltageData(SparkStart_Idx:SparkStop_Idx));
        SparkDataStruct(file_idx).ModeClampedSparkVoltage               = mode(ClampedSparkVoltageData(SparkStart_Idx:SparkStop_Idx));
        SparkDataStruct(file_idx).MaxClampedSparkVoltage                = max(ClampedSparkVoltageData(SparkStart_Idx:SparkStop_Idx));
        SparkDataStruct(file_idx).MinClampedSparkVoltage                = min(ClampedSparkVoltageData(SparkStart_Idx:SparkStop_Idx));
        SparkDataStruct(file_idx).MaxFullSignalSparkVoltage             = max(FullSignalSparkVoltageData(SparkStart_Idx:SparkStop_Idx));
        SparkDataStruct(file_idx).MinFullSignalSparkVoltage             = min(FullSignalSparkVoltageData(SparkStart_Idx:SparkStop_Idx));
        SparkDataStruct(file_idx).MeanSparkCurrent                      = mean(SparkCurrentData(SparkStart_Idx:SparkStop_Idx));
        SparkDataStruct(file_idx).ModeSparkCurrent                      = mode(SparkCurrentData(SparkStart_Idx:SparkStop_Idx));
        SparkDataStruct(file_idx).MeanSparkPower                        = mean(InstantaneousSparkPower);
        SparkDataStruct(file_idx).ModeSparkPower                        = mode(InstantaneousSparkPower);
        SparkDataStruct(file_idx).ClampedSparkVoltage_25PercDuration 	= ClampedSparkVoltageData(Idx_25Percent);
        SparkDataStruct(file_idx).ClampedSparkVoltage_50PercDuration  	= ClampedSparkVoltageData(Idx_50Percent);
        SparkDataStruct(file_idx).ClampedSparkVoltage_75PercDuration  	= ClampedSparkVoltageData(Idx_75Percent);
        SparkDataStruct(file_idx).SparkCurrent_25PercDuration           = SparkCurrentData(Idx_25Percent);
        SparkDataStruct(file_idx).SparkCurrent_50PercDuration           = SparkCurrentData(Idx_50Percent);
        SparkDataStruct(file_idx).SparkCurrent_75PercDuration           = SparkCurrentData(Idx_75Percent);
        SparkDataStruct(file_idx).SparkPower_25PercDuration             = InstantaneousSparkPower(Idx_25Percent);
        SparkDataStruct(file_idx).SparkPower_50PercDuration             = InstantaneousSparkPower(Idx_50Percent);
        SparkDataStruct(file_idx).SparkPower_75PercDuration             = InstantaneousSparkPower(Idx_75Percent);
        
    end

%% Convert the structure to a cell and write the Excel file
    
    % Ensure that SparkDataStruct is an NX1 struct array so that the
    % struct2cell function behaves predictably.
    if size(SparkDataStruct,2)>1
        SparkDataStruct = SparkDataStruct';
    end

    % Convert the structure to a cell array
    output_cell         = struct2cell(SparkDataStruct);
    output_cell_headers = fieldnames(SparkDataStruct);
    
    % Ensure that output_cell is arranged such that there is a row for
    % every file.
    if size(output_cell,1)==length(output_cell_headers)
        output_cell = output_cell';
    end
    
    % Ensure that the headers cell array is a row
    if ~isrow(output_cell_headers)
        output_cell_headers = output_cell_headers';
    end
    
    % Add the header row
    output_cell = [output_cell_headers;output_cell];
    
    % Write the Excel file
    try
        xlswrite(fullfile(HomeFolder,'SparkSummaryTable.xlsx'),output_cell,'Sheet1','A1')
        
    catch
        % There was an issue writing the Excel file. Warn the user and
        % allow them to try again.
        error = errordlg('There was an error writing the Spark Summary Table. Please check that the file is not open and try again.','ERROR!');
        uiwait(error)
        
        % Try again
        xlswrite(fullfile(HomeFolder,'SparkSummaryTable.xlsx'),output_cell,'Sheet1','A1')
        
    end
    
    % Update waitbar
    multiWaitbar('Writing Summary File',1);
    pause(0.5)

%% Clean-up
    % Close all waitbars
    multiWaitbar('CloseAll');

end

