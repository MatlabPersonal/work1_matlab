function [q0,q1,q2,q3,roll,pitch,yaw] = runMotionIntensityClassfier(q0in,q1in,q2in,q3in,q0ind,q1ind,q2ind,q3ind,accin,frequency)
len = length(q0in);
roll = zeros(1,len);
pitch = zeros(1,len);
yaw = zeros(1,len);
q0 = zeros(1,len);
q1 = zeros(1,len);
q2 = zeros(1,len);
q3 = zeros(1,len);
window_size = round(frequency/226*10000);
n = fix(len/window_size);
algo_threshold = 0.3;

if(n == 0)
    if(std(accin)>algo_threshold)
        q0 = q0ind;
        q1 = q1ind;
        q2 = q2ind;
        q3 = q3ind;
    else
        q0 = q0in;
        q1 = q1in;
        q2 = q2in;
        q3 = q3in;
    end
    [roll,pitch,yaw] = quat2angle2Inverted([q0' q1' q2' q3'],'xyz');
    roll = roll';
    pitch = pitch';
    yaw = yaw';
else
    r = [];
    p = [];
    y = [];
    for i = 1:n
        acc_window = accin((i-1)*window_size+1:i*window_size);
        if(std(acc_window)>algo_threshold)
%             fprintf('debug: window %d used VU algo\n',i);
            quatjoint_VU = [q0ind' q1ind' q2ind' q3ind'];
            [rt,pt,yt] = quat2angle2Inverted(quatjoint_VU((i-1)*window_size+1:i*window_size,:),'xyz');
            r = [r; rt];
            p = [p; pt];
            y = [y; yt];
        else
%             fprintf('debug: window %d used UQ algo\n',i);
            quatjoint_UQ = [q0in' q1in' q2in' q3in'];
            [rt,pt,yt] = quat2angle2Inverted(quatjoint_UQ((i-1)*window_size+1:i*window_size,:),'xyz');
            r = [r; rt];
            p = [p; pt];
            y = [y; yt];
        end
    end
    acc_window = accin(n*window_size+1:end);
    if(std(acc_window)>algo_threshold)
        quatjoint_VU = [q0ind' q1ind' q2ind' q3ind'];
        [rt,pt,yt] = quat2angle2Inverted(quatjoint_VU(n*window_size+1:end,:),'xyz');
        r = [r; rt];
        p = [p; pt];
        y = [y; yt];
    else
        quatjoint_UQ = [q0in' q1in' q2in' q3in'];
        [rt,pt,yt] = quat2angle2Inverted(quatjoint_UQ(n*window_size+1:end,:),'xyz');
        r = [r; rt];
        p = [p; pt];
        y = [y; yt];
    end
    quattemp = angle2quatInverted(r,p,y,'xyz');
    q0 = quattemp(:,1)';
    q1 = quattemp(:,2)';
    q2 = quattemp(:,3)';
    q3 = quattemp(:,4)';
    roll = r';
    pitch = p';
    yaw = y';
end
end