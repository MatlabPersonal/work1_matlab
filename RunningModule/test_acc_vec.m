%% test acc vector based event detection
clc;
clear;
filename = 'D:\Derek\Matlab\runningModule_V2\MatlabFiles\data\test_vimove2_int\GCT\20180223110932656_raw.csv';
[Stc,data_left,data_right] = readDataFromVM2RawCsv(filename);
data_left = data_left(:,:); %4312:9844
%% get vec

[left_vec] = getAccVector(data_left);
figure;
plot(left_vec);

%% cwt tf

% [swingWav, stanceWav_IPA,coeffs] = calculateCWT_V3(left_vec);
wavStruct=cwtft(left_vec,'scales',1:64);
IdxSc2Inv = 64;
wav = icwtft(wavStruct,'IdxSc',IdxSc2Inv);
wav = wav - mean(wav);
MPD = 20;
MaxPD = 200;
MPH = 0.02;
[PKS,LOCS]= findpeaks(-wav(10:end-10),'MinPeakDistance',MPD,'MinPeakHeight',MPH);
LOCS = LOCS + 9;
data_left_clipped = data_left(:,1);
data_left_clipped(data_left_clipped>-1) = -1;
accydiff = diff(data_left_clipped);
IPA_loc = nan(1,length(LOCS)-1);
for i = 1:length(LOCS)-1
    if LOCS(i+1) - LOCS(i)< MaxPD
        StrideRange = LOCS(i):LOCS(i+1);
        data_clipped_stride = data_left_clipped(StrideRange);
        [~,temp_loc] = min(accydiff(StrideRange));
        left_edge = temp_loc - 3;
        right_edge = temp_loc + 3;
        if(right_edge>length(data_clipped_stride))
            right_edge = length(data_clipped_stride);
        end
        if(left_edge<1)
            left_edge = 1;
        end
        [~,adj_loc] = min(data_clipped_stride(left_edge:right_edge));
        IPA_loc(i) = LOCS(i) + temp_loc + adj_loc - 5;
    end
end
IPA_loc(isnan(IPA_loc)) = [];
figure;
a(1) = subplot(311);
plot(left_vec);
title('acc vector magnitude');
a(2) = subplot(312);
plot(wav); hold on;
plot(LOCS,wav(LOCS),'rx');
title('64th wavelet decomp');
a(3) = subplot(313);
plot(data_left(:,1)); hold on;
plot(IPA_loc,data_left(IPA_loc,1),'rx');
title('accy');
linkaxes(a,'x');