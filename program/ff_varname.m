function jvar = ff_varname(as_, as_varname)
    for k = 1:length(as_)
    %Compare column name with as_ value
        if strcmp(as_varname, as_(k)) == 1
            jvar = k;
        end
    end
end
