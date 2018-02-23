function q=quatint_stc(q0,gyr,stc)
sizeg=size(gyr);
q=zeros(sizeg(1),4);
gyr=gyr/180*pi;
stc=[stc stc(end)+median(diff(stc))];
for k=1:sizeg(1)
    T=stc(k+1)-stc(k);
    deltaq=zeros(1,4);
    theta=gyr(k,:)*T/2;
    thetamag=norm(theta);
    if (thetamag<0.0001) %avoid div/0 errors
        thetamagsq=thetamag^2;
        deltaq(1)=1-thetamagsq/2;
        s=1-thetamagsq/6;
    else
        deltaq(1)=cos(thetamag);
        s=sin(thetamag)/thetamag;
    end
    deltaq(2:4)=theta(1:3)*s;
    q0=(quatmult(q0,deltaq))';
    q(k,:)=q0;
end