c_show_fg = 1;
cc_show_fg = 0;
dccr_show_fg = 0;

label = '\theta = \theta_0';

show_deg_array = [0 360];
cut_deg_array = [];
cut_deg_array = [cut_deg_array ,(set_deg(1,1)-0.1),(set_deg(1,2)+0.1)];

figure
hold on

for str = char(sort(cellstr(properties(c_free_part))))' 
    plot(c_free_part.(genvarname(str')),'FaceColor',[255/255 80/255 0],'FaceAlpha',1.0,'EdgeAlpha',0.0)
end

if c_show_fg == 1
    plot(c_cls_3d_shp,'FaceColor','green','FaceAlpha',0.25,'EdgeAlpha',0.01)
end

if cc_show_fg == 1
    plot(cc_cls_3d_shp,'FaceColor',[255/255,192/255,0],'FaceAlpha',0.25,'EdgeAlpha',0.01)
end

if dccr_show_fg == 1
    plot(dccr_3d_shp,'FaceColor','magenta','FaceAlpha',0.25,'EdgeAlpha',0.01)
    dccr_pcd_plus = pointCloud(dccr_pcd.Location(dccr_pcd.Location(:,2)>0,:));
    dccr_pcd_minus = pointCloud(dccr_pcd.Location(dccr_pcd.Location(:,2)<0,:));
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
        
        if i == 1
            cc_cls_t = pctransform(cc_cls,tform_t);
            cc_cls_t = pointCloud(round([cc_cls_t.Location(:,1),cc_cls_t.Location(:,2),cc_cls_t.Location(:,3)],10^10));
            
            dccr_plus_t = pctransform(dccr_pcd_plus,tform_t);
            dccr_plus_t = pointCloud(round([dccr_plus_t.Location(:,1),dccr_plus_t.Location(:,2),dccr_plus_t.Location(:,3)],10^10));
            
            dccr_minus_t = pctransform(dccr_pcd_minus,tform_t);
            dccr_minus_t = pointCloud(round([dccr_minus_t.Location(:,1),dccr_minus_t.Location(:,2),dccr_minus_t.Location(:,3)],10^10));
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
            temp_dccr_plus = pctransform(dccr_plus_t, tf_tran);
            temp_dccr_minus = pctransform(dccr_minus_t, tf_tran);
        end
        
        z = n * z_search_interval;

        mz = z;

        [~,tmp_cmb] = boundaryFacets(alphaShape(double(temp_c.Location(:,1:2)),Threshold));    
        [~,tmp_ccmb] = boundaryFacets(alphaShape(double(temp_cc.Location(:,1:2)),Threshold)); 
        [~,tmp_dccr_plus] = boundaryFacets(alphaShape(double(temp_dccr_plus.Location(:,1:2)),Threshold));
        [~,tmp_dccr_minus] = boundaryFacets(alphaShape(double(temp_dccr_minus.Location(:,1:2)),Threshold));
        
        if c_show_fg == 1
            fill3( ...
                tmp_cmb(:,1), ...
                tmp_cmb(:,2), ...
                mz*ones(size(tmp_cmb,1),1)*compression_coefficient, ...
                'white','FaceAlpha',1.0,'EdgeColor','black','EdgeAlpha',1.0,'LineWidth',1 ...
            );
        end
        
        
        if i == 1
            if cc_show_fg == 1
                fill3( ...
                    tmp_ccmb(:,1), ...
                    tmp_ccmb(:,2), ...
                    mz*ones(size(tmp_ccmb,1),1)*compression_coefficient, ...
                    'white','FaceAlpha',1.0,'EdgeColor','black','EdgeAlpha',1.0,'LineWidth',1 ...
                );
            end
            
            if dccr_show_fg == 1
                fill3( ...
                    tmp_dccr_plus(:,1), ...
                    tmp_dccr_plus(:,2), ...
                    mz*ones(size(tmp_dccr_plus,1),1)*compression_coefficient, ...
                    'white','FaceAlpha',1.0,'EdgeColor','black','EdgeAlpha',1.0,'LineWidth',1 ...
                );
                fill3( ...
                    tmp_dccr_minus(:,1), ...
                    tmp_dccr_minus(:,2), ...
                    mz*ones(size(tmp_dccr_minus,1),1)*compression_coefficient, ...
                    'white','FaceAlpha',1.0,'EdgeColor','black','EdgeAlpha',1.0,'LineWidth',1 ...
                );
            end
        end
    end
    fill3([-100,-100,100,100],[-100,100,100,-100],[mz,mz,mz,mz]*compression_coefficient,'white','FaceAlpha',0.5);
end

%scatter3(0,0,0*compression_coefficient,10,'filled','MarkerFaceColor','black');

%plot3([0,0],[-15,-15],[set_deg(1,1)-1,set_deg(1,2)+1],'Color','black','LineWidth',2);
%plot3([0,0],[15,15],[set_deg(1,1)-1,set_deg(1,2)+1],'Color','black','LineWidth',2);

axis on
axis equal

view(60,20);
xlim([-100 100])
ylim([-100 100])
%zlim([0-2,(compression_coefficient*(z-z_search_interval))+2])
zlim([compression_coefficient*show_deg_array(1,1)-1, ...
    (compression_coefficient*(show_deg_array(1,2)-z_search_interval))+2 ...
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
    zticklabels({'\theta = 0', '\theta_1', '\theta_2', '\theta = 2\pi'})
end

ax = gca;
ax.YTickLabel = cell(size(ax.YTickLabel));
ax.XTickLabel = cell(size(ax.XTickLabel));

xlim manual
ylim manual
zlim manual

%print(strcat('result_',sprintf(datestr(datetime('now'),'yyyy_mm_dd_HH_MM_ss_FFF'))),'-dpng','-r300')

hold off