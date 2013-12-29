function [PeaksMatrix,BinaryPeaks,PeaksOverlayFigureHandle] = MatrixPeakfinder(Matrix,PeakThreshold,Image)
% This function finds the peaks in a matrix by searching vertically and
% horizontally through the matrix for peaks that are greater than a
% threshold. The function returns a matrix the same size as the input
% matrix that consists of the magnitudes of the peaks where they were found
% and zeros everywhere else. It also returns a logical matrix that is true
% where there are no peaks and false where peaks were found.

    % Preallocate memory
    PeaksMatrix = zeros(size(Matrix));
    BinaryPeaks = zeros(size(Matrix));

    % Check to see if the user would like to overlay the peaks onto the
    % input matrix. This is mainly used when the input matrix is an image
    if ~isempty(Image)
        PeaksOverlayFigureHandle = figure;
        imshow(Image)
        hold on
    else
        PeaksOverlayFigureHandle = [];
    end
    
    % For every column in the image, find the peaks and their location
    for loop2 = 1:size(Matrix,2)

        if any(Matrix(:,loop2)>PeakThreshold)

            [peak_mag,loc] = findpeaks(Matrix(:,loop2),...
                                        'MINPEAKHEIGHT',PeakThreshold);
            
            % Where a peak was found, change the value in the binary matrix
            % to "false"
            BinaryPeaks(loc,ones(size(loc,1),1)*loop2) = 1;

            % Convert the locations of the peaks to linear indices
            linear_indices = sub2ind(size(PeaksMatrix),loc,ones(size(loc,1),1)*loop2);

            PeaksMatrix(linear_indices) = peak_mag;
            
            if ~isempty(Image)
                plot(ones(size(loc))*loop2,loc,'Marker','o',...
                    'MarkerFaceColor','g',...
                    'MarkerSize',5,...
                    'LineStyle','none',...
                    'MarkerEdgeColor','g')
            end
            
        end

    end

    % For every row in the image, find the peaks and their location
    for loop2 = 1:size(Matrix,1)

        % Test to make sure that at there is at least one peak in the
        % row.
        if any(Matrix(loop2,:)>PeakThreshold)

            [peak_mag,loc] = findpeaks(Matrix(loop2,:),...
                                        'MINPEAKHEIGHT',PeakThreshold);
            
            % Where a peak was found, change the value in the binary matrix
            % to "false"
            BinaryPeaks(ones(size(loc,2),1)*loop2,loc) = 0;

            % Convert the locations of the peaks to linear indices
            linear_indices = sub2ind(size(PeaksMatrix),ones(1,size(loc,2))*loop2,loc);

            PeaksMatrix(linear_indices) = peak_mag;
            
            if ~isempty(Image)
                plot(loc,ones(size(loc))*loop2,'Marker','o',...
                    'MarkerFaceColor','g',...
                    'MarkerSize',5,...
                    'LineStyle','none',...
                    'MarkerEdgeColor','g')
            end

        end
    end
    
    
end