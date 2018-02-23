%% This is written on 2017/12/04 for comparison between new and old results
clear;
clc;
data_new = load('D:\Derek\Matlab\UQ\Matlab\quat_recal_20170619\Wolly.mat');
data_old = load('D:\Derek\Matlab\UQ\Matlab\quat_recal_20170619\EKF Output\s10.mat');

%%
%process data
clc;
cd('D:\Derek\Matlab\UQ\Matlab');
cursors_natalie = [766.954475610324,875.890429110919,955.481852024889,1163.17064263012,1678.13116240518,1904.74412917296,1956.17734306314,1994.20665375998,2066.72576556562,2103.26722313458,2162.40827880638,2195.37344472423,2325.99612702862,2386.01570306998,2509.00780377285,2597.53954834085,2689.54798479365,2786.83550632369,2845.24278903616]; % i=1
cursors_melanie = [662.5,750.3,813.3,888.3,1020,1063.2,1122.1,1158.7,1218.3,1255.5,1333.600,1371.7,1445.5,1487.8,1654,1729.5,1818.5,1900,1966.5]-632.7; %i=3
cursors_saulo = [302.007555328322,380.844831921879,454.829258871597,554.175934706567,692.355057165862,727.346830091348,772.665633393010,806.775263884884,890.185384572574,923.882316943481,981.391792068143,1015.76037134760,1095.37110026575,1136.50356884162,1288.15715078753,1392.15972101938,1487.60262101736,1583.49858263431,1638.20059642476]-273.3; %i=4
cursors_joseph = [2063.50000000000,2170.38618716649,2242.92681096526,2311.27997142683,2453.35522773063,2477.18236393553,2511.06038194639,2539.53253281641,2610.76486606630,2635.78114572929,2716.81751528176,2743.40437574944,2814.59055798889,2840.02309291776,2988.20739118994,3138.94843244398,3230.32980039685,3309.5926171928,3356.38631676537]-2035.3; %i=6
cursors_gerard = [598.006494195369,683.947681360578,752.237261823720,818.042646520081,949.009893267221,1017.61279910320,1072.14480378842,1100.08187045113,1145.13041911536,1177.99744219833,1223.43784529243,1254.03962194809,1312.46611370766,1344.96568311224,1472.68288971730,1584.48751069531,1676.13178145314,1749.80759237953,1806.78537648875]-570.4; %i=7
cursors_edgar = [414.931523275026,505.140886007865,575.066322799432,653.114868126598,786.764567311507,817.109216943135,850.771017567384,883.282931523360,926.964843425289,956.823411911972,1011.21470991216,1044.46427691983,1109.38633445327,1145.0469568700,1242.50188904374,1312.08273818420,1401.98458789970,1517.50909785606,1584.26324989579]-387.3; % %i=8
cursors_mark = [378.840009447790,456.754158098594,518.496401493116,598.015365395569,726.271384405070,757.125258348459,809.306537324088,837.400470452871,883.939061554936,911.841128335017,962.200851508685,994.022012348961,1056.86013020331,1097.00186191341,1219.63598014749,1317.79944427399,1415.34482757023,1488.22960226625,1548.80585754646]-351.2; %i=9
cursors_wolly = [363.001864788600,426.599349996702,487.846703195818,553.370440512141,736.089607128744,770.681141241334,807.979963634905,840.464128781498,880.186965228781,909.424708050862,944.981958511909,978.911187427738,1038.49169250618,1074.75668434339,1175.85674838781,1232.59094461947,1322.43517791657,1418.70001806166,1476.03307018336]-337.5; %i=10
cursors_esther = [287.467280885027,365.843226882543,435.304951485797,496.593200442292,586.482282654588,635.691951529832,673.239960286128,720.776269067998,757.486377442724,788.909867149396,820.710549926304,852.785984287018,916.067921711457,949.543629436827,1039.46445527249,1102.51398326939,1177.94915398225,1240.82967728019,1300.45491861475]-260.5; %i=2;

cursorsAll = [zeros(1,19);cursors_melanie;cursors_saulo;zeros(1,19);cursors_joseph;cursors_gerard;cursors_edgar;cursors_mark;cursors_wolly;cursors_esther];
names = {'Viena','Melanie','Saulo','Natalie','Joseph','Gerard','Edgar','Mark','Wolly','Esther'};

idx=[16,18,19,8,6,3,10,11,4,5,1,2,12,13,15,9,14,7,17];

cursors = cursorsAll(Subject,:);
% cursors = cursors_wolly;
calibrationRange = fix(cursors(1).*length(s6.time)./(s6.time(end)./1000))+fix(length(s6.time)./222);
% data = temp;

