function var_return = fset_removenan(var_interp, var_time_tmp)
    nanx = isnan(var_interp);         %nan index
    var_interp(nanx) = interp1(var_time_tmp(~nanx),var_interp(~nanx),var_time_tmp(nanx));  %interpolate all values outside nan
    var_interp(isnan(var_interp))=0;  %assign zero to all other values
    var_return = var_interp;
end
