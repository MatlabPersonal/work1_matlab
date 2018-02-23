% Testbench2 for knee control test - 17/03/2014
% Test with 27 players and 324 repetitions of squats and hops

repL=[1,2,3,7,8,9];
repR=[4,5,6,10,11,12];

for i=1:1
    for l=1:2
        if l==1
            leg='left';
        else leg='right';
        end
        for k=1:2
            if k==1
                type='squat';
            else type='hop';
            end            
            for r=1:3
                if(strcmp(leg,'left'))
                    if(strcmp(type,'squat'))
                        rep=repL(r);
                    else rep=repL(r+3);
                    end
                else strcmp(leg,'right')
                    if(strcmp(type,'squat'))
                        rep=repR(r);
                    else rep=repR(r+3);
                    end
                end
               
               [Stc,accX,accY,accZ,gyroX,gyroY,gyroZ,tibia_angle] = formatKneeData(player,leg,type,rep);
               [EulerX,EulerY,EulerZ,angle_S] = valgus_deviation(Stc',accX',accY',accZ',gyroX',gyroY',gyroZ',tibia_angle);                           
               EulerS=[EulerX',EulerY',EulerZ' angle_S'];
               results{l,k,r}=EulerS;
               figure;
               a(1)=subplot(1,2,1);
               plot(EulerS);title(num2str(i)); xlabel(leg); ylabel(type);legend(strcat('Rep',num2str(rep)))
               a(2)=subplot(1,2,2);plot([angle_S' EulerY']);
               linkaxes(a,'x');
            end
        end
    end
end
save('wellington.mat');
clear;clc
%%
% Extract data
% a(1)=subplot(2,1,1);
% plot(Gy1); hold on;
% plot(Gy2,'r');
% a(2)=subplot(2,1,2);

plot(Ax1,'b--'); hold on;
plot(Ax2,'r--');
%linkaxes(a,'x');

%%
% sort cursors and parse data
cursors=zeros(1,24);
for i=1:24
    cursors(i)=cursor_info(i).Position(1);
end
cursors=sort(cursors);
%
for k=1:12
    delta = cursors(k*2-1):cursors(k*2);
    player.left{k} = [Stc(delta) Ax1(delta) Ay1(delta) Az1(delta) Gx1(delta) Gy1(delta) Gz1(delta)];
    player.right{k} = [Stc(delta) Ax2(delta) Ay2(delta) Az2(delta) Gx2(delta) Gy2(delta) Gz2(delta)];
end
