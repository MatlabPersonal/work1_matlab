function outq=update_w_acc(inq,pts,acc,twist) %#codegen
if(nargin==3)
    twist=0;
end
mag=zeros(length(acc),1);
for k=1:length(acc)
    mag(k,1)=norm(acc(k,:));
end
anglez=-atan2(-acc(:,2),-acc(:,1));
angley=-asin(acc(:,3)./mag);
anglex=ones(length(acc),1)*twist;
%% DN: Minor edit to below function
thetaq=XYZ_to_Quaternion([-anglez,-angley,anglex]);
%%
zps=[1;pts;length(inq)];
%% DN: Must fully define thetas before assigning 
thetas = zeros(length(zps),4);
%%
for k=1:length(zps)
    for m=1:4
        thetas(k,m)=avg2(thetaq(:,m),zps(k),20);
    end
end
outq=zeros(length(inq),4);
for k=1:length(zps)-1
    for m=1:4
    diffx=zps(k+1)-zps(k);
    diffy=thetas(k+1,m)-thetas(k,m);
    diffy_in=inq(zps(k+1),m)-inq(zps(k),m);
    outq(zps(k):zps(k+1),m)=inq(zps(k):zps(k+1),m)-inq(zps(k),m)-(0:diffx)'/diffx*diffy_in...
        +thetas(k,m)+(0:diffx)'/diffx*diffy;
    end
end

function out=avg2(in,index,b)
out=mean(in(max(1,index-b):min(index+b,length(in))));