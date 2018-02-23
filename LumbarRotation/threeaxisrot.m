
function [r1 r2 r3] = threeaxisrot(r11, r12, r21, r31, r32)
        % find angles for rotations about X, Y, and Z axes
        r1 = atan2( r11, r12 );
        r2 = asin( r21 );
        r3 = atan2( r31, r32 );