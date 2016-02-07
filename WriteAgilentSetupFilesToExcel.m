


% The setup file exists. Read the file.
SetupFileOutput = ReadAgilentSetupFile(SetupFileName);

% Place the details of the setup in the output data struct.
SparkDataStruct(file_idx).SparkVoltageChannelScale     	= SetupFileOutput.AnalogConfiguration(SparkVoltageChannel).Scale;
SparkDataStruct(file_idx).SparkVoltageChannelPosition  	= SetupFileOutput.AnalogConfiguration(SparkVoltageChannel).Position;
SparkDataStruct(file_idx).SparkVoltageChannelCoupling  	= SetupFileOutput.AnalogConfiguration(SparkVoltageChannel).Coupling;
SparkDataStruct(file_idx).SparkVoltageChannelBWLimit   	= SetupFileOutput.AnalogConfiguration(SparkVoltageChannel).BWLimit;
SparkDataStruct(file_idx).SparkVoltageChannelInvert    	= SetupFileOutput.AnalogConfiguration(SparkVoltageChannel).Invert;
SparkDataStruct(file_idx).SparkVoltageChannelImpedance	= SetupFileOutput.AnalogConfiguration(SparkVoltageChannel).Impedance;
SparkDataStruct(file_idx).SparkVoltageChannelProbeRatio	= SetupFileOutput.AnalogConfiguration(SparkVoltageChannel).ProbeRatio;
SparkDataStruct(file_idx).SparkVoltageChannelSkew     	= SetupFileOutput.AnalogConfiguration(SparkVoltageChannel).Skew;

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
        TimePerDiv = regexp(SetupFileOutput.HorizontalConfiguration.MainScale,'[0-9\.]+','match');
        TimePerDiv = TimePerDiv{:};
        TimeUnits = SetupFileOutput.HorizontalConfiguration.MainScale(length(TimePerDiv)+1:end);
        TimePerDiv = str2double(TimePerDiv);

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

% First, get the voltage scale
VoltagePerDiv   = regexp(SparkDataStruct(file_idx).SparkVoltageChannelScale,'[0-9\.]+','match');
VoltagePerDiv   = VoltagePerDiv{:};
VoltageUnits 	= SparkDataStruct(file_idx).SparkVoltageChannelScale(length(VoltagePerDiv)+1:end);
VoltagePerDiv   = str2double(VoltagePerDiv);

CurrentPerDiv   = regexp(SparkDataStruct(file_idx).SparkCurrentChannelScale,'[0-9\.]+','match');
CurrentPerDiv   = CurrentPerDiv{:};
CurrentUnits    = SparkDataStruct(file_idx).SparkCurrentChannelScale(length(CurrentPerDiv)+1:end);
CurrentPerDiv   = str2double(CurrentPerDiv);

% Determine the spark voltage scale units
switch VoltageUnits

    case 'kV'
        SparkDataStruct(file_idx).SparkVoltageResolution = VoltagePerDiv*1000*10/2^VerticalBits;

    case 'V'
        SparkDataStruct(file_idx).SparkVoltageResolution = VoltagePerDiv*10/2^VerticalBits;

    case 'mV'
        SparkDataStruct(file_idx).SparkVoltageResolution = VoltagePerDiv/1000*10/2^VerticalBits;

    otherwise
        % Unknown units!
end

% Determine the spark current scale units
switch CurrentUnits

    case 'kA'
        SparkDataStruct(file_idx).SparkCurrentResolution = CurrentPerDiv*1000*10/2^VerticalBits;

    case 'A'
        SparkDataStruct(file_idx).SparkCurrentResolution = CurrentPerDiv*10/2^VerticalBits;

    case 'mV'
        SparkDataStruct(file_idx).SparkCurrentResolution = CurrentPerDiv/1000*10/2^VerticalBits;

    otherwise
        % Unknown units!
end
            