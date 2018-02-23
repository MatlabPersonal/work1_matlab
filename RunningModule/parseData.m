% Parse data

playerTemp{1,1}=load('player1_run1_measured.mat');
playerTemp{1,2}=load('player1_run1_true.mat');
playerTemp{2,1}=load('player2_run1_measured.mat');
playerTemp{2,2}=load('player2_run1_true.mat');
playerTemp{3,1}=load('player3_run1_measured.mat');
playerTemp{3,2}=load('player3_run1_true.mat');
playerTemp{4,1}=load('player4_run1_measured.mat');
playerTemp{4,2}=load('player4_run1_true.mat');
playerTemp{5,1}=load('player5_run1_measured.mat');
playerTemp{5,2}=load('player5_run1_true.mat');
playerTemp{6,1}=load('player6_run1_measured.mat');
playerTemp{6,2}=load('player6_run1_true.mat');
playerTemp{7,1}=load('player7_run1_measured.mat');
playerTemp{7,2}=load('player7_run1_true.mat');
playerTemp{8,1}=load('player8_run1_measured.mat');
playerTemp{8,2}=load('player8_run1_true.mat');
playerTemp{9,1}=load('player9_run1_measured.mat');
playerTemp{9,2}=load('player9_run1_true.mat');
playerTemp{10,1}=load('player10_run1_measured.mat');
playerTemp{10,2}=load('player10_run1_true.mat');

playerTemp{11,1}=load('player11_run1_measured.mat');
playerTemp{11,2}=load('player11_run1_true.mat');
playerTemp{12,1}=load('player12_run1_measured.mat');
playerTemp{12,2}=load('player12_run1_true.mat');
playerTemp{13,1}=load('player13_run1_measured.mat');
playerTemp{13,2}=load('player13_run1_true.mat');
playerTemp{14,1}=load('player14_run1_measured.mat');
playerTemp{14,2}=load('player14_run1_true.mat');
playerTemp{15,1}=load('player15_run1_measured.mat');
playerTemp{15,2}=load('player15_run1_true.mat');
playerTemp{16,1}=load('player16_run1_measured.mat');
playerTemp{16,2}=load('player16_run1_true.mat');
playerTemp{17,1}=load('player17_run1_measured.mat');
playerTemp{17,2}=load('player17_run1_true.mat');
playerTemp{18,1}=load('player18_run1_measured.mat');
playerTemp{18,2}=load('player18_run1_true.mat');
%playerTemp{19,1}=load('player19_run1_measured.mat');
%playerTemp{19,2}=load('player19_run1_true.mat');
playerTemp{20,1}=load('player20_run1_measured.mat');
playerTemp{20,2}=load('player20_run1_true.mat');

playerTemp{21,1}=load('player21_run1_measured.mat');
playerTemp{21,2}=load('player21_run1_true.mat');
playerTemp{22,1}=load('player22_run1_measured.mat');
playerTemp{22,2}=load('player22_run1_true.mat');
playerTemp{23,1}=load('player23_run1_measured.mat');
playerTemp{23,2}=load('player23_run1_true.mat');
playerTemp{24,1}=load('player24_run1_measured.mat');
playerTemp{24,2}=load('player24_run1_true.mat');
playerTemp{25,1}=load('player25_run1_measured.mat');
playerTemp{25,2}=load('player25_run1_true.mat');
playerTemp{26,1}=load('player26_run1_measured.mat');
playerTemp{26,2}=load('player26_run1_true.mat');
m=1;

if 0
playerTemp{1,1}=load('player1_run2_measured.mat');
playerTemp{1,2}=load('player1_run2_true.mat');
playerTemp{2,1}=load('player2_run2_measured.mat');
playerTemp{2,2}=load('player2_run2_true.mat');
playerTemp{3,1}=load('player3_run2_measured.mat');
playerTemp{3,2}=load('player3_run2_true.mat');
playerTemp{4,1}=load('player4_run2_measured.mat');
playerTemp{4,2}=load('player4_run2_true.mat');
playerTemp{5,1}=load('player5_run2_measured.mat');
playerTemp{5,2}=load('player5_run2_true.mat');
playerTemp{6,1}=load('player6_run2_measured.mat');
playerTemp{6,2}=load('player6_run2_true.mat');
playerTemp{7,1}=load('player7_run2_measured.mat');
playerTemp{7,2}=load('player7_run2_true.mat');
playerTemp{8,1}=load('player8_run2_measured.mat');
playerTemp{8,2}=load('player8_run2_true.mat');
playerTemp{9,1}=load('player9_run2_measured.mat');
playerTemp{9,2}=load('player9_run2_true.mat');
playerTemp{10,1}=load('player10_run2_measured.mat');
playerTemp{10,2}=load('player10_run2_true.mat');
m=2;


