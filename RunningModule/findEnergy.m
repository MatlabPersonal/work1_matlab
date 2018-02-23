function [energy,energyFilt] = findEnergy(Stc,swingWav,derivAcc)
% energy = cumtrapz(Stc/1000,abs(swingWav).^2);
energy = swingWav.^2;
energyAcc = abs(derivAcc).^2;
[B,A]=butter(2,2/(100/2),'low');
energyFilt = filtfilt(B,A,energy);
% energyAccFilt = filtfilt(B,A,energyAcc);
% energy = energy+energyAccFilt;
end


