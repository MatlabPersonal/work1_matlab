function  [GRF, GRFVector] = estimateGRF_SS(IPA, FlatFoot, Speed, BodyMass)
netdata = [3	3	3	3	3	3;
2	2	2	2	2	2;
50.6	50.6	50.6	50.6	50.6	50.6;
-0.371794597	-0.081980984	0.432774186	-1.344747811	-2.714201634	-2.714201634;
0.031522657	-0.158366175	-0.119285225	0.489032039	-1.077747506	-1.077747506;
110	110	110	110	110	110;
5.999483841	18.54369997	22.92996594	45.39602231	57.51800311	57.51800311;
1.988933607	5.32398479	7.887652102	10.80634398	16.15335616	16.15335616;
1	1	1	1	1	1;
2	2	2	2	2	2;
401.6605771	546.9292234	553.4778693	661.7770915	960.9709265	960.9709265;
1217.331056	1897.130907	1941.255653	2924.343025	3164.416871	3164.416871;
3	5	5	2	2	2;
3	3	3	3	3	3;
-1.616368456	2.394533089	88.20529503	0.274319492	0.246147334	0.246147334;
-1.89879917	13.92744764	16.54667669	-1.28999814	-2.484963395	-2.484963395;
-0.515804587	24.98987625	0.232673829	0.053485457	0.07719425	0.07719425;
-1.504098877	1.072115736	0.273921746	-0.239249178	-1.862333001	-1.862333001;
-1.315188888	0.903558784	83.74616958	0.00376198	-0.044994941	-0.044994941;
-0.008000727	-2.835705208	5.453169404	-0.940422334	-1.777905215	-1.777905215;
-1.404773225	-0.917317166	-15.13846758	1	1	1;
-1.317724548	-2.212352825	-2.969330982	2	2	2;
-0.029394568	2.645042667	-2.86691361	3.210742972	3.404015294	3.404015294;
1	-0.895568444	17.07103432	2.26513909	5.488442394	5.488442394;
3	-4.095044667	-14.9698367	2	2	2;
0.861939735	-0.340356665	11.23291774	1	1	1;
-0.95397084	-10.75246506	-0.317685597	-0.489332481	-0.338402489	-0.338402489;
-1.627010436	2.869957015	-0.314998416	4.18436821	6.470295116	6.470295116;
3	-0.468116652	2.086792055	1	1	1;
1	1	1	1	1	1;
-0.5643465	5	5	-0.723660891	-4.360243516	-4.360243516;
-0.558844222	-0.546482939	-0.400061418	0	0	0;
-0.804409665	0.687684361	0.266532358	0	0	0;
1	-0.608399308	-7.619514959	0	0	0;
1	0.1496654	7.651071155	0	0	0;
-1.001181979	2.637586226	0.532432606	0	0	0;
0	5	5	0	0	0;
0	1	1	0	0	0;
0	-7.602042116	0.677597539	0	0	0;
0	7.373118528	-12.27638057	0	0	0;
0	4.628224321	-1.02759766	0	0	0;
0	3.106621525	-1.008294774	0	0	0;
0	-2.444383057	35.90360412	0	0	0;
0	1	1	0	0	0;
0	1	1	0	0	0;
0	1.33163526	0.079895242	0	0	0];

BWVec = BodyMass*ones(1,length(IPA));
SpeedVec = [2 4 6 9 12 15];
ind = find(SpeedVec>Speed,1);
if(isempty(ind))
    net_range = [6 6];
elseif(ind(1) == 1)
    net_range = [1 1];
else
    net_range = [ind(1)-1 ind(1)];
end

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

stepAverage = 3; L = length(FlatFoot);
if(stepAverage >= L)    
    FlatFootVector = mean(FlatFoot);    
else
    FlatFootVector=zeros(1,L-stepAverage);
    for i=1:L-stepAverage
        FlatFootVector(i) = mean(FlatFoot(i:i+stepAverage));
    end
end

GRFVector=zeros(1,L);GRF=0;

fs=1; %One stride per second 
[B,A]=butter(2,0.3/(fs/2),'low');
if (length(FlatFootVector)>6)
    temp = filtfilt(B,A,FlatFootVector);
    FlatFootVector = reshape(temp,1,[]);
end 

% FlatFootVector((FlatFootVector+1)<0)=[]; % Get rid of unwanted -1 values for log

if(~isempty(FlatFootVector))
    Input = [BWVec' IPA' FlatFootVector']';
    GRFVector = ImplementNNRegress(inputRange,outputRange,IW,LW,b1,b2,Input);
    GRF = median(GRFVector);
end
end