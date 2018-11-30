function [ x2, y2 ] = epipolarCorrespondence( im1, im2, F, x1, y1 )
% epipolarCorrespondence:
%       im1 - Image 1
%       im2 - Image 2
%       F - Fundamental Matrix between im1 and im2
%       x1 - x coord in image 1
%       y1 - y coord in image 1

% Q4.1:
%           Implement a method to compute (x2,y2) given (x1,y1)
%           Use F to only scan along the epipolar line
%           Experiment with different window sizes or weighting schemes
%           Save F, pts1, and pts2 used to generate view to q4_1.mat
%
%           Explain your methods and optimization in your writeup

    

    p1 = [x1;y1;1];
    % Calculating the epipolar line for image 2.
    %Form : ax+by+cz=0 ...[a;b;c]
    epipolar_line = F * p1;
    
    % Making the line as ax+by+1 = 0 
    epipolar_line = epipolar_line./norm(epipolar_line);
    
    % Point p2 will be on this line...
    % Calculating the dimensions of this line on image plane
    y_range = 1 :size(im1,2);
    x_range = round(-(1+epipolar_line(2)*y_range)./epipolar_line(1));
    
    %Parameter Initialization
    sigma = 6;
    window_size = 23;
    temp = 0;
    lambda = (window_size-1)/2;
    
    %Gaussian Weighting
    weights = fspecial('gaussian',[window_size,window_size], sigma);
    
    patch_1 = im1(y1-lambda:y1+lambda,x1-lambda:x1+lambda);
    patch_1 = double(patch_1);
    
    % Moving the new window along the epipolar line.
    prev_error = inf;
    for i = 1: length(x_range)
        
        x2_raw = x_range(i);
        y2_raw = y_range(i);
        window_dimensions = [x2_raw-lambda, x2_raw+lambda y2_raw-lambda,y2_raw+lambda];
        
        if window_dimensions(1) > 0 && window_dimensions(2) <= size(im2,2) && window_dimensions(3) > 0 && window_dimensions(4) <= size(im2,1)
            if (sqrt((x1 - x2_raw)^2 + (y1 - y2_raw)^2) > 30)
                continue;
            end
            patch_2 = im2(y2_raw-lambda:y2_raw+lambda,x2_raw-lambda:x2_raw+lambda);
            patch_2 = double(patch_2);
            error = sum(sum(abs(patch_2- patch_1).*weights));
            if error < prev_error
                x2 = x2_raw;
                y2 = y2_raw;
                prev_error = error;
            end        
        end      
    end
    
end
