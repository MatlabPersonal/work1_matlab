function [GRF_Vector_Left_Filt,GRF_Vector_Right_Filt,...
         IPA_Vector_Left_Filt,IPA_Vector_Right_Filt,...
         ContactTimeVector_Left_Filt,ContactTimeVector_Right_Filt,...
         SpeedVector_Filt,CadenceVector_Filt,ASI_Vector_Filt] = filterMetrics(GRF_Vector_Left,GRF_Vector_Right,IPA_Vector_Left,IPA_Vector_Right,...
                                                                              ContactTimeVector_Left,ContactTimeVector_Right,...
                                                                                SpeedVector,CadenceVector,ASI_Vector,Distance)

    GRF_Vector_Left_Filt = zeros(1,1);
    GRF_Vector_Right_Filt = zeros(1,1);
    IPA_Vector_Left_Filt = zeros(1,1);
    IPA_Vector_Right_Filt = zeros(1,1);
    ContactTimeVector_Left_Filt = zeros(1,1);
    ContactTimeVector_Right_Filt = zeros(1,1);
    SpeedVector_Filt = zeros(1,1);
    CadenceVector_Filt = zeros(1,1);
    ASI_Vector_Filt = zeros(1,1);

    Distance = Distance/1000;
    if (Distance < 1) % < 1km - Do nothing

        GRF_Vector_Left_Filt = GRF_Vector_Left;
        GRF_Vector_Right_Filt = GRF_Vector_Right;
        IPA_Vector_Left_Filt = IPA_Vector_Left;
        IPA_Vector_Right_Filt = IPA_Vector_Right;
        ContactTimeVector_Left_Filt = ContactTimeVector_Left;
        ContactTimeVector_Right_Filt = ContactTimeVector_Right;
        SpeedVector_Filt = SpeedVector;
        CadenceVector_Filt = CadenceVector;
        ASI_Vector_Filt = ASI_Vector;

    else
%         B=0;A=0;
        if (Distance > 20)
            [B,A]=butter(4,0.025/2,'low');
            GRF_Vector_Left_Filt = filtfilt(B,A,GRF_Vector_Left);
            GRF_Vector_Right_Filt = filtfilt(B,A,GRF_Vector_Right);
            IPA_Vector_Left_Filt = filtfilt(B,A,IPA_Vector_Left);
            IPA_Vector_Right_Filt = filtfilt(B,A,IPA_Vector_Right);
            ContactTimeVector_Left_Filt = filtfilt(B,A,ContactTimeVector_Left);
            ContactTimeVector_Right_Filt = filtfilt(B,A,ContactTimeVector_Right);
            SpeedVector_Filt = filtfilt(B,A,SpeedVector);
            CadenceVector_Filt = filtfilt(B,A,CadenceVector);
            ASI_Vector_Filt = filtfilt(B,A,ASI_Vector);

        elseif ((Distance > 8) && (Distance <= 20))
            [B,A]=butter(4,0.05/2,'low');
            GRF_Vector_Left_Filt = filtfilt(B,A,GRF_Vector_Left);
            GRF_Vector_Right_Filt = filtfilt(B,A,GRF_Vector_Right);
            IPA_Vector_Left_Filt = filtfilt(B,A,IPA_Vector_Left);
            IPA_Vector_Right_Filt = filtfilt(B,A,IPA_Vector_Right);
            ContactTimeVector_Left_Filt = filtfilt(B,A,ContactTimeVector_Left);
            ContactTimeVector_Right_Filt = filtfilt(B,A,ContactTimeVector_Right);
            SpeedVector_Filt = filtfilt(B,A,SpeedVector);
            CadenceVector_Filt = filtfilt(B,A,CadenceVector);
            ASI_Vector_Filt = filtfilt(B,A,ASI_Vector);

        elseif ((Distance > 2) && (Distance <= 8))
            [B,A]=butter(4,0.1/2,'low');
            GRF_Vector_Left_Filt = filtfilt(B,A,GRF_Vector_Left);
            GRF_Vector_Right_Filt = filtfilt(B,A,GRF_Vector_Right);
            IPA_Vector_Left_Filt = filtfilt(B,A,IPA_Vector_Left);
            IPA_Vector_Right_Filt = filtfilt(B,A,IPA_Vector_Right);
            ContactTimeVector_Left_Filt = filtfilt(B,A,ContactTimeVector_Left);
            ContactTimeVector_Right_Filt = filtfilt(B,A,ContactTimeVector_Right);
            SpeedVector_Filt = filtfilt(B,A,SpeedVector);
            CadenceVector_Filt = filtfilt(B,A,CadenceVector);
            ASI_Vector_Filt = filtfilt(B,A,ASI_Vector);

        elseif ((Distance >=1) && (Distance <= 2))
            [B,A]=butter(4,0.2/2,'low');
            GRF_Vector_Left_Filt = filtfilt(B,A,GRF_Vector_Left);
            GRF_Vector_Right_Filt = filtfilt(B,A,GRF_Vector_Right);
            IPA_Vector_Left_Filt = filtfilt(B,A,IPA_Vector_Left);
            IPA_Vector_Right_Filt = filtfilt(B,A,IPA_Vector_Right);
            ContactTimeVector_Left_Filt = filtfilt(B,A,ContactTimeVector_Left);
            ContactTimeVector_Right_Filt = filtfilt(B,A,ContactTimeVector_Right);
            SpeedVector_Filt = filtfilt(B,A,SpeedVector);
            CadenceVector_Filt = filtfilt(B,A,CadenceVector);     
            ASI_Vector_Filt = filtfilt(B,A,ASI_Vector);

        end

        
       
    end
    
%     figure;
%     a(1)=subplot(2,2,1);
%     plot(GRF_Vector_Left); hold on;plot(GRF_Vector_Right,'r');
%     plot(GRF_Vector_Left_Filt,'g','linewidth',2); hold on;plot(GRF_Vector_Right_Filt,'k--','linewidth',2)
%     grid;  title('GRF');
%     legend('Left','Right','Left Filt','Right Filt');
%     a(2)=subplot(2,2,2);
%     plot(IPA_Vector_Left); hold on;plot(IPA_Vector_Right,'r'); hold on;
%     plot(IPA_Vector_Left_Filt,'g','linewidth',2); hold on;plot(IPA_Vector_Right_Filt,'k--','linewidth',2)
%     grid;  title('IPA');
%     a(3)=subplot(2,2,3);
%     plot(ContactTimeVector_Left); hold on;plot(ContactTimeVector_Right,'r'); hold on;
%     plot(ContactTimeVector_Left_Filt,'g','linewidth',2); hold on;plot(ContactTimeVector_Right_Filt,'k--','linewidth',2)
%     grid;  title('CT');
%     a(4)=subplot(2,2,4);
%     plot(SpeedVector,'r'); hold on;plot(CadenceVector/10,'r'); hold on;
%     plot(SpeedVector_Filt,'g--','linewidth',2);hold on;plot(CadenceVector_Filt/10,'k--','linewidth',2)
%     grid;  title('Speed');
%     linkaxes(a,'x');

end