function Waveform = importAgilentBin(inputFilename, waveformSelection)
% ImportAgilentBin reads the Agilent Binary Waveform filetype and creates a
% struct that contains the requested waveforms as well as relevant
% information about each waveform. If the WaveformIndex is an empty array,
% all waveforms present in the binary file will be read.
%
% Sample usage:
% Waveform = importAgilentBin('file_001.bin', [1 2 3 4])

%% Opening file checks
    % Check that the file exists
    if exist(inputFilename,'file')~=2
        error(['The specified file, ' inputFilename ' is not in the specified location.']);
    end

    % Open the file
    fileId = fopen(inputFilename, 'r');

    % Read file header
    fileCookie  = fread(fileId, 2, 'char');
    fileVersion = fread(fileId, 2, 'char');
    fileSize    = fread(fileId, 1, 'int32');
    nWaveforms  = fread(fileId, 1, 'int32');

    % Verify cookie
    fileCookie = char(fileCookie');
    if ~strcmp(fileCookie, 'AG')
        fclose(fileId);
        error('Unrecognized file format.');
    end

%% Determine which waveform to read

    % Check to see if the user has specified a waveform to read
    if isempty(waveformSelection)
        % Assume that the user would like to read all waveforms
        waveformSelection = 1:nWaveforms;
    end
    
%% Initialize the struct to hold the data

    Waveform = struct('xDisplayRange',[],...
                        'xDisplayOrigin',[],...
                        'xIncrement',[],...
                        'xOrigin',[],...
                        'xUnits','',...
                        'yUnits','',...
                        'timeTag',[],...
                        'segmentIndex',[],...
                        'timeVector',[],...
                        'dataVector',[],...
                        'ReferenceTimeVector',[]);

%% Read in the data and store it in the struct

    % We must read all the data, even if we will not use it or store it in
    % the struct because we need to read our way through the entire binary
    % file.
    for waveformIndex = 1:nWaveforms
        % Read waveform header
        headerSize                          = fread(fileId, 1, 'int32');    bytesLeft = headerSize - 4;
        waveformType                        = fread(fileId, 1, 'int32');    bytesLeft = bytesLeft - 4;
        nWaveformBuffers                    = fread(fileId, 1, 'int32');    bytesLeft = bytesLeft - 4;
        Waveform(waveformIndex).nPoints     = fread(fileId, 1, 'int32');    bytesLeft = bytesLeft - 4;
        count                               = fread(fileId, 1, 'int32');    bytesLeft = bytesLeft - 4;
        
        % Get the properties for the X-axis
        Waveform(waveformIndex).xDisplayRange   = fread(fileId, 1, 'float32');  bytesLeft = bytesLeft - 4;
        Waveform(waveformIndex).xDisplayOrigin  = fread(fileId, 1, 'double');   bytesLeft = bytesLeft - 8;
        Waveform(waveformIndex).xIncrement      = fread(fileId, 1, 'double');   bytesLeft = bytesLeft - 8;
        Waveform(waveformIndex).xOrigin         = fread(fileId, 1, 'double');   bytesLeft = bytesLeft - 8;
        xUnits                                  = fread(fileId, 1, 'int32');    bytesLeft = bytesLeft - 4;
        switch xUnits
            case 0
                Waveform(waveformIndex).xUnits = 'unknown';
            case 1
                Waveform(waveformIndex).xUnits = 'Volts';
            case 2
                Waveform(waveformIndex).xUnits = 'Seconds';
            case 3
                Waveform(waveformIndex).xUnits = 'Constant';
            case 4
                Waveform(waveformIndex).xUnits = 'Amps';
            case 5
                Waveform(waveformIndex).xUnits = 'dB';
            case 6
                Waveform(waveformIndex).xUnits = 'Hz';
            otherwise
        end
        
        % Get the units for the y-axis
        yUnits = fread(fileId, 1, 'int32');    bytesLeft = bytesLeft - 4;
        switch yUnits
            case 0
                Waveform(waveformIndex).yUnits = 'unknown';
            case 1
                Waveform(waveformIndex).yUnits = 'Volts';
            case 2
                Waveform(waveformIndex).yUnits = 'Seconds';
            case 3
                Waveform(waveformIndex).yUnits = 'Constant';
            case 4
                Waveform(waveformIndex).yUnits = 'Amps';
            case 5
                Waveform(waveformIndex).yUnits = 'dB';
            case 6
                Waveform(waveformIndex).yUnits = 'Hz';
            otherwise
        end
        
        % The following two parameters, dateString and timeString, are not
        % used in the InfiniiVision oscilloscopes and so they will not be
        % stored in the waveform struct.
        dateString  = fread(fileId, 16, 'char');    bytesLeft = bytesLeft - 16;
        timeString	= fread(fileId, 16, 'char');    bytesLeft = bytesLeft - 16;
        
        % The "frame" is the model and serial number of the oscilloscope in
        % the format "MODEL#:SERIAL#"
        frameString	= fread(fileId, 24, 'char');    bytesLeft = bytesLeft - 24;
        
        % The label assigned to the waveform
        Waveform(waveformIndex).waveformString	= fread(fileId, 16, 'char');    bytesLeft = bytesLeft - 16;
        
        % The following are used only when saving multiple segments 
        % (requires the segmented memory option). The timeTag is is the
        % time, in seconds, since the first trigger. The segmentIndex is 
        % the segment number.
        Waveform(waveformIndex).timeTag         = fread(fileId, 1, 'double');   bytesLeft = bytesLeft - 8;
        Waveform(waveformIndex).segmentIndex	= fread(fileId, 1, 'uint32');   bytesLeft = bytesLeft - 4;

        % Skip over any remaining data in the header
        fseek(fileId, bytesLeft, 'cof');

        % Generate the time vector from the xIncrement and xOrigin values.
        % In general, the time vectors could be different for each 
        % waveform. In order to avoid loading the same x data multiple 
        % times, we will check the xIncrement, npoints and xOrigin values 
        % for the current waveform against previous waveforms. If they are
        % the same, we will not load any data into the timeVector array for
        % this waveform. If they are different, we will load the new data.
        if waveformIndex==1
            % This is the first waveform, so we don't need to check the
            % x-data against any other waveforms.
            Waveform(waveformIndex).timeVector          = (Waveform(waveformIndex).xIncrement * [0:(Waveform(waveformIndex).nPoints-1)]') + Waveform(waveformIndex).xOrigin;
            Waveform(waveformIndex).ReferenceTimeVector = [];
        else
            % This is not the first waveform.
            
            % Create temporary arrays that hold the xIncrement, nPoints and
            % xOrigin values for all previous waveforms.
            temp_xIncrement = [Waveform.xIncrement(1:end-1)]; 
            temp_nPoints    = [Waveform.nPoints(1:end-1)];
            temp_xOrigin    = [Waveform.xOrigin(1:end-1)];
            
            % Compare the current values of xIncrement, nPoints and xOrigin
            % to all of the previous values. The result is three logical
            % arrays.
            find_xIncrement_idx = Waveform(waveformIndex).xIncrement==temp_xIncrement;
            find_nPoints_idx    = Waveform(waveformIndex).nPoints==temp_nPoints;
            find_xOrigin_idx	= Waveform(waveformIndex).xOrigin==temp_xOrigin;
            
            % Sum the logical arrays. Wherever the sum is equal to 3, the 
            % xdata is identical to that from the particular waveform
            temp_sum_array = find_xIncrement_idx + find_nPoints_idx + find_xOrigin_idx;
                        
            if any(temp_sum_array==3)
                % A previously loaded waveform has identical xdata to this
                % waveform. Find the first waveform with identical xdata
                % (this is arbitrary)
                final_idx_temp                              = find(temp_sum_array==3,1,'first');
                Waveform(waveformIndex).timeVector          = [];
                Waveform(waveformIndex).ReferenceTimeVector = final_idx_temp;
            else
                % This waveform has unique xdata.
                Waveform(waveformIndex).timeVector          = (Waveform(waveformIndex).xIncrement * [0:(Waveform(waveformIndex).nPoints-1)]') + Waveform(waveformIndex).xOrigin;
                Waveform(waveformIndex).ReferenceTimeVector = [];
            end
            
        end
        
        % Run through the buffers and load the data
        for bufferIndex = 1:nWaveformBuffers
            % Read waveform buffer header
            headerSize      = fread(fileId, 1, 'int32'); bytesLeft = headerSize - 4;
            bufferType      = fread(fileId, 1, 'int16'); bytesLeft = bytesLeft - 2;
            bytesPerPoint   = fread(fileId, 1, 'int16'); bytesLeft = bytesLeft - 2;
            bufferSize      = fread(fileId, 1, 'int32'); bytesLeft = bytesLeft - 4;

            % Skip over any remaining data in the header
            fseek(fileId, bytesLeft, 'cof');

            % If this waveform was requested by the user, store its data in
            % the struct
            if waveformIndex == waveformSelection
                % The user has requested this waveform.
                if bufferType == 1 || bufferType == 2 || bufferType == 3
                    % bufferType is PB_DATA_NORMAL, PB_DATA_MIN, or PB_DATA_MAX (float)
                    Waveform(waveformIndex).dataVector(:, bufferIndex) = fread(fileId, Waveform(waveformIndex).nPoints, 'float');
                elseif bufferType == 4
                    % bufferType is PB_DATA_COUNTS (int32)
                    Waveform(waveformIndex).dataVector(:, bufferIndex) = fread(fileId, Waveform(waveformIndex).nPoints, '*int32');
                elseif bufferType == 5
                    % bufferType is PB_DATA_LOGIC (int8)
                    Waveform(waveformIndex).dataVector(:, bufferIndex) = fread(fileId, Waveform(waveformIndex).nPoints, '*uint8');
                else
                    % Unrecognized bufferType read as unformated bytes
                    Waveform(waveformIndex).dataVector(:, bufferIndex) = fread(fileId, bufferSize, '*uint8');
                end
            else
                % This waveform was not selected, so skip it.
                fseek(fileId, bufferSize, 'cof');
            end
        end
    end
    
%% Close the file
    fclose(fileId);
    
end
