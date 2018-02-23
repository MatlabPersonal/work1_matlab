clear;
clc;

filename = 'D:\Derek\Matlab\gait_study\Data\DataOutput_DVS\Data_2302_DER\SW2_RSK.bin';
m = memmapfile(filename);
A = m.Data;
[laccx,laccy,laccz,~,~,~,~,~,~,...
    lhigh_g_interpx,lhigh_g_interpy,lhigh_g_interpz,...
    ~,~,ltimeInterp] = process_bin_V1(A',16,100,2000,49.12);

filename = 'D:\Derek\Matlab\gait_study\Data\DataOutput_DVS\Data_2302_DER\6B_LSK.bin';
m = memmapfile(filename);
A = m.Data;
[raccx,raccy,raccz,~,~,~,~,~,~,...
    rhigh_g_interpx,rhigh_g_interpy,rhigh_g_interpz,...
    ~,~,rtimeInterp] = process_bin_V1(A',16,100,2000,49.12);
figure;
plot(ltimeInterp,laccy); hold on;
plot(rtimeInterp,raccy,'r');
