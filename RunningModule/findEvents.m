function [indFF,indIPA,indFS,indTO] = findEvents(locsST,locsNegIPA_ST, locsSW, EdSlope, indZero, data, dataFilt,coeffs)

% Find FF
L=length(locsST);temp=zeros(1,L);
for k=1:L
    %[distFF,indFF(k)] = min(abs(locsST(k)-indZero(min(find(locsST(k) < indZero)):end)));
    if ~isempty(min(find(locsST(k) <= indZero)))
        temp(k) = min(find(locsST(k) <= indZero));
    end
end
indFF=temp(1:k); %clear temp;
indFF(indFF==0)=[]; %This is just in case it skips one because the matrix is empty
indFF = indZero(indFF);
indFF(data(indFF)<-2)=[];% Filter

% Find IPA via Wavelets
L=length(locsNegIPA_ST);temp=zeros(1,L);
toleranceIPA = 2;
for k =1:L
    if ~isempty(max(find(locsNegIPA_ST(k) >= indZero)))
        temp(k) = max(find(locsNegIPA_ST(k) >= indZero));
        % Check if deeper trough around
        if indZero(temp(k)) > toleranceIPA
         [~,I]=min(data(indZero(temp(k))-toleranceIPA:locsNegIPA_ST(k)));
         temp(k)=indZero(temp(k))-toleranceIPA+I-1;
        end        
    end
end
indIPA=temp(1:k);%clear temp;
%indIPA=union(indIPA,locsDataIPA,'legacy');

% Find IPA via FF
L=length(indFF);temp=zeros(1,L);
toleranceIPA_FF=6;
for k=1:L
    if indFF(k)>toleranceIPA_FF
        [~,I] = min(data(indFF(k)-toleranceIPA_FF:indFF(k)));
        temp(k) = indFF(k)-toleranceIPA_FF+I-1; 
    end
end
indIPA=union(indIPA,temp); %<FIXME>
indIPA(indIPA==0)=[]; %<FIXME: why do we need this?>

% Find FS
toleranceFS=4;
L=length(indIPA);temp=zeros(1,L);
for k=1:L    
    if ~isempty(max(find(indIPA(k) > indZero)))
        temp(k) = max(find(indIPA(k) > indZero));
        if (indZero(temp(k)) > toleranceFS)
         [~,I]=max(data(indZero(temp(k))-toleranceFS:indIPA(k)));
         temp(k)=indZero(temp(k))-toleranceFS+I-1;
        end      
    end
end
indFS=temp(1:k); %clear temp;
indFS(indFS==0)=[]; %<FIXME: Recheck why we need to get rid of zeros>

% Find Toe Off - tie this with the number of FS events up to the closest
% stSlope (locsSW) and then find nearest peak to stSlope
counter=1; indTO = zeros(1,length(indFS)); tolerance = 0; locsSW = locsSW + tolerance;

for l=1:length(indFS)
    %display(indFS(l))
    if ~isempty(find(indFS(l) < locsSW))
        indNear = min(find(indFS(l) < locsSW));
        strideStance = (indFS(l):locsSW(indNear)+1);
         wavTO = coeffs(8,strideStance)/max(max(coeffs))*100;
         strideStance=data(strideStance);
         %figure;plot(strideStance,'linewidth',2);hold on;%contour(coeffs(:,indFS(l):locsSW(indNear)),10);title(num2str(l));
         %plot(wavTO,'r','linewidth',2);
        if(length(strideStance) > 3)
            [~,locsTemp]=findpeaks(strideStance,'NPeaks',10);[~,locsWavTemp]=findpeaks(wavTO,'NPeaks',10);
           % plot(locsTemp,strideStance(locsTemp),'ro','linewidth',2)
            locsWavTemp=sort(locsWavTemp,'descend');           
            indNearWav = (find(locsWavTemp(1) >= locsTemp')); % Find nearest to last peak found in Wavelet
            
            indNearWavOut=[];
            if (~isempty(indNearWav))
                %display(l);
                if (length(indNearWav)~=1)
                    if(abs(locsTemp(indNearWav(end))-locsTemp(indNearWav(end-1))) <=6) % Threshold of 6 at this stage 
                        if(strideStance(locsTemp(indNearWav(end))) > strideStance(locsTemp(indNearWav(end-1))))                
                            indNearWavOut = locsTemp(indNearWav(end));
                        else indNearWavOut = locsTemp(indNearWav(end-1));
                        end

                    else indNearWavOut = locsTemp(indNearWav(end));
                    end
                else indNearWavOut = locsTemp(indNearWav(end));
                end
            end
            
            %plot(indNearWav,strideStance(indNearWav),'co','linewidth',2)
            
            %locsTemp=sort(locsTemp);
%             if(~isempty(locsTemp))
%                 indTO(counter) = indFS(l)+locsTemp(end)-1;
%                 counter=counter+1;
%             end

            if(~isempty(indNearWavOut))
                indTO(counter) = indFS(l)+indNearWavOut-1;
                counter=counter+1;
            end
        end
    end
end

indTO = indTO(1:counter-1);

% Remove any event before the first speed slope (stSlope/locsSW) or the
% last (edSlope/indZero)
indFS(locsSW(1) > indFS)=[];
indFF(locsSW(1) > indFF)=[];
indIPA(locsSW(1) > indIPA)=[];
indFS(locsSW(1) > indFS)=[];
indTO(locsSW(1) > indTO)=[];

indFS(EdSlope(end) < indFS)=[];
indFF(EdSlope(end) < indFF)=[];
indIPA(EdSlope(end) < indIPA)=[];
indFS(EdSlope(end) < indFS)=[];
indTO(EdSlope(end) < indTO)=[];

% If length(TO) != length(FS)
indFS=indFS(1:length(indTO));  
