function [Stc,acc,gyro] = codegen_read_data(in_csv_loc)

% Utility function to read CSV file.  We do not generate code from this
% function.

data=dlmread(in_csv_loc);
Stc=data(:,1);
acc=data(:,2:4);
gyro=data(:,5:7);