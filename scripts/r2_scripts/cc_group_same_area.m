%óÃàÊï™ÇØ
Left = [-1 0];
Under = [0 -1];
LowerL = [-1 -1];
UpperL = [-1 1];

Up = [0 1];
Right = [1 0];
LowerR = [1 -1];
UpperR = [1 1];

%cc_groupÇÃóÃàÊï™ÇØ
for str = char(sort(cellstr(properties(cc_group))))'
    area=1;
    for cc_group_size = 1:size(cc_group.(matlab.lang.makeValidName(str'))(:,1))
        test_L = cc_group.(matlab.lang.makeValidName(str'))(cc_group_size,1:2)+Left;
        test_Un = cc_group.(matlab.lang.makeValidName(str'))(cc_group_size,1:2)+Under;
           
        if isempty(find(cc_group.(matlab.lang.makeValidName(str'))(:,1) == test_L(1,1) & cc_group.(matlab.lang.makeValidName(str'))(:,2) == test_L(1,2) | cc_group.(matlab.lang.makeValidName(str'))(:,1) == test_Un(1,1) & cc_group.(matlab.lang.makeValidName(str'))(:,2) == test_Un(1,2), 1))== 0
            %disp('true') 
            test1 = find(cc_group.(matlab.lang.makeValidName(str'))(:,1) == test_L(1,1) & cc_group.(matlab.lang.makeValidName(str'))(:,2) == test_L(1,2) | cc_group.(matlab.lang.makeValidName(str'))(:,1) == test_Un(1,1) & cc_group.(matlab.lang.makeValidName(str'))(:,2) == test_Un(1,2));
            cc_group.(matlab.lang.makeValidName(str'))(test1,3) = min(cc_group.(matlab.lang.makeValidName(str'))(test1,3));
            cc_group.(matlab.lang.makeValidName(str'))(cc_group_size,3) = min(cc_group.(matlab.lang.makeValidName(str'))(test1,3));
            %disp(test1) 
        else
            %disp('false')
            cc_group.(matlab.lang.makeValidName(str'))(cc_group_size,3) = area;
            area = area+1;
        end
    end
    
    for cc_group_size = size(cc_group.(matlab.lang.makeValidName(str'))(:,1)):-1:1
            test_Up = cc_group.(matlab.lang.makeValidName(str'))(cc_group_size,1:2)+Up;
            test_R = cc_group.(matlab.lang.makeValidName(str'))(cc_group_size,1:2)+Right;
        if isempty(find(cc_group.(matlab.lang.makeValidName(str'))(:,1) == test_R(1,1) & cc_group.(matlab.lang.makeValidName(str'))(:,2) == test_R(1,2) | cc_group.(matlab.lang.makeValidName(str'))(:,1) == test_Up(1,1) & cc_group.(matlab.lang.makeValidName(str'))(:,2) == test_Up(1,2), 1))== 0
            %disp('true') 
            test1 = find(cc_group.(matlab.lang.makeValidName(str'))(:,1) == test_R(1,1) & cc_group.(matlab.lang.makeValidName(str'))(:,2) == test_R(1,2) | cc_group.(matlab.lang.makeValidName(str'))(:,1) == test_Up(1,1) & cc_group.(matlab.lang.makeValidName(str'))(:,2) == test_Up(1,2));
            cc_group.(matlab.lang.makeValidName(str'))(test1,3) = min(cc_group.(matlab.lang.makeValidName(str'))(test1,3));
            cc_group.(matlab.lang.makeValidName(str'))(cc_group_size,3) = min(cc_group.(matlab.lang.makeValidName(str'))(test1,3));
            %disp(test1) 
        end
    end
    
end
%}

%è¡é∏ã´äEÇÃóÃàÊï™ÇØ
%if isempty(vb) == 0
%{
    area=1;
    for vb_size = 1:size(vb(:,1))
        test_L =vb(vb_size,1:2)+Left;
        test_Un =vb(vb_size,1:2)+Under;
        test_LL = vb(vb_size,1:2)+LowerL;
        test_UL = vb(vb_size,1:2)+UpperL;
           
        if isempty(find(vb(:,1) == test_L(1,1) & vb(:,2) == test_L(1,2) | vb(:,1) == test_Un(1,1) & vb(:,2) == test_Un(1,2) | vb(:,1) == test_LL(1,1) & vb(:,2) == test_LL(1,2) | vb(:,1) == test_UL(1,1) & vb(:,2) == test_UL(1,2), 1))== 0
            %disp('true') 
            test1 = find(vb(:,1) == test_L(1,1) & vb(:,2) == test_L(1,2) | vb(:,1) == test_Un(1,1) & vb(:,2) == test_Un(1,2) |  vb(:,1) == test_LL(1,1) & vb(:,2) == test_LL(1,2) | vb(:,1) == test_UL(1,1) & vb(:,2) == test_UL(1,2));
            vb(test1,3) = min(vb(test1,3));
            vb(vb_size,3) = min(vb(test1,3));
            %disp(test1) 
        else
            %disp('false')
            vb(vb_size,3) = area;
            area = area+1;
        end
    end
    
    for vb_size = size(vb(:,1)):-1:1
        test_Up = vb(vb_size,1:2)+Up;
        test_R = vb(vb_size,1:2)+Right;
        test_LR = vb(vb_size,1:2)+LowerR;
        test_UR = vb(vb_size,1:2)+UpperR;
        if isempty(find(vb(:,1) == test_R(1,1) & vb(:,2) == test_R(1,2) | vb(:,1) == test_Up(1,1) & vb(:,2) == test_Up(1,2) | vb(:,1) == test_LR(1,1) & vb(:,2) == test_LR(1,2) | vb(:,1) == test_UR(1,1) & vb(:,2) == test_UR(1,2), 1))== 0
            %disp('true') 
            test1 = find(vb(:,1) == test_R(1,1) & vb(:,2) == test_R(1,2) | vb(:,1) == test_Up(1,1) & vb(:,2) == test_Up(1,2) | vb(:,1) == test_LR(1,1) & vb(:,2) == test_LR(1,2) | vb(:,1) == test_UR(1,1) & vb(:,2) == test_UR(1,2));
            vb(test1,3) = min(vb(test1,3));
            vb(vb_size,3) = min(vb(test1,3));
            %disp(test1) 
        end
    end
%}

    
%end