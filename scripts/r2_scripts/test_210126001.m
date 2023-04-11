cc_group_polys = Regions;

mdccr_pcd = double.empty(0,3);

for str = cc_group_pro_name' 
    mdccr_pcd = [mdccr_pcd;double(cc_group.(matlab.lang.makeValidName(str'))(:,1:2))];
end

mdccr_shp = alphaShape(mdccr_pcd(:,1:2), dcc_search_interval/(fix(sqrt(2)*(10^10))/(10^10)),'HoleThreshold',10^12);    
[~,tmp_region] = boundaryFacets(mdccr_shp);
mdccr_poly = polyshape(transpose(tmp_region(:,1)),transpose(tmp_region(:,2)),'Simplify',true);

figure
hold on
plot(mdccr_poly,'LineWidth',1.0,'FaceAlpha',0.5,'FaceColor',[255/255,192/255,0],'EdgeColor','magenta');

axis off
axis equal
xlim([-150 150])
ylim([-150 150])
hold offq