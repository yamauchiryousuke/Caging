 % SE(2)のC-Closure Objectの描画

file_name = '../../img/test_001.png';
robot_r = 5;
robot_corners = 24;
dots_spacing = 1;
search_interval = 1.0;
compression_coefficient = 0.5;
expand_val = 1;
set_deg = [0,360];

% エンドエフェクタの位置をposition_matに入れる
distance = 30;
position_mat = [ ...
    0,distance/2;
    0,-distance/2
];

show_c_free_num = 20;

% c_free_objになりうる範囲
c_free_range = 50;

z_search_interval = search_interval;
Threshold = search_interval/(fix(sqrt(2)*(10^10))/(10^10));
large_value = 10^16;

addpath('../../func','-end')
addpath('../../class','-end')

z = 0;
c_cls_tower = double.empty(0,3);
or_tower = double.empty(0,3);
c_free = double.empty(0,3);
c_cls = get_C_closure_object2d(file_name,robot_r,robot_corners,dots_spacing,search_interval);
c_cls_shp = alphaShape(double(c_cls.Location(:,1)),double(c_cls.Location(:,2)),Threshold);

for n = 0:round((set_deg(1,2)-set_deg(1,1))/z_search_interval)
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
   
    len = size(position_mat,1);

    for i= 1 : len
        
        tf_tran = [1.0, 0.0, 0.0, 0.0; ...
        0.0, 1.0, 0.0, 0.0; ...
        0.0, 0.0, 1.0, 0.0; ...
        position_mat(i,1), position_mat(i,2), z, 1.0
        ];
        tf_tran = affine3d(tf_tran);

        temp_c = pctransform(c_cls_t, tf_tran);
        
        c_cls_tower = [c_cls_tower;[ ...
            temp_c.Location(:,1), ...
            temp_c.Location(:,2), ...
            z*ones(size(temp_c.Location,1),1)*compression_coefficient] ...
        ];
        
        if i == 1
            or_canditate_point = temp_c.Location(:,1:2);
        else
            tmp_c_shp = alphaShape(double(temp_c.Location(:,1:2)), search_interval/(fix(sqrt(2)*(10^10))/(10^10)),'HoleThreshold',10^12);
            in_point_id = inShape(tmp_c_shp,or_canditate_point(:,1),or_canditate_point(:,2));
            or_canditate_point = or_canditate_point(in_point_id,:);
        end
    end
    
    or_tower = [or_tower;[ ...
            or_canditate_point(:,1), ...
            or_canditate_point(:,2), ...
            z*ones(size(or_canditate_point,1),1)*compression_coefficient] ...
        ];
    
    % make c_free
    temp_i = 1;
    temp_pt_base = zeros(1000,2);
    for temp_x=round(-c_free_range/search_interval)-1:round(c_free_range/search_interval)+1
        for temp_y=round(-c_free_range/search_interval)-1:round(c_free_range/search_interval)+1
                temp_pt_base(temp_i,:) = search_interval*[temp_x,temp_y];
                temp_i = temp_i + 1;
        end
    end

    temp_shp = alphaShape(double(c_cls_tower(c_cls_tower(:,3) == z*compression_coefficient,1:2)),Threshold);
    in = ~(inShape(temp_shp,temp_pt_base(:,1),temp_pt_base(:,2)));
    
    large_value = 10^16;
    temp_trim_shp = alphaShape(double(c_cls_tower(c_cls_tower(:,3) == z*compression_coefficient,1:2)),Threshold*expand_val,'HoleThreshold',large_value);
    in = in & (inShape(temp_trim_shp,temp_pt_base(:,1),temp_pt_base(:,2)));
    
    c_free = [c_free;[ ...
        temp_pt_base(in,1), ...
        temp_pt_base(in,2), ...
        z*ones(size(temp_pt_base(in,:),1),1)*compression_coefficient] ...
    ];
       
    disp(set_deg(1,1) + z);
    
    z = z + z_search_interval;
end

delta = 10^-12;
Threshold_3d = search_interval*sqrt(3)/2+delta;
c_cls_3d_shp = alphaShape(c_cls_tower,Threshold_3d);
c_free_3d_shp = alphaShape(c_free,Threshold_3d);

or_3d_shp = alphaShape(or_tower,Threshold_3d);

c_free_part = PointClouds;
check_outer_pcd = c_cls_tower;

if show_c_free_num <= numRegions(c_free_3d_shp)
    for i = 1: show_c_free_num
        c_free_part_str = strcat('cf_shp_',sprintf('%02d',i));
        c_free_part.addprop(c_free_part_str);
        
        c_free_part_pcd = c_free(inShape(c_free_3d_shp,c_free(:,1),c_free(:,2),c_free(:,3),i),:);
        c_free_part.(genvarname(['cf_shp_',sprintf('%02d',i)])) = alphaShape(c_free_part_pcd,Threshold_3d);
        check_outer_pcd = [check_outer_pcd;c_free_part_pcd];
    end

else
    for i = 1: numRegions(c_free_3d_shp)
        c_free_part_str = strcat('cf_shp_',sprintf('%02d',i));
        c_free_part.addprop(c_free_part_str);
        c_free_part.(genvarname(['cf_shp_',sprintf('%02d',i)])) = alphaShape(c_free(inShape(c_free_3d_shp,c_free(:,1),c_free(:,2),c_free(:,3),i),:),Threshold_3d);
    end
end

[~ , outer_pcd] = boundaryFacets(alphaShape(check_outer_pcd,Threshold_3d*expand_val));
result_pcd = double.empty(0,3);

for str = char(sort(cellstr(properties(c_free_part))))'
    [~,c_free_outer] =boundaryFacets(c_free_part.(genvarname(str')));
    result_pcd = [result_pcd; intersect(c_free_outer,outer_pcd,'rows')];
end