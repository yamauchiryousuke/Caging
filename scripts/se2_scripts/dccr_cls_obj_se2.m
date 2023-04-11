% SE(2)のCC

file_name = '../../img/sample.png';
robot_r = 5;
robot_corners = 24;
dots_spacing = 1;
search_interval = 1.0;
compression_coefficient = 0.5;
expand_val = 3;
set_deg = [0,360];
show_c_free_num = 7;

% c_free_objになりゆる範囲
c_free_range = 30;

% エンドエフェクタの位置をposition_matに入れる

position_mat = [ ...
    0, -35/2;
    0, 35/2;
];

z_search_interval = search_interval;
Threshold = search_interval/(fix(sqrt(2)*(10^10))/(10^10));
large_value = 10^16;

addpath('../../func','-end')
addpath('../../class','-end')

z = 0;
c_cls_tower = double.empty(0,3);
cc_cls_tower = double.empty(0,3);
dccr_tower = double.empty(0,3);
c_free = double.empty(0,3);
c_cls = get_C_closure_object2d(file_name,robot_r,robot_corners,dots_spacing,search_interval);
c_cls_shp = alphaShape(double(c_cls.Location(:,1)),double(c_cls.Location(:,2)),Threshold);

cc_cls = get_CC_closure_object2d(c_cls,dots_spacing,search_interval);
cc_cls_shp = alphaShape(double(cc_cls.Location(:,1)),double(cc_cls.Location(:,2)),Threshold);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delta = 10^-8;

object_X = c_cls.XLimits(1,2)-c_cls.XLimits(1,1);
object_Y = c_cls.YLimits(1,2)-c_cls.YLimits(1,1);
c_cls_1_shp = alphaShape(double(c_cls.Location(:,1:2)),search_interval/(fix(sqrt(2)*(10^10))/(10^10)),'HoleThreshold',10^12);
[~,c_cls_1_b] = boundaryFacets(c_cls_1_shp);

cc_group = CC_Point_Clouds;

polygon = scale(polyshape(transpose(c_cls_1_b(:,1)),transpose(c_cls_1_b(:,2)),'Simplify',true),1+delta,[0,0]);

for i = 0:round(object_Y/search_interval)+1
    for j = 0: 2*round(object_X/search_interval)+1
        polygon_t = translate(polygon, ...
            [search_interval*(j-(1+round(object_X/search_interval))), ...
            search_interval*(i-(1+round(object_Y/search_interval)))]);
        center_point = [search_interval*(j-(1+round(object_X/search_interval))), ...
            search_interval*(i-(1+round(object_Y/search_interval))),0];
        
        polyout = intersect(polygon,polygon_t);
        N = numboundaries(polyout);
        
        if N > 0
            cc_str = strcat('cc_',sprintf('%02d',N));
            if isprop(cc_group, cc_str) == false
                cc_group.addprop(cc_str);
                cc_group.(genvarname(['cc_',sprintf('%02d',N)])) = double.empty(0,3);
            end
            
            cc_group.(genvarname(['cc_',sprintf('%02d',N)])) = [cc_group.(genvarname(['cc_',sprintf('%02d',N)]));center_point;-center_point];
        end
    end
end

cc_group_pro_name = sort(cell2mat(properties(cc_group)));

for i = 1: size(cc_group_pro_name,1)
    cc_group.(genvarname(cc_group_pro_name(i,:))) = unique(cc_group.(genvarname(cc_group_pro_name(i,:))),'rows');
end

dccr_shp = alphaShape(double(cc_group.cc_02(:,1)),double(cc_group.cc_02(:,2)),search_interval/(fix(sqrt(2)*(10^10))/(10^10)));
dccr_pcd = pointCloud(cc_group.cc_02);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pointclouds = PointClouds;

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
   
    cc_cls_t = pctransform(cc_cls,tform_t);
    cc_cls_t = pointCloud(round([cc_cls_t.Location(:,1),cc_cls_t.Location(:,2),cc_cls_t.Location(:,3)],10^10));
    
    dccr_t = pctransform(dccr_pcd,tform_t);
    dccr_t = pointCloud(round([dccr_t.Location(:,1),dccr_t.Location(:,2),dccr_t.Location(:,3)],10^10));
    
    len = size(position_mat,1);

    for i= 1 : len
        
        tf_tran = [1.0, 0.0, 0.0, 0.0; ...
        0.0, 1.0, 0.0, 0.0; ...
        0.0, 0.0, 1.0, 0.0; ...
        position_mat(i,1), position_mat(i,2), z, 1.0
        ];
        tf_tran = affine3d(tf_tran);

        temp_c = pctransform(c_cls_t, tf_tran);
        temp_cc = pctransform(cc_cls_t, tf_tran);
        
        temp_dccr = pctransform(dccr_t, tf_tran);
        temp_dccr = pctransform(dccr_t, tf_tran);
        
        c_cls_tower = [c_cls_tower;[ ...
            temp_c.Location(:,1), ...
            temp_c.Location(:,2), ...
            z*ones(size(temp_c.Location,1),1)*compression_coefficient] ...
        ];
    
        if i == 1
            cc_cls_tower = [cc_cls_tower;[ ...
                temp_cc.Location(:,1), ...
                temp_cc.Location(:,2), ...
                z*ones(size(temp_cc.Location,1),1)*compression_coefficient] ...
            ];
            disp(z)
            dccr_tower = [dccr_tower;[ ...
                temp_dccr.Location(:,1), ...
                temp_dccr.Location(:,2), ...
                z*ones(size(temp_dccr.Location,1),1)*compression_coefficient] ...
            ];
        end
    end
    
    disp(set_deg(1,1) + z);
    
    z = z + z_search_interval;
end

delta = 10^-12;
Threshold_3d = search_interval*sqrt(3)/2+delta;
c_cls_3d_shp = alphaShape(c_cls_tower,Threshold_3d);
cc_cls_3d_shp = alphaShape(cc_cls_tower,Threshold_3d);
dccr_3d_shp = alphaShape(dccr_tower,Threshold_3d);
c_free_3d_shp = alphaShape(c_free,Threshold_3d);