function c_space = get_CC_closure_object2d_oct(C_cls,dots_spacing,search_interval,sub_div_n)
    delta = 10^-8;
    c_counter = 1;
    warning('off','all')

    target_ptCloud = pointCloud(C_cls);

    A = [1.0, 0.0, 0.0, 0.0; ...
            0.0, 1.0, 0.0, 0.0; ...
            0.0, 0.0, 1.0, 0.0; ...
            -(target_ptCloud.XLimits(1,2)+target_ptCloud.XLimits(1,1))/2, ...
            -(target_ptCloud.YLimits(1,2)+target_ptCloud.YLimits(1,1))/2, ...
        0,1.0];
    tform1 = affine3d(A);
    target_ptCloud = pctransform(target_ptCloud,tform1);

    target_shp = alphaShape(double(target_ptCloud.Location(:,1:2)), dots_spacing/(fix(sqrt(2)*(10^10))/(10^10)));
    [~,target_b] = boundaryFacets(target_shp);
    target_polygon = scale(polyshape(transpose(target_b(:,1)),transpose(target_b(:,2)),'Simplify',true),1+delta,[0,0]);
    effector_polygon = target_polygon;
    
    % make C-Closure Object
    resolution = sub_div_n*search_interval*dots_spacing;
    c_space = double.empty(0,3);
    object_X = target_ptCloud.XLimits(1,2)-target_ptCloud.XLimits(1,1);
    object_Y = target_ptCloud.YLimits(1,2)-target_ptCloud.YLimits(1,1);

    for i = 1: 2*(round((2*(object_Y/2))/resolution)+1)
        for j = 1: 2*(round((2*(object_X/2))/resolution)+1)
            polygon_t = translate(target_polygon, ...
                [resolution*(j-(1+round((2*(object_X/2))/resolution)+1)), ...
                resolution*(i-(1+round((2*(object_Y/2))/resolution)+1))]);
            center_point = [resolution*(j-(1+round((2*(object_X/2))/resolution)+1)), ...
                resolution*(i-(1+round((2*(object_Y/2))/resolution)+1)),0];
            polyout = intersect(effector_polygon,polygon_t);
            N = numboundaries(polyout);
            if N > 0
                c_space(c_counter,:) = center_point;
                c_counter = c_counter + 1;
            end
        end
    end

    c_cls_shp = alphaShape(double(c_space(:,1:2)), resolution/(fix(sqrt(2)*(10^10))/(10^10)));
    [~,c_cls_b] = boundaryFacets(c_cls_shp);

    % Subdivision
    if sub_div_n > 1
        for n = 2: sub_div_n
            for i = 1: size(c_cls_b,1)
                for j = -1 : 1
                    for k = -1 : 1
                        if (j == 0 && k ==0) ~= true
                            polygon_t = translate(target_polygon, ...
                                [c_cls_b(i,1)+2^sub_div_n*j*search_interval/(2^n), ...
                                c_cls_b(i,2)+2^sub_div_n*k*search_interval/(2^n)]);
                            center_point = [c_cls_b(i,1)+2^sub_div_n*j*search_interval/(2^n), ...
                                c_cls_b(i,2)+2^sub_div_n*k*search_interval/(2^n),0];
                            polyout = intersect(effector_polygon,polygon_t);
                            N = numboundaries(polyout);
                            if N > 0
                                c_space(c_counter,:) = center_point;
                                c_counter = c_counter + 1;
                            end
                        end
                    end
                end
            end
            c_cls_shp = alphaShape(double(c_space(:,1:2)), 2^sub_div_n*search_interval/(fix(sqrt(2)*(10^10))/(10^10))/(2^n),'HoleThreshold',10^12);
            [~,c_cls_b] = boundaryFacets(c_cls_shp);
        end
    end
    warning('on','all')
    c_space = pointCloud(c_space);
end