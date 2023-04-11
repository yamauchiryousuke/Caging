clear

file_name = '../../img/test_001.png';
magnification = 1;
corners = 32;
dots_spacing = 1;
c_cls_search_interval = 0.1;
r = 5;
dcc_search_interval = 1*c_cls_search_interval;
delta = 10^-8;

addpath('../../func','-end')
addpath('../../class','-end')

%run('make_c_cls_obj')

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

    A = [1.0, 0.0, 0.0, 0.0; ...
            0.0, 1.0, 0.0, 0.0; ...
            0.0, 0.0, 1.0, 0.0; ...
            -(target_ptCloud.XLimits(1,2)+target_ptCloud.XLimits(1,1))/2, ...
            -(target_ptCloud.YLimits(1,2)+target_ptCloud.YLimits(1,1))/2, ...
        0,1.0];
    tform1 = affine3d(A);
    target_ptCloud = pctransform(target_ptCloud,tform1);

s_x = round(r*cos(transpose(1:corners)*2*pi/corners),3);
s_y = round(r*sin(transpose(1:corners)*2*pi/corners),3);
%robo_ptCloud = pointCloud([s_x,s_y,s_z]);
sphere_threshold = Inf;
sphere_shp = alphaShape(s_x, s_y ,sphere_threshold);  %エンドエフェクタ領域

A=sphere_shp.Points; B=target_ptCloud.Location(:,1:2);
[S,D]=minksum(A,B);
figure
plot(A(:,1),A(:,2),'b.')
axis([0 7 0 7])
figure
plot(B(:,1),B(:,2),'b.')
axis([0 7 0 7])
figure
plot(S(:,1),S(:,2),'mo')
axis([0 7 0 7])

A=sphere_shp.Points; B=target_ptCloud.Location(:,1:2);
[SS,D]=minksum(S,S);
plot(SS(:,1),SS(:,2),'m.')
axis([0 7 0 7])