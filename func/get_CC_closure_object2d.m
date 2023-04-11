function cc_cls_object = get_CC_closure_object2d(C_cls,points_spacing,search_interval)
    % make C closure object's boundary_ptCloud
    
    Threshold = points_spacing/(fix(sqrt(2)*(10^10))/(10^10));
    C_cls_shp = alphaShape(double(C_cls.Location(:,1)),double(C_cls.Location(:,2)),Threshold*search_interval);
    
    % make C-Closure Object

    resolution = points_spacing*search_interval;
    cc_space = double.empty(0,3);

    object_X = C_cls.XLimits(1,2)-C_cls.XLimits(1,1);
    object_Y = C_cls.YLimits(1,2)-C_cls.YLimits(1,1);

    for i = 1: round((4*(object_Y/resolution))/resolution)+1
        for j = 1: round((4*(object_X/resolution))/resolution)+1
            A = [1.0, 0.0, 0.0, 0.0; ...
                0.0, 1.0, 0.0, 0.0; ...
                0.0, 0.0, 1.0, 0.0; ...
                resolution*(j-(1+round((2*(object_X/resolution))/resolution))), ...
                resolution*(i-(1+round((2*(object_Y/resolution))/resolution))), ...
            0,1.0];
            tform1 = affine3d(A);
            tf_obj = pctransform(C_cls,tform1);

            center_point = [(tf_obj.XLimits(1,1)+tf_obj.XLimits(1,2))/2,(tf_obj.YLimits(1,1)+tf_obj.YLimits(1,2))/2,(tf_obj.ZLimits(1,1)+tf_obj.ZLimits(1,2))/2];
            tf = inShape(C_cls_shp,double(tf_obj.Location(:,1)),double(tf_obj.Location(:,2)));
            interference_count = nnz(tf);
            if interference_count > 0
                cc_space = [cc_space;center_point];
            end
        end
    end
    cc_cls_object = pointCloud(cc_space);
end