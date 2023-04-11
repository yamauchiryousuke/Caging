cut_regions = PointClouds; 

clear cut_deg_array

show_deg_array = [0 180+55];
cut_deg_array = [180+55];

cut_deg_array = [show_deg_array(1,1)-0.01 show_deg_array(1,2)+0.01  cut_deg_array];

num = 1;

label = '\theta_B + \Delta \theta';

for cut_deg = cut_deg_array
    cut_theta = deg2rad(cut_deg);
    tf_t = [cos(cut_theta), sin(cut_theta), 0.0, 0.0; ...
        -sin(cut_theta), cos(cut_theta), 0.0, 0.0; ...
        0.0, 0.0, 1.0, 0.0; ...
        0.0, 0.0, 0.0, 1.0
    ];
    tform_t = affine3d(tf_t);
    c_cls_t = pctransform(c_cls,tform_t);
    c_cls_t = pointCloud(round([c_cls_t.Location(:,1),c_cls_t.Location(:,2),c_cls_t.Location(:,3)],10^10));

    % c_cls_1
    x_1 = 0;    
    y_1 = distance/2;
    tf_1 = [1.0, 0.0, 0.0, 0.0; ...
        0.0, 1.0, 0.0, 0.0; ...
        0.0, 0.0, 1.0, 0.0; ...
        x_1, y_1, z, 1.0
    ];
    tform1 = affine3d(tf_1);
    c_cls_1 = pctransform(c_cls_t,tform1);

    % c_cls_2
    x_2 = 0;
    y_2 = -distance/2;
    tf_2 = [1.0, 0.0, 0.0, 0.0; ...
        0.0, 1.0, 0.0, 0.0; ...
        0.0, 0.0, 1.0, 0.0; ...
        x_2, y_2, z, 1.0
    ];
    tform2 = affine3d(tf_2);
    c_cls_2 = pctransform(c_cls_t,tform2);
    
    [~,c_cls_tower_a_m] = boundaryFacets(alphaShape(double(c_cls_1.Location(:,1:2)),Threshold));
    [~,c_cls_tower_b_m] = boundaryFacets(alphaShape(double(c_cls_2.Location(:,1:2)),Threshold));
    
    cut_regions_str_cut_deg = strcat('z_',sprintf('%02d',num));
    cut_regions.addprop(cut_regions_str_cut_deg);
    cut_regions.(genvarname(['z_',sprintf('%02d',num)])) = z_search_interval * (cut_deg - set_deg(1,1))/z_search_interval;
    
    cut_regions_str_region_a = strcat('region_a_',sprintf('%02d',num));
    cut_regions.addprop(cut_regions_str_region_a);
    cut_regions.(genvarname(['region_a_',sprintf('%02d',num)])) = c_cls_tower_a_m;
    
    cut_regions_str_region_b = strcat('region_b_',sprintf('%02d',num));
    cut_regions.addprop(cut_regions_str_region_b);
    cut_regions.(genvarname(['region_b_',sprintf('%02d',num)])) = c_cls_tower_b_m;

    num = num + 1;
end

show_target_vec1 = (c_cls_tower_1(:,3) >= show_deg_array(1,1)) & (c_cls_tower_1(:,3) <= show_deg_array(1,2));
show_target_vec2 = (c_cls_tower_2(:,3) >= show_deg_array(1,1)) & (c_cls_tower_2(:,3) <= show_deg_array(1,2));
show_target_vec_free_obj = (c_free_obj(:,3) >= show_deg_array(1,1)) & (c_free_obj(:,3) <= show_deg_array(1,2));

c_cls_3d_1_shp_part = alphaShape([c_cls_tower_1(show_target_vec1,[1,2]), compression_coefficient*c_cls_tower_1(show_target_vec1,3)],Threshold_3d);
c_cls_3d_2_shp_part = alphaShape([c_cls_tower_2(show_target_vec2,[1,2]), compression_coefficient*c_cls_tower_2(show_target_vec2,3)],Threshold_3d);

