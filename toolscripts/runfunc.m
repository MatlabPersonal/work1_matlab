clear;
clc;
folders = dir('C:\Users\dorsavi\Downloads');
for i = 6:13
    filename = ['C:\Users\dorsavi\Downloads\' folders(i).name];
    DRP_simulate_decode(filename);
    disp(i-5);
end