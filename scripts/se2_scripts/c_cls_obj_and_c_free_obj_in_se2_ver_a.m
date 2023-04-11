file_name = '../../img/test_h1_double.png';

robot_r = 5*2;
robot_corners = 24;
dots_spacing = 1;
search_interval = 1;
distance = 60;
compression_coefficient = 0.5;

set_deg = [0,360];
c_free_size = 100;

Threshold = search_interval/(fix(sqrt(2)*(10^10))/(10^10));
z_search_interval = search_interval;

large_value = 10^16;

addpath('../../func','-end')
addpath('../../class','-end')

z = 0;
c_cls = get_C_closure_object2d(file_name,robot_r,robot_corners,dots_spacing,search_interval);
c_cls_shp = alphaShape(double(c_cls.Location(:,1)),double(c_cls.Location(:,2)),Threshold);

c_cls_tower_1 = double.empty(0,3);
c_cls_tower_2 = double.empty(0,3);

for i = 0:round((set_deg(1,2)-set_deg(1,1))/z_search_interval)
    theta = deg2rad(set_deg(1,1) + z);
    % rotate theta
    tf_t = [cos(theta), sin(theta), 0.0, 0.0; ...
        -sin(theta), cos(theta), 0.0, 0.0; ...
        0.0, 0.0, 1.0, 0.0; ...
        0.0, 0.0, 0.0, 1.0
    ];
    tform_t = affine3d(tf_t);
    c_cls_t = pctransform(c_cls,tform_t);
    c_cls_t = pointCloud(round([c_cls_t.Location(:,1),c_cls_t.Location(:,2),c_cls_t.Location(:,3)],10^10));
    
    % c_cls_1
    x_1 = 0;    
    y_1 = distance/2;
    tf_1 = [1.0, 0.0, 0.0, 0.0; ...
        0.0, 1.0, 0.0, 0.0; ...
        0.0, 0.0, 1.0, 0.0; ...
        x_1, y_1, z, 1.0
    ];
    tform1 = affine3d(tf_1);
    c_cls_1 = pctransform(c_cls_t,tform1);
    
    % c_cls_2
    x_2 = 0;
    y_2 = -distance/2;
    tf_2 = [1.0, 0.0, 0.0, 0.0; ...
        0.0, 1.0, 0.0, 0.0; ...
        0.0, 0.0, 1.0, 0.0; ...
        x_2, y_2, z, 1.0
    ];
    tform2 = affine3d(tf_2);
    c_cls_2 = pctransform(c_cls_t,tform2);
    
    c_cls_tower_1 = [c_cls_tower_1;[c_cls_1.Location(:,1),c_cls_1.Location(:,2),z*ones(size(c_cls_1.Location,1),1)]];
    c_cls_tower_2 = [c_cls_tower_2;[c_cls_2.Location(:,1),c_cls_2.Location(:,2),z*ones(size(c_cls_1.Location,1),1)]];
    
    disp(set_deg(1,1) + z);
    
    % top and bottom plane
    if i == 1
        [~,c_cls_tower_a_b] = boundaryFacets(alphaShape(double(c_cls_1.Location(:,1:2)),Threshold));
        [~,c_cls_tower_b_b] = boundaryFacets(alphaShape(double(c_cls_2.Location(:,1:2)),Threshold));
    end
    if i == round((set_deg(1,2)-set_deg(1,1))/z_search_interval)-1
        [~,c_cls_tower_a_t] = boundaryFacets(alphaShape(double(c_cls_1.Location(:,1:2)),Threshold));
        [~,c_cls_tower_b_t] = boundaryFacets(alphaShape(double(c_cls_2.Location(:,1:2)),Threshold));
    end
    
    z = z + z_search_interval;
end

delta = 10^-12;
Threshold_3d = search_interval*sqrt(3)/2+delta;

c_cls_3d_1_shp = alphaShape([c_cls_tower_1(:,[1,2]),compression_coefficient*c_cls_tower_1(:,3)],Threshold_3d);
c_cls_3d_2_shp = alphaShape([c_cls_tower_2(:,[1,2]),compression_coefficient*c_cls_tower_2(:,3)],Threshold_3d);

c_cls_3d_shp = alphaShape([c_cls_tower_1;c_cls_tower_2],Threshold_3d);
temp_bottom = get_base_ptcloud(search_interval,-c_free_size, c_free_size, -c_free_size, c_free_size, -z_search_interval, 0);
temp_top = get_base_ptcloud(search_interval,-c_free_size, c_free_size, -c_free_size, c_free_size, z-z_search_interval, z);
c_cls_3d = [c_cls_tower_1;c_cls_tower_2;temp_bottom.Location;temp_top.Location];
c_cls_3d_pcd = pointCloud(c_cls_3d); 

c_cls_3d_fill_shp = alphaShape(c_cls_3d_pcd.Location,Threshold_3d,'HoleThreshold',large_value);

c_cls_3d_free_base = get_base_ptcloud(search_interval,c_cls_3d_pcd.XLimits(1,1), c_cls_3d_pcd.XLimits(1,2), ...
    c_cls_3d_pcd.YLimits(1,1), c_cls_3d_pcd.YLimits(1,2), ...
    c_cls_3d_pcd.ZLimits(1,1), c_cls_3d_pcd.ZLimits(1,2));
    
tf_r = inShape(c_cls_3d_fill_shp,c_cls_3d_free_base.Location(:,1),c_cls_3d_free_base.Location(:,2),c_cls_3d_free_base.Location(:,3));


tf_rr = tf_r & ~inShape(c_cls_3d_shp,c_cls_3d_free_base.Location(:,1),c_cls_3d_free_base.Location(:,2),c_cls_3d_free_base.Location(:,3));

target_pcd = c_cls_3d_free_base.Location(tf_rr,:);
target_pcd_shp = alphaShape(target_pcd,Threshold_3d*2);

c_free_obj = c_cls_3d_free_base.Location(tf_rr ...
    & c_cls_3d_free_base.Location(:,3) >= 0 ...
    & c_cls_3d_free_base.Location(:,3) <= z - z_search_interval,:);

if isempty(c_free_obj) ~= 1
    c_free_obj_shp = alphaShape([c_free_obj(:,[1,2]),compression_coefficient*c_free_obj(:,3)],Threshold_3d,'HoleThreshold',large_value);
end