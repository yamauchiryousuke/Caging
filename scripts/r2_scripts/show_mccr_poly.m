figure
hold on

for str = char(sort(cellstr(properties(cc_group_polys))))'
    %if contains(str','cc_02')
        plot(cc_group_polys.(matlab.lang.makeValidName(str')),'LineWidth',1.0,'FaceAlpha',0.1,'FaceColor','magenta','EdgeColor','magenta');
    %end
end

if isempty(check_boundary) == 0
    %scatter(check_boundary(:,1),check_boundary(:,2),2.0,'filled','MarkerFaceColor','blue','MarkerFaceAlpha',1.0);
end

if isempty(vb) == 0
    %scatter(vb(:,1),vb(:,2),2.0,'filled','MarkerFaceColor','red','MarkerFaceAlpha',1.0);
end

axis off
axis equal
xlim([-150 150])
ylim([-150 150])
hold off