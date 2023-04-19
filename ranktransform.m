function [rt_left,rt_right] = ranktransform(left_image, right_image, window_width)
%RANKTRANSFORM Summary of this function goes here
%   Detailed explanation goes here
    [H,W] = size(left_image);
    %% pad image
    window_radius = ((window_width-1)/2);
    left_image_padded = padarray(left_image, [window_radius window_radius], 0);
    right_image_padded = padarray(right_image, [window_radius window_radius], 0);
    rt_left = zeros(size(left_image_padded));
    rt_right = zeros(size(left_image_padded));
    
    %% Loop over internal image in steps of 5
    for y = window_radius+1: 5: H - window_radius
        for x = window_radius+1: 5: W - window_radius  
            % Loop over window
            pixel_vals_left = zeros(window_width*window_width, 1);
            pixel_vals_right = zeros(window_width*window_width, 1);

            % make list of all pixel values in window
            i = 1;
            for v = -window_radius: window_radius
                for u = -window_radius: window_radius
                    pixel_vals_left(i) = left_image_padded(y+v, x+u);
                    pixel_vals_right(i) = right_image_padded(y+v, x+u);
                    i = i+1;
                end
            end
      
            % create a sorted set from pixel values retrieved above
            unique_ranked_pixels_left = sort(unique(pixel_vals_left));
            unique_ranked_pixels_right = sort(unique(pixel_vals_right));

            % step through window again, replacing pixel values with index ("rank") of pixel val from above list
            rt_left = zeros(size(left_image_padded));
            rt_right = zeros(size(left_image_padded));
            for v = -window_radius: window_radius
                for u = -window_radius: window_radius
                    rt_left(y+v, x+u) = find(unique_ranked_pixels_left == left_image_padded(y+v, x+u));
                    rt_right(y+v, x+u) = find(unique_ranked_pixels_right == right_image_padded(y+v, x+u));
                end
            end
        
        end
    end
  
end

