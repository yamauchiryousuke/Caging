%% make mccr_oct
for i = -2:2
    for j = -2:2
        if (i == 0 && j ==0) ~= true
            for k = 1:size(check_boundary(:,1))
                polygon_t = translate(polygon, ...
                    [check_boundary(k,1)+dcc_search_interval*j,check_boundary(k,2)+dcc_search_interval*i]);
                center_point = [check_boundary(k,1)+dcc_search_interval*j,check_boundary(k,2)+dcc_search_interval*i,0];
        
                polyout = intersect(polygon,polygon_t);
                N = numboundaries(polyout);
        
                if N >= 1
                    cc_str = strcat('cc_',sprintf('%02d',N));
                    if isprop(cc_group, cc_str) == false
                        cc_group.addprop(cc_str);
                        cc_group.(matlab.lang.makeValidName(['cc_',sprintf('%02d',N)])) = double.empty(0,3);
                    end
            
                    cc_group.(matlab.lang.makeValidName(['cc_',sprintf('%02d',N)])) = [cc_group.(matlab.lang.makeValidName(['cc_',sprintf('%02d',N)]));center_point;-center_point];
                end
            end
        end
    end
end

cc_group_pro_name_test1 = sort(cell2mat(properties(cc_group)));
cc_group_pro_name = cell2mat(sort(properties(cc_group)));

for i = 1: size(cc_group_pro_name,1)
    cc_group.(matlab.lang.makeValidName(cc_group_pro_name(i,:))) = unique(cc_group.(matlab.lang.makeValidName(cc_group_pro_name(i,:))),'rows');
end

%% check vanishing boundary
check_boundary = double.empty(0,3);
vb = double.empty(0,3);
cc_vb_group = CC_Point_Clouds;

for str = cc_group_pro_name'
    %cc_tmp_shp = alphaShape(double(cc_group.(matlab.lang.makeValidName(str'))(:,1:2)), dcc_search_interval/(fix(sqrt(2)*(10^10))/(10^10)));
    cc_tmp_shp = alphaShape(double(cc_group.(matlab.lang.makeValidName(str'))(:,1:2)), (2/(2^QN))/(fix(sqrt(2)*(10^10))/(10^10)),'HoleThreshold',10^12);
    cc_tmp_shp = alphaShape(double(cc_group.(matlab.lang.makeValidName(str'))(:,1:2)), dcc_search_interval/(fix(sqrt(2)*(10^10))/(10^10)),'HoleThreshold',10^12);

    figure;
    axis equal
    plot(cc_tmp_shp)
    
    [~,tmp_boundary] = boundaryFacets(cc_tmp_shp);
    check_boundary = [check_boundary;tmp_boundary];
end

for p = check_boundary'
    p1 = p';
    for dx = -1:1
        for dy = -1:1
            if dx ~= 0 && dy ~=0
                p2 = [p1(1,1)+(dx*dcc_search_interval), p1(1,2)+(dy*dcc_search_interval)];
                
                polygon1 = translate(polygon, p1);
                polygon2 = translate(polygon, p2);

                polyout1 = intersect(polygon,polygon1);
                polyout2 = intersect(polygon,polygon2);

                polyout1  = sortboundaries(polyout1,'centroid','ascend');
                polyout2  = sortboundaries(polyout2,'centroid','ascend');

                polyout1_regions = Regions;
                polyout2_regions = Regions;

                for n = 1: numboundaries(polyout1)
                    [x, y] = boundary(polyout1,n);

                    poly_str = strcat('d_',sprintf('%02d',n));
                    polyout1_regions.addprop(poly_str);
                    polyout1_regions.(matlab.lang.makeValidName(['d_',sprintf('%02d',n)])) = polyshape(x,y);
                end

                for n = 1: numboundaries(polyout2)
                    [x, y] = boundary(polyout2,n);

                    poly_str = strcat('d_',sprintf('%02d',n));
                    polyout2_regions.addprop(poly_str);
                    polyout2_regions.(matlab.lang.makeValidName(['d_',sprintf('%02d',n)])) = polyshape(x,y);
                end

                for n = 1: numboundaries(polyout1)
                    poly_union = intersect(polyout2, polyout1_regions.(matlab.lang.makeValidName(['d_',sprintf('%02d',n)])));
                    if numboundaries(poly_union) == 0
                        vb = [vb;p1];
                    end
                end

                for n = 1: numboundaries(polyout2)
                    poly_union = intersect(polyout1, polyout2_regions.(matlab.lang.makeValidName(['d_',sprintf('%02d',n)])));
                    if numboundaries(poly_union) == 0
                        vb = [vb;p1];
                    end
                end            
                
            end
        end
    end
end

vp = [vb;-vb];