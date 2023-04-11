% run_scripts

clear

file_name = '../../img/test_001.png';
%magnification = 1;
robot_corners = 32;
dots_spacing = 1;
c_cls_search_interval = 1;
robot_r = 5;
dcc_search_interval = 1*c_cls_search_interval;
%dcc_search_interval = 1;
delta = 10^-8;

addpath('../../func','-end')
addpath('../../class','-end')

run('make_mccr2')
%run('test_220609001')
run('check_boundarys')
run('show_data')
%run('show_mccr_r_theta')
%run('show_mccr_r_theta180')
%{
run('cc_group_same_area')
run('area_unique')
run('show_data_color_kai')
run('show_mccr_r_theta180_color_kai')
%}

