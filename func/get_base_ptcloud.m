function pt_base_cloud = get_base_ptcloud(interval,x_min, x_max, y_min, y_max, z_min, z_max)

    temp_pt_x = double.empty(0,1);
    temp_pt_xy = double.empty(0,2);
    temp_pt_xyz = double.empty(0,3);

    for temp_x=round(x_min/interval):round(x_max/interval)
        temp_pt_x = [temp_pt_x;interval*temp_x];
    end

    for temp_y=round(y_min/interval):round(y_max/interval)
        temp_pt_xy = [temp_pt_xy; [temp_pt_x, interval*ones(size(temp_pt_x,1),1)*temp_y]];
    end

    for temp_z=round(z_min/interval):round(z_max/interval)
        temp_pt_xyz = [temp_pt_xyz; [temp_pt_xy, interval*ones(size(temp_pt_xy,1),1)*temp_z]];
    end

    pt_base_cloud = pointCloud(temp_pt_xyz);
    clear -regexp temp;

end