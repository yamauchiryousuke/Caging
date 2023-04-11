% show data

circle_r = 60;
theta = [0,360];
depth_rate = 2;

fig_num = 1;

if fig_num == 1 % show mccr 
    figure
    hold on
    
    show_num = 1;
    cc_num = size(properties(cc_group),1);
    
    
    for str = char(sort(cellstr(properties(cc_group))))'
        show_num = show_num * depth_rate;
        %if (str' == 'cc_02')
        scatter(cc_group.(matlab.lang.makeValidName(str'))(:,1)/2,cc_group.(matlab.lang.makeValidName(str'))(:,2)/2,1*10,'filled','MarkerFaceColor','magenta','MarkerFaceAlpha', show_num/(depth_rate^cc_num));
        %scatter(cc_group.(matlab.lang.makeValidName(str'))(:,1),cc_group.(matlab.lang.makeValidName(str'))(:,2),2.0,'filled','MarkerFaceColor','magenta','MarkerFaceAlpha', show_num*0.05);
        %end
    end
    
    scatter(0,0,2.0,'filled','MarkerFaceColor','black','MarkerFaceAlpha', 1);
    %show_num = show_num * depth_rate;
    %scatter(cc_group.(matlab.lang.makeValidName(str'))(:,1),cc_group.(matlab.lang.makeValidName(str'))(:,2),2.0,'filled','MarkerFaceColor','magenta','MarkerFaceAlpha', show_num/(depth_rate^cc_num));
    
    if isempty(check_boundary) == 0
        scatter(check_boundary(:,1)/2,check_boundary(:,2)/2,0.5*10,'filled','MarkerFaceColor','blue','MarkerFaceAlpha',1.0);
    end

    if isempty(vb) == 0
        scatter(vb(:,1)/2,vb(:,2)/2,0.5*10,'filled','MarkerFaceColor','red','MarkerFaceAlpha',1.0);
    end
    
    
    title(sprintf('Multi Dual C Closure Regions and d = %0.1f',circle_r),sprintf('(r = %0.1f[mm], search interval =  %0.1f[mm])',robot_r,dcc_search_interval))
    xlabel('x[mm]');
    ylabel('y[mm]');

    axis on
    axis equal
    xlim([-160 160])
    ylim([-110 110])
    hold off
    print(strcat('result/result_',sprintf(datestr(datetime('now'),'yyyy_mm_dd_HH_MM_ss_FFF'))),'-dpng','-r300')

    figure;
    axis image
    scatter(check_boundary(:,1),check_boundary(:,2),0.5*2,'filled','MarkerFaceColor','blue','MarkerFaceAlpha',1.0);
    daspect([1 1 1])
    
elseif fig_num == 2 % show mccr and circle
    figure
    hold on
    
    show_num = 1;
    cc_num = size(properties(cc_group),1);

    for str = char(sort(cellstr(properties(cc_group))))'
        show_num = show_num * depth_rate;
        scatter(cc_group.(matlab.lang.makeValidName(str'))(:,1),cc_group.(matlab.lang.makeValidName(str'))(:,2),2.0,'filled','MarkerFaceColor','magenta','MarkerFaceAlpha', show_num/(depth_rate^cc_num));
        %scatter(cc_group.(matlab.lang.makeValidName(str'))(:,1),cc_group.(matlab.lang.makeValidName(str'))(:,2),1.0,'filled','MarkerFaceColor','magenta','MarkerFaceAlpha', show_num*0.01);
    end

    if isempty(check_boundary) == 0
        scatter(check_boundary(:,1),check_boundary(:,2),2.0,'filled','MarkerFaceColor','blue','MarkerFaceAlpha',1.0);
    end

    if isempty(vb) == 0
        scatter(vb(:,1),vb(:,2),2.0,'filled','MarkerFaceColor','red','MarkerFaceAlpha',1.0);
    end
    
    % show circles
    circle_corners = 200;
    %circle_x = round(circle_r*cos(transpose(1:circle_corners)*2*pi/circle_corners),3);
    %circle_y = round(circle_r*sin(transpose(1:circle_corners)*2*pi/circle_corners),3);
    %circle_poly = polyshape(transpose(circle_x),transpose(circle_y),'Simplify',true);
    %plot(circle_poly,'LineWidth',1.5,'FaceAlpha',0.0,'EdgeColor',[0,0.388,0.211]);
    circle_x = circle_r*cos(deg2rad(theta(851,1):0.1:theta(1,2))+(pi/2));
    circle_y = circle_r*sin(deg2rad(theta(1,1):0.1:theta(1,2))+(pi/2)); 
    plot(circle_x,circle_y,'Color','green');
    scatter(0,0,10,'filled','MarkerFaceColor','black');
    
    %title(sprintf('Dual C Closure Regions and d = %0.1f',circle_r),sprintf('(r = %0.1f[mm], search interval =  %0.1f[mm])',robot_r,dcc_search_interval))
    title(sprintf('Multi Dual C Closure Regions and d = %0.1f',circle_r),sprintf('(r = %0.1f[mm], search interval =  %0.1f[mm])',robot_r,dcc_search_interval))
    xlabel('x[mm]');
    ylabel('y[mm]');
    
    axis on
    axis equal
    xlim([-400 400])
    ylim([-250 150])
    hold off
    
    %print(strcat('result/result_',sprintf(datestr(datetime('now'),'yyyy_mm_dd_HH_MM_ss_FFF'))),'-dpng','-r300')
    
end