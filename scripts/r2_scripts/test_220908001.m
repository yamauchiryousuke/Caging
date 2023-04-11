c_cls_outline_double=c_cls_outline_double/2;
[c_cls,target_obj,sphere_shp] = get_C_closure_object2d_octree_test(file_name,robot_r,robot_corners,dots_spacing,c_cls_search_interval,c_cls,magnification,c_cls_outline_double,target_obj,sphere_shp);  %C_cls_obj作成
c_cls_1_shp_out = alphaShape(double(c_cls.Location(:,1:2)), c_cls_search_interval/(fix(sqrt(2)*(10^10))/(10^10)),'HoleThreshold',10^12);
%{
figure;
axis equal
plot(c_cls_1_shp_out)

figure;
axis equal
plot(c_cls_1_shp_all)
%}

[~,c_cls_1_out_b] = boundaryFacets(c_cls_1_shp_out);


polygon_out = scale(polyshape(transpose(c_cls_1_out_b(:,1)),transpose(c_cls_1_out_b(:,2)),'Simplify',true),1-delta,[0,0]);
%{
figure;
axis equal
plot(polygon_in)
figure;
axis equal
plot(polygon_out)
%}
%polygon = xor(polygon_in,polygon_out);
polygon = polygon_out;
%{
figure;
axis equal
plot(polygon)
daspect([1 1 1])
%}

%c_cls_boundary = boundary(c_cls.Location(:,1),c_cls.Location(:,2),1);
%c_cls_outline = c_cls.Location(c_cls_boundary,1:2);
[~,c_cls_outline]=boundaryFacets(c_cls_1_shp_out);
%{
figure;
axis equal
plot(c_cls_outline(:,1),c_cls_outline(:,2),'b.')
daspect([1 1 1])
%}

c_cls_outline_double = c_cls_outline*2;
%figure;
%scatter(c_cls_outline_double(:,1),c_cls_outline_double(:,2),'filled')