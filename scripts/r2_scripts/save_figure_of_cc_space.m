dc = 36;
depth_rate = 2;
theta = [117 243];

for tmp_theta = theta(1,1) : 1 : theta(1,2)
    
    savefigure = figure('visible','off');
    
    hold on

    show_num = 1;
    cc_num = size(properties(cc_group),1);

    addpath('../../func','-end')
    addpath('../../class','-end')

    for str = char(sort(cellstr(properties(cc_group))))'
        show_num = show_num * depth_rate;
        scatter(cc_group.(matlab.lang.makeValidName(str'))(:,1),cc_group.(matlab.lang.makeValidName(str'))(:,2),2.0,'filled','MarkerFaceColor','magenta','MarkerFaceAlpha', show_num/(depth_rate^cc_num));
    end

    if isempty(check_boundary) == 0
        scatter(check_boundary(:,1),check_boundary(:,2),2.0,'filled','MarkerFaceColor','blue','MarkerFaceAlpha',1.0);
    end

    if isempty(vb) == 0
        scatter(vb(:,1),vb(:,2),2.0,'filled','MarkerFaceColor','red','MarkerFaceAlpha',1.0);
    end

    % show circles
    circle_corners = 200;
    circle_x = dc*cos(deg2rad(theta(1,1):0.1:theta(1,2))+(pi/2));
    circle_y = dc*sin(deg2rad(theta(1,1):0.1:theta(1,2))+(pi/2)); 
    plot(circle_x,circle_y,'Color',[0.2,0.5,0.2],'LineWidth',1);

    scatter(0,0,10,'filled','MarkerFaceColor','black');

    scatter(dc*cos(deg2rad(tmp_theta)+pi/2),dc*sin(deg2rad(tmp_theta )+pi/2),10,'filled','MarkerFaceColor',[0.2,1.0,0.2]);

    xlabel('x[mm]');
    ylabel('y[mm]');

    axis on
    axis equal
    xlim([-100 100])
    ylim([-100 100])
    
    savename = strcat('result/',sprintf('%03d',tmp_theta),'.png');
    saveas(savefigure,savename)
    close all hidden
    
    disp(strcat("Finished file output : ",savename))
end