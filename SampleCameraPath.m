%% clear workspace
clc
clear all
close all

% load variables: BackgroundPointCloudRGB,ForegroundPointCloudRGB,K,crop_region,filter_size)
load data.mat

data3DC = {BackgroundPointCloudRGB,ForegroundPointCloudRGB};
R       = eye(3);

%% Estimate initial camera position
imgW1 = 100;
imgH1 = 160;

objW = range(ForegroundPointCloudRGB(1,:));
objH = range(ForegroundPointCloudRGB(2,:));
objD0 = mean(ForegroundPointCloudRGB(3,:));

fov_x = rad2deg(2 * atan2(400, 2 * K(1,1)));
fov_y = rad2deg(2 * atan2(640, 2 * K(2,2)));
new_fx = imgW1 / (2 * tan(deg2rad(fov_x/2)));
new_fy = imgH1 / (2 * tan(deg2rad(fov_y/2)));
K(1,1) = new_fx;
K(2,2) = new_fy;

M0 = K*[R zeros(3,1)];

% used this tool to calculate baseline: https://nerian.com/support/calculator/#results
foregroundObj = [ForegroundPointCloudRGB(1,:);...
    ForegroundPointCloudRGB(2,:);...
    ForegroundPointCloudRGB(3,:);...
    ones(1,size(ForegroundPointCloudRGB(1,:),2))];
foregroundImage = M0 * foregroundObj;

disp("min depth: " + min(ForegroundPointCloudRGB(3,:)));
disp("max depth: " + max(BackgroundPointCloudRGB(3,:)));

imgW0 = range(foregroundImage(1,:) ./ foregroundImage(3,:));
imgH0 = range(foregroundImage(2,:) ./ foregroundImage(3,:));

objD1 = objD0 * imgW0 / imgW1;
%Z (depth) = (focalLength * baseline) / disparity
t_left = [-0.6; 0; 0];
t_right = [0.6; 0; 0];

%% Generate disparity maps

M_left = K*[R t_left];
M_right = K*[R t_right];

left_image = PointCloud2Image(M_left, data3DC, crop_region, filter_size);
right_image = PointCloud2Image(M_right, data3DC, crop_region, filter_size);
imwrite(left_image, "leftfish.png");
imwrite(right_image, "rightfish.png")

[gray_left, gray_right] = convertgrayscale(left_image, right_image);
imwrite(gray_left, "leftfish.png");
imwrite(gray_right, "rightfish.png")
max_disparity = 25;
filter_width = 15;

[rt_left, rt_right] = ranktransform(gray_left, gray_right, 5);
writematrix(rt_left, 'rt_left values fish.csv');
writematrix(rt_right, 'rt_right values fish.csv');
 
cost_volume = SAD(rt_left, rt_right, max_disparity, filter_width);
result = winnertakesall(cost_volume);
 
writematrix(result, '15x15 disparity map fish.csv');