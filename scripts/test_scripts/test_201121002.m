% separate dccr test

target_cc = double(cc_group.cc_02(:,1:2));
result_cc = double.empty(0,2);

first_pt = target_cc(randi([1 size(target_cc,1)]),:);
start_pt_array = double.empty(0,3); %target_cc(randi([1 size(target_cc,1)]),:);
next_pt_array = double.empty(0,3); %target_cc(randi([1 size(target_cc,1)]),:);
check_pt = double.empty(0,2);

for i = -1:1
    for j = -1:1
        if ~(i==0 && j==0)
            next_pt_array = [next_pt_array;first_pt(1,1)+(i*dcc_search_interval),first_pt(1,2)+(j*dcc_search_interval)];
        end
    end
end

next_pt_array = next_pt_array(ismember(next_pt_array,target_cc,'rows'),:);

for row = (next_pt_array)'
    %ismember(target_cc,B,'rows')
    
    polygon1 = translate(polygon, first_pt);
    polygon2 = translate(polygon, row');

    polyout1 = intersect(polygon,polygon1);
    polyout2 = intersect(polygon,polygon2);

    if numboundaries(intersect(polyout1,polyout2)) == 2
        start_pt_array=[start_pt_array;row'];
    end
end

%polygon1 = translate(polygon, p1);
%polygon1 = translate(polygon, p1);

p1 = [0,0];

for j = -1:1
    for k = -1:1
        if j ~= 0 && k ~=0
            p2 = [p1+j*dcc_search_interval, p1+k*dcc_search_interval];

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
                polyout1_regions.(genvarname(['d_',sprintf('%02d',n)])) = polyshape(x,y);
            end

            for n = 1: numboundaries(polyout2)
                [x, y] = boundary(polyout2,n);

                poly_str = strcat('d_',sprintf('%02d',n));
                polyout2_regions.addprop(poly_str);
                polyout2_regions.(genvarname(['d_',sprintf('%02d',n)])) = polyshape(x,y);
            end

            for n = 1: numboundaries(polyout1)
                poly_union = intersect(polyout2, polyout1_regions.(genvarname(['d_',sprintf('%02d',n)])));
                if numboundaries(poly_union) == 0
                    dp = [dp;p1];
                end
            end

            for n = 1: numboundaries(polyout2)
                poly_union = intersect(polyout1, polyout2_regions.(genvarname(['d_',sprintf('%02d',n)])));
                if numboundaries(poly_union) == 0
                    dp = [dp;p1];
                end
            end            

        end
    end
end