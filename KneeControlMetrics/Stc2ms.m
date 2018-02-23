function [ms]=Stc2ms(Stc) %convert stc to milisecs
n=length(Stc);
ms=zeros(1,n);
if(n~=0)
    temp=strfind(Stc(1),':');
    if(length(temp{1,1}<3))
        Stc(1)=strcat(Stc(1),':0');
        temp=strfind(Stc(1),':');
    end
    ms(1)=datenum(Stc(1), 'HH:MM:SS:FFF')*24*60*60*1000;
    for i=2:n
        temp=strfind(Stc(i),':');
        if(length(temp{1,1}<3))
            Stc(i)=strcat(Stc(i),':0');
            temp=strfind(Stc(i),':');
        end
        ms(i)=datenum(Stc(i), 'HH:MM:SS:FFF')*24*60*60*1000-ms(1);
    end
    ms(1)=0;
end
end