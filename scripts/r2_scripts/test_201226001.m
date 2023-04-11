file_name = '../../img/test_x004.png'; % 対象物体となる画像ファイル(png)
c_cls_search_interval = 0.2;
robot_r = 5;

dcc_search_interval = 1*c_cls_search_interval;
theta_interval = 1;

dc = 31;
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

theta = -90: theta_interval: 90;
del_theta = deg2rad(1);

polyout_before_regions = Regions;
    
for i = 1 : size(theta,2)    
    target_theta = theta(1,i);
    
    polyout_after_regions = Regions;
    polygon_t = rotate(polygon,target_theta);
    
    if i == 1
        polyout1_regions = Regions;
        polygon1 = translate(rotate(polygon,target_theta),[0,dc]);
        polyout1 = intersect(polygon_t,polygon1);
        polyout1  = sortboundaries(polyout1,'centroid','ascend');
        for n = 1: numboundaries(polyout1)
            [x, y] = boundary(polyout1,n);

            poly_str = strcat('d_',sprintf('%02d',n));
            polyout1_regions.addprop(poly_str);
            polyout1_regions.(matlab.lang.makeValidName(['d_',sprintf('%02d',n)])) = polyshape(x,y);
        end
        polyout_before_regions = polyout1_regions;
    end  
    
    polygon2 = translate(rotate(polygon,target_theta+del_theta),[0,dc]);
    polyout2_regions = Regions;
    polyout2 = intersect(polygon_t,polygon2);
    polyout2  = sortboundaries(polyout2,'centroid','ascend');

    for n = 1: numboundaries(polyout2)
        [x, y] = boundary(polyout2,n);

        poly_str = strcat('d_',sprintf('%02d',n));
        polyout2_regions.addprop(poly_str);
        polyout2_regions.(matlab.lang.makeValidName(['d_',sprintf('%02d',n)])) = polyshape(x,y);
    end
    
    reg_val = 0;
    poly_name_before_list = char(sort(cellstr(properties(polyout_before_regions))));
    
    % beforeとp2で重なる領域をafter追加する
    
    for str_before = char(sort(cellstr(properties(polyout_before_regions))))'
        for str_p2 = char(sort(cellstr(properties(polyout2_regions))))'
            poly_union = intersect( ...
                polyout_before_regions.(matlab.lang.makeValidName(str_before')), polyout2_regions.(matlab.lang.makeValidName(str_p2')) ...
            );
            if numboundaries(poly_union) > 0 % 各重なりが重なった場合            
                poly_name_after_list = char(sort(cellstr(properties(polyout_after_regions))));
                if nnz(ismember(poly_name_after_list,str_before','rows')) == 0 % afterにまだ追加されていない場合
                    polyout_after_regions.addprop(str_before');
                    polyout_after_regions.(matlab.lang.makeValidName(str_before')) = polyout2_regions.(matlab.lang.makeValidName(str_p2'));
                else % afterにすでに追加されていた場合
                    %reg_val = reg_val + 1;
                    %polyout_after_regions.addprop(matlab.lang.makeValidName(['d_',sprintf('%02d',size(poly_name_before_list,1)+reg_val)]));
                    polyout_after_regions.(matlab.lang.makeValidName(str_before')) = ...
                        union(polyout_after_regions.(matlab.lang.makeValidName(str_before')),polyout2_regions.(matlab.lang.makeValidName(str_p2')));
                end   
            end
        end
    end
    
    % p2にのみ存在する領域をaftar追加する
    for str_p2 = char(sort(cellstr(properties(polyout2_regions))))'
        exit_fg = false;
        for str_after = char(sort(cellstr(properties(polyout_after_regions))))'
            poly_union = intersect( ...
                polyout_after_regions.(matlab.lang.makeValidName(str_after')), polyout2_regions.(matlab.lang.makeValidName(str_p2')) ...
            );
            if numboundaries(poly_union) > 0
                exit_fg = true;
            end
        end
        if exit_fg == false
            reg_val = reg_val + 1;
            polyout_after_regions.addprop(strcat('d_',sprintf('%02d',size(poly_name_before_list,1)+reg_val)));
            polyout_after_regions.(matlab.lang.makeValidName(['d_',sprintf('%02d',size(poly_name_before_list,1)+reg_val)])) = polyout2_regions.(matlab.lang.makeValidName(str_p2'));
        end
    end
    
    % beforeにのみ存在する領域を空にする
    for  str_before = char(sort(cellstr(properties(polyout_before_regions))))'
        poly_name_after_list = char(sort(cellstr(properties(polyout_after_regions))));
        if nnz(ismember(poly_name_after_list,str_before','rows')) == 0
            polyout_after_regions.addprop(str_before');
            polyout_after_regions.(matlab.lang.makeValidName(str_before')) = polyshape();             
        end
    end
    
    polyout_before_regions = polyout_after_regions;
    
    disp(i)
    disp(char(sort(cellstr(properties(polyout_before_regions)))))
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    savefigure = figure('visible','off');
    hold on
    
    plot(polygon_t,'FaceColor','green','FaceAlpha',0.0,'EdgeColor' ,'black','LineStyle' ,':');
    scatter(0,0,5.0,'filled','MarkerFaceColor','black','MarkerFaceAlpha',1.0);
    plot(polygon2,'FaceColor','green','FaceAlpha',0.0,'EdgeColor' ,'black','LineStyle' ,':');
    scatter(0,dc,5.0,'filled','MarkerFaceColor','black','MarkerFaceAlpha',1.0);
    
    name_list = char(sort(cellstr(properties(polyout_after_regions))));
    show_num = size(char(sort(cellstr(properties(polyout_after_regions))))',2);
    prism_c = prism(show_num);
    for num = 1 : show_num
        %if strcmp(name_list(num,:),strcat('d_',sprintf('%02d',show_num)))
            plot(polyout_after_regions.(matlab.lang.makeValidName(name_list(num,:))),'FaceColor',prism_c(num,:),'FaceAlpha',0.2,'EdgeColor' ,'black');
        %end
    end
    
    axis on
    axis equal
    xlim([-100 100])
    ylim([-100 100])
    xlabel('x[mm]');
    ylabel('y[mm]');
    axis on
    axis equal
    xlim manual
    ylim manual
    hold off
    
    title(sprintf( 'theta = %0.1f[deg], D_{c} = %0.1f[mm] \n r = %0.1f[mm], search interval =  %0.1f[mm])',target_theta,dc,robot_r,c_cls_search_interval))
    
    savename = strcat('result/',sprintf('%03d',i),'.png');
    saveas(savefigure,savename)
    close all hidden
    
    disp(strcat("Finished file output : ",savename))
end