clear

robot_corners = 32;
dots_spacing = 1;
c_cls_search_interval = 1;
robot_r = 5;
dcc_search_interval = 1*c_cls_search_interval;
delta = 10^-8;

addpath('../../func','-end')
addpath('../../class','-end')

s_x = round(robot_r*cos(transpose(1:robot_corners)*2*pi/robot_corners),3);
s_y = round(robot_r*sin(transpose(1:robot_corners)*2*pi/robot_corners),3);
%robo_ptCloud = pointCloud([s_x,s_y,s_z]);
sphere_threshold = Inf;
sphere_shp = alphaShape(s_x, s_y ,sphere_threshold); 

[qx, qy] = meshgrid(-10:1:10, -10:1:10);
figure;
in = inShape(sphere_shp,qx,qy);
plot(sphere_shp)
hold on
plot(qx(in),qy(in),'r.')
plot(qx(~in),qy(~in),'b.')
