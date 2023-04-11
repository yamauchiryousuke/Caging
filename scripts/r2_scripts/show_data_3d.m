% show data

circle_r = 60;
theta = [0,360];
depth_rate = 2;

 
    figure
    hold on
    
    show_num = 1;
    cc_num = size(properties(cc_group),1);
    
    
    for str = char(sort(cellstr(properties(cc_group))))'
        show_num = show_num * depth_rate;
        ptCloud = pointCloud(cc_group.(matlab.lang.makeValidName(str')));
        for t = 0:20:360
        A = [1 0 0 0; ...
            0 cosd(t) -sind(t) 0; ...
            0 sind(t) cosd(t) 0; ...
            0 0 0 1];
        tform = affine3d(A);
        cc_group_ptCloud = pctransform(ptCloud,tform);
        aa= pcshow(cc_group_ptCloud,"BackgroundColor",'white');
        %pcshow(cc_group_ptCloud,'magenta','MarkerFaceAlpha', show_num/(depth_rate^cc_num));
        %scatter3(cc_group_ptCloud.Location(:,1),cc_group.(matlab.lang.makeValidName(str'))(:,2),cc_group.(matlab.lang.makeValidName(str'))(:,3),1*2,'filled','MarkerFaceColor','magenta','MarkerFaceAlpha', show_num/(depth_rate^cc_num));
        %scatter(cc_group.(matlab.lang.makeValidName(str'))(:,1),cc_group.(matlab.lang.makeValidName(str'))(:,2),2.0,'filled','MarkerFaceColor','magenta','MarkerFaceAlpha', show_num*0.05);
        end
    end
    
    scatter3(0,0,0,2.0,'filled','MarkerFaceColor','black','MarkerFaceAlpha', 1);
    %show_num = show_num * depth_rate;
    %scatter(cc_group.(matlab.lang.makeValidName(str'))(:,1),cc_group.(matlab.lang.makeValidName(str'))(:,2),2.0,'filled','MarkerFaceColor','magenta','MarkerFaceAlpha', show_num/(depth_rate^cc_num));
    
    if isempty(check_boundary) == 0
        check_boundary_3d = check_boundary;
        check_boundary_3d(:,3) = 0;
        check_boundary_3d(:,4) = 1;
        for t = 0:20:360
        A = [1 0 0 0; ...
            0 cosd(t) -sind(t) 0; ...
            0 sind(t) cosd(t) 0; ...
            0 0 0 1];
        check_boundary_3d=A*check_boundary_3d.';
        check_boundary_3d=check_boundary_3d.';
        scatter3(check_boundary_3d(:,1),check_boundary_3d(:,2),check_boundary_3d(:,3),0.5*2,'filled','MarkerFaceColor','blue','MarkerFaceAlpha',1.0);
        end
    end

    if isempty(vb) == 0
        vb_3d = vb;
        vb_3d(:,3) = 0;
        vb_3d(:,4) = 1;
        for t = 0:20:360
        A = [1 0 0 0; ...
            0 cosd(t) -sind(t) 0; ...
            0 sind(t) cosd(t) 0; ...
            0 0 0 1];
        vb_3d=A*vb_3d.';
        vb_3d=vb_3d.';
        scatter3(vb_3d(:,1),vb_3d(:,2),vb_3d(:,3),0.5*2,'filled','MarkerFaceColor','red','MarkerFaceAlpha',1.0);
        end
    end
    
    
    title(sprintf('Multi Dual C Closure Regions and d = %0.1f',circle_r),sprintf('(r = %0.1f[mm], search interval =  %0.1f[mm])',robot_r,dcc_search_interval))
    xlabel('x[mm]');
    ylabel('y[mm]');
    ylabel('z[mm]');

    axis on
    axis equal
    hold off
    %print(strcat('result/result_',sprintf(datestr(datetime('now'),'yyyy_mm_dd_HH_MM_ss_FFF'))),'-dpng','-r300')