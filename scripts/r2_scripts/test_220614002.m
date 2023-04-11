% run_scripts

clear

file_name = '../../img/test_001_double.png';
magnification = 1;
robot_corners = 32;
dots_spacing = 1;
c_cls_search_interval = 1;
robot_r = 5*magnification*2;
dcc_search_interval = 1*c_cls_search_interval;
delta = 10^-8;

addpath('../../func','-end')
addpath('../../class','-end')

run('make_mccr2_test')
%run('make_mccr2_test2')
%run('test_220609001')
run('check_boundarys')
run('show_data')
run('show_mccr_r_theta180')
