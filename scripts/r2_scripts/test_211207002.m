%è¡é∏ã´äEÇÃóÃàÊï™ÇØ
%if isempty(vb) == 0
    area=1;
    vb = unique(vb,'stable','rows');
    for vb_size = 1:size(vb(:,1))
        test_L =vb(vb_size,1:2)+Left;
        test_Un =vb(vb_size,1:2)+Under;
        test_LL = vb(vb_size,1:2)+LowerL;
        
           
        if isempty(find(vb(:,1) == test_L(1,1) & vb(:,2) == test_L(1,2) | vb(:,1) == test_Un(1,1) & vb(:,2) == test_Un(1,2) | vb(:,1) == test_LL(1,1) & vb(:,2) == test_LL(1,2)))== 0
            disp('true') 
            test1 = find(vb(:,1) == test_L(1,1) & vb(:,2) == test_L(1,2) | vb(:,1) == test_Un(1,1) & vb(:,2) == test_Un(1,2) |  vb(:,1) == test_LL(1,1) & vb(:,2) == test_LL(1,2));
            vb(test1,3) = min(vb(test1,3));
            vb(vb_size,3) = min(vb(test1,3));
            disp(test1) 
        else
            disp('false')
            vb(vb_size,3) = area;
            area = area+1;
        end
    end
   
    for vb_size = size(vb(:,1)):-1:1
        test_Up = vb(vb_size,1:2)+Up;
        test_R = vb(vb_size,1:2)+Right;
        test_LR = vb(vb_size,1:2)+LowerR;
        test_UL = vb(vb_size,1:2)+UpperL;
        test_UR = vb(vb_size,1:2)+UpperR;
        if isempty(find(vb(:,1) == test_R(1,1) & vb(:,2) == test_R(1,2) | vb(:,1) == test_Up(1,1) & vb(:,2) == test_Up(1,2) | vb(:,1) == test_LR(1,1) & vb(:,2) == test_LR(1,2) | vb(:,1) == test_UR(1,1) & vb(:,2) == test_UR(1,2) | vb(:,1) == test_UL(1,1) & vb(:,2) == test_UL(1,2)))== 0
            disp('true') 
            test1 = find(vb(:,1) == test_R(1,1) & vb(:,2) == test_R(1,2) | vb(:,1) == test_Up(1,1) & vb(:,2) == test_Up(1,2) | vb(:,1) == test_LR(1,1) & vb(:,2) == test_LR(1,2) | vb(:,1) == test_UR(1,1) & vb(:,2) == test_UR(1,2) | vb(:,1) == test_UL(1,1) & vb(:,2) == test_UL(1,2));
            vb(test1,3) = min(vb(test1,3));
            vb(vb_size,3) = min(vb(test1,3));
            disp(test1) 
        end
    end
    
%end
    