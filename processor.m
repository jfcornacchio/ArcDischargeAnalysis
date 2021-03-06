function ProcessedData = processor(input_file_struct,PreprocessedData)
%processor is a function that does stuff. I'm still remembering exactly
%what that is.

%% Initialization

    % Preallocate memory for speed
    radius_pixels_top = nan(length(PreprocessedData),input_file_struct.CropXMax-input_file_struct.CropXMin+1);
    radius_pixels_bot = nan(length(PreprocessedData),input_file_struct.CropXMax-input_file_struct.CropXMin+1);

%% Processing
    
    % For every frame in the preprocessed data struct, process the data
    for loop = 1:length(PreprocessedData)
    
        % Break the frame into an upper and a lower half using the image
        % centerline location
        UpperHalf = (PreprocessedData(loop).frame(1:input_file_struct.CenterLocY-1,:));
        LowerHalf = (PreprocessedData(loop).frame(input_file_struct.CenterLocY:end,:));
        
        % Track the black pixel heights above (or below) the centerline
        % that are farthest from the centerline. This "distance" matrix
        % will later be used to calculate distance changes.
        if ~all(UpperHalf(:))
            % There is at least one black pixel that can be tracked in
            % the top half of the image

            % For every row, find the black pixel farthest from the
            % centerline. First, find the columns with ANY black pixels
            % by calculating the sum of the matrix elements. If the
            % column consists purely of white pixels, the sum of the
            % elements in that column will be equal to the number of
            % rows. If there are any black pixels, the sum of the
            % elements in that column will be less than the number of
            % rows.
            col_idx_top = find(sum(UpperHalf)<size(UpperHalf,1));

            for loop2 = 1:length(col_idx_top)
                % Find the black pixel farthest away from the
                % centerline
                radius_pixels_top(loop,col_idx_top(loop2)) = size(UpperHalf,1)-find(UpperHalf(:,col_idx_top(loop2))==0,1,'first');
            end

        else
            % There are no pixels to track.

        end

        if ~all(LowerHalf(:))
            % There is at least one black pixel that can be tracked in
            % the bottom half of the image
            col_idx_bot = find(sum(LowerHalf)<size(LowerHalf,1));

            for loop2 = 1:length(col_idx_bot)

                % Find the black pixel farthest away from the
                % centerline
                radius_pixels_bot(loop,col_idx_bot(loop2)) = find(LowerHalf(:,col_idx_bot(loop2))==0,1,'first');
            end

        else
            % There are no pixels to track.

        end

    end
    
    % Convert all NaNs to zeros
    radius_pixels_top(isnan(radius_pixels_top)) = 0;
    radius_pixels_bot(isnan(radius_pixels_bot)) = 0;
    
%% Calculate the change in radius with time, dr/dt, in units of pixels

    % Calculate dr/dt for the upper image
    dr_dt_upper = diff(radius_pixels_top,1,1)./(input_file_struct.TimeStep/1000);

    % Calculate dr/dt for the lower image
    dr_dt_lower = diff(radius_pixels_bot,1,1)./(input_file_struct.TimeStep/1000);
    
    % Create a time stamp matrix for plotting.
    time = ((0:size(dr_dt_upper,1))*input_file_struct.TimeStep)';
    
    % Store the dr/dt data for the center location as its own parameter
    centerline_drdt_upper = dr_dt_upper(:,input_file_struct.CenterLocX);
    centerline_drdt_lower = dr_dt_lower(:,input_file_struct.CenterLocX);   
    
%% Calculate dr/dt in unts of cm/s
    % First, calculate the size of the pixels in centimeters
    cm_per_pixel                        = input_file_struct.MMPerPixel/10;
    centerline_drdt_upper_cm_per_sec    = centerline_drdt_upper*cm_per_pixel;
    centerline_drdt_lower_cm_per_sec    = centerline_drdt_lower*cm_per_pixel;
    
%% Save variables into the output struct
    ProcessedData.drdt.upper                        = dr_dt_upper;
    ProcessedData.drdt.lower                        = dr_dt_lower;
    ProcessedData.Time                              = time;
    ProcessedData.TimeFirstDerivative               = time(2:end);
    ProcessedData.UpperCenterline_Normalized_drdt   = centerline_drdt_upper;
    ProcessedData.LowerCenterline_Normalized_drdt   = centerline_drdt_lower;
    ProcessedData.UpperCenterLineRadius_cm          = radius_pixels_top(:,input_file_struct.CenterLocX)*cm_per_pixel;
    ProcessedData.LowerCenterLineRadius_cm          = radius_pixels_bot(:,input_file_struct.CenterLocX)*cm_per_pixel;
    ProcessedData.UpperCenterline_cm_per_sec_drdt   = centerline_drdt_upper_cm_per_sec;
    ProcessedData.LowerCenterline_cm_per_sec_drdt   = centerline_drdt_lower_cm_per_sec;
    ProcessedData.LowerCenterline_cm_per_sec_drdt   = centerline_drdt_lower_cm_per_sec;
    ProcessedData.LowerCenterline_cm_per_sec_drdt   = centerline_drdt_lower_cm_per_sec;
    ProcessedData.NominalSparkGap                   = input_file_struct.NominalSparkGap;
    
end

