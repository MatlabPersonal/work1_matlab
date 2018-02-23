foldername = 'D:\Alan\20180117\';
folders = dir(foldername);
figure;
hold on;
colors = {'r','g','b','k','y','c'};
delay = [0 25 103 8];
for i = 3:length(folders)
    file{i-2}.name = folders(i).name;
    [file{i-2}.acc,~,~,~,~,~,...
    ~,~,~,~,...
    file{i-2}.time,~,~,~] = qu_file_v6c([foldername file{i-2}.name]);
    plot(file{i-2}.time + delay(i-2),file{i-2}.acc(:,2),colors{i-2});
end