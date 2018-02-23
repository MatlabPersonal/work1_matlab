%% load data
raw_data_normal = xlsread('D:\Derek\Matlab\EKFProcessFileDLL\EKFprocessFileDLL\data\Pfizer data\STemp Normal.csv');
raw_data_LBP = xlsread('D:\Derek\Matlab\EKFProcessFileDLL\EKFprocessFileDLL\data\Pfizer data\FSarg LowBackPain.csv');
data_normal.acc1 = raw_data_normal(:,3:5);
data_normal.gyro1 = raw_data_normal(:,9:11);
data_normal.acc2 = raw_data_normal(:,12:14);
data_normal.gyro2 = raw_data_normal(:,18:20);
data_normal.emg = raw_data_normal(:,21:22);
data_normal.euler1 = raw_data_normal(:,23:24);
data_normal.euler2 = raw_data_normal(:,26:27);
data_normal.euler_joint = raw_data_normal(:,29:30);

data_LBP.acc1 = raw_data_LBP(:,3:5);
data_LBP.gyro1 = raw_data_LBP(:,9:11);
data_LBP.acc2 = raw_data_LBP(:,12:14);
data_LBP.gyro2 = raw_data_LBP(:,18:20);
data_LBP.emg = raw_data_LBP(:,21:22);
data_LBP.euler1 = raw_data_LBP(:,23:24);
data_LBP.euler2 = raw_data_LBP(:,26:27);
data_LBP.euler_joint = raw_data_LBP(:,29:30);

%% Process with EKF - depreciated
n = length(data_normal.acc1(:,1));
time = linspace(1,n*50,n);
data_normal.q1 = zeros(n,4);
[data_normal.q1(:,1),data_normal.q1(:,2),data_normal.q1(:,3),data_normal.q1(:,4),~,~,~] =...
    runAttitudeEstimator(data_normal.gyro1(:,2)',data_normal.gyro1(:,1)',data_normal.gyro1(:,3)',...
                         data_normal.acc1(:,2)',data_normal.acc1(:,1)',data_normal.acc1(:,3)',zeros(1,n),zeros(1,n),zeros(1,n),time,2);
                     
[data_normal.q1(:,1),data_normal.q1(:,2),data_normal.q1(:,3),data_normal.q1(:,4),~,~,~] =...
    runQuaternionCalibrator(data_normal.q1(:,1)',data_normal.q1(:,2)',data_normal.q1(:,3)',data_normal.q1(:,4)',134);

data_normal.q2 = zeros(n,4);
[data_normal.q2(:,1),data_normal.q2(:,2),data_normal.q2(:,3),data_normal.q2(:,4),~,~,~] =...
    runAttitudeEstimator(data_normal.gyro2(:,2)',data_normal.gyro2(:,1)',data_normal.gyro2(:,3)',...
                         data_normal.acc2(:,2)',data_normal.acc2(:,1)',data_normal.acc2(:,3)',zeros(1,n),zeros(1,n),zeros(1,n),time,2);
                     
[data_normal.q2(:,1),data_normal.q2(:,2),data_normal.q2(:,3),data_normal.q2(:,4),~,~,~] =...
    runQuaternionCalibrator(data_normal.q2(:,1)',data_normal.q2(:,2)',data_normal.q2(:,3)',data_normal.q2(:,4)',134);

data_normal.q = zeros(n,4);
[data_normal.q(:,1),data_normal.q(:,2),data_normal.q(:,3),data_normal.q(:,4),data_normal.euler_new(:,1),data_normal.euler_new(:,2),data_normal.euler_new(:,3)] =...
    runJointAngleCalculator(data_normal.q1(:,1)',data_normal.q1(:,2)',data_normal.q1(:,3)',data_normal.q1(:,4)',...
                            data_normal.q2(:,1)',data_normal.q2(:,2)',data_normal.q2(:,3)',data_normal.q2(:,4)');
figure;
subplot(211)
plot(data_normal.euler_new(:,1)*180/pi); hold on; plot(data_normal.euler2(:,2),'r');
subplot(212)
plot(data_normal.euler_new(:,2)*180/pi); hold on; plot(data_normal.euler2(:,1),'r');

%% Process with euler angles
acc = [data_LBP.acc1(:,1) data_LBP.acc1(:,2) data_LBP.acc1(:,3)];
[data_LBP.FX1,data_LBP.LFX1] = calculateDipAngle(acc);
data_LBP.FX1 = data_LBP.FX1 - data_LBP.FX1(1) + data_LBP.euler1(1,1);
figure;
plot(data_LBP.FX1); hold on;
plot(data_LBP.euler1(:,1),'r');

acc = [data_LBP.acc2(:,1) data_LBP.acc2(:,2) data_LBP.acc2(:,3)];
[data_LBP.FX2,data_LBP.LFX2] = calculateDipAngle(acc);
data_LBP.FX2 = data_LBP.FX2 - data_LBP.FX2(1) + data_LBP.euler2(1,1);
figure;
plot(data_LBP.FX2); hold on;
plot(data_LBP.euler2(:,1),'r');

data_LBP.FXJoint = -data_LBP.FX1 + data_LBP.FX2;
figure;
plot(data_LBP.FXJoint); hold on;
plot(data_LBP.euler_joint(:,1),'r');

acc = [data_normal.acc1(:,1) data_normal.acc1(:,2) data_normal.acc1(:,3)];
[data_normal.FX1,data_normal.LFX1] = calculateDipAngle(acc);
data_normal.FX1 = data_normal.FX1 - data_normal.FX1(1) + data_normal.euler1(1,1);
figure;
plot(data_normal.FX1); hold on;
plot(data_normal.euler1(:,1),'r');

acc = [data_normal.acc2(:,1) data_normal.acc2(:,2) data_normal.acc2(:,3)];
[data_normal.FX2,data_normal.LFX2] = calculateDipAngle(acc);
data_normal.FX2 = data_normal.FX2 - data_normal.FX2(1) + data_normal.euler2(1,1);
figure;
plot(data_normal.FX2); hold on;
plot(data_normal.euler2(:,1),'r');

data_normal.FXJoint = -data_normal.FX1 + data_normal.FX2;
figure;
plot(data_normal.FXJoint); hold on;
plot(data_normal.euler_joint(:,1),'r');