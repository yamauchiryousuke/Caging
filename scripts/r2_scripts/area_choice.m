% show data

circle_r = 60;
theta = [0,360];
depth_rate = 2;

fig_num = 1;

figure
hold on

cc_color = [1 0 1];
cc_num = size(properties(cc_group),1);
show_num = 1;
    
for str = char(sort(cellstr(properties(cc_group))))'
    show_num = show_num*depth_rate;
    if (str' == 'cc_02')
        for area_size = 1:size(area_unique_cc_group.(matlab.lang.makeValidName(str')))
        %row=find(cc_group.(matlab.lang.makeValidName(str'))(:,3)==area_unique_cc_group.(matlab.lang.makeValidName(str'))(area_size,1));
        row=find(cc_group.(matlab.lang.makeValidName(str'))(:,3)==7);
        xryou=cc_group.(matlab.lang.makeValidName(str'))(row,1);
        yryou=cc_group.(matlab.lang.makeValidName(str'))(row,2);
        k = boundary(xryou,yryou,1.0);
        %plot(xryou(k),yryou(k));
        patch(xryou(k),yryou(k),cc_color,'FaceAlpha',show_num/(depth_rate^cc_num));
    %scatter(cc_group.(matlab.lang.makeValidName(str'))(:,1),cc_group.(matlab.lang.makeValidName(str'))(:,2),2.0,'filled','MarkerFaceColor','#313770','MarkerFaceAlpha', 1.0);
    %show_num = show_num * depth_rate;
        end
    %show_num = show_num * depth_rate;
    end
end
    
scatter(0,0,2.0,'filled','MarkerFaceColor','black','MarkerFaceAlpha', 1);
%show_num = show_num * depth_rate;
%scatter(cc_group.(matlab.lang.makeValidName(str'))(:,1),cc_group.(matlab.lang.makeValidName(str'))(:,2),2.0,'filled','MarkerFaceColor','magenta','MarkerFaceAlpha', show_num/(depth_rate^cc_num));
    
if isempty(check_boundary) == 0
    scatter(check_boundary(:,1),check_boundary(:,2),2,'filled','MarkerFaceColor','blue','MarkerFaceAlpha',1.0);
end

if isempty(vb) == 0
    for area_size = 1:size(area_unique_vb)
        row=find(vb(:,3)==area_unique_vb(area_size,1));
        %row=find(vb(:,3)==4);
        xryou=vb(row,1);
        yryou=vb(row,2);
        k = boundary(xryou,yryou,1.0);
        %plot(xryou(k),yryou(k));
        %fill(xryou(k),yryou(k),'r');
        scatter(vb(:,1),vb(:,2),2,'filled','MarkerFaceColor','red','MarkerFaceAlpha',1.0);
    end
end
    
axis off
axis equal
xlim([-200 200])
ylim([-200 200])
hold off
%print(strcat('result/result_',sprintf(datestr(datetime('now'),'yyyy_mm_dd_HH_MM_ss_FFF'))),'-dpng','-r300')
    
