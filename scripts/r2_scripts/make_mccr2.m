% test script of makeing multh c-closure region

s_x = round(robot_r*cos(transpose(1:robot_corners)*2*pi/robot_corners),3);
s_y = round(robot_r*sin(transpose(1:robot_corners)*2*pi/robot_corners),3);

c_cls = get_C_closure_object2d(file_name,robot_r,robot_corners,dots_spacing,c_cls_search_interval);
object_X = c_cls.XLimits(1,2)-c_cls.XLimits(1,1);
object_Y = c_cls.YLimits(1,2)-c_cls.YLimits(1,1);

c_cls_1_shp_out = alphaShape(double(c_cls.Location(:,1:2)), c_cls_search_interval/(fix(sqrt(2)*(10^10))/(10^10)),'HoleThreshold',10^12);
c_cls_1_shp_all = alphaShape(double(c_cls.Location(:,1:2)), c_cls_search_interval/(fix(sqrt(2)*(10^10))/(10^10)));

[~,c_cls_1_out_b] = boundaryFacets(c_cls_1_shp_out);
[~,c_cls_1_all_b] = boundaryFacets(c_cls_1_shp_all);

c_cls_1_in_b = c_cls_1_all_b(~ismember(c_cls_1_all_b,c_cls_1_out_b,'rows'),:);

cc_group = CC_Point_Clouds;

polygon_in = scale(polyshape(transpose(c_cls_1_in_b(:,1)),transpose(c_cls_1_in_b(:,2)),'Simplify',true),1+delta,[0,0]);
polygon_out = scale(polyshape(transpose(c_cls_1_out_b(:,1)),transpose(c_cls_1_out_b(:,2)),'Simplify',true),1-delta,[0,0]);

polygon = xor(polygon_in,polygon_out);

for i = 0:round(object_Y/dcc_search_interval)+1
    for j = 0: 2*round(object_X/dcc_search_interval)+1
        polygon_t = translate(polygon, ...
            [dcc_search_interval*(j-(1+round(object_X/dcc_search_interval))), ...
            dcc_search_interval*(i-(1+round(object_Y/dcc_search_interval)))]);
        center_point = [dcc_search_interval*(j-(1+round(object_X/dcc_search_interval))), ...
            dcc_search_interval*(i-(1+round(object_Y/dcc_search_interval))),0];
       
        polyout = intersect(polygon,polygon_t);
        N = numboundaries(polyout)-polyout.NumHoles;

        
        if N > 0
            cc_str = strcat('cc_',sprintf('%02d',N));
            if isprop(cc_group, cc_str) == false
                cc_group.addprop(cc_str);
                cc_group.(matlab.lang.makeValidName(['cc_',sprintf('%02d',N)])) = double.empty(0,3);
            end
            
            cc_group.(matlab.lang.makeValidName(['cc_',sprintf('%02d',N)])) = [cc_group.(matlab.lang.makeValidName(['cc_',sprintf('%02d',N)]));center_point;-center_point];
        end
    end
end

cc_group_pro_name = sort(cell2mat(properties(cc_group)));

for i = 1: size(cc_group_pro_name,1)
    cc_group.(matlab.lang.makeValidName(cc_group_pro_name(i,:))) = unique(cc_group.(matlab.lang.makeValidName(cc_group_pro_name(i,:))),'rows');
end