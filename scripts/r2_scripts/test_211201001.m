%{
for str = char(sort(cellstr(properties(cc_group))))'
    if (str' == 'cc_02')
        I_test = find(cc_group.(matlab.lang.makeValidName(str'))(:,1)==-155 & cc_group.(matlab.lang.makeValidName(str'))(:,2)==-16 | cc_group.(matlab.lang.makeValidName(str'))(:,1)==-155 & cc_group.(matlab.lang.makeValidName(str'))(:,2)==16);
        if(isempty(I_test)==1)
            disp('true')
        else
            disp(I_test)
        end
        cc_group.(matlab.lang.makeValidName(str'))(:,3)=0;
    end
end
%}
vb(:,3)=0;