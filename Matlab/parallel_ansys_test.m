% clear all
% close all
clc

Model.working_dir = 'd:\Working folder\ANSYS working folder\frame_test';
Model.input_file  = 'frame_test.mac';
Model.input_var.Fx= linspace(1e4,2e4,10);
Model.input_var.Fy= linspace(1e4,2e4,10);
Model.ansys_exe   = 'C:\Program Files\ANSYS Inc\v162\ANSYS\bin\winx64\ansys162.exe';
Model.result_file = {'mid_displ_x.txt'; 'mid_displ_y.txt'};

R = parallel_ansys(Model);

mid_displ_x = cell2mat({R(:).mid_displ_x})
mid_displ_y = cell2mat({R(:).mid_displ_y})