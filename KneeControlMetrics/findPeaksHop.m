function locsPks = findPeaksHop(kneeFlexion)

% Find the 4 highest peaks in the flexion plane
%locsPks=ones(1,2);locsFX=ones(1,10);
locsPks=[];locsFX=[];
[~,locsFX]=findpeaks(kneeFlexion,'NPeaks',10,'SortStr','descend','MinPeakHeight',-10000);
if(length(locsFX)~=0)
    locsFX=sort(locsFX);

    % Decompose in Wavelets
    scales =1:20;
    wavCoeffs = cwtCustomized(kneeFlexion,scales,'db3');
    % Calculate Energy
    energy = sqrt(sum(abs(wavCoeffs).^2,2));
    percentage = 100*energy/sum(energy);
    % Detect the scale of greatest energy.
    [~,maxScaleIDX] = max(percentage);
    %display(maxScaleIDX);
    wavHighEnergy = wavCoeffs(scales(maxScaleIDX),:);
    wavHighEnergy = wavHighEnergy*30/max(wavHighEnergy);
%     figure;
%     plot(kneeFlexion,'linewidth',2);hold on;
%     contour(wavCoeffs,10);
%     plot(wavHighEnergy,'k');

    % Find lowest and highest two points
    [~,locsDiv]=findpeaks(-wavHighEnergy,'NPeaks',1,'SortStr','descend','MinPeakHeight',-10000);
    [~,locsMaxWavFX]=findpeaks(wavHighEnergy,'NPeaks',14,'SortStr','descend','MinPeakHeight',-10000);
        if(length(locsDiv)~=0 && length(locsMaxWavFX)~=0)
            locsMaxWavFX=sort(locsMaxWavFX);

            %plot(locsFX,kneeFlexion(locsFX),'rx','linewidth',2);
            %plot(locsDiv,wavHighEnergy(locsDiv),'ko','linewidth',2);
            %plot(locsMaxWavFX,wavHighEnergy(locsMaxWavFX),'r^');

            % Find highest peaks before and after hop based on Wavelet division
            locsFXPre=zeros(1,10);locsFXPost=zeros(1,10);
            k=1;l=1;
            for i=1:length(locsFX)
                if(isequal(locsFX(i)<=locsDiv,1))
                    locsFXPre(k)=locsFX(i);
                    k=k+1;
                else
                    locsFXPost(l)=locsFX(i);
                    l=l+1;
                end
            end
            locsFXPre=locsFXPre(1:k-1);
            locsFXPost=locsFXPost(1:l-1);

            % Get the maximum before hopping
            if(length(kneeFlexion(locsFXPre))~=0)
                [~,locsMaxPre]=max(kneeFlexion(locsFXPre));
                % Get the maximum after the division pre/post landing around the Wavelet
                % peak after landing
                %locsMaxWavFX=locsMaxWavFX(find(locsMaxWavFX > locsDiv));

                k=1;locsMaxWavFXPost=zeros(1,14);
                for i=1:length(locsMaxWavFX)
                    if(isequal(locsMaxWavFX(i) > locsDiv,1))
                        locsMaxWavFXPost(k)=locsMaxWavFX(i);
                        k=k+1;
                    end
                end
                % display(min(locsMaxWavFXPost(1:k-1)-locsDiv)) 
                % average between the
                % closest peak in the wavelet and the landing point is 13, max is 23 and
                % min is 3 - therefore the search window will be within 2*23 = 46;
                locsMaxWavFX=locsMaxWavFXPost(1:k-1);

                k=1;locsMaxWavFXRange=zeros(1,14);
                for i=1:length(locsMaxWavFX)
                    if(isequal((locsMaxWavFX(i)-locsDiv) < 46,1))
                        locsMaxWavFXRange(k)= locsMaxWavFX(i);
                        k=k+1;
                    end
                end
                locsMaxWavFX=locsMaxWavFXRange(1:k-1);

                if(length(wavHighEnergy(locsMaxWavFX))~=0)
                    [~,X]=max(wavHighEnergy(locsMaxWavFX));
                    locsMaxWavFX=locsMaxWavFX(X);
                    tolerance=20;i=1;L=length(locsFXPost);temp=zeros(1,L);
                    for k=1:L
                        if(~isempty(find(locsDiv:locsMaxWavFX+tolerance == locsFXPost(k))))
                            temp(i)=locsFXPost(k);        
                            i=i+1;
                        end
                    end

                    if(length(temp(1:i-1))~=0)
                        [~,X]=max(kneeFlexion(temp(1:i-1)));
                        locsMaxPost=locsFXPost(X);
                        locsMaxPre = locsFXPre(locsMaxPre);

                        % plot(locsMaxWavFX,wavHighEnergy(locsMaxWavFX),'bo');
                        % plot(locsMaxPre,kneeFlexion(locsMaxPre),'c^','linewidth',2);
                        % plot(locsMaxPost,kneeFlexion(locsMaxPost),'go','linewidth',2);

                        %valuesPks=kneeFlexion([locsMaxPre locsMaxPost]);
                        locsPks=[locsMaxPre locsMaxPost];
                    end
                end
            end
        end
    end
end