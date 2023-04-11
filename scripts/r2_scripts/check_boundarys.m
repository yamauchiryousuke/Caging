% check vanishing boundary

check_boundary = double.empty(0,3);
vb = double.empty(0,3);
cc_vb_group = CC_Point_Clouds;

for str = cc_group_pro_name'
    cc_tmp_shp = alphaShape(double(cc_group.(matlab.lang.makeValidName(str'))(:,1:2)), dcc_search_interval/(fix(sqrt(2)*(10^10))/(10^10)));
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