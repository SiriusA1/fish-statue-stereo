function [result] = winnertakesall(cost_volume)
%WINNERTAKESALL Summary of this function goes here
%   Detailed explanation goes here
  % Function for matching the best suiting pixels for the disparity image
  %   @param[in] cost_volume: The three-dimensional cost volume to be searched for the best matching pixel (H,W,D)
  %   @return: The two-dimensional disparity image resulting from the best matching pixel inside the cost volume (H,W)
  [m, n] = min(cost_volume(:));
  [x, y, z] = ind2sub(size(cost_volume),n);
  result = [x y z];
end