MovementTypes={'Normal standing','Walking 3kmph','Walking 5kmph','Running 8kmph','Flexion(standing)','Extension (standing)','Lateral flexion Left (standing)',...
    'Lateral flexion right(standing)','Flex+Rot.left+lat.flex.left','Flex+Rot.right+lat.flex.right','Ext+Rot.left+lat.flex.right',...
    'Ext+Rot.right+lat.flex.right','Rotation Left (sitting)','Rotation Right (sitting)','Stair walking up or down (3 steps)','Jump from height',...
    'Sit-stand transfer','Whatever','Reference2 (Normal standing)'};

quatIndex = 1:4;
[B,A]=butter(2,20/frequency(freqIndex),'low');
q_combined = filtfilt(B,A,q_combined);
%sensor data
timeSensor = s6.time/1000;
% quatS8 = filtfilt(B,A,s8.EKF);
% quatS6 = filtfilt(B,A,s6.EKF);
% % quatS3 = filtfilt(B,A,s3.EKF);

% quatS8mat = filtfilt(B,A,s8.matEKF);
% quatS6mat = filtfilt(B,A,s6.matEKF);

% calQuatL5S1_ViMove = mean(quatS8(calibrationRange:calibrationRange+10,quatIndex)); 
% calQuatT12L1_ViMove = mean(quatS6(calibrationRange:calibrationRange+10,quatIndex));
% dataQuatL5S1Cal_ViMove = quatmult((quatS8(:,quatIndex)),quatconj(calQuatL5S1_ViMove))';
% dataQuat12L1Cal_ViMove = quatmult((quatS6(:,quatIndex)),quatconj(calQuatT12L1_ViMove))';
% dataQuatT12L1_L5S1_ViMove = quatmult(dataQuatL5S1Cal_ViMove ,quatconj(dataQuat12L1Cal_ViMove))';

% calQuatL5S1_ViMove_mat = mean(quatS8mat(calibrationRange:calibrationRange+10,quatIndex)); 
% calQuatT12L1_ViMove_mat = mean(quatS6mat(calibrationRange:calibrationRange+10,quatIndex));
% dataQuatL5S1Cal_ViMove_mat = quatmult((quatS8mat(:,quatIndex)),quatconj(calQuatL5S1_ViMove_mat))';
% dataQuat12L1Cal_ViMove_mat = quatmult((quatS6mat(:,quatIndex)),quatconj(calQuatT12L1_ViMove_mat))';
% dataQuatT12L1_L5S1_ViMove_mat = quatmult(dataQuatL5S1Cal_ViMove_mat ,quatconj(dataQuat12L1Cal_ViMove_mat))';

% [roll,pitch,yaw] = quat2angle2(dataQuatT12L1_L5S1_ViMove,'XYZ'); 
% dataQuatT12L1_L5S1_ViMove_mat = [q0' q1' q2' q3'];
% [rollmat,pitchmat,yawmat] = quat2angle2(quatconj(dataQuatT12L1_L5S1_ViMove_mat),'XYZ'); 

[rOut,pOut,~] = quat2angle2(q_combined,'XYZ'); 
rollmat = -rOut';
pitchmat = -pOut';

% h=figure('units','normalized','outerposition',[0 0 1 1]);
% a(1)=subplot(2,1,1);
% % plot(s6.time(1:end)/1000,pitch*180/pi,'k','linewidth',2); hold on;
% plot(-0.3+s6.time(1:end)/1000,pitchmat*180/pi,'k--','linewidth',1); hold on;
% legend('java','matlab');
% title(strcat(names(Subject),strcat(', sag, fs=',strcat(num2str(frequency(freqIndex)),'Hz'))));
% a(2)=subplot(2,1,2);
% % plot(0.3+s6.time(1:end)/1000,roll*180/pi,'k','linewidth',2); hold on;
% plot(-0.3+s6.time(1:end)/1000,rollmat*180/pi,'k--','linewidth',1); hold on;
% legend('java','matlab');
% title('ML');


% Calibrate Vicon - static trial i=16 and derive calibration Quaternions

