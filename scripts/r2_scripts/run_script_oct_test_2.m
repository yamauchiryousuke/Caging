% run_scripts

clear

file_name = '../../img/test_001_octuple.png';
magnification = 1;
MN=3;
robot_corners = 32*8;
dots_spacing = 1;
robot_r = 5*8;
%c_cls_search_interval = robot_r*1.41;
c_cls_search_interval = 2^MN;
%c_cls_search_interval = 5*8*2;
org_interval = c_cls_search_interval;
%dcc_search_interval = 1*c_cls_search_interval;
delta = 10^-8;
QN=1;

addpath('../../func','-end')
addpath('../../class','-end')

run('make_c_cls_obj')

for QN=1:MN
    c_cls_search_interval = org_interval/2^QN;
    run('test_220908001')
    QN;
end
magnification = 3;
run('show_data_c_cls')

dcc_search_interval=8;
org_interval=dcc_search_interval;

run('test_220707001')
run('show_data')

MN=3;
for QN=1:MN
    dcc_search_interval=dcc_search_interval/2;
    run('test_220708001')
    run('show_data')
end

%run('show_data')
%{
run('test_220707002')
run('show_data')
run('test_220707003')
run('show_data')
run('test_220707004')
run('show_data')
%}
%}


