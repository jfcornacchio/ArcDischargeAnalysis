function Output = ReadAgilentSetupFile(OscilloscopeSetupFileName)
%ReadAgilentSetupFile reads the Agilent DSOX2024 oscilloscope setup files
% and puts the various configuration properties into structures.
% This code assumes that the setup file has sections in the following
% order:
% 1) ANALOG
% 2) TRIGGER
% 3) HORIZONTAL
% 4) ACQUISITION
%
% It doesn't if other sections are present as long as the above order is
% present.

%% Set properties to pull from the setup file
    
    % Analog configuration properties we want to retrieve
    AnalogConfigurationProperties = {'Scale','Pos','Coup','BWLimit','Inv','Imp','Probe','Skew'};

    % Trigger configuration properties we want to retrieve
    TriggerConfigurationProperties = {'SweepMode','Coup','NoiseRej','HFRej','Holdoff','Mode','Source','Slope','Level'};

    % Horizontal configuration properties we want to retrieve
    HorizontalConfigurationProperties = {'Mode','Ref','MainScale','MainDelay'};

    % Acquisition configuration properties we want to retrieve
    AcquisitionConfigurationProperties = {'Mode','Realtime','Vectors','Persistence'};

%% Open the file and read the analog channel configurations

    % Open the file
    FileID = fopen(OscilloscopeSetupFileName);

    % Read the lines in the  text file until we reach the analog channel
    % section.
    SectionTitle = '';

    while ~strcmpi(SectionTitle,'ANALOG')

        SectionTitle = fgetl(FileID);

    end

    % Initialize a cell array to hold the analog channel configuration
    temp_cell = cell(2,1);

    temp_cell(1) = {fgetl(FileID)};
    temp_cell(2) = {fgetl(FileID)};
    
    % Initialize (at least, partially) the analog configuration struct.
    AnalogConfiguration(1).ChannelNumber = NaN;
    AnalogConfiguration(2).ChannelNumber = NaN;
    AnalogConfiguration(3).ChannelNumber = NaN;
    AnalogConfiguration(4).ChannelNumber = NaN;
    
    % Read the analog channel configurations until the first line is blank,
    % which means that we've reached the end of the analog channel 
    % configuration section.
    while ~isempty(temp_cell{1})
        % We haven't reached the end of the analog configuration section.

        % Assume that the first part of the line is the channel number and that
        % the channel number is a single digit. Then, assign that number to the
        % correct level in the analog configuration struct.
        ChannelNumber                                       = str2double(temp_cell{1}(4));
        AnalogConfiguration(ChannelNumber).ChannelNumber    = ChannelNumber;

        % Concatenate the lines into a single string
        single_string = [temp_cell{1} ',' temp_cell{2}];

        % Remove all spaces
        single_string(single_string==' ') = [];

        for loop = 1:length(AnalogConfigurationProperties)
            % Determine the starting index for this property in the string,
            % then determine the location of the collowing comma, which is
            % where this configuration string ends.
            config_str_start	= strfind(single_string,AnalogConfigurationProperties{loop});
            next_comma          = find(single_string(config_str_start:end)==',',1,'first');

            % Check to see if this is the last property on the line
            if ~isempty(next_comma)
                % This is not the last property
                config_string = single_string(config_str_start:config_str_start-1+next_comma-1);
            else
                % This is the last property
                config_string = single_string(config_str_start:end);
            end

            % Assign the channel property to the correct field name in the
            % analog configuration struct.
            switch AnalogConfigurationProperties{loop}

                case 'Scale'
                    AnalogConfiguration(ChannelNumber).Scale = config_string(6:end-1);

                case 'Pos'
                    AnalogConfiguration(ChannelNumber).Position = config_string(4:end);

                case 'Coup'
                    AnalogConfiguration(ChannelNumber).Coupling = config_string(5:end);

                case 'BWLimit'
                    AnalogConfiguration(ChannelNumber).BWLimit = config_string(8:end);

                case 'Inv'
                    AnalogConfiguration(ChannelNumber).Invert = config_string(4:end);

                case 'Imp'
                    AnalogConfiguration(ChannelNumber).Impedance = config_string(4:end);

                case 'Probe'
                    AnalogConfiguration(ChannelNumber).ProbeRatio = config_string(6:end);

                case 'Skew'
                    AnalogConfiguration(ChannelNumber).Skew = config_string(5:end-1);

                otherwise

            end
        end

        % Read the next two lines, which contain an analog channel
        % configuration.
        temp_cell(1) = {fgetl(FileID)};
        temp_cell(2) = {fgetl(FileID)};

    end
        
