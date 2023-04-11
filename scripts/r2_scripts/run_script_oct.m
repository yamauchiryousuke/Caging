% run_scripts

clear

file_name = '../../img/test_001.png';
magnification = 1;
robot_corners = 32;
dots_spacing = 1;
c_cls_search_interval = 1;
robot_r = 5;
dcc_search_interval = 1*c_cls_search_interval;
delta = 10^-8;

addpath('../../func','-end')
addpath('../../class','-end')

run('make_c_cls_obj')

file_name = '../../img/test_001_double.png';
QN=1;
magnification = 2^QN;
run('make_c_cls_obj_oct')

file_name = '../../img/test_001_quadruple.png';
QN=2;
magnification = 2^QN;
run('make_c_cls_obj_oct')

file_name = '../../img/test_001_octuple.png';
QN=3;
magnification = 2^QN;
run('make_c_cls_obj_oct')

%{
run('test_220707001')
run('show_data')

%{
for loop=1:6
    q_tree=1/(2^loop);
    run('test_220708001')
    %run('show_data')
end
run('show_data')
%}

run('test_220707002')
run('show_data')
run('test_220707003')
run('show_data')
run('test_220707004')
run('show_data')
%}
%}


