function [ContactTime, ContactTimeVectorOut] = estimateContactTime(Stc, FootStrike, ToeOff, Speed)

% Interpolate different sizes for Speed and Contact Time
%if length(ToeOff)==length(FootStrike)
ContactTimeVector = Stc(ToeOff)-Stc(FootStrike);%Foot Strike and Toe Off must have the same sizes - do an assert?
thresholdCT = 500;
ContactTimeVector(ContactTimeVector > thresholdCT) = [];
L_ContactTime=length(ContactTimeVector);
L_Speed=length(Speed);

% Interpolate <FIXME: Use Stc to interpolate not RN>
if(L_ContactTime>L_Speed)
    factor=L_ContactTime/L_Speed;
    Speed_Intp1=interp1((1:L_Speed)*factor,Speed',1:L_ContactTime);    
%     ContactTimeVector = ContactTimeVector' - (337.5./Speed_Intp1') - 37.1; % The higher the speed, the shorter the delay        
    ContactTimeVector(isnan(Speed_Intp1))=[]; Speed_Intp1(isnan(Speed_Intp1))=[];
    ContactTimeVector = ContactTimeVector' - (85./Speed_Intp1') - 19.7; % The higher the speed, the shorter the delay    
 
elseif(L_ContactTime>1) 
    factor=L_Speed/L_ContactTime;
     ContactTime_Intp1=interp1((1:L_ContactTime)*factor,ContactTimeVector,1:L_Speed);          
%      ContactTime_Intp1 = ContactTime_Intp1 - (337.5./Speed) - 37.1; % The higher the speed, the shorter the delay
     ContactTime_Intp1 = ContactTime_Intp1 - (85./Speed) - 19.7; % The higher the speed, the shorter the delay
     ContactTime_Intp1(isnan(ContactTime_Intp1))=[]; % <FIXME: If interpolating with Stc this is not required>
     ContactTimeVector=ContactTime_Intp1'; %Overwrite original contactTime vector     
else
    ContactTimeVector=0;
end

ContactTimeVector(isnan(ContactTimeVector))=[];

stepAverage = 3; L = length(ContactTimeVector);
if(stepAverage >= L)    
    ContactTimeVectorOut = mean(ContactTimeVector);    
else
    ContactTimeVectorOut = zeros(1,L-stepAverage);
    for i=1:L-stepAverage
        ContactTimeVectorOut(i) = mean(ContactTimeVector(i:i+stepAverage));
    end
end

fs=1; %One stride per second
if(length(ContactTimeVectorOut)>6)   
    [B,A]=butter(2,0.3/(fs/2),'low');
    temp=filtfilt(B,A,ContactTimeVectorOut);     
    ContactTimeVectorOut=reshape(temp,1,[]);
%     ContactTimeVectorOut=ContactTimeVectorOut; % Plug it back to ms
end

ContactTime = median(ContactTimeVectorOut);
ContactTimeVectorOut(ContactTimeVectorOut>ContactTime*2) = ContactTime-10+20*rand;
ContactTimeVectorOut(ContactTimeVectorOut<ContactTime/2) = ContactTime-10+20*rand;
ContactTimeVectorOut(isnan(ContactTimeVectorOut)) = median(ContactTimeVectorOut) + rand;
end