figure
hold on
clear cut_deg_array

show_deg_array = [0 144];
cut_deg_array = [144];
cut_deg_array = [cut_deg_array,(set_deg(1,1)-0.1),(set_deg(1,2)+0.1)];

c_show_fg = 1;
dcor_show_fg = 0;

show_xy_range = 100; 

label = '\theta_0';

if c_show_fg == 1
    plot(c_cls_3d_shp,'FaceColor','green','FaceAlpha',0.25,'EdgeAlpha',0.01)
end

if dcor_show_fg == 1
    plot(or_3d_shp,'FaceColor',[255/255,192/255,0],'FaceAlpha',0.5,'EdgeAlpha',0.01)
end

%plot(cc_cls_3d_shp,'FaceColor',[255/255,192/255,0],'FaceAlpha',0.25,'EdgeAlpha',0.01)
%scatter3(result_pcd(:,1),result_pcd(:,2),result_pcd(:,3),10,'filled','MarkerFaceColor',[255/255 160/255 80/255]);

for str = char(sort(cellstr(properties(c_free_part))))'
    plot(c_free_part.(genvarname(str')),'FaceColor',[255/255 80/255 0],'FaceAlpha',1.0,'EdgeAlpha',0.0)
end

for m = 1 : size(cut_deg_array,2)
    for i= 1 : len
        n = round((cut_deg_array(1,m)-set_deg(1,1))/z_search_interval);

        theta = deg2rad(cut_deg_array(1,m));

        % rotate theta
        tf_t = [cos(theta), sin(theta), 0.0, 0.0; ...
            -sin(theta), cos(theta), 0.0, 0.0; ...
            0.0, 0.0, 1.0, 0.0; ...
            0.0, 0.0, 0.0, 1.0
        ];
        tform_t = affine3d(tf_t);
        c_cls_t = pctransform(c_cls,tform_t);
        c_cls_t = pointCloud(round([c_cls_t.Location(:,1),c_cls_t.Location(:,2),c_cls_t.Location(:,3)],10^10));
        
        len = size(position_mat,1);

        tf_tran = [1.0, 0.0, 0.0, 0.0; ...
        0.0, 1.0, 0.0, 0.0; ...
        0.0, 0.0, 1.0, 0.0; ...
        position_mat(i,1), position_mat(i,2), z, 1.0
        ];
        tf_tran = affine3d(tf_tran);

        temp_c = pctransform(c_cls_t, tf_tran);

        z = n * z_search_interval;

        mz = z;

        [~,tmp_mb] = boundaryFacets(alphaShape(double(temp_c.Location(:,1:2)),Threshold));    
        
        if c_show_fg == 1
            fill3( ...
                tmp_mb(:,1), ...
                tmp_mb(:,2), ...
                mz*ones(size(tmp_mb,1),1)*compression_coefficient, ...
                'white','FaceAlpha',1.0,'EdgeColor','black','EdgeAlpha',1.0,'LineWidth',1 ...
            );
        end
        
        if i == 1
            or_canditate_point = temp_c.Location(:,1:2);
        else
            tmp_c_shp = alphaShape(double(temp_c.Location(:,1:2)), search_interval/(fix(sqrt(2)*(10^10))/(10^10)),'HoleThreshold',10^12);
            in_point_id = inShape(tmp_c_shp,or_canditate_point(:,1),or_canditate_point(:,2));
            or_canditate_point = or_canditate_point(in_point_id,:);
        end
    end
    
    tmp_or_shp = alphaShape(double(or_canditate_point(:,1:2)), search_interval/(fix(sqrt(2)*(10^10))/(10^10)),'HoleThreshold',10^12);
    for j = 1: numRegions(tmp_or_shp)
        [~,tmp_region] = boundaryFacets(tmp_or_shp,j);
        
        if dcor_show_fg == 1
            fill3( ...
                tmp_region(:,1), ...
                tmp_region(:,2), ...
                mz*ones(size(tmp_region,1),1)*compression_coefficient, ...
                [255/255,192/255,0],'FaceAlpha',1.0,'EdgeColor','black','EdgeAlpha',1.0,'LineWidth',1 ...
            );
        end
    end
    
    fill3([-show_xy_range,-show_xy_range,show_xy_range,show_xy_range],[-show_xy_range,show_xy_range,show_xy_range,-show_xy_range],[mz,mz,mz,mz]*compression_coefficient,'white','FaceAlpha',0.5);
end

axis on
axis equal

view(20,40);
%view(20,15);

xlim([-show_xy_range show_xy_range])
ylim([-show_xy_range show_xy_range])

zlim([compression_coefficient*show_deg_array(1,1)-1, ...
    (compression_coefficient*(show_deg_array(1,2)-z_search_interval))+1 ...
    ])


if size(cut_deg_array,2)-2 == 0
    zticks([0 compression_coefficient*(set_deg(1,2)-z_search_interval)])
    zticklabels({'\theta = 0', '\theta = 2\pi'})
end

if size(cut_deg_array,2)-2 == 1
    zticks([0 compression_coefficient*(cut_deg_array(1,1)-set_deg(1,1)) compression_coefficient*(set_deg(1,2)-z_search_interval)])
    zticklabels({'\theta = 0', label, '\theta = 2\pi'})
end

if size(cut_deg_array,2)-2 == 2
    zticks([0 compression_coefficient*(cut_deg_array(1,1)-set_deg(1,1)) compression_coefficient*(cut_deg_array(1,2)-set_deg(1,1)) compression_coefficient*(set_deg(1,2)-z_search_interval)])
    %zticklabels({'\theta = 0', '\theta_0', '\theta_0 + \pi', '\theta = 2\pi'})
    zticklabels({'\theta = 0', '\theta_-', '\theta_+', '\theta = 2\pi'})
end

if size(cut_deg_array,2)-2 == 3
    zticks([0 compression_coefficient*(cut_deg_array(1,1)-set_deg(1,1)) compression_coefficient*(cut_deg_array(1,2)-set_deg(1,1)) compression_coefficient*(cut_deg_array(1,3)-set_deg(1,1)) compression_coefficient*(set_deg(1,2)-z_search_interval)])
    zticklabels({'\theta = 0', '\theta_-','\theta_0', '\theta_+', '\theta = 2\pi'})
end

ax = gca;
ax.YTickLabel = cell(size(ax.YTickLabel));
ax.XTickLabel = cell(size(ax.XTickLabel));

xlim manual
ylim manual
zlim manual

print(strcat('./result/result_',sprintf(datestr(datetime('now'),'yyyy_mm_dd_HH_MM_ss_FFF'))),'-dpng','-r300')

hold off