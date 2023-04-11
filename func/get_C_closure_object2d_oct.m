%function c_space = get_C_closure_object2d_oct(file_name,r,corners,dots_spacing,search_interval)
    file_name = '../../img/test_001.png';
    r = 5;
    corners = 32;
    dots_spacing = 1;
    search_interval = 1;
    sub_div_n = 6;
    delta = 10^-8;
    c_counter = 1;
    warning('off','all')

    img = imbinarize(rgb2gray(imread(file_name)));
    img_size = size(img);

    % make sphere
    s_x = round(r*cos(transpose(1:corners)*2*pi/corners),3);
    s_y = round(r*sin(transpose(1:corners)*2*pi/corners),3);
    effector_polygon = scale(polyshape(transpose(s_x),transpose(s_y),'Simplify',true),1,[0,0]);

    % get object pointcloud
    img_point = double.empty(0,3);
    mass = 1;
    for i = 1:img_size(1,1)
        for j = 1:img_size(1,2)
            if img(i,j) == 1
                img_point(mass,1) = dots_spacing*(j-1);
                img_point(mass,2) = dots_spacing*(i-1);
                mass = mass + 1;
            end
        end
    end
    img_point(:,2) = -img_point(:,2);
    target_ptCloud = pointCloud(img_point);

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

    % make C-Closure Object
    resolution = sub_div_n*search_interval*dots_spacing;
    c_space = double.empty(0,3);
    object_X = target_ptCloud.XLimits(1,2)-target_ptCloud.XLimits(1,1);
    object_Y = target_ptCloud.YLimits(1,2)-target_ptCloud.YLimits(1,1);

    for i = 1: 2*(round(((1*r)+(object_Y/2))/resolution)+1)
        for j = 1: 2*(round(((1*r)+(object_X/2))/resolution)+1)
            polygon_t = translate(target_polygon, ...
                [resolution*(j-(1+round((r+(object_X/2))/resolution)+1)), ...
                resolution*(i-(1+round((r+(object_Y/2))/resolution)+1))]);
            center_point = [resolution*(j-(1+round((r+(object_X/2))/resolution)+1)), ...
                resolution*(i-(1+round((r+(object_Y/2))/resolution)+1)),0];
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

%end