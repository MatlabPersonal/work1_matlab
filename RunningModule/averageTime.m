function Stc = averageTime(StcOriginal,timeDelta)

L=length(StcOriginal)-timeDelta;
Stc = zeros(1,L);
for i=1:length(StcOriginal)-timeDelta
    Stc(i) = mean(StcOriginal(i:i+timeDelta));
end

end