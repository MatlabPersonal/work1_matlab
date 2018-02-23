%%
% NN=length(nsamples);
% for k=1:NN
% %     data{k}=matrix((nsamples(k,1)):nsamples(k,2),:);
% end
% Testbench for Cervical Spine
% close all;

calibration_data=1;

for k=1:7
% for k=12
    %     nsamples(k,1)=nsamples(k,1)+1;
    %     nsamples(k,1)=nsamples(k,1)-1;
%     data{k}=matrix((nsamples(k,1)):nsamples(k,2),:);
data{k}=data_VP{k}(:,2:end);
    accX1 = data{k}(:,2);accY1 = data{k}(:,3);accZ1 = data{k}(:,4);
    accX2 = data{k}(:,11);accY2 = data{k}(:,12);accZ2 = data{k}(:,13);
    gyroX1 = data{k}(:,8);gyroY1 = data{k}(:,9);gyroZ1 = data{k}(:,10);
    gyroX2 = data{k}(:,17);gyroY2 = data{k}(:,18);gyroZ2 = data{k}(:,19);
    stc = data{k}(:,1);
    output = [accX1 accY1 accZ1 gyroX1 gyroY1 gyroZ1...
        accX2 accY2 accZ2 gyroX2 gyroY2 gyroZ2 stc];
    [CalFx_low, CalLfx_low, CalFx_up, CalLfx_up] = calibrateData(data{calibration_data}(1:5,2)',data{calibration_data}(1:5,3)',data{calibration_data}(1:5,4)',...
        data{calibration_data}(1:5,11)',data{calibration_data}(1:5,12)',data{calibration_data}(1:5,13)');
    %    [EulerS1, EulerS2, EulerS3,...
    %           EulerLowerS1, EulerLowerS2, EulerLowerS3,...
    %           EulerUpperS1, EulerUpperS2, EulerUpperS3] = processData(accX1',accY1',accZ1',accX2',accY2',accZ2', gyroX1',gyroY1',gyroZ1',gyroX2',gyroY2',gyroZ2',...
    %                                              CalFx_low, CalLfx_low, CalFx_up, CalLfx_up);
    
    
    [EulerS1, EulerS2, EulerS3,...
        EulerLowerS1, EulerLowerS2, EulerLowerS3,...
        EulerUpperS1, EulerUpperS2, EulerUpperS3] = processData(accX1',accY1',accZ1',accX2',accY2',accZ2', gyroX1',gyroY1',gyroZ1',gyroX2',gyroY2',gyroZ2',...
        stc',CalFx_low, CalLfx_low, CalFx_up, CalLfx_up);
    
    
%         [EulerS1, EulerS2, EulerS3,...
%         EulerLowerS1, EulerLowerS2, EulerLowerS3,...
%         EulerUpperS1, EulerUpperS2, EulerUpperS3] = processData(accX1',accY1',accZ1',accX2',accY2',accZ2', gyroX1',gyroY1',gyroZ1',gyroX2',gyroY2',gyroZ2',...
%         0, 0, 0, 0);
    
    if(k>2 && isempty(strfind(lower(Subtype{k}),'rot')) && isempty(strfind(lower(Subtype{k}),'sit'))) % not rotation
        if(~isempty(strfind(lower(Subtype{k}),'pla'))) % planking
        [EulerS1, EulerS2, EulerS3,...
        EulerLowerS1, EulerLowerS2, EulerLowerS3,...
        EulerUpperS1, EulerUpperS2, EulerUpperS3] = processData_vhv2_dip_xzy(accX1',accY1',accZ1',accX2',accY2',accZ2', gyroX1',gyroY1',gyroZ1',gyroX2',gyroY2',gyroZ2',...
        CalFx_low, CalLfx_low, CalFx_up, CalLfx_up);
        else % push up and bird dog
        [EulerS1, EulerS2, EulerS3,...
        EulerLowerS1, EulerLowerS2, EulerLowerS3,...
        EulerUpperS1, EulerUpperS2, EulerUpperS3] = processData_vhv2_prone_xzy(accX1',accY1',accZ1',accX2',accY2',accZ2', gyroX1',gyroY1',gyroZ1',gyroX2',gyroY2',gyroZ2',...
        stc',CalFx_low, CalLfx_low, CalFx_up, CalLfx_up);
        end
    end
%     [EulerS1i, EulerS2i, EulerS3i,...
%         EulerLowerS1i, EulerLowerS2i, EulerLowerS3i,...
%         EulerUpperS1i, EulerUpperS2i, EulerUpperS3i] = processData_int(accX1',accY1',accZ1',accX2',accY2',accZ2', gyroX1',gyroY1',gyroZ1',gyroX2',gyroY2',gyroZ2',...
%         CalFx_low, CalLfx_low, CalFx_up, CalLfx_up);
    EulerS_low{k}=[EulerLowerS1', EulerLowerS2', EulerLowerS3']/180*pi;
    EulerS_upp{k}=[EulerUpperS1', EulerUpperS2', EulerUpperS3']/180*pi;
    EulerS{k}=[EulerS1', EulerS2', EulerS3'];
    
%         EulerS_low_i{k}=[EulerLowerS1i', EulerLowerS2i', EulerLowerS3i']/180*pi;
%     EulerS_upp_i{k}=[EulerUpperS1i', EulerUpperS2i', EulerUpperS3i']/180*pi;
%     EulerS_i{k}=[EulerS1i', EulerS2i', EulerS3i']/180*pi;
end
return;
%%
k=4;
figure;plot(EulerS{k});
% hold on;plot(EulerS_matlab{k},'--','linewidth',5);

    %%
    k=2;
    figure;
    % clf;
    subplot(2,2,1);
    plot((data{k}(:,1)-data{k}(1,1))/1000,EulerS_low{k}/pi*180);
    hold on;plot((1:length(Eulers_Vicon{k}))/250,Eulers_lower{k}/pi*180,'--');
    legend('Sensor X','Sensor Y','Sensor Z','Vicon X','Vicon Y','Vicon Z');title('Lower');
    subplot(2,2,2);
    plot((data{k}(:,1)-data{k}(1,1))/1000,EulerS_upp{k}/pi*180);
    hold on;plot((1:length(Eulers_Vicon{k}))/250,Eulers_upper{k}/pi*180,'--');
    legend('Sensor X','Sensor Y','Sensor Z','Vicon X','Vicon Y','Vicon Z');title('Upper');
    subplot(2,2,3);
    plot((data{k}(:,1)-data{k}(1,1))/1000,EulerS{k}/pi*180);
    hold on;
%         plot((data{k}(:,1)-data{k}(1,1))/1000,EulerS_i{k}/pi*180,':');
    plot((1:length(Eulers_Vicon{k}))/250,Eulers_Vicon{k}/pi*180,'--');
    legend('Sensor X','Sensor Y','Sensor Z','Sensor Xi','Sensor Yi','Sensor Zi','Vicon NewCal X','Vicon NewCal Y','Vicon NewCal Z');title('Diff vs NewCal');
    subplot(2,2,4);
    plot((data{k}(:,1)-data{k}(1,1))/1000,EulerS{k}/pi*180);hold on;

    plot((1:length(Eulers_Vicon{k}))/250,Eulers_Vicon2{k}/pi*180,'--');
    legend('Sensor X','Sensor Y','Sensor Z','Vicon OldCal X','Vicon OldCal Y','Vicon OldCal Z');title('Diff vs OldCal');
    %    plot((data{k}(2:end,1)-data{k}(1,1))/1000,diff(data{k}(:,1)));
    figure(gcf);
% end
return;
%%
clf;
subplot(1,3,1);
plot((data{k}(:,1)-data{k}(1,1))/1000,data{k}(:,20:22));
hold on;plot((1:length(Eulers_Vicon{k}))/250,Eulers_lower{k}/pi*180,'--');
subplot(1,3,2);
plot((data{k}(:,1)-data{k}(1,1))/1000,data{k}(:,23:25));
hold on;plot((1:length(Eulers_Vicon{k}))/250,Eulers_upper{k}/pi*180,'--');
subplot(1,3,3);
plot((data{k}(:,1)-data{k}(1,1))/1000,data{k}(:,26:28));
hold on;plot((1:length(Eulers_Vicon{k}))/250,Eulers_Vicon{k}/pi*180,'--');
%%
% k=12;
% figure;
% hold on;
% plot((data{k}(:,1)-data{k}(1,1))/1000,test_EulerS{k}/pi*180);
% Fv=250;
% sv=size(Eulers_Vicon{k},1);
% plot((1:sv)/Fv,Eulers_Vicon{k}(:,1:3)/pi*180,'--');
% legend('FX\_VM','LF\_VM','TX\_VM','FX\_Vicon','LF\_Vicon','TX\_Vicon');
%%
m=0;figure;
ylabels={'Euler Angle X / degs','Euler Angle Y / degs','Euler Angle Z / degs'};
titles={'Flexion','Lateral Flexion (Right)','Axial Rotation (Left)','Upper Quadrants (Left)'};
ylims={[-20 80],[-20 80],[-90 20],[-60 100]};
for k=[14 11 2 32]
    m=m+1;
    for p=1:3
        h((m-1)+4*(p-1)+1)=subplot(3,4,(m-1)+4*(p-1)+1);
        set(gca,'FontSize',18);
        plot((data{k}(:,1)-data{k}(1,1))/1000,EulerS{k}(:,p)/pi*180,'linewidth',3);
        hold on;
        plot((1:length(Eulers_Vicon{k}))/250,Eulers_Vicon{k}(:,p)/pi*180,'--','linewidth',3);
        grid on;
        if(m==1)
            ylabel(ylabels{p});
        end
        if(m<4)
            xlim([0 8]);
        end
        if(p==1)
            title(titles{m});
        end
        ylim(ylims{m});
    end
end
xlabel('Time / seconds');
legend('ViPerform','Vicon');