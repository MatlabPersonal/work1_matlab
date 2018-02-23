function [coeffs] = readCoeffs(coeff8,coeff9,coeff10,version)
if(version == 6.4)
    coeffs.gacc(1) = hex2dec(coeff8(1:2)) + hex2dec(coeff8(3:4))*256;
    coeffs.oacc(1) = hex2dec(coeff8(5:6)) + hex2dec(coeff8(7:8))*256;
    coeffs.gacc(2) = hex2dec(coeff8(9:10)) + hex2dec(coeff8(11:12))*256;
    coeffs.oacc(2) = hex2dec(coeff8(13:14)) + hex2dec(coeff8(15:16))*256;
    coeffs.gacc(3) = hex2dec(coeff8(17:18)) + hex2dec(coeff8(19:20))*256;
    coeffs.oacc(3) = hex2dec(coeff8(21:22)) + hex2dec(coeff8(23:24))*256;
    
    coeffs.ggyro(1) = hex2dec(coeff8(25:26)) + hex2dec(coeff8(27:28))*256;
    coeffs.ogyro(1) = hex2dec(coeff8(29:30)) + hex2dec(coeff8(31:32))*256;
    coeffs.ggyro(2) = hex2dec(coeff8(33:34)) + hex2dec(coeff8(35:36))*256;
    coeffs.ogyro(2) = hex2dec(coeff9(1:2)) + hex2dec(coeff9(3:4))*256;
    coeffs.ggyro(3) = hex2dec(coeff9(5:6)) + hex2dec(coeff9(7:8))*256;
    coeffs.ogyro(3) = hex2dec(coeff9(9:10)) + hex2dec(coeff9(11:12))*256;
    
    coeffs.gmag(1) = hex2dec(coeff9(13:14)) + hex2dec(coeff9(15:16))*256;
    coeffs.omag(1) = hex2dec(coeff9(17:18)) + hex2dec(coeff9(19:20))*256;
    coeffs.gmag(2) = hex2dec(coeff9(21:22)) + hex2dec(coeff9(23:24))*256;
    coeffs.omag(2) = hex2dec(coeff9(25:26)) + hex2dec(coeff9(27:28))*256;
    coeffs.gmag(3) = hex2dec(coeff9(29:30)) + hex2dec(coeff9(31:32))*256;
    coeffs.omag(3) = hex2dec(coeff9(33:34)) + hex2dec(coeff9(35:36))*256;
elseif(version == 6.6)
    coeffs.gacc(1) = hex2dec(coeff8(1:2)) + hex2dec(coeff8(3:4))*256;
    coeffs.oacc(1) = hex2dec(coeff8(5:6)) + hex2dec(coeff8(7:8))*256;
    coeffs.gacc(2) = hex2dec(coeff8(9:10)) + hex2dec(coeff8(11:12))*256;
    coeffs.oacc(2) = hex2dec(coeff8(13:14)) + hex2dec(coeff8(15:16))*256;
    coeffs.gacc(3) = hex2dec(coeff8(17:18)) + hex2dec(coeff8(19:20))*256;
    coeffs.oacc(3) = hex2dec(coeff8(21:22)) + hex2dec(coeff8(23:24))*256;
    
    coeffs.ggyro(1) = hex2dec(coeff9(1:2)) + hex2dec(coeff9(3:4))*256;
    coeffs.ogyro(1) = hex2dec(coeff9(5:6)) + hex2dec(coeff9(7:8))*256;
    coeffs.ggyro(2) = hex2dec(coeff9(9:10)) + hex2dec(coeff9(11:12))*256;
    coeffs.ogyro(2) = hex2dec(coeff9(13:14)) + hex2dec(coeff9(15:16))*256;
    coeffs.ggyro(3) = hex2dec(coeff9(17:18)) + hex2dec(coeff9(19:20))*256;
    coeffs.ogyro(3) = hex2dec(coeff9(21:22)) + hex2dec(coeff9(23:24))*256;
    
    coeffs.gmag(1) = hex2dec(coeff10(1:2)) + hex2dec(coeff10(3:4))*256;
    coeffs.omag(1) = hex2dec(coeff10(5:6)) + hex2dec(coeff10(7:8))*256;
    coeffs.gmag(2) = hex2dec(coeff10(9:10)) + hex2dec(coeff10(11:12))*256;
    coeffs.omag(2) = hex2dec(coeff10(13:14)) + hex2dec(coeff10(15:16))*256;
    coeffs.gmag(3) = hex2dec(coeff10(17:18)) + hex2dec(coeff10(19:20))*256;
    coeffs.omag(3) = hex2dec(coeff10(21:22)) + hex2dec(coeff10(23:24))*256;
end
coeffs.gacc = coeffs.gacc/16384;
coeffs.oacc = coeffs.oacc/16384;
coeffs.ggyro = coeffs.ggyro/16384;
coeffs.ogyro = coeffs.ogyro/16384;
coeffs.gmag = coeffs.gmag/16384;
coeffs.omag = coeffs.omag/16384;
end