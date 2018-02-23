function [ASI,ASI_Vector] = findASI(GRF_Vector_Left,GRF_Vector_Right, FlatFoot_Left, FlatFoot_Right, Stc)

ASI = 0;
ASI_Vector = zeros(1,1);
% Choose left
LA = length(GRF_Vector_Left); LB = length(GRF_Vector_Right);
LA = FlatFoot_Left(1:LA); LB=FlatFoot_Right(1:LB);
if(length(GRF_Vector_Left)>1 && length(GRF_Vector_Right)>1)
    GRF_Vector_Left_Interp = interp1(Stc(LA),GRF_Vector_Left, Stc(LB));
    ASI_Vector = 100*(GRF_Vector_Right - GRF_Vector_Left_Interp)./((GRF_Vector_Left_Interp + GRF_Vector_Right)/2);
    ASI_Vector(isnan(ASI_Vector))=[];
    ASI = median(ASI_Vector);
else
    ASI_Vector = 100*(GRF_Vector_Right(1) - GRF_Vector_Left(1))./((GRF_Vector_Left(1) + GRF_Vector_Right(1))/2);
    ASI_Vector(isnan(ASI_Vector))=[];
%     ASI = median(ASI_Vector);
end

end