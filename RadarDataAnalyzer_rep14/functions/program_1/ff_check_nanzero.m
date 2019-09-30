function var = f_checknanzero(var, var_ref)
nanx = isnan(var);
t    = 1:numel(var);
    if isempty(var) ~= 1
        if max(nanx) == 1 && min(nanx) == 1
            var = zeros(size(var_ref,1),1); 
        else
            var(nanx) = interp1(t(~nanx), var(~nanx), t(nanx));
        end
    else
        var = zeros(size(var_ref,1),1); 
    end
end
