% show data

circle_r = 36;
theta = [0,0];
depth_rate = 6;

for deg = 46:1:52
    theta = deg2rad(deg);
    
    savefigure = figure('visible','off');
    %figure
    hold on

    show_num = 1;
    cc_num = size(properties(cc_group),1);

    for str = char(sort(cellstr(properties(cc_group))))'
        show_num = show_num * depth_rate;
        scatter(cc_group.(matlab.lang.makeValidName(str'))(:,1),cc_group.(matlab.lang.makeValidName(str'))(:,2),2.0,'filled','MarkerFaceColor','magenta','MarkerFaceAlpha', show_num/(depth_rate^cc_num));
    end
    
    circle_corners = 200;
    circle_x = round(dc*cos(transpose(1:circle_corners)*2*pi/circle_corners),3);
    circle_y = round(dc*sin(transpose(1:circle_corners)*2*pi/circle_corners),3);
    circle_poly = polyshape(transpose(circle_x),transpose(circle_y),'Simplify',true);
    plot(circle_poly,'LineWidth',1.0,'FaceAlpha',0.0,'EdgeColor',[0,0.388,0.211]);
     
    if isempty(check_boundary) == 0
        scatter(check_boundary(:,1),check_boundary(:,2),0.5,'filled','MarkerFaceColor','blue','MarkerFaceAlpha',1.0);
    end

    if isempty(vb) == 0
        scatter(vb(:,1),vb(:,2),0.5,'filled','MarkerFaceColor','red','MarkerFaceAlpha',1.0);
    end
    
    scatter(0,0,10.0,'filled','MarkerFaceColor','black','MarkerFaceAlpha', 1);
    scatter(dc*sin(theta),dc*cos(theta),10.0,'filled','MarkerFaceColor','black','MarkerFaceAlpha', 1);
       
    axis off
    axis equal
    xlim([-150 150])
    ylim([-100 100])
    hold off
    print(savefigure,strcat('result_',sprintf('%03d',deg)),'-dpng','-r300')

    %savename = strcat('result/',sprintf('%03d',n),'.png');
    %saveas(savefigure,savename)
    %close all hidden
end

close all hidden