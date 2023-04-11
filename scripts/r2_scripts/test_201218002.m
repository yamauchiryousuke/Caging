file_name = '../../img/test_009.png'; % 対象物体となる画像ファイル(png)
c_cls_search_interval = 1.0;
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

theta =0:deg2rad(1):deg2rad(180);

dc_set = 35:1:35;
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

del_theta = deg2rad(1);
separete_theta_array = double.empty(0,2);

for check_theta = check_theta_array(:,2)'
    st_fg = 0;
    
    polygon1 = translate(polygon,[dc*cos(-check_theta+del_theta),dc*sin(-check_theta+del_theta)]);
    polygon2 = translate(polygon,[dc*cos(-check_theta),dc*sin(-check_theta)]);
    
    polyout1 = intersect(polygon,polygon1);
    polyout2 = intersect(polygon,polygon2);
    
    polyout1  = sortboundaries(polyout1,'centroid','ascend');
    polyout2  = sortboundaries(polyout2,'centroid','ascend');
    
    polyout1_regions = Regions;
    polyout2_regions = Regions;
    
    for n = 1: numboundaries(polyout1)
        [x, y] = boundary(polyout1,n);

        poly_str = strcat('d_',sprintf('%02d',n));
        polyout1_regions.addprop(poly_str);
        polyout1_regions.(matlab.lang.makeValidName(['d_',sprintf('%02d',n)])) = polyshape(x,y);
    end
    
    for n = 1: numboundaries(polyout2)
        [x, y] = boundary(polyout2,n);

        poly_str = strcat('d_',sprintf('%02d',n));
        polyout2_regions.addprop(poly_str);
        polyout2_regions.(matlab.lang.makeValidName(['d_',sprintf('%02d',n)])) = polyshape(x,y);
    end
    
    for n = 1: numboundaries(polyout1)
    
        fg_value = 0;
        
        for m = 1: numboundaries(polyout2)
            poly_union = intersect( ...
                polyout1_regions.(matlab.lang.makeValidName(['d_',sprintf('%02d',n)])), ...
                polyout2_regions.(matlab.lang.makeValidName(['d_',sprintf('%02d',m)])) ...
            );
            if numboundaries(poly_union) > 0
                fg_value = fg_value + 1;
            end
        end
        
        if fg_value > 1
            st_fg =  1;
        end
        
    end
    
    if st_fg == 1
        separete_theta_array = [separete_theta_array;dc ,check_theta];
    end
 end

figure
polarscatter(check_theta_array(:,2),check_theta_array(:,1),20,'filled','MarkerFaceColor','black')    
hold on
polarscatter(separete_theta_array(:,2),separete_theta_array(:,1),20,'filled','MarkerFaceColor','blue')
hold off