if isempty(c_free_obj) ~= 1
    c_free_obj_shp_part = alphaShape([c_free_obj(show_target_vec_free_obj,[1,2]),compression_coefficient*c_free_obj(show_target_vec_free_obj,3)],Threshold_3d,'HoleThreshold',large_value);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure

hold on 
plot(c_cls_3d_1_shp_part,'FaceColor','green','FaceAlpha',0.25,'EdgeAlpha',0.01)
plot(c_cls_3d_2_shp_part,'FaceColor','green','FaceAlpha',0.25,'EdgeAlpha',0.01)
plot(c_free_obj_shp_part,'FaceColor',[255/255 80/255 0],'FaceAlpha',1.0,'EdgeAlpha',0.0)

for num = 1: size(cut_deg_array,2)
    fill3( ...
        cut_regions.(genvarname(['region_a_',sprintf('%02d',num)]))(:,1), ... 
        cut_regions.(genvarname(['region_a_',sprintf('%02d',num)]))(:,2), ...
        (compression_coefficient*cut_regions.(genvarname(['z_',sprintf('%02d',num)]))) * ...
        ones(size(cut_regions.(genvarname(['region_a_',sprintf('%02d',num)])),1),1), ...
        'white','FaceAlpha',1.0,'EdgeColor','black','EdgeAlpha',1.0,'LineWidth',1 ...
    );
    fill3( ...
        cut_regions.(genvarname(['region_b_',sprintf('%02d',num)]))(:,1), ... 
        cut_regions.(genvarname(['region_b_',sprintf('%02d',num)]))(:,2), ...
        (compression_coefficient*cut_regions.(genvarname(['z_',sprintf('%02d',num)]))) * ...
        ones(size(cut_regions.(genvarname(['region_b_',sprintf('%02d',num)])),1),1), ...
        'white','FaceAlpha',1.0,'EdgeColor','black','EdgeAlpha',1.0,'LineWidth',1 ...
    );
    
    fill3([-100,-100,100,100],[-100,100,100,-100],(compression_coefficient*cut_regions.(genvarname(['z_',sprintf('%02d',num)]))) *ones(1,4),'white','FaceAlpha',0.5);

end

axis on
axis equal
grid off
view(20+180,30);
%view(20,15);

axis 'auto x'
axis 'auto y'
%xlim([-100 100])
%ylim([-100 100])
zlim([compression_coefficient*show_deg_array(1,1)-1, compression_coefficient*show_deg_array(1,2)+1])

%xlabel('x[mm]');
%ylabel('y[mm]');
%zlabel('theta[rad]');

if size(cut_deg_array,2)-2 == 0
    zticks(compression_coefficient*[show_deg_array(1,1) show_deg_array(1,2)])
    zticklabels([show_deg_array(1,1) show_deg_array(1,2)])
    zticks([0 (compression_coefficient*(set_deg(1,2)-z_search_interval))])
    zticklabels({'\theta = 0', '\theta = 2\pi'})
    zticklabels({})
end

if size(cut_deg_array,2)-2 == 1
    zticks([0 compression_coefficient*cut_deg_array(1,3) (compression_coefficient*(set_deg(1,2)-z_search_interval))])
    zticklabels({'\theta = 0', label, '\theta = 2\pi'})
end

if size(cut_deg_array,2)-2 == 2
    zticks([0 compression_coefficient*cut_deg_array(1,3) compression_coefficient*cut_deg_array(1,4) (compression_coefficient*(set_deg(1,2)-z_search_interval))])
    zticklabels({'\theta = 0', '\theta_-', '\theta_+', '\theta = 2\pi'})
end

ax = gca;
ax.YTickLabel = cell(size(ax.YTickLabel));
ax.XTickLabel = cell(size(ax.XTickLabel));
ax.ZTickLabel = cell(size(ax.ZTickLabel));

xlim manual
ylim manual
zlim manual

print(strcat('result/result_',sprintf(datestr(datetime('now'),'yyyy_mm_dd_HH_MM_ss_FFF'))),'-dpng','-r300')

hold off