calQuatL5S1 = mean(data{1,16}.Quat_L5S1(1000:2000,:));
calQuatT12L1 = mean(data{1,16}.Quat_T12L1(1000:2000,:));
color = {'b','r','g','y',[.5 .6 .7],[.8 .2 .6]};
l=1;
RMSE_sag = zeros(1,19);
RMSE_ml = zeros(1,19);
    for k=idx
        if(~isempty(data{1,k}))    
            dataQuatL5S1 = quatmult(data{1,k}.Quat_L5S1,quatconj(calQuatL5S1))';
            dataQuatT12L1 = quatmult(data{1,k}.Quat_T12L1,quatconj(calQuatT12L1))';
            dataQuatT12L1_L5S1 = quatmult(quatconj(dataQuatT12L1),dataQuatL5S1)';
            
            [rollVicon,pitchVicon,yawVicon] = quat2angle2(dataQuatT12L1_L5S1,'XYZ');
%             subplot(a(1));            
%             plot(linspace(0,length(yawVicon)/200,length(yawVicon))+cursors(l),-pitchVicon*180/pi,'linewidth',2,'color',color{mod(l,6)+1});hold on;grid;
%             
%             subplot(a(2));
%             plot(linspace(0,length(rollVicon)/200,length(rollVicon))+cursors(l),-rollVicon*180/pi,'linewidth',2,'color',color{mod(l,6)+1});hold on;grid;
            
            %for calculating RMSE
            timeVicon = linspace(0,length(yawVicon)/200,length(yawVicon))+cursors(l);
            viconInterp_sag = interp1(timeVicon,-pitchVicon*180/pi,timeSensor);
            viconInterp_ml = interp1(timeVicon,-rollVicon*180/pi,timeSensor);
            
            tempSensorQuat_sag = pitchmat'*180/pi;
            tempSensorQuat_ml = rollmat'*180/pi;
            tempValue = length(pitchmat)./(s6.time(end)./1000);
            
            tempSensorQuat_sag = tempSensorQuat_sag(fix((cursors(l)+0.3)*tempValue):(fix((cursors(l)+0.3)*tempValue+length(yawVicon)*(frequency(freqIndex)./226))-1));
            tempSensorQuat_ml = tempSensorQuat_ml(fix((cursors(l)+0.3)*tempValue):(fix((cursors(l)+0.3)*tempValue+length(yawVicon)*(frequency(freqIndex)./226))-1));
            viconInterp_sag(isnan(viconInterp_sag))=[];    
            viconInterp_ml(isnan(viconInterp_ml))=[];
            
            [data1,data2] = shiftCursor(tempSensorQuat_sag,viconInterp_sag);
            [data3,data4] = shiftCursor(tempSensorQuat_ml,viconInterp_ml);
            figure;
%             plot([(viconInterp_sag(1:fix(length(viconInterp_sag)*0.6))) tempSensorQuat_sag(1:fix(length(viconInterp_sag)*0.6))]);   
%             plot([(viconInterp_ml(1:fix(length(viconInterp_ml)*0.6))) tempSensorQuat_ml(1:fix(length(viconInterp_ml)*0.6))]);
            subplot(2,1,1);            
            plot([data1 data2]);
            subplot(2,1,2);   
            plot([data3 data4]);
            
            RMSE(l,2)=getRMSE(data2,data1);
            RMSE(l,1)=getRMSE(data4,data3);
            [meanDiff_sag(l),stdDiff_sag(l)]=BlandAltmanPlot(data1,data2,'1',false);
            [meanDiff_ml(l),stdDiff_ml(l)]=BlandAltmanPlot(data3,data4,'1',false);
            l=l+1;
        end     
    end

meanDiff_sag = meanDiff_sag';
stdDiff_sag =stdDiff_sag';
meanDiff_ml = meanDiff_ml';
stdDiff_ml = stdDiff_ml';

error_results = zeros(19,6);
error_results(:,1) = RMSE_sag;
error_results(:,2) = RMSE_ml;
error_results(:,3) = meanDiff_sag;
error_results(:,4) = stdDiff_sag;
error_results(:,5) = meanDiff_ml;
error_results(:,6) = stdDiff_ml;

% linkaxes(a,'x');
disp('ready');

% %%
% %save workspace
% clc;
% sensor3{freqIndex} = [s6.time quatS3];
% sensor6{freqIndex} = [s6.time quatS6];
% sensor8{freqIndex} = [s6.time quatS8];
% disp('ready');
% 
% %%
% % save workspace to file
% clc;
% cd('C:\derek\UQ\Matlab\new results');
% fileName = strcat(names(Subject),'.mat');
% save(fileName{1},'sensor3','sensor6','sensor8');
% cd('C:\derek\UQ\Matlab');
% disp('ready');
% %%
% %plot RMSE
% plot(frequency, [RMSE_ml_mean' RMSE_sag_mean']);
% legend('ML','SAG');
% title('Gerard, RMSE vs Frequency');
% xlabel('Freq/Hz');
% ylabel('RMSE');
