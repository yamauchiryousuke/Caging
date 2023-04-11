function [c_cls_object,target_ptCloud,sphere_shp] = get_C_closure_object2d(file_name,r,corners,dots_spacing,search_interval)
    % make target point cloud
    img = imread(file_name);  %画像読み込み
    img = rgb2gray(img);      %グレースケール変換
    img = imbinarize(img);    %2値化
    img_size = size(img);     %画像の配列サイズ

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
    
    % make C-Closure Object
    % make sphere
    % Number of corners
    s_x = round(r*cos(transpose(1:corners)*2*pi/corners),3);
    s_y = round(r*sin(transpose(1:corners)*2*pi/corners),3);
    %robo_ptCloud = pointCloud([s_x,s_y,s_z]);
    sphere_threshold = Inf;
    sphere_shp = alphaShape(s_x, s_y ,sphere_threshold);  %エンドエフェクタ領域

    % make C-Closure Object

    resolution = search_interval*dots_spacing;  %解像度
    c_space = double.empty(0,3);

    object_X = target_ptCloud.XLimits(1,2)-target_ptCloud.XLimits(1,1);
    object_Y = target_ptCloud.YLimits(1,2)-target_ptCloud.YLimits(1,1);

    for i = 1: 2*(round(((1*r)+(object_Y/2))/resolution)+1)
        for j = 1: 2*(round(((1*r)+(object_X/2))/resolution)+1)
            A = [1.0, 0.0, 0.0, 0.0; ...
                0.0, 1.0, 0.0, 0.0; ...
                0.0, 0.0, 1.0, 0.0; ...
                resolution*(j-(1+round((r+(object_X/2))/resolution)+1)), ...
                resolution*(i-(1+round((r+(object_Y/2))/resolution)+1)), ...
            0,1.0];
            tform1 = affine3d(A);
            tf_obj = pctransform(target_ptCloud,tform1);

            center_point = [(tf_obj.XLimits(1,1)+tf_obj.XLimits(1,2))/2,(tf_obj.YLimits(1,1)+tf_obj.YLimits(1,2))/2,(tf_obj.ZLimits(1,1)+tf_obj.ZLimits(1,2))/2];
            tf = inShape(sphere_shp,double(tf_obj.Location(:,1)),double(tf_obj.Location(:,2)));
            interference_count = nnz(tf);
            if interference_count > 0
                c_space = [c_space;center_point];
            end
        end
        %disp(round(100*i/(2*(round(((1*r)+(object_Y/2))/resolution)+1))));
    end
    disp(i*j);
    c_cls_object = pointCloud(c_space);
    %{
    figure;
    axis equal
    plot(c_cls_object.Location(:,1),c_cls_object.Location(:,2),'b.')
    %}

end