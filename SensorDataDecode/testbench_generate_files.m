addpath('D:\Derek\Matlab\toolscripts');
output_head = 'D:\Derek\Matlab\ProcessBinDLL\generated_bins\mdm000';
counter = 1;
for i = 2:4
    for j = 1:10;
        disp(counter);
        filename = [output_head num2str(i) '-' num2str(j) '.bin'];
        randomBinGenerator(20,20,1000,0,0,600,filename);
        counter = counter + 1;
    end
end