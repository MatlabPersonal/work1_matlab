%% ekf
clear;
clc;
n = 10000;
for i=1:n   
    L=randi(30000,1,1);
    if(false)
        ax = zeros(1,L);
        ay = zeros(1,L);
        az = zeros(1,L);
        gx = zeros(1,L);
        gy = zeros(1,L);
        gz = zeros(1,L);
        mx = zeros(1,L);
        my = zeros(1,L);
        mz = zeros(1,L);
    else
        ax = 16*rand(1,L);
        ay = 16*rand(1,L);
        az = 16*rand(1,L);
        gx = 2000*rand(1,L);
        gy = 2000*rand(1,L);
        gz = 2000*rand(1,L);
        mx = 49.12*rand(1,L);
        my = 49.12*rand(1,L);
        mz = 49.12*rand(1,L);
    end
    freq = randi(5,1,1)*20;
    time = linspace(1,L/freq,L);
    type = randi(4,1,1);
    tic
    % run process bin
    runAttitudeEstimator(gx,gy,gz,ax,ay,az,mx,my,mz,time,type);
    toc
end

%% EMG downsampler
