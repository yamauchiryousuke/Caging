init_distance = 10;

for i=0:1:40
    close all hidden
    distance = i+init_distance;
    run('c_cls_obj_and_c_free_obj_in_se2_ver_a');
    run('show_figure_ver_a');
end