playerTemp{1,1}=load('player1_run3_measured.mat');
playerTemp{1,2}=load('player1_run3_true.mat');
playerTemp{2,1}=load('player2_run3_measured.mat');
playerTemp{2,2}=load('player2_run3_true.mat');
playerTemp{3,1}=load('player3_run3_measured.mat');
playerTemp{3,2}=load('player3_run3_true.mat');
playerTemp{4,1}=load('player4_run3_measured.mat');
playerTemp{4,2}=load('player4_run3_true.mat');
playerTemp{5,1}=load('player5_run3_measured.mat');
playerTemp{5,2}=load('player5_run3_true.mat');
playerTemp{6,1}=load('player6_run3_measured.mat');
playerTemp{6,2}=load('player6_run3_true.mat');
playerTemp{7,1}=load('player7_run3_measured.mat');
playerTemp{7,2}=load('player7_run3_true.mat');
playerTemp{8,1}=load('player8_run3_measured.mat');
playerTemp{8,2}=load('player8_run3_true.mat');
playerTemp{9,1}=load('player9_run3_measured.mat');
playerTemp{9,2}=load('player9_run3_true.mat');
playerTemp{10,1}=load('player10_run3_measured.mat');
playerTemp{10,2}=load('player10_run3_true.mat');

%playerTemp{11,1}=load('player11_run3_measured.mat');
%playerTemp{11,2}=load('player11_run3_true.mat');
%playerTemp{12,1}=load('player12_run3_measured.mat');
%playerTemp{12,2}=load('player12_run3_true.mat');
playerTemp{13,1}=load('player13_run3_measured.mat');
playerTemp{13,2}=load('player13_run3_true.mat');
playerTemp{14,1}=load('player14_run3_measured.mat');
playerTemp{14,2}=load('player14_run3_true.mat');
playerTemp{15,1}=load('player15_run3_measured.mat');
playerTemp{15,2}=load('player15_run3_true.mat');
playerTemp{16,1}=load('player16_run3_measured.mat');
playerTemp{16,2}=load('player16_run3_true.mat');
playerTemp{17,1}=load('player17_run3_measured.mat');
playerTemp{17,2}=load('player17_run3_true.mat');
playerTemp{18,1}=load('player18_run3_measured.mat');
playerTemp{18,2}=load('player18_run3_true.mat');
playerTemp{19,1}=load('player19_run3_measured.mat');
playerTemp{19,2}=load('player19_run3_true.mat');
playerTemp{20,1}=load('player20_run3_measured.mat');
playerTemp{20,2}=load('player20_run3_true.mat');

playerTemp{21,1}=load('player21_run3_measured.mat');
playerTemp{21,2}=load('player21_run3_true.mat');
playerTemp{22,1}=load('player22_run3_measured.mat');
playerTemp{22,2}=load('player22_run3_true.mat');
playerTemp{23,1}=load('player23_run3_measured.mat');
playerTemp{23,2}=load('player23_run3_true.mat');
playerTemp{24,1}=load('player24_run3_measured.mat');
playerTemp{24,2}=load('player24_run3_true.mat');
playerTemp{25,1}=load('player25_run3_measured.mat');
playerTemp{25,2}=load('player25_run3_true.mat');
playerTemp{26,1}=load('player26_run3_measured.mat');
playerTemp{26,2}=load('player26_run3_true.mat');
m=3;
end

%% Plot
symbol = {'x','o','*','^','.','+'}; colour = {'r','g','b','c','k','m'};
a(1)=subplot(2,1,1);plot(dataPlayer(:,2)); hold on; for i=1:6 plot(gaitEventsTrue{i},dataPlayer(gaitEventsTrue{i},2),strcat(colour{i},symbol{i}),'linewidth',2); end; legend('RAW','FS','IPA','FF','TO','ST','END');
a(2)=subplot(2,1,2);plot(dataPlayer(:,3)); hold on; for i=7:12 plot(gaitEventsTrue{i},dataPlayer(gaitEventsTrue{i},3),strcat(colour{i-6},symbol{i-6}),'linewidth',2);end; linkaxes(a,'x');

