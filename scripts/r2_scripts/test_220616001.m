% round あり

clear

file_name = '../../img/test_001_quadruple.png';
magnification = 1;
robot_corners = 32;
dots_spacing = 1;
c_cls_search_interval = 1;
robot_r = 5*magnification;
dcc_search_interval = 1*c_cls_search_interval;
delta = 10^-8;

addpath('../../func','-end')
addpath('../../class','-end')

r = robot_r;
corners = robot_corners;
search_interval = c_cls_search_interval;

% make target point cloud
img = imread(file_name);  %画像読み込み
img = rgb2gray(img);      %グレースケール変換
img = imbinarize(img);    %2値化
img_size = size(img);     %画像の配列サイズ

img_point = double.empty(0,3);
mass = 1;
for i = 1:img_size(1,1)
    for j = 1:img_size(1,2)
        if img(i,j) == 1
            img_point(mass,1) = dots_spacing*(j-1);
            img_point(mass,2) = dots_spacing*(i-1);
            mass = mass + 1;
        end
    end
end

img_point(:,2) = -img_point(:,2);

target_ptCloud = pointCloud(img_point);

gridStep = 0.1;
target_ptCloudA = pcdownsample(target_ptCloud,'gridAverage',gridStep);

figure;
pcshow(target_ptCloud);

figure;
pcshow(target_ptCloudA);

stepSize = floor(target_ptCloud.Count/target_ptCloudA.Count);
indices = 1:stepSize:target_ptCloud.Count;
target_ptCloudB = select(target_ptCloud, indices);

figure;
pcshow(target_ptCloudB);