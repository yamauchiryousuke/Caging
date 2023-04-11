% 2DのC-Closure Objectの表示

% 生成パラメーター
file_name = '../../img/test_001.png'; % 対象物体となる画像ファイル(png)
robot_r = 5; % エンドエフェクタの半径
robot_corners = 24;
dots_spacing = 1.0;
search_interval = 1.0;
deg = 0;

theta = deg2rad(deg);

delC_theta = double.empty(0,2);

potision_mat = [0, 0, 0.0; ...
                40, 40, 0.0];

% alpha shapeを生成する時のパラメータ
delta = 10^-6;
large_value = 10^12;
Threshold = search_interval/(fix(sqrt(2)*(10^10))/(10^10));

addpath('../../func','-end')
addpath('../../class','-end')

% make object's boundary
object = get_object2d(file_name,dots_spacing);
% make robot's boundary
s_x = (robot_r-search_interval)*cos(transpose(1:robot_corners)*2*pi/robot_corners);
s_y = (robot_r-search_interval)*sin(transpose(1:robot_corners)*2*pi/robot_corners);
% make C-Closure Object
%c_cls_obj = get_C_closure_object2d(file_name,robot_r,robot_corners,dots_spacing,search_interval);
c_cls_obj = get_C_closure_object2d_oct(file_name,robot_r,robot_corners,dots_spacing,search_interval,24);
%cc_cls_obj = get_CC_closure_object2d(c_cls_obj,dots_spacing,search_interval);
cc_cls_obj = get_CC_closure_object2d_oct(c_cls_obj.Location,dots_spacing,search_interval,24);

cc_cls_shp = alphaShape(double(cc_cls_obj.Location(:,1:2)), search_interval/(fix(sqrt(2)*(10^10))/(10^10)),'HoleThreshold',10^12);
[~,cc_cls_b] = boundaryFacets(cc_cls_shp);

for n= 0: 0
    theta = deg2rad(n);
    % trans_object
    tf_0 = [cos(theta), sin(theta), 0.0, 0.0; ...
        -sin(theta), cos(theta), 0.0, 0.0; ...
        0.0, 0.0, 1.0, 0.0; ...
        0, 0, 0, 1.0];
    tform0 = affine3d(tf_0);
    object_t = pctransform(object,tform0);
    object_t = pointCloud(round([object_t.Location(:,1),object_t.Location(:,2),object_t.Location(:,3)],10^10));
    Threshold = dots_spacing/(fix(sqrt(2)*(10^10))/(10^10));
    object_shp = alphaShape(double(object_t.Location(:,1)),double(object_t.Location(:,2)),Threshold);
    [~,object_b] = boundaryFacets(object_shp);

    pointclouds = PointClouds;

    len = size(potision_mat,1);

    for i= 1 : len
        tf_tran = [cos(theta), sin(theta), 0.0, 0.0; ...
                -sin(theta), cos(theta), 0.0, 0.0; ...
                0.0, 0.0, 1.0, 0.0; ...
                potision_mat(i,1), potision_mat(i,2), 0, 1.0];
        tf_tran = affine3d(tf_tran);

        pc_location_str = strcat('Location',sprintf('%02d',i));
        pc_shp_str = strcat('shp',sprintf('%02d',i));
        pc_b_str = strcat('b',sprintf('%02d',i));
        pointclouds.addprop(pc_location_str);
        pointclouds.addprop(pc_shp_str);
        pointclouds.addprop(pc_b_str);
        pointclouds.(matlab.lang.makeValidName(['Location',sprintf('%02d',i)])) = pctransform(c_cls_obj, tf_tran);
        pointclouds.(matlab.lang.makeValidName(['shp',sprintf('%02d',i)])) = alphaShape(pointclouds.(matlab.lang.makeValidName(['Location',sprintf('%02d',i)])).Location(:,1:2),Threshold);
        [~,pointclouds.(matlab.lang.makeValidName(['b',sprintf('%02d',i)]))] = boundaryFacets(pointclouds.(matlab.lang.makeValidName(['shp',sprintf('%02d',i)])));
        
        if i == 1
            cc_cls_obj_tf = pctransform(cc_cls_obj, tf_tran);
            cc_cls_obj_shp = alphaShape(cc_cls_obj_tf.Location(:,1:2),Threshold);
            [~,cc_cls_obj_tf_b] = boundaryFacets(cc_cls_obj_shp);
        end
    end
    
    check_line = [0, 0; 100, 0];
    check_poly = polyshape(cc_cls_obj_tf_b(:,1),cc_cls_obj_tf_b(:,2));
    [in_line, out_line] = intersect(check_poly,check_line);
    delC_theta = [ ...
    delC_theta; ...
    theta, norm(in_line(2,:)) ...
    ];
    
    figure
    %savefigure = figure('visible','off');
    hold on
    % object
    fill(object_b(:,1),object_b(:,2),'red','FaceAlpha',0.5);
    % cc_cls_obj
    fill(cc_cls_obj_tf_b(:,1),cc_cls_obj_tf_b(:,2),[255/255,192/255,0],'FaceAlpha',0.1);
    
    for i = 1 : len
        % robot
        fill(s_x+potision_mat(i,1),s_y+potision_mat(i,2),'green','LineStyle','-','FaceAlpha',0.1);
        %plot(s_x+potision_mat(i,1),s_y+potision_mat(i,2),'Color','black','LineStyle',':');
        scatter(potision_mat(i,1),potision_mat(i,2),8,'filled','MarkerFaceColor','black');
        % c_cls_obj
        pc_s_str = strcat('s',sprintf('%02d',i));
        pointclouds.addprop(pc_s_str);
        pointclouds.(matlab.lang.makeValidName(['s',sprintf('%02d',i)])) = fill(pointclouds.(matlab.lang.makeValidName(['b',sprintf('%02d',i)]))(:,1), ...
        pointclouds.(matlab.lang.makeValidName(['b',sprintf('%02d',i)]))(:,2), 'green');
        pointclouds.(matlab.lang.makeValidName(['s',sprintf('%02d',i)])).FaceAlpha = 0.1;
        pointclouds.(matlab.lang.makeValidName(['s',sprintf('%02d',i)])).EdgeAlpha = 0.8;
    end
    
    %scatter(in_line(2,1),in_line(2,2),10,'filled','MarkerFaceColor','black');
    
    %plot(polyshape(transpose(cc_cls_b(:,1)),transpose(cc_cls_b(:,2)),'Simplify',true));

    
    xlim([-180 180])
    ylim([-180 180])
    axis off
    axis equal
    xlim manual
    ylim manual
    hold off
    %savename = strcat('graph/',sprintf('%03d',n+180),'.png');
    %saveas(savefigure,savename)
    %close all hidden
end