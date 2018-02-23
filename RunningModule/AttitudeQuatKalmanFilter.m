function [quatOut] = AttitudeQuatKalmanFilter(gyro,quatIn,gyroTime,NGyroProcess,NGyroMeasure,NQuatMeasure,tau,coeff)
%=====================================================================================================================
% function [quatOut] = AttitudeQuatKalmanFilter(gyro,quatIn,gyroTime,NGyroProcess,NGyroMeasure,NQuatMeasure,tau,coeff)
% 
% Quaternion based Extended Kalman Filter for Attitude Estimation
% Input params:
% gyro - nx3 matrix for gyro x, y, z data in rad/sec
% quatIn - nx4 matrix for quaternion with scalar vector in the first column
% gyroTime - nx1 time vector
% NGyroProcess,NGyroMeasure,NQuatMeasure,tau - measure/process noise and time constant
% coeff - for adjusting gyro drifting, leave 1 by default
%=====================================================================================================================

% matlab implementation of the EKF for attitude estimation

    %Noise Covariance
    GyroObservationNoise = NGyroProcess.^2;
    timeConstant = tau;
    gyroMeasureNoise = NGyroMeasure.^2;
    quatMeasureNoise = NQuatMeasure.^2;
    %input
    pi=3.14159265359;
    gyroX = gyro(:,1)./180.*pi;
    gyroY = gyro(:,2)./180.*pi;
    gyroZ = gyro(:,3)./180.*pi;
    q0 = quatIn(:,1);
    q1 = quatIn(:,2);
    q2 = quatIn(:,3);
    q3 = quatIn(:,4);
    
    %param
    tPrevious = (gyroTime(1)-gyroTime(2))/1000;
    len = length(gyroTime);
    quatOut = zeros(len,4);
%     coeff=1;
    R = [gyroMeasureNoise 0 0 0 0 0 0;
         0 gyroMeasureNoise 0 0 0 0 0;
         0 0 gyroMeasureNoise 0 0 0 0;
         0 0 0 quatMeasureNoise 0 0 0;
         0 0 0 0 quatMeasureNoise 0 0;
         0 0 0 0 0 quatMeasureNoise 0;
         0 0 0 0 0 0 quatMeasureNoise];
     
    %Initial State (Cov) 
    x = [0;0;0;1;0;0;0];
    P = eye(7).*exp(30);
    %Orb
    H = eye(7);
    for i = 1:len
        deltaT = gyroTime(i)/1000 - tPrevious;
        tPrevious = gyroTime(i)/1000;
        decay = exp(-deltaT./timeConstant);
        t = deltaT./2;
        %Trans
        F = [decay 0 0 0 0 0 0;
            0 decay 0 0 0 0 0;
            0 0 decay 0 0 0 0;
            -x(5).*t  -x(6).*t  -x(7).*t  1        -x(1).*t   -x(2).*t  -x(3).*t;
             x(4).*t  -x(7).*t   x(6).*t  x(1).*t   1          x(3).*t  -x(2).*t;
             x(7).*t   x(4).*t  -x(5).*t  x(2).*t  -x(3).*t    1         x(1).*t;
            -x(6).*t   x(5).*t   x(4).*t  x(3).*t   x(2).*t   -x(1).*t   1];
        
        z = [gyroX(i);gyroY(i);gyroZ(i);q0(i);q1(i);q2(i);q3(i)];
        
        %Noise Cov Matrix
        GyroProNoise = GyroObservationNoise.*(1-decay.^2)./(2.*timeConstant);
        Q = [GyroProNoise 0 0 0 0 0 0;
            0 GyroProNoise 0 0 0 0 0;
            0 0 GyroProNoise 0 0 0 0;
            0 0 0 0 0 0 0;
            0 0 0 0 0 0 0;
            0 0 0 0 0 0 0;
            0 0 0 0 0 0 0];
        
        %predict
%         x = F*x;
        xPrior = [decay.*x(1); decay.*x(2); decay.*x(3);
            x(4)-coeff.*t*(x(1).*x(5)+x(2).*x(6)+x(3).*x(7));
            x(5)+coeff.*t*(x(1).*x(4)-x(2).*x(7)+x(3).*x(6));
            x(6)+coeff.*t*(x(1).*x(7)+x(2).*x(4)-x(3).*x(5));
            x(7)+coeff.*t*(-x(1).*x(6)+x(2).*x(5)+x(3).*x(4))];
%         x=xTemp;
        PPrior = F*P*(F') + Q;
        %Update
        y = z - H*xPrior;
        S = H*PPrior*(H') + R;
        K = PPrior*(H')/S;
        x = xPrior+K*y;
        P = (eye(7) - K*H)*PPrior;
        %normalise Quaternions
        normfac = 1./sqrt(x(4).^2+x(5).^2+x(6).^2+x(7).^2);
        x(4) = normfac.*x(4);
        x(5) = normfac.*x(5);
        x(6) = normfac.*x(6);
        x(7) = normfac.*x(7);
        %set Output
        quatOut(i,:) = [x(4) x(5) x(6) x(7)];
        
    end
end 