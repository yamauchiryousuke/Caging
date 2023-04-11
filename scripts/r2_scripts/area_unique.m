for str = char(sort(cellstr(properties(cc_group))))'
    area_unique_cc_group.(matlab.lang.makeValidName(sprintf('%s',str))) = double.empty;
    area_unique_cc_group.(matlab.lang.makeValidName(str')) = unique(cc_group.(matlab.lang.makeValidName(str'))(:,3));
end
%area_unique_vb = unique(vb(:,3));
