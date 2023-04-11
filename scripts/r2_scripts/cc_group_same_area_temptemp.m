%cc_group‚Ì—Ìˆæ•ª‚¯
Left = [-1 0];
Under = [0 -1];
Up = [0 1];
Right = [1 0];
area=1;

for str = char(sort(cellstr(properties(cc_group))))'
    for cc_group_size = size(cc_group.(genvarname(str'))(:,1)):-1:1
        if (str' == 'cc_02')
            test_L = cc_group.(genvarname(str'))(cc_group_size,1:2)+Left;
            test_Un = cc_group.(genvarname(str'))(cc_group_size,1:2)+Under;
            test_Up = cc_group.(genvarname(str'))(cc_group_size,1:2)+Up;
            test_R = cc_group.(genvarname(str'))(cc_group_size,1:2)+Right;
           
            if isempty(find(cc_group.(genvarname(str'))(:,1) == test_R(1,1) & cc_group.(genvarname(str'))(:,2) == test_R(1,2) | cc_group.(genvarname(str'))(:,1) == test_Up(1,1) & cc_group.(genvarname(str'))(:,2) == test_Up(1,2)))== 0
                %disp('true') 
                test1 = find(cc_group.(genvarname(str'))(:,1) == test_R(1,1) & cc_group.(genvarname(str'))(:,2) == test_R(1,2) | cc_group.(genvarname(str'))(:,1) == test_Up(1,1) & cc_group.(genvarname(str'))(:,2) == test_Up(1,2));
                cc_group.(genvarname(str'))(cc_group_size,3) = min(cc_group.(genvarname(str'))(test1,3));
                cc_group.(genvarname(str'))(test1,3) = min(cc_group.(genvarname(str'))(test1,3));
                %disp(test1) 
            else
                %disp('false')
                cc_group.(genvarname(str'))(cc_group_size,3) = area;
                area = area+1;
            end
            
        end
    end
    %{
    for cc_group_size = size(cc_group.(genvarname(str'))(:,1)):-1:1
        if (str' == 'cc_02')
        if isempty(find(cc_group.(genvarname(str'))(:,1) == test_R(1,1) & cc_group.(genvarname(str'))(:,2) == test_R(1,2) | cc_group.(genvarname(str'))(:,1) == test_Up(1,1) & cc_group.(genvarname(str'))(:,2) == test_Up(1,2)))== 0
            %disp('true') 
            test1 = find(cc_group.(genvarname(str'))(:,1) == test_R(1,1) & cc_group.(genvarname(str'))(:,2) == test_R(1,2) | cc_group.(genvarname(str'))(:,1) == test_Up(1,1) & cc_group.(genvarname(str'))(:,2) == test_Up(1,2));
            cc_group.(genvarname(str'))(cc_group_size,3) = min(cc_group.(genvarname(str'))(test1,3));
            cc_group.(genvarname(str'))(test1,3) = min(cc_group.(genvarname(str'))(test1,3));
            %disp(test1) 
        end
        end
    end
    %}
end