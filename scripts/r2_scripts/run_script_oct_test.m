% run_scripts
clear

file_name = '../../img/test_001.png';
magnification = 1;
robot_corners = 32;
dots_spacing = 1;
c_cls_search_interval = 8;
robot_r = 5;
dcc_search_interval = 1*c_cls_search_interval;
delta = 10^-8;

addpath('../../func','-end')
addpath('../../class','-end')

run('make_c_cls_obj')

c_cls_search_interval = 4;
run('test_220908001')

c_cls_search_interval = 2;
run('test_220908001')

c_cls_search_interval = 1;
run('test_220908001')


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
%}