%% Read the trigger configuration

    % Read the lines in the  text file until we reach the trigger section.
    SectionTitle = temp_cell{2};

    while ~strcmpi(SectionTitle,'TRIGGER')

        SectionTitle = fgetl(FileID);

    end

    % Read the two lines of text that contain the trigger configuration
    temp_cell(1) = {fgetl(FileID)};
    temp_cell(2) = {fgetl(FileID)};

    % Concatenate the lines into a single string
    single_string = [temp_cell{1} ',' temp_cell{2}];

    % Remove all spaces
    single_string(single_string==' ') = [];

    for loop = 1:length(TriggerConfigurationProperties)

        % Determine the starting index for this property in the string,
        % then determine the location of the collowing comma, which is
        % where this configuration string ends.
        config_str_start	= strfind(single_string,TriggerConfigurationProperties{loop});
        next_comma          = find(single_string(config_str_start:end)==',',1,'first');

        % Check to see if this is the last property on the line
        if ~isempty(next_comma)
            % This is not the last property
            config_string = single_string(config_str_start:config_str_start-1+next_comma-1);
        else
            % This is the last property
            config_string = single_string(config_str_start:end);
        end

        % Assign the trigger property to the correct field name in the trigger
        % configuration struct.
        switch TriggerConfigurationProperties{loop}

            case 'SweepMode'
                TriggerConfiguration.SweepMode = config_string(10:end);

            case 'Coup'
                TriggerConfiguration.Coupling = config_string(5:end);

            case 'NoiseRej'
                TriggerConfiguration.NoiseRejection = config_string(9:end);

            case 'HFRej'
                TriggerConfiguration.HFRejection = config_string(6:end);

            case 'Holdoff'
                TriggerConfiguration.Holdoff = config_string(8:end);

            case 'Mode'
                TriggerConfiguration.Mode = config_string(5:end);

            case 'Source'
                TriggerConfiguration.Source = config_string(7:end);

            case 'Slope'
                TriggerConfiguration.Slope = config_string(6:end);

            case 'Level'
                TriggerConfiguration.Level = config_string(6:end);

            otherwise

        end

    end

%% Read the horizontal channel configuration

    % Read the lines in the  text file until we reach the horizontal section.
    SectionTitle = '';

    while ~strcmpi(SectionTitle,'HORIZONTAL')

        SectionTitle = fgetl(FileID);

    end

    % Read the horizontal configuration string
    single_string = fgetl(FileID);

    % Remove all spaces
    single_string(single_string==' ') = [];

    for loop = 1:length(HorizontalConfigurationProperties)

        % Determine the starting index for this property in the string, then
        % determine the location of the collowing comma, which is where this
        % configuration string ends.
        config_str_start	= strfind(single_string,HorizontalConfigurationProperties{loop});
        next_comma          = find(single_string(config_str_start:end)==',',1,'first');

        % Check to see if this is the last property on the line
        if ~isempty(next_comma)
            % This is not the last property
            config_string = single_string(config_str_start:config_str_start-1+next_comma-1);
        else
            % This is the last property
            config_string = single_string(config_str_start:end);
        end

        % Assign the channel property to the correct field name in the
        % horizontal configuration struct.
        switch HorizontalConfigurationProperties{loop}

            case 'Mode'
                HorizontalConfiguration.Scale = config_string(5:end);

            case 'Ref'
                HorizontalConfiguration.Reference = config_string(4:end);

            case 'MainScale'
                HorizontalConfiguration.MainScale = config_string(10:end-1);

            case 'MainDelay'
                HorizontalConfiguration.MainDelay = config_string(10:end);

            otherwise

        end

    end

%% Read the acquisition mode configuration

    % Read the lines in the  text file until we reach the acquisition section.
    SectionTitle = '';

    while ~strcmpi(SectionTitle,'ACQUISITION')

        SectionTitle = fgetl(FileID);

    end

    % {'Mode','Realtime','Vectors','Persistence'};

    % Read the horizontal configuration string
    single_string = fgetl(FileID);

    % Remove all spaces
    single_string(single_string==' ') = [];

    for loop = 1:length(AcquisitionConfigurationProperties)

        % Determine the starting index for this property in the string, then 
        % determine the location of the collowing comma, which is where this
        % configuration string ends.
        config_str_start	= strfind(single_string,AcquisitionConfigurationProperties{loop});
        next_comma          = find(single_string(config_str_start:end)==',',1,'first');

        % Check to see if this is the last property on the line
        if ~isempty(next_comma)
            % This is not the last property
            config_string = single_string(config_str_start:config_str_start-1+next_comma-1);
        else
            % This is the last property
            config_string = single_string(config_str_start:end);
        end

        % Assign the channel property to the correct field name in the
        % horizontal configuration struct.
        switch AcquisitionConfigurationProperties{loop}

            case 'Mode'
                AcquisitionConfiguration.Mode = config_string(5:end);

            case 'Realtime'
                AcquisitionConfiguration.Realtime = config_string(9:end);

            case 'Vectors'
                AcquisitionConfiguration.Vectors = config_string(8:end);

            case 'Persistence'
                AcquisitionConfiguration.Persistence = config_string(12:end);

            otherwise

        end

    end

%% Close the file
    fclose(FileID);

%% Assign outputs

    Output.AnalogConfiguration      = AnalogConfiguration;
    Output.TriggerConfiguration     = TriggerConfiguration;
    Output.HorizontalConfiguration  = HorizontalConfiguration;
    Output.AcquisitionConfiguration = AcquisitionConfiguration;
    
end

