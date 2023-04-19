function [gray_left,gray_right] = convertgrayscale(left_image,right_image)
%CONVERTGRAYSCALE Converts given stereo rgb images to gray scale
%   Grey_value = (0.3)Red_Channel + (0.59) Green_Channel + (0.11)Blue_Channel
  [H, W, C] = size(left_image);
  gray_left = zeros(H, W);
  gray_right = zeros(H, W);
  for y = 1: H
    for x = 1: W
      gray_left(y, x) = left_image(y, x, 1) * 0.3 + left_image(y, x, 2) * 0.59 + left_image(y, x, 3) * 0.11;
      gray_right(y, x) = right_image(y, x, 1) * 0.3 + right_image(y, x, 2) * 0.59 + right_image(y, x, 3) * 0.11;
    end
  end
end

