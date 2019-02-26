function [out] = makemap(dmin,dmax,dd)
    out_x = (dmin:dd:dmax)';
    out_y = zeros(length(out_x),1);
    
    out = [out_x out_y out_y];
end


