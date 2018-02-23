function [acc_left,acc_right,highg_left,highg_right,time] = synchroniseSensors(laccy,raccy,lhigh_g_interpy,rhigh_g_interpy,ltimeInterp,lcursor,rcursor)
acc_left = zeros(1,1);
acc_right = zeros(1,1);
highg_left = zeros(1,1);
highg_right = zeros(1,1);
time = zeros(1,1);
laccy = laccy(lcursor(1):lcursor(2));
lhigh_g_interpy = lhigh_g_interpy(lcursor(1):lcursor(2));
raccy = raccy(rcursor(1):rcursor(2));
rhigh_g_interpy = rhigh_g_interpy(rcursor(1):rcursor(2));
time = ltimeInterp(lcursor(1):lcursor(2)) - ltimeInterp(lcursor(1));
freq = 1000./mean(diff(time));

[B,A] = butter(5,20/(1000/2),'low');
laccy = filtfilt(B,A,double(laccy'));
raccy = filtfilt(B,A,double(raccy'));
lhigh_g_interpy = filtfilt(B,A,double(lhigh_g_interpy'));
rhigh_g_interpy = filtfilt(B,A,double(rhigh_g_interpy'));

n = length(laccy)*100/freq;
acc_left = interp1(1:length(laccy),laccy,linspace(1,length(laccy),n));
acc_right = interp1(1:length(raccy),raccy,linspace(1,length(raccy),n));
highg_left = interp1(1:length(lhigh_g_interpy),lhigh_g_interpy,linspace(1,length(lhigh_g_interpy),n));
highg_right = interp1(1:length(rhigh_g_interpy),rhigh_g_interpy,linspace(1,length(rhigh_g_interpy),n));
time = interp1(1:length(time),time,linspace(1,length(time),n));
if(size(acc_left,2)==1)
    acc_left = acc_left';
    acc_right = acc_right';
    highg_left = highg_left';
    highg_right = highg_right';
end
end