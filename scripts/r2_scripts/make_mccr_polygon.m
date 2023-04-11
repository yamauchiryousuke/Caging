% making polygons of multh c-closure region

cc_group_polys = Regions;

for str = cc_group_pro_name'
    cc_tmp_shp = alphaShape(double(cc_group.(matlab.lang.makeValidName(str'))(:,1:2)), dcc_search_interval/(fix(sqrt(2)*(10^10))/(10^10)),'HoleThreshold',10^12);

    for j = 1: numRegions(cc_tmp_shp)
        part_poly_str = strcat(str',sprintf('_%02d',j));
        cc_group_polys.addprop(part_poly_str);

        [~,tmp_region] = boundaryFacets(cc_tmp_shp,j);
        cc_group_polys.(matlab.lang.makeValidName(part_poly_str)) = polyshape(transpose(tmp_region(:,1)),transpose(tmp_region(:,2)),'Simplify',true);
    end
end

figure
hold on

for str = char(sort(cellstr(properties(cc_group_polys))))'
    plot(cc_group_polys.(matlab.lang.makeValidName(str')),'LineWidth',1.0,'FaceAlpha',0.5,'FaceColor','magenta','EdgeColor','magenta');
end

if isempty(check_boundary) == 0
    scatter(check_boundary(:,1),check_boundary(:,2),2.0,'filled','MarkerFaceColor','blue','MarkerFaceAlpha',1.0);
end

if isempty(vb) == 0
    scatter(vb(:,1),vb(:,2),2.0,'filled','MarkerFaceColor','red','MarkerFaceAlpha',1.0);
end

axis on
axis equal
xlim([-150 150])
ylim([-150 150])
hold off