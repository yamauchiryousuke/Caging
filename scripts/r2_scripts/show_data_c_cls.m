
mag = [1/magnification, 0.0, 0.0, 0.0; ...
        0.0, 1/magnification, 0.0, 0.0; ...
        0.0, 0.0, 1/magnification, 0.0; ...
        0, 0,0, 1.0];
tform_mag = affine3d(mag);                
c_cls=pctransform(c_cls,tform_mag);

figure;
axis image
plot(c_cls.Location(:,1),c_cls.Location(:,2),'b.')
daspect([1 1 1])


print(strcat('result/result_c_cls_point_',sprintf(datestr(datetime('now'),'yyyy_mm_dd_HH_MM_ss_FFF'))),'-dpng','-r300')

polygon=scale(polygon,1/magnification,[0 0]);
figure;
axis image
plot(polygon)
daspect([1 1 1])

print(strcat('result/result_c_cls_poly_',sprintf(datestr(datetime('now'),'yyyy_mm_dd_HH_MM_ss_FFF'))),'-dpng','-r300')