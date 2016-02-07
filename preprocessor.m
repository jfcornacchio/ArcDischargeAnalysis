function preprocessing = preprocessor(input_data,vid)
%% Initialization
    % Use the initial frame as the background image and crop it
    % according to the input file
    background = read(vid,1);
    background = rgb2gray(background(input_data.CropYMin:input_data.CropYMax, input_data.CropXMin:input_data.CropXMax,:));

    % Form a list of movie frames to be analyzed
    frames = input_data.StartFrame:input_data.EndFrame;

    % Preallocate a structure array to hold the logical matrices that
    % contain edge data for each frame. Get the first frame in the video
    % and crop it according to the input file.
    temp_frame = read(vid,frames(1));
    temp_frame = rgb2gray(temp_frame(input_data.CropYMin:input_data.CropYMax, input_data.CropXMin:input_data.CropXMax,:));
    
    % Use this temporary frame, which has been cropped to the correct size,
    % to initialize the structure
    
    %Initialize struct fields
    preprocessing.frame         = ones(size(temp_frame));
    preprocessing.binary_peaks  = ones(size(temp_frame));
    preprocessing.ContourCoord  = struct('ContourCoordX',NaN,'ContourCoordY',NaN);
    
    % Preallocate memory for all struct fields
    preprocessing(length(frames)).frame = ones(size(temp_frame));
    
    % Initialize the storage in the struct for the image and its outline.
    % This data can be used to help the user examine the goodness of the
    % found edges in the image.
    
%% Preprocessing
    
    % Initialize the waitbar
    edge_finding_wait = waitbar(0,'Finding edges in frame ');
    
    for loop = 1:length(frames)

        % Update the waitbar
        waitbar((loop-1)/length(frames),edge_finding_wait,['Find edges in frame ' num2str(frames(loop))]);
        
        % Get the movie frame
        frame = read(vid,frames(loop));

        % Convert to a grayscale image and crop
        gray_frame = rgb2gray(frame(input_data.CropYMin:input_data.CropYMax, input_data.CropXMin:input_data.CropXMax,:));

        % Subtract the background image
        gray_frame = gray_frame - background;
        
        % Convert to double precision (would single be sufficient?)
        gray_frame = im2double(gray_frame);
        
        % Preallocate the struct for this frame
        preprocessing(loop).frame = ones(size(gray_frame));
        
        % Calculate the intensity gradient in the gray image. Create the
        % kernels        
        VertSobelKernel = [-1 -2 -1; 0 0 0;1 2 1]/4;
        HorzSobelKernel = [1 0 -1;2 0 -2;1 0 -1]/4;

        % Smooth and calculate the vertical gradient
        gray_vert = abs(imfilter(gray_frame,VertSobelKernel));
        
        % Smooth and calculate the horizontal gradient in the x-direction
        gray_horz = abs(imfilter(gray_frame,HorzSobelKernel));
        
        % Combine the two images to get an absolute intensity gradient
        % magnitude
        gray_total = sqrt(gray_vert.^2+gray_horz.^2);
        
        % Find the locations of all peaks in the gradient matrix that are
        % larger than some threshold
        if loop==1
            % Then this is the first frame, where the spark is going off
            [peak_mag_matrix,peaks_matrix_logical,~] = MatrixPeakfinder(gray_total,0.3,[]);
        else
            [peak_mag_matrix,peaks_matrix_logical,~] = MatrixPeakfinder(gray_total,0.08,[]);
        end

        
        % Using the "alphavol" function, calculate the location of the
        % outer boundary of the point cloud (the peaks found by the
        % MatrixPeakFinder function).
        
        % First, get the locations of the peaks
        [I,J] = find(peak_mag_matrix>0);
        
        % Call the alphavol function:
        [~,concavehull] = alphavol([I J],8,0);

        linear_ind_temp = sub2ind(size(gray_total),concavehull.YCoord,concavehull.XCoord);

        % Find the intensities of the edge pixels found above
        edge_intensity = gray_frame(linear_ind_temp);
        
        % Calculate the contour line that corresponds to the average edge
        % intensity
        TemporaryFigureHandle = figure('Visible','off');
%         TemporaryFigureHandle = figure;        
%         imshow(gray_frame)
        hold on
        [contour_output,~] = imcontour(gray_frame,mean(edge_intensity),'-m');
%         pause
        close(TemporaryFigureHandle)
        
%% Convert the contour line(s) into a logical matrix and store in the data structure
        % First, find the number of contours that exist.
        ContourIndices      = find(contour_output(1,:)==mean(edge_intensity));
        NumberofContours    = numel(ContourIndices);
        
        % Store the contour coordinates, in the order in which they can be
        % plotted, which is the original order given by the imcontour
        % function
        if length(ContourIndices)>1
            for loop2 = 1:length(ContourIndices)
                if loop2~=length(ContourIndices)
                    % We are not on the last contour
                    preprocessing(loop).ContourCoord(loop2).ContourCoordX = contour_output(1,ContourIndices(loop2)+1:ContourIndices(loop2+1)-1);
                    preprocessing(loop).ContourCoord(loop2).ContourCoordY = contour_output(2,ContourIndices(loop2)+1:ContourIndices(loop2+1)-1);
                else
                    % We are on the last contour
                    preprocessing(loop).ContourCoord(loop2).ContourCoordX = contour_output(1,ContourIndices(loop2)+1:end);
                    preprocessing(loop).ContourCoord(loop2).ContourCoordY = contour_output(2,ContourIndices(loop2)+1:end);
                end
            end
        else
            % Only one contour is present
            preprocessing(loop).ContourCoord(1).ContourCoordX = contour_output(1,2:end);
            preprocessing(loop).ContourCoord(1).ContourCoordY = contour_output(2,2:end);
        end
        
        % Clear the "gradient" and "number of points" data from the contour
        % output matrix
        contour_output(:,ContourIndices)    = [];
        ContourRounded                      = round(contour_output);

        % Store the edge pixels in the data structure
        for loop2 = 1:size(ContourRounded,2)
            preprocessing(loop).frame(ContourRounded(2,loop2),ContourRounded(1,loop2)) = 0;
        end
        
%% Store any other data in the output struct
        
        % Store the binary peak matrix
        preprocessing(loop).binary_peaks = peaks_matrix_logical;

        % Store the binary peak matrix in (x,y) coordinate form
        idx                                     = find((peaks_matrix_logical(:)==1));
        [Y,X]                                   = ind2sub(size(peaks_matrix_logical),idx);
        preprocessing(loop).BinaryPeaksCoord    = [X,Y];
                
        % Update the waitbar
        waitbar(loop/length(frames),edge_finding_wait,['Find edges in frame ' num2str(frames(loop))]);
        
    end
    
    % Close the waitbar
    close(edge_finding_wait)

end


