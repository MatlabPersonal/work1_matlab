function  [GRF, GRFVector] = estimateGRF_NN(IPA, FlatFoot, Speed, BodyMass)
% BP Neural Network based GRF estimation
% based on gait study data with Victoria University

SpeedVec = Speed*ones(1,length(IPA));
% Neural Network Params
inputRange = [-0.8987 51.2127; 2 15; -3.2762 16.8565];
outputRange = [0.2217 3.3746];
IW = [0.320224712097777,2.67264301411593,-1.73297835538642;...
    0.0974149305597436,4.78674860922001,0.477251786115419;...
    -1.55404441397930,0.113357969011786,0.259199832597526;...
    1.70361325975895,-10.8052712016234,4.29108348137901;...
    0.887135031752563,-0.509443773669499,-0.977104833567486];
LW = [0.485499411054293,-0.401332648677149,-0.549919774216616,-0.198597775590302,-0.936497582036454];
b1 = [-2.31342510428992;-2.97613807949206;-0.587243719951190;0.519199397306984;1.16289878317446];
b2 = 0.944683232934816;

L = length(FlatFoot);
FlatFootVector = FlatFoot;

GRFVector=zeros(1,L);GRF=0;

fs=1; %One stride per second 
[B,A]=butter(2,0.3/(fs/2),'low');
if (length(FlatFootVector)>6)
    temp = filtfilt(B,A,FlatFootVector);
    FlatFootVector = reshape(temp,1,[]);
end 

% FlatFootVector((FlatFootVector+1)<0)=[]; % Get rid of unwanted -1 values for log

if(~isempty(FlatFootVector))
    Input = [IPA' SpeedVec' FlatFootVector']';
    GRFVector = ImplementNNRegress(inputRange,outputRange,IW,LW,b1,b2,Input) * BodyMass * 9.8;
    GRF = median(GRFVector);
end
GRFVector(isnan(GRFVector)) = mean(GRFVector + rand);
end