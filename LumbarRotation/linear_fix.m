function out=linear_fix(in1,in2,w)
if(nargin<3)
    w=10;
end
size_in=size(in1);
start1=mean(in1(1:w,:));
finish1=mean(in1(end-w+1:end,:));
start2=mean(in2(1:w,:));
finish2=mean(in2(end-w+1:end,:));

slope1=(finish1-start1)/(size_in(1)-1);
slope2=(finish2-start2)/(size_in(1)-1);
diff_out=zeros(size_in(1),size_in(2));
out=zeros(size_in(1),size_in(2));
for k=1:size_in(2)
    diff_out(:,k)=(slope2(k)-slope1(k))*(0:size_in(1)-1)'-start1(k)+start2(k);
    out(:,k)=diff_out(:,k)+in1(:,k);
end