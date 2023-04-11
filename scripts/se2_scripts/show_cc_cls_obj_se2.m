figure
hold on
plot(c_cls_3d_shp,'FaceColor','green','FaceAlpha',0.25,'EdgeAlpha',0.01)
plot(cc_cls_3d_shp,'FaceColor',[255/255,192/255,0],'FaceAlpha',0.25,'EdgeAlpha',0.01)

cut_deg_array = [100,225];
cut_deg_array = [cut_deg_array ,(set_deg(1,1)-0.1),(set_deg(1,2)+0.1)];

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
        
        if i == 1
            cc_cls_t = pctransform(cc_cls,tform_t);
            cc_cls_t = pointCloud(round([cc_cls_t.Location(:,1),cc_cls_t.Location(:,2),cc_cls_t.Location(:,3)],10^10));
        end
        
        len = size(position_mat,1);

        tf_tran = [1.0, 0.0, 0.0, 0.0; ...
        0.0, 1.0, 0.0, 0.0; ...
        0.0, 0.0, 1.0, 0.0; ...
        position_mat(i,1), position_mat(i,2), z, 1.0
        ];
        tf_tran = affine3d(tf_tran);

        temp_c = pctransform(c_cls_t, tf_tran);
        
        if i == 1
            temp_cc = pctransform(cc_cls_t, tf_tran);
        end
        
        z = n * z_search_interval;

        mz = z;

        [~,tmp_cmb] = boundaryFacets(alphaShape(double(temp_c.Location(:,1:2)),Threshold));    
        [~,tmp_ccmb] = boundaryFacets(alphaShape(double(temp_cc.Location(:,1:2)),Threshold)); 
        
        fill3( ...
            tmp_cmb(:,1), ...
            tmp_cmb(:,2), ...
            mz*ones(size(tmp_cmb,1),1)*compression_coefficient, ...
            'white','FaceAlpha',1.0,'EdgeColor','black','EdgeAlpha',1.0,'LineWidth',1 ...
        );
        
        if i == 1
            fill3( ...
                tmp_ccmb(:,1), ...
                tmp_ccmb(:,2), ...
                mz*ones(size(tmp_ccmb,1),1)*compression_coefficient, ...
                'white','FaceAlpha',1.0,'EdgeColor','black','EdgeAlpha',1.0,'LineWidth',1 ...
            );
        end
    end
    fill3([-100,-100,100,100],[-100,100,100,-100],[mz,mz,mz,mz]*compression_coefficient,'white','FaceAlpha',0.5);
end

%scatter3(0,0,0*compression_coefficient,10,'filled','MarkerFaceColor','black');

plot3([0,0],[0,0],[set_deg(1,1)-1,set_deg(1,2)+1],'Color','black','LineWidth',2);
plot3([40,40],[40,40],[set_deg(1,1)-1,set_deg(1,2)+1],'Color','black','LineWidth',2);

axis on
axis equal

view(60,15);
xlim([-100 100])
ylim([-100 100])
zlim([0-2,(compression_coefficient*(z-z_search_interval))+2])

if size(cut_deg_array,2)-2 == 0
    zticks([0 compression_coefficient*(set_deg(1,2)-z_search_interval)])
    zticklabels({'\theta = 0', '\theta = 2\pi'})
end

if size(cut_deg_array,2)-2 == 1
    zticks([0 compression_coefficient*(cut_deg_array(1,1)-set_deg(1,1)) compression_coefficient*(set_deg(1,2)-z_search_interval)])
    zticklabels({'\theta = 0', '\theta_0', '\theta = 2\pi'})
end

if size(cut_deg_array,2)-2 == 2
    zticks([0 compression_coefficient*(cut_deg_array(1,1)-set_deg(1,1)) compression_coefficient*(cut_deg_array(1,2)-set_deg(1,1)) compression_coefficient*(set_deg(1,2)-z_search_interval)])
    zticklabels({'\theta = 0', '\theta_1', '\theta_2', '\theta = 2\pi'})
end
ax = gca;
ax.YTickLabel = cell(size(ax.YTickLabel));
ax.XTickLabel = cell(size(ax.XTickLabel));

xlim manual
ylim manual
zlim manual

%print(strcat('result/result_',sprintf(datestr(datetime('now'),'yyyy_mm_dd_HH_MM_ss_FFF'))),'-dpng','-r300')

hold off