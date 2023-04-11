%% 1回目
clear

file_name = '../../img/test_001_double.png';
magnification = 2;
robot_corners = 32;
dots_spacing = 1;
c_cls_search_interval = 1;
robot_r = 5*magnification;
dcc_search_interval = 1*c_cls_search_interval;
delta = 10^-8;

addpath('../../func','-end')
addpath('../../class','-end')

c_cls = get_C_closure_object2d_mag(file_name,robot_r,robot_corners,dots_spacing,c_cls_search_interval,magnification);  %C_cls_obj作成
c_cls_1_shp_out = alphaShape(double(c_cls.Location(:,1:2)), c_cls_search_interval/(fix(sqrt(2)*(10^10))/(10^10)),'HoleThreshold',10^12);
c_cls_1_shp_all = alphaShape(double(c_cls.Location(:,1:2)), c_cls_search_interval/(fix(sqrt(2)*(10^10))/(10^10)));

[~,c_cls_1_out_b] = boundaryFacets(c_cls_1_shp_out);
[~,c_cls_1_all_b] = boundaryFacets(c_cls_1_shp_all);

c_cls_1_in_b = c_cls_1_all_b(~ismember(c_cls_1_all_b,c_cls_1_out_b,'rows'),:);

polygon_in = scale(polyshape(transpose(c_cls_1_in_b(:,1)),transpose(c_cls_1_in_b(:,2)),'Simplify',true),1+delta,[0,0]);
polygon_out = scale(polyshape(transpose(c_cls_1_out_b(:,1)),transpose(c_cls_1_out_b(:,2)),'Simplify',true),1-delta,[0,0]);

polygon = xor(polygon_in,polygon_out);

figure;
plot(polygon)

c_cls_boundary = boundary(c_cls.Location(:,1),c_cls.Location(:,2),1);
c_cls_outline = c_cls.Location(c_cls_boundary,1:2);
figure;
scatter(c_cls_outline(:,1),c_cls_outline(:,2),'filled')

c_cls_outline_double = c_cls_outline*4;
figure;
scatter(c_cls_outline_double(:,1),c_cls_outline_double(:,2),'filled')


%% double計算

file_name = '../../img/test_001_quadruple.png';
magnification = 4;
robot_corners = 32*magnification;
dots_spacing = 1;
c_cls_search_interval = 1;
robot_r = 5*magnification;
dcc_search_interval = 1*c_cls_search_interval;
delta = 10^-8;

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

A = [1.0, 0.0, 0.0, 0.0; ...
        0.0, 1.0, 0.0, 0.0; ...
        0.0, 0.0, 1.0, 0.0; ...
        -(target_ptCloud.XLimits(1,2)+target_ptCloud.XLimits(1,1))/2, ...
        -(target_ptCloud.YLimits(1,2)+target_ptCloud.YLimits(1,1))/2, ...
    0,1.0];
tform1 = affine3d(A);
target_ptCloud = pctransform(target_ptCloud,tform1);

%{
figure
pcshow(target_ptCloud)
xlabel('X')
ylabel('Y')
zlabel('Z')
%}

figure;
plot(target_ptCloud.Location(:,1),target_ptCloud.Location(:,2),'r.')

% make C-Closure Object
% make sphere
% Number of corners
s_x = round(r*cos(transpose(1:corners)*2*pi/corners),3);
s_y = round(r*sin(transpose(1:corners)*2*pi/corners),3);
%robo_ptCloud = pointCloud([s_x,s_y,s_z]);
sphere_threshold = Inf;
sphere_shp = alphaShape(s_x, s_y ,sphere_threshold);  %エンドエフェクタ領域

figure;
plot(sphere_shp)

% make C-Closure Object

resolution = search_interval*dots_spacing;  %解像度
c_space = double.empty(0,3);

object_X = target_ptCloud.XLimits(1,2)-target_ptCloud.XLimits(1,1);
object_Y = target_ptCloud.YLimits(1,2)-target_ptCloud.YLimits(1,1);

for i = -magnification:magnification
    for j= -magnification:magnification
        for k = 1:size(c_cls_outline_double(:,1))
            A = [1.0, 0.0, 0.0, 0.0; ...
                0.0, 1.0, 0.0, 0.0; ...
                0.0, 0.0, 1.0, 0.0; ...
                c_cls_outline_double(k,1)+j, ...
            c_cls_outline_double(k,2)+i, ...
            0,1.0];
            tform1 = affine3d(A);
            tf_obj = pctransform(target_ptCloud,tform1);

            center_point = [(tf_obj.XLimits(1,1)+tf_obj.XLimits(1,2))/2,(tf_obj.YLimits(1,1)+tf_obj.YLimits(1,2))/2,(tf_obj.ZLimits(1,1)+tf_obj.ZLimits(1,2))/2];
            tf = inShape(sphere_shp,double(tf_obj.Location(:,1)),double(tf_obj.Location(:,2)));
            interference_count = nnz(tf);
            if interference_count > 0
                c_space = [c_space;center_point];
            end
            %{
            if(rem(k,100)==0)
                figure;
                hold on
                plot(sphere_shp)
                tf_obj_x = double(tf_obj.Location(:,1));
                tf_obj_y = double(tf_obj.Location(:,2));
                plot(tf_obj_x(tf),tf_obj_y(tf),'r.')
                plot(tf_obj_x(~tf),tf_obj_y(~tf),'b.')
                hold off
            end
            %}
            
        
        end
        %disp(round(100*i/(2*(round(((1*r)+(object_Y/2))/resolution)+1))));
    end
end

c_space = c_space/magnification;
disp(i*j*k);
c_cls_object = pointCloud(c_space);
figure;
plot(c_cls_object.Location(:,1),c_cls_object.Location(:,2),'b.')

c_cls_object = pcmerge(c_cls_object,c_cls,0.5);
figure;
plot(c_cls_object.Location(:,1),c_cls_object.Location(:,2),'b.')

c_cls = c_cls_object;

c_cls_1_shp_out = alphaShape(double(c_cls.Location(:,1:2)), c_cls_search_interval/(fix(sqrt(2)*(10^10))/(10^10)),'HoleThreshold',10^12);
c_cls_1_shp_all = alphaShape(double(c_cls.Location(:,1:2)), c_cls_search_interval/(fix(sqrt(2)*(10^10))/(10^10)));

[~,c_cls_1_out_b] = boundaryFacets(c_cls_1_shp_out);
[~,c_cls_1_all_b] = boundaryFacets(c_cls_1_shp_all);

c_cls_1_in_b = c_cls_1_all_b(~ismember(c_cls_1_all_b,c_cls_1_out_b,'rows'),:);

polygon_in = scale(polyshape(transpose(c_cls_1_in_b(:,1)),transpose(c_cls_1_in_b(:,2)),'Simplify',true),1+delta,[0,0]);
polygon_out = scale(polyshape(transpose(c_cls_1_out_b(:,1)),transpose(c_cls_1_out_b(:,2)),'Simplify',true),1-delta,[0,0]);

polygon = xor(polygon_in,polygon_out);

figure;
plot(polygon)