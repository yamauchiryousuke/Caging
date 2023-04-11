file_name = '../../img/test_loop_001.png'; % ‘ÎÛ•¨‘Ì‚Æ‚È‚é‰æ‘œƒtƒ@ƒCƒ‹(png)
c_cls_search_interval = 1;
robot_r = 5;

dcc_search_interval = 1*c_cls_search_interval;
robot_corners = 36;
dots_spacing = 1.0;
delta = 10^-8;

addpath('../../func','-end')
addpath('../../class','-end')

c_cls = get_C_closure_object2d(file_name,robot_r,robot_corners,dots_spacing,c_cls_search_interval);

object_X = c_cls.XLimits(1,2)-c_cls.XLimits(1,1);
object_Y = c_cls.YLimits(1,2)-c_cls.YLimits(1,1);

c_cls_1_shp = alphaShape(double(c_cls.Location(:,1:2)), c_cls_search_interval/(fix(sqrt(2)*(10^10))/(10^10)),'HoleThreshold',10^12);
[~,c_cls_1_b] = boundaryFacets(c_cls_1_shp);

polygon = polyshape(transpose(c_cls_1_b(:,1)),transpose(c_cls_1_b(:,2)),'Simplify',true);

polygon = scale(polygon,1+delta,[0,0]);

theta =0:deg2rad(0.2):deg2rad(360);

dc_set = 0:1:200;
n_array = double.empty(0,2);
check_theta_array = double.empty(0,2);

for dc = dc_set
    for i = 1 : size(theta,2)       
        target_theta = -theta(1,i);
        polygon_t = translate(polygon,[dc*cos(target_theta), dc*sin(target_theta)]);
        polyout = intersect(polygon,polygon_t);
        N = numboundaries(polyout);
        n_array = [n_array; dc, N];
        
        if i > 1
            if n_array(size(n_array,1),2) ~= n_array(size(n_array,1)-1,2)
                check_theta_array = [check_theta_array; dc, theta(1,i)];
            end
        end
    end
end

polarscatter(check_theta_array(:,2),check_theta_array(:,1),5,'filled','MarkerFaceColor','black')    