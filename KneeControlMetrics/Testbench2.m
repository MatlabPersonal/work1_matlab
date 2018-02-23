% Testbench for knee control test - 17/03/2014
% Testing of metrics detection in 300 datasets
% counterFig=0;
% for i=1:25
for i=[13 20 24 25]
    for l=1:2
        for k=2:2
            for r=1:3
                temp1=resultsAll{i};
                temp2=temp1{l,k,r};
                EulerX=temp2(:,2);angle_S=temp2(:,4);
                stc=temp2(:,1);
                if(k==1)
                    movementType=1;
                else movementType=2;
                end
                if(l==2)
                	angle_S=-angle_S; % Required because there was a bug in the knee Control DLL - right leg's convention was negative
                end                
                gyroX=temp2(:,6); gyroY=temp2(:,7); gyroZ=temp2(:,8);       
                if(l==1)
                    tibia_angle=45;
                else tibia_angle=-45;
                end 
                
                [locsFX,locsLFX,maxKneeFlexion,devProjAngle,speed,maxPostLand,minPostLand] = findMetrics(EulerX',angle_S',movementType,gyroX',gyroY',gyroZ', tibia_angle);
                if(movementType==1)
                    % Squat
                    figure;
                    plot(EulerX,'linewidth',2);hold on;
                    plot(angle_S,'r','linewidth',2);
                    plot(locsFX,EulerX(locsFX),'rx','linewidth',2);
                    plot(locsLFX,angle_S(locsLFX),'c^','linewidth',2);
                    text(10,maxKneeFlexion,strcat('Speed:',num2str(speed(1))));
                    text(10,maxKneeFlexion-2,strcat('FX:',num2str(maxKneeFlexion)))
                    text(10,maxKneeFlexion-4,strcat('LFX_{Dev}:',num2str(devProjAngle(1))))
                    text(10,maxKneeFlexion-6,strcat('LFX_{Base}:',num2str(devProjAngle(2))));
                    text(10,maxKneeFlexion-8,strcat('LFX_{ROM}:',num2str(devProjAngle(3))));       
                    xlabel(num2str(i)); ylabel(num2str(l));legend(num2str(r));
                    title('Squat')
                    grid;

                elseif(movementType==2)
                    % Hop
                    %h=figure; set(h,'Visible','off');
                    figure;
                    plot([EulerX angle_S],'linewidth',2);hold on;
                    plot((locsFX(1:2)),EulerX(locsFX(1:2)),'rx','linewidth',2);
                    plot((locsFX(3)),EulerX(locsFX(3)),'ko','linewidth',2);
                    plot((locsLFX),angle_S(locsLFX),'c^','linewidth',2);
                    text(10,maxKneeFlexion,strcat('Speed Pre:',num2str(speed(1))));
                    text(10,maxKneeFlexion-2,strcat('Speed Post:',num2str(speed(2))));
                    text(10,maxKneeFlexion-4,strcat('FX:',num2str(maxKneeFlexion)));
                    text(10,maxKneeFlexion-6,strcat('LFX_{Dev}:',num2str(devProjAngle(1))));
                    text(10,maxKneeFlexion-8,strcat('LFX_{Base}:',num2str(devProjAngle(2))));
                    text(10,maxKneeFlexion-10,strcat('LFX_{ROM}:',num2str(devProjAngle(3))));
                    text(10,maxKneeFlexion-12,strcat('LFX_{ROM_Pre}:',num2str(devProjAngle(4))));
                    title('Hop')
                    xlabel(num2str(i)); ylabel(num2str(l));legend(num2str(r));
                    grid;                   
                    %saveas(h,strcat(num2str(counterFig),'.png'))     
                    %counterFig=counterFig+1;
                end
            end
        end
    end
end

%%
% clearvars -EXCEPT resultsAdemilson resultsAntonio resultsClemente ...
%                   resultsDenilson resultsDouglas resultsEdson resultsFabricio ...
%                   resultsJadson resultsJoao resultsLucas resultsLuisFabiano ...
%                   resultsLuisRicardo resultsMaicon resultsMarcelo resultsMateus ...
%                   resultsOswaldo resultsPauloGanso resultsPauloMiranda resultsRafael...
%                   resultsReinaldo resultsRicardoSasaki resultsRodrigo resultsSilvio ...
%                   resultsTiago resultsWellington results;
%%
% load('ademilson.mat','results')
% resultsAdemilson=results;
% clear results;
% 
% load('antonio.mat','results')
% resultsAntonio=results;
% clear results;
% 
% load('clemente.mat','results')
% resultsClemente=results;
% clear results;
% 
% load('denilson.mat','results')
% resultsDenilson=results;
% clear results;
% 
% load('douglas.mat','results')
% resultsDouglas=results;
% clear results;
% 
% load('edson.mat','results')
% resultsEdson=results;
% clear results;
% 
% load('fabricio.mat','results')
% resultsFabricio=results;
% clear results;
% 
% load('jadson.mat','results')
% resultsJadson=results;
% clear results;
% 
% load('joao.mat','results')
% resultsJoao=results;
% clear results;
% 
% load('lucas.mat','results')
% resultsLucas=results;
% clear results;
% 
% load('luis_fabiano.mat','results')
% resultsLuisFabiano=results;
% clear results;
% 
% load('luis_ricardo.mat','results')
% resultsLuisRicardo=results;
% clear results;
% 
% load('maicon.mat','results')
% resultsMaicon=results;
% clear results;
% 
% load('marcelo.mat','results')
% resultsMarcelo=results;
% clear results;
% 
% load('mateus.mat','results')
% resultsMateus=results;
% clear results;
% 
% load('oswaldo.mat','results')
% resultsOswaldo=results;
% clear results;
% 
% load('paulo_ganso.mat','results')
% resultsPauloGanso=results;
% clear results;
% 
% load('paulo_miranda.mat','results')
% resultsPauloMiranda=results;
% clear results;
% 
% load('rafael.mat','results')
% resultsRafael=results;
% clear results;
% 
% load('reinaldo.mat','results')
% resultsReinaldo=results;
% clear results;
% 
% load('ricardo_sasaki.mat','results')
% resultsRicardoSasaki=results;
% clear results;
% 
% load('rodrigo.mat','results')
% resultsRodrigo=results;
% clear results;
% 
% load('roger.mat','results')
% resultsRoger=results;
% clear results;
% 
% load('silvio.mat','results')
% resultsSilvio=results;
% clear results;
% 
% load('tiago.mat','results')
% resultsTiago=results;
% clear results;
% 
% load('wellington.mat','results')
% resultsWellington=results;
% clear results;
% 
% resultsAll = {resultsAdemilson,resultsAntonio,resultsClemente,resultsDenilson,...
%               resultsDouglas, resultsEdson, resultsFabricio, ...
%               resultsJadson, resultsJoao, resultsLucas, resultsLuisFabiano, ...
%               resultsLuisRicardo, resultsMaicon, resultsMarcelo, resultsMateus, ...
%               resultsOswaldo, resultsPauloGanso, resultsPauloMiranda, ...
%               resultsRafael, resultsReinaldo, resultsRicardoSasaki, resultsRodrigo,...
%               resultsRoger, resultsSilvio, resultsTiago, resultsWellington};
%%
% Output squat
% i=25;l=2;k=1;r=2;
% temp1=resultsAll{i};
% temp2=temp1{l,k,r};
% EulerX=temp2(:,2);angle_S=temp2(:,5);
% dataSquat = [EulerX angle_S];
% plot(dataSquat(1:175,:))
% %%
% dlmwrite('dataSquat.csv',dataSquat(1:175,:),'precision',10);
% 
% %% 
% % Output hop
% i=24;l=1;k=2;r=1;
% temp1=resultsAll{i};
% temp2=temp1{l,k,r};
% EulerX=temp2(:,2);angle_S=temp2(:,5);
% dataHop = [EulerX angle_S/3];
% [B,A]=butter(2,5/(40/2),'low');
% plot(filtfilt(B,A,dataHop))
% dlmwrite('dataHop.csv',filtfilt(B,A,dataHop),'precision',10);
%%
% data{1}=importfile('Ademilson hop L1.csv');
% data{2}=importfile('Ademilson hop L2.csv');
% data{3}=importfile('Ademilson hop L3.csv');
% data{4}=importfile('Ademilson hop R1.csv');
% data{5}=importfile('Ademilson hop R2.csv');
% data{6}=importfile('Ademilson hop R3.csv');
% data{7}=importfile('Antonio Carlos hop L1.csv');
% data{8}=importfile('Antonio Carlos hop L2.csv');
% data{9}=importfile('Antonio Carlos hop L3.csv');
% data{10}=importfile('Antonio Carlos hop R1.csv');
% data{11}=importfile('Antonio Carlos hop R2.csv');
% data{12}=importfile('Antonio Carlos hop R3.csv');
% data{13}=importfile('Clemente hop L1.csv');
% data{14}=importfile('Clemente hop L2.csv');
% data{15}=importfile('Clemente hop L3.csv');
% data{16}=importfile('Clemente hop R1.csv');
% data{17}=importfile('Clemente hop R2.csv');
% data{18}=importfile('Clemente hop R3.csv');
% data{19}=importfile('Denilson Pereira hop L1.csv');
% data{20}=importfile('Denilson Pereira hop L2.csv');
% data{21}=importfile('Denilson Pereira hop L3.csv');
% data{22}=importfile('Denilson Pereira hop R1.csv');
% data{23}=importfile('Denilson Pereira hop R2.csv');
% data{24}=importfile('Denilson Pereira hop R3.csv');
% data{25}=importfile('Douglas hop L1.csv');
% data{26}=importfile('Douglas hop L2.csv');
% data{27}=importfile('Douglas hop L3.csv');
% data{28}=importfile('Douglas hop R1.csv');
% data{29}=importfile('Douglas hop R2.csv');
% data{30}=importfile('Douglas hop R3.csv');
% data{31}=importfile('Edson hop L1.csv');
% data{32}=importfile('Edson hop L2.csv');
% data{33}=importfile('Edson hop L3.csv');
% data{34}=importfile('Edson hop R1.csv');
% data{35}=importfile('Edson hop R2.csv');
% data{36}=importfile('Edson hop R3.csv');
% data{37}=importfile('Fabricio hop L1.csv');
% data{38}=importfile('Fabricio hop L2.csv');
% data{39}=importfile('Fabricio hop L3.csv');
% data{40}=importfile('Fabricio hop R1.csv');
% data{41}=importfile('Fabricio hop R2.csv');
% data{42}=importfile('Fabricio hop R3.csv');
% data{43}=importfile('Jadson hop L1.csv');
% data{44}=importfile('Jadson hop L2.csv');
% data{45}=importfile('Jadson hop L3.csv');
% data{46}=importfile('Jadson hop R1.csv');
% data{47}=importfile('Jadson hop R2.csv');
% data{48}=importfile('Jadson hop R3.csv');
% data{49}=importfile('Joao Felipe hop L1.csv');
% data{50}=importfile('Joao Felipe hop L2.csv');
% data{51}=importfile('Joao Felipe hop L3.csv');
% data{52}=importfile('Joao Felipe hop R1.csv');
% data{53}=importfile('Joao Felipe hop R2.csv');
% data{54}=importfile('Joao Felipe hop R3.csv');
% data{55}=importfile('Lucas Evangelist hop L1.csv');
% data{56}=importfile('Lucas Evangelist hop L2.csv');
% data{57}=importfile('Lucas Evangelist hop L3.csv');
% data{58}=importfile('Lucas Evangelist hop R1.csv');
% data{59}=importfile('Lucas Evangelist hop R2.csv');
% data{60}=importfile('Lucas Evangelist hop R3.csv');
% data{61}=importfile('Lucas Farias hop L1.csv');
% data{62}=importfile('Lucas Farias hop L2.csv');
% data{63}=importfile('Lucas Farias hop L3.csv');
% data{64}=importfile('Lucas Farias hop R1.csv');
% data{65}=importfile('Lucas Farias hop R2.csv');
% data{66}=importfile('Lucas Farias hop R3.csv');
% data{67}=importfile('Luis Fabiano hop L1.csv');
% data{68}=importfile('Luis Fabiano hop L2.csv');
% data{69}=importfile('Luis Fabiano hop L3.csv');
% data{70}=importfile('Luis Fabiano hop R1.csv');
% data{71}=importfile('Luis Fabiano hop R2.csv');
% data{72}=importfile('Luis Fabiano hop R3.csv');
% data{73}=importfile('Luis Ricardo hop L1.csv');
% data{74}=importfile('Luis Ricardo hop L2.csv');
% data{75}=importfile('Luis Ricardo hop L3.csv');
% data{76}=importfile('Luis Ricardo hop R1.csv');
% data{77}=importfile('Luis Ricardo hop R2.csv');
% data{78}=importfile('Luis Ricardo hop R3.csv');
% data{79}=importfile('Maicon Thiago Hop L1.csv');
% data{80}=importfile('Maicon Thiago Hop L2.csv');
% data{81}=importfile('Maicon Thiago Hop L3.csv');
% data{82}=importfile('Maicon Thiago Hop R1.csv');
% data{83}=importfile('Maicon Thiago Hop R2.csv');
% data{84}=importfile('Maicon Thiago Hop R3.csv');
% data{85}=importfile('Marcelo Canete Hop L1.csv');
% data{86}=importfile('Marcelo Canete Hop L2.csv');
% data{87}=importfile('Marcelo Canete Hop L3.csv');
% data{88}=importfile('Marcelo Canete Hop R1.csv');
% data{89}=importfile('Marcelo Canete Hop R2.csv');
% data{90}=importfile('Marcelo Canete Hop R3.csv');
% data{91}=importfile('Mateus Lucena Hop L1.csv');
% data{92}=importfile('Mateus Lucena Hop L2.csv');
% data{93}=importfile('Mateus Lucena Hop L3.csv');
% data{94}=importfile('Mateus Lucena Hop R1.csv');
% data{95}=importfile('Mateus Lucena Hop R2.csv');
% data{96}=importfile('Mateus Lucena Hop R3.csv');
% data{97}=importfile('Oswaldo Lourenco Hop L1.csv');
% data{98}=importfile('Oswaldo Lourenco Hop L2.csv');
% data{99}=importfile('Oswaldo Lourenco Hop L3.csv');
% data{100}=importfile('Oswaldo Lourenco Hop R1.csv');
% data{101}=importfile('Oswaldo Lourenco Hop R2.csv');
% data{102}=importfile('Oswaldo Lourenco Hop R3.csv');
% data{103}=importfile('Paul henrique Hop L1.csv');
% data{104}=importfile('Paul henrique Hop L2.csv');
% data{105}=importfile('Paul henrique Hop L3.csv');
% data{106}=importfile('Paul henrique Hop R1.csv');
% data{107}=importfile('Paul henrique Hop R2.csv');
% data{108}=importfile('Paul henrique Hop R3.csv');
% data{109}=importfile('paulo miranda Hop L1.csv');
% data{110}=importfile('paulo miranda Hop L2.csv');
% data{111}=importfile('paulo miranda Hop L3.csv');
% data{112}=importfile('paulo miranda Hop R1.csv');
% data{113}=importfile('paulo miranda Hop R2.csv');
% data{114}=importfile('paulo miranda Hop R3.csv');
% data{115}=importfile('Rafael Toloi Hop L1.csv');
% data{116}=importfile('Rafael Toloi Hop L2.csv');
% data{117}=importfile('Rafael Toloi Hop L3.csv');
% data{118}=importfile('Rafael Toloi Hop R1.csv');
% data{119}=importfile('Rafael Toloi Hop R2.csv');
% data{120}=importfile('Rafael Toloi Hop R3.csv');
% data{121}=importfile('Reinaldo Manoel Hop L1.csv');
% data{122}=importfile('Reinaldo Manoel Hop L2.csv');
% data{123}=importfile('Reinaldo Manoel Hop L3.csv');
% data{124}=importfile('Reinaldo Manoel Hop R1.csv');
% data{125}=importfile('Reinaldo Manoel Hop R2.csv');
% data{126}=importfile('Reinaldo Manoel Hop R3.csv');
% data{127}=importfile('Ricardo Sasaki Hop L1.csv');
% data{128}=importfile('Ricardo Sasaki Hop L2.csv');
% data{129}=importfile('Ricardo Sasaki Hop L3.csv');
% data{130}=importfile('Ricardo Sasaki Hop R1.csv');
% data{131}=importfile('Ricardo Sasaki Hop R2.csv');
% data{132}=importfile('Ricardo Sasaki Hop R3.csv');
% data{133}=importfile('Roberta Rosas Hop L1.csv');
% data{134}=importfile('Roberta Rosas Hop L2.csv');
% data{135}=importfile('Roberta Rosas Hop L3.csv');
% data{136}=importfile('Roberta Rosas Hop R1.csv');
% data{137}=importfile('Roberta Rosas Hop R2.csv');
% data{138}=importfile('Roberta Rosas Hop R3.csv');
% data{139}=importfile('Rodrigo Caio Hop L1.csv');
% data{140}=importfile('Rodrigo Caio Hop L2.csv');
% data{141}=importfile('Rodrigo Caio Hop L3.csv');
% data{142}=importfile('Rodrigo Caio Hop R1.csv');
% data{143}=importfile('Rodrigo Caio Hop R2.csv');
% data{144}=importfile('Rodrigo Caio Hop R3.csv');
% data{145}=importfile('Roger de Hop L1.csv');
% data{146}=importfile('Roger de Hop L2.csv');
% data{147}=importfile('Roger de Hop L3.csv');
% data{148}=importfile('Roger de Hop R1.csv');
% data{149}=importfile('Roger de Hop R2.csv');
% data{150}=importfile('Roger de Hop R3.csv');
% data{151}=importfile('Silvio Jose Hop L1.csv');
% data{152}=importfile('Silvio Jose Hop L2.csv');
% data{153}=importfile('Silvio Jose Hop L3.csv');
% data{154}=importfile('Silvio Jose Hop R1.csv');
% data{155}=importfile('Silvio Jose Hop R2.csv');
% data{156}=importfile('Silvio Jose Hop R3.csv');
% data{157}=importfile('Thiago Craleto Hop L1.csv');
% data{158}=importfile('Thiago Craleto Hop L2.csv');
% data{159}=importfile('Thiago Craleto Hop L3.csv');
% data{160}=importfile('Thiago Craleto Hop R1.csv');
% data{161}=importfile('Thiago Craleto Hop R2.csv');
% data{162}=importfile('Thiago Craleto Hop R3.csv');

 %%
% data{1}=importfile('Ademilson squat L1.csv');
% data{2}=importfile('Ademilson squat L2.csv');
% data{3}=importfile('Ademilson squat L3.csv');
% data{4}=importfile('Ademilson squat R1.csv');
% data{5}=importfile('Ademilson squat R2.csv');
% data{6}=importfile('Ademilson squat R3.csv');
% data{7}=importfile('Antonio Carlos squat L1.csv');
% data{8}=importfile('Antonio Carlos squat L2.csv');
% data{9}=importfile('Antonio Carlos squat L3.csv');
% data{10}=importfile('Antonio Carlos squat R1.csv');
% data{11}=importfile('Antonio Carlos squat R2.csv');
% data{12}=importfile('Antonio Carlos squat R3.csv');
% data{13}=importfile('Clemente squat L1.csv');
% data{14}=importfile('Clemente squat L2.csv');
% data{15}=importfile('Clemente squat L3.csv');
% data{16}=importfile('Clemente squat R1.csv');
% data{17}=importfile('Clemente squat R2.csv');
% data{18}=importfile('Clemente squat R3.csv');
% data{19}=importfile('Denilson Pereira squat L1.csv');
% data{20}=importfile('Denilson Pereira squat L2.csv');
% data{21}=importfile('Denilson Pereira squat L3.csv');
% data{22}=importfile('Denilson Pereira squat R1.csv');
% data{23}=importfile('Denilson Pereira squat R2.csv');
% data{24}=importfile('Denilson Pereira squat R3.csv');
% data{25}=importfile('Douglas squat L1.csv');
% data{26}=importfile('Douglas squat L2.csv');
% data{27}=importfile('Douglas squat L3.csv');
% data{28}=importfile('Douglas squat R1.csv');
% data{29}=importfile('Douglas squat R2.csv');
% data{30}=importfile('Douglas squat R3.csv');
% data{31}=importfile('Edson squat L1.csv');
% data{32}=importfile('Edson squat L2.csv');
% data{33}=importfile('Edson squat L3.csv');
% data{34}=importfile('Edson squat R1.csv');
% data{35}=importfile('Edson squat R2.csv');
% data{36}=importfile('Edson squat R3.csv');
% data{37}=importfile('Fabricio squat L1.csv');
% data{38}=importfile('Fabricio squat L2.csv');
% data{39}=importfile('Fabricio squat L3.csv');
% data{40}=importfile('Fabricio squat R1.csv');
% data{41}=importfile('Fabricio squat R2.csv');
% data{42}=importfile('Fabricio squat R3.csv');
% data{43}=importfile('Jadson squat L1.csv');
% data{44}=importfile('Jadson squat L2.csv');
% data{45}=importfile('Jadson squat L3.csv');
% data{46}=importfile('Jadson squat R1.csv');
% data{47}=importfile('Jadson squat R2.csv');
% data{48}=importfile('Jadson squat R3.csv');
% data{49}=importfile('Joao Felipe squat L1.csv');
% data{50}=importfile('Joao Felipe squat L2.csv');
% data{51}=importfile('Joao Felipe squat L3.csv');
% data{52}=importfile('Joao Felipe squat R1.csv');
% data{53}=importfile('Joao Felipe squat R2.csv');
% data{54}=importfile('Joao Felipe squat R3.csv');
% data{55}=importfile('Lucas Evangelist squat L1.csv');
% data{56}=importfile('Lucas Evangelist squat L2.csv');
% data{57}=importfile('Lucas Evangelist squat L3.csv');
% data{58}=importfile('Lucas Evangelist squat R1.csv');
% data{59}=importfile('Lucas Evangelist squat R2.csv');
% data{60}=importfile('Lucas Evangelist squat R3.csv');
% data{61}=importfile('Lucas Farias squat L1.csv');
% data{62}=importfile('Lucas Farias squat L2.csv');
% data{63}=importfile('Lucas Farias squat L3.csv');
% data{64}=importfile('Lucas Farias squat R1.csv');
% data{65}=importfile('Lucas Farias squat R2.csv');
% data{66}=importfile('Lucas Farias squat R3.csv');
% data{67}=importfile('Luis Fabiano squat L1.csv');
% data{68}=importfile('Luis Fabiano squat L2.csv');
% data{69}=importfile('Luis Fabiano squat L3.csv');
% data{70}=importfile('Luis Fabiano squat R1.csv');
% data{71}=importfile('Luis Fabiano squat R2.csv');
% data{72}=importfile('Luis Fabiano squat R3.csv');
% data{73}=importfile('Luis Ricardo squat L1.csv');
% data{74}=importfile('Luis Ricardo squat L2.csv');
% data{75}=importfile('Luis Ricardo squat L3.csv');
% data{76}=importfile('Luis Ricardo squat R1.csv');
% data{77}=importfile('Luis Ricardo squat R2.csv');
% data{78}=importfile('Luis Ricardo squat R3.csv');
% data{79}=importfile('Maicon Thiago squat L1.csv');
% data{80}=importfile('Maicon Thiago squat L2.csv');
% data{81}=importfile('Maicon Thiago squat L3.csv');
% data{82}=importfile('Maicon Thiago squat R1.csv');
% data{83}=importfile('Maicon Thiago squat R2.csv');
% data{84}=importfile('Maicon Thiago squat R3.csv');
% data{85}=importfile('Marcelo Canete squat L1.csv');
% data{86}=importfile('Marcelo Canete squat L2.csv');
% data{87}=importfile('Marcelo Canete squat L3.csv');
% data{88}=importfile('Marcelo Canete squat R1.csv');
% data{89}=importfile('Marcelo Canete squat R2.csv');
% data{90}=importfile('Marcelo Canete squat R3.csv');
% data{91}=importfile('Mateus Lucena squat L1.csv');
% data{92}=importfile('Mateus Lucena squat L2.csv');
% data{93}=importfile('Mateus Lucena squat L3.csv');
% data{94}=importfile('Mateus Lucena squat R1.csv');
% data{95}=importfile('Mateus Lucena squat R2.csv');
% data{96}=importfile('Mateus Lucena squat R3.csv');
% data{97}=importfile('Oswaldo Lourenco squat L1.csv');
% data{98}=importfile('Oswaldo Lourenco squat L2.csv');
% data{99}=importfile('Oswaldo Lourenco squat L3.csv');
% data{100}=importfile('Oswaldo Lourenco squat R1.csv');
% data{101}=importfile('Oswaldo Lourenco squat R2.csv');
% data{102}=importfile('Oswaldo Lourenco squat R3.csv');
% data{103}=importfile('Paul henrique squat L1.csv');
% data{104}=importfile('Paul henrique squat L2.csv');
% data{105}=importfile('Paul henrique squat L3.csv');
% data{106}=importfile('Paul henrique squat R1.csv');
% data{107}=importfile('Paul henrique squat R2.csv');
% data{108}=importfile('Paul henrique squat R3.csv');
% data{109}=importfile('paulo miranda squat L1.csv');
% data{110}=importfile('paulo miranda squat L2.csv');
% data{111}=importfile('paulo miranda squat L3.csv');
% data{112}=importfile('paulo miranda squat R1.csv');
% data{113}=importfile('paulo miranda squat R2.csv');
% data{114}=importfile('paulo miranda squat R3.csv');
% data{115}=importfile('Rafael Toloi squat L1.csv');
% data{116}=importfile('Rafael Toloi squat L2.csv');
% data{117}=importfile('Rafael Toloi squat L3.csv');
% data{118}=importfile('Rafael Toloi squat R1.csv');
% data{119}=importfile('Rafael Toloi squat R2.csv');
% data{120}=importfile('Rafael Toloi squat R3.csv');
% data{121}=importfile('Reinaldo Manoel squat L1.csv');
% data{122}=importfile('Reinaldo Manoel squat L2.csv');
% data{123}=importfile('Reinaldo Manoel squat L3.csv');
% data{124}=importfile('Reinaldo Manoel squat R1.csv');
% data{125}=importfile('Reinaldo Manoel squat R2.csv');
% data{126}=importfile('Reinaldo Manoel squat R3.csv');
% data{127}=importfile('Ricardo Sasaki squat L1.csv');
% data{128}=importfile('Ricardo Sasaki squat L2.csv');
% data{129}=importfile('Ricardo Sasaki squat L3.csv');
% data{130}=importfile('Ricardo Sasaki squat R1.csv');
% data{131}=importfile('Ricardo Sasaki squat R2.csv');
% data{132}=importfile('Ricardo Sasaki squat R3.csv');
% data{133}=importfile('Roberta Rosas squat L1.csv');
% data{134}=importfile('Roberta Rosas squat L2.csv');
% data{135}=importfile('Roberta Rosas squat L3.csv');
% data{136}=importfile('Roberta Rosas squat R1.csv');
% data{137}=importfile('Roberta Rosas squat R2.csv');
% data{138}=importfile('Roberta Rosas squat R3.csv');
% data{139}=importfile('Rodrigo Caio squat L1.csv');
% data{140}=importfile('Rodrigo Caio squat L2.csv');
% data{141}=importfile('Rodrigo Caio squat L3.csv');
% data{142}=importfile('Rodrigo Caio squat R1.csv');
% data{143}=importfile('Rodrigo Caio squat R2.csv');
% data{144}=importfile('Rodrigo Caio squat R3.csv');
% data{145}=importfile('Roger de squat L1.csv');
% data{146}=importfile('Roger de squat L2.csv');
% data{147}=importfile('Roger de squat L3.csv');
% data{148}=importfile('Roger de squat R1.csv');
% data{149}=importfile('Roger de squat R2.csv');
% data{150}=importfile('Roger de squat R3.csv');
% data{151}=importfile('Silvio Jose squat L1.csv');
% data{152}=importfile('Silvio Jose squat L2.csv');
% data{153}=importfile('Silvio Jose squat L3.csv');
% data{154}=importfile('Silvio Jose squat R1.csv');
% data{155}=importfile('Silvio Jose squat R2.csv');
% data{156}=importfile('Silvio Jose squat R3.csv');
% data{157}=importfile('Thiago Craleto squat L1.csv');
% data{158}=importfile('Thiago Craleto squat L2.csv');
% data{159}=importfile('Thiago Craleto squat L3.csv');
% data{160}=importfile('Thiago Craleto squat R1.csv');
% data{161}=importfile('Thiago Craleto squat R2.csv');
% data{162}=importfile('Thiago Craleto squat R3.csv');

