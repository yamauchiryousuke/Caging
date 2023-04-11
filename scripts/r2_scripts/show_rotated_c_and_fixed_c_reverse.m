%clear C-Objectの格角度の姿勢

file_name = '../../img/test_009.png'; % 対象物体となる画像ファイル(png)
robot_r = 5; % エンドエフェクタの半径
dc = 30; % エンドエフェクタ間距離
search_interval = 1.0; % C-ClosureObjectを生成するときの細かさを設定(0.1~1.0を推奨)

x_lim = 100;   %グラフのサイズ
y_lim = 100;

%potision_mat = [0, -dc/2, 0.0; ...
%                0, dc/2, 0.0;]; % エンドエフェクタの位置

potision_mat = [ ...
    0,-dc/2;
    0,dc/2
];

% 以下いじらないことを推奨
dots_spacing = 1.0;
robot_corners = 24; % エンドエフェクタの角の細かさ設定(defaultは24で正24角形として近似して計算)
delta = 10^-6; % (defaultは10^-6)
large_value = 10^12;
Threshold = search_interval/(fix(sqrt(2)*(10^10))/(10^10));

addpath('../../func','-end')
addpath('../../class','-end')

% make robot's boundary
s_x = (robot_r-search_interval)*cos(transpose(1:robot_corners)*2*pi/robot_corners);
s_y = (robot_r-search_interval)*sin(transpose(1:robot_corners)*2*pi/robot_corners);

% make object's boundary
object = get_object2d(file_name,dots_spacing);

% make C-Closure Object
c_cls = get_C_closure_object2d(file_name,robot_r,robot_corners,dots_spacing,search_interval);

c_cls_shp = alphaShape(c_cls.Location(:,1:2),Threshold);
[~,c_cls_b] = boundaryFacets(c_cls_shp);

for n= -90:1:90
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
    
    % trans_c_closure_object
    pointclouds = PointClouds;
    len = size(potision_mat,1);

    for i= 1 : len
        tf_tran = [cos(theta), sin(theta), 0.0, 0.0; ...
                -sin(theta), cos(theta), 0.0, 0.0; ...
                0.0,  0.0, 1.0, 0.0; ...
                potision_mat(i,1), potision_mat(i,2), 0, 1.0];
        tf_tran = affine3d(tf_tran);

        pc_location_str = strcat('Location',sprintf('%02d',i));
        pc_shp_str = strcat('shp',sprintf('%02d',i));
        pc_b_str = strcat('b',sprintf('%02d',i));
        pointclouds.addprop(pc_location_str);
        pointclouds.addprop(pc_shp_str);
        pointclouds.addprop(pc_b_str);
        pointclouds.(matlab.lang.makeValidName(['Location',sprintf('%02d',i)])) = pctransform(c_cls, tf_tran);
        pointclouds.(matlab.lang.makeValidName(['shp',sprintf('%02d',i)])) = alphaShape(pointclouds.(matlab.lang.makeValidName(['Location',sprintf('%02d',i)])).Location(:,1:2),Threshold);
        [~,pointclouds.(matlab.lang.makeValidName(['b',sprintf('%02d',i)]))] = boundaryFacets(pointclouds.(matlab.lang.makeValidName(['shp',sprintf('%02d',i)])));
    end
    
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 以下出力設定 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    savefigure = figure('visible','off');
    hold on
    %fill(object_b(:,1),object_b(:,2),'red','FaceAlpha',0.5);
    %scatter(0,0,10,'filled','MarkerFaceColor','black');
    
    for i = 1 : len
        %robot
        %fill(s_x+potision_mat(i,1),s_y+potision_mat(i,2),'green','LineStyle','-','FaceAlpha',0.3);
        
        % c_cls_obj
        pc_s_str = strcat('s',sprintf('%02d',i));
        pointclouds.addprop(pc_s_str);
        pointclouds.(matlab.lang.makeValidName(['s',sprintf('%02d',i)])) = fill(pointclouds.(matlab.lang.makeValidName(['b',sprintf('%02d',i)]))(:,1), ...
        pointclouds.(matlab.lang.makeValidName(['b',sprintf('%02d',i)]))(:,2), 'green',"EdgeColor","black","LineWidth",1.0);
        pointclouds.(matlab.lang.makeValidName(['s',sprintf('%02d',i)])).FaceAlpha = 0.1;
        pointclouds.(matlab.lang.makeValidName(['s',sprintf('%02d',i)])).EdgeAlpha = 0.8;
        
        scatter(potision_mat(i,1),potision_mat(i,2),10,'filled','MarkerFaceColor','black');
    end

    xlim([-200 200])
    ylim([-200 200])
    xlabel('x[mm]');
    ylabel('y[mm]');
    axis on
    axis equal
    xlim manual
    ylim manual
    hold off
    
    title(sprintf( 'theta = %0.1f[deg], d = %0.1f[mm] \n r = %0.1f[mm], search interval =  %0.1f[mm])',90-n,dc,robot_r,search_interval))
    
    savename = strcat('result/r',sprintf('%03d', 180-(90-n)),'.svg');
    saveas(savefigure,savename)
    close all hidden
    disp(strcat("Finished file output : ",savename))
    
    savefigure = figure('visible','off');
    hold on
    
    for i = 1 : len
        % c_cls_obj
        fill(c_cls_b(:,1)+(ones(size(c_cls_b,1),1)*(norm(potision_mat(i,:)-potision_mat(1,:)))*sin(theta)), ...
        c_cls_b(:,2)+(ones(size(c_cls_b,1),1)*(norm(potision_mat(i,:)-potision_mat(1,:)))*cos(theta)), ...
        'green',"EdgeColor","black","LineWidth",1.0,"FaceAlpha",0.1,"EdgeAlpha",0.8);
        
        scatter( ...
            (norm(potision_mat(i,:)-potision_mat(1,:)))*sin(theta), ...
            (norm(potision_mat(i,:)-potision_mat(1,:)))*cos(theta), ...
            10,'filled','MarkerFaceColor','black' ...
        );
    end
    
    xlim([-200 200])
    ylim([-200 200])
    xlabel('x[mm]');
    ylabel('y[mm]');
    axis on
    axis equal
    xlim manual
    ylim manual
    hold off
    
    title(sprintf( 'theta = %0.1f[deg], d = %0.1f[mm] \n r = %0.1f[mm], search interval =  %0.1f[mm])',90-n,dc,robot_r,search_interval))
    
    savename = strcat('result/fixed_r',sprintf('%03d', 180-(90-n)),'.svg');
    saveas(savefigure,savename)
    close all hidden
    
    disp(strcat("Finished file output : ",savename))
end