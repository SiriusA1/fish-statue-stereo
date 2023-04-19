function [cost_volume] = SAD(left_image, right_image, max_disparity, filter_width)
%SAD Summary of this function goes here
%   Detailed explanation goes here

  % Compute a cost volume with maximum disparity D considering a neighbourhood R with Sum of Absolute Differences (SAD)
  %   @param[in] left_image: The left image to be used for stereo matching (H,W) 
  %   @param[in] right_image: The right image to be used for stereo matching (H,W)
  %   @param[in] max_disparity: The maximum disparity to consider
  %   @param[in] filter_width: The filter width to be considered for matching
  %   @return: The best matching pixel inside the cost volume according to the pre-defined criterion (H,W,D) 
  [H,W] = size(left_image);
  cost_volume = zeros(H,W,max_disparity);
  filter_radius = ((filter_width-1)/2);

  % Loop over internal image
  for y = filter_radius+1:H - filter_radius
    for x = filter_radius+1: W - filter_radius 
      % Loop over window
      for v = -filter_radius: filter_radius
        for u = -filter_radius: filter_radius
          % Loop over all possible disparities
          for d = 1: max_disparity
            % need to cast to int here because the numbers are uint8 by default which cannot allow negatives
            if x+u-d < 1
                cost_volume(y,x,d) = cost_volume(y,x,d) + abs(left_image(y+v, x+u) - right_image(y+v, 1));
            else
                cost_volume(y,x,d) = cost_volume(y,x,d) + abs(left_image(y+v, x+u) - right_image(y+v, x+u-d));
            end
          end
        end
      end
    end
  end
        
end

