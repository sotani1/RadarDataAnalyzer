function [var_, flg_wrinkle] = f_cm2_1_check_tinterval(var_, as_)
%% Åò2-1-3-3-2 Interpolat/Extrapolate function for missing or uneven files
i_wrinkle        = 1;
dt               = 0;
d_sum_wrinkle    = 0;
d_ind_wrinkle    = 0;
d_wrinkle_thresh = 1.0;
mat_wrinkle      = [];
var_temp_1       = [];
var_temp_2       = [];
var_temp_all     = [];
flg_wrinkle      = 0;

try
    var_time = var_{ff_set_varname(as_, as_{1})};
    dt = var_time(2) - var_time(1);
    % Determine which rows have uneven sampling intervals
    for i=1:length(var_time)
        if i < length(var_time)
            if (var_time(i+1) - var_time(i)) ~= dt 
                mat_wrinkle(i_wrinkle) = i;
                i_wrinkle = i_wrinkle + 1;
            end
        end
    end
    % Break from function if mat_wrinkle is empty (no need to interp/extrap)
    if isempty(mat_wrinkle) == 1
        return;
    end
    
    % Check to see if total wrinkle is greater than one, or if individual increment is greater than one
    for j=1:size(mat_wrinkle,1)
        d_sum_wrinkle = d_sum_wrinkle + mat_wrinkle(j);
        if mat_wrinkle(j) >= d_wrinkle_thresh
            flg_wrinkle = 1;
        end
    end
    if d_sum_wrinkle >= d_wrinkle_thresh
        flg_wrinkle = 1;
    end
    % Interpolate or Extrapolate values if there is a wrinkle
        for k1=1:size(var_,2)
            for k2=1:size(mat_wrinkle,2)
                if isempty(var_{1,k1}) == 1
                    continue;
                end
                var_temp_1 = var_{1,k1}(1:mat_wrinkle(k2),1);
                var_temp_2 = var_{1,k1}(mat_wrinkle(k2)+1:end,1);
                var_temp_all(1:size(var_temp_1,1),1) = var_temp_1;
                var_temp_all(size(var_temp_1,1)+1,1) = NaN;
                var_temp_all(size(var_temp_1,1)+2:size(var_temp_2,1)+size(var_temp_1,1)+1,1) = var_temp_2;
                nans       = isnan(var_temp_all);
                t          = 1:numel(var_temp_all);
                % Skip if all values are NaNs (Interp/Extrap functions will result in errors)
                if all(nans == nans(1))
                    var_{1,k1}   = var_temp_all;
                    continue;
                else
                    % Interpolate
                    var_temp_all(nans) = interp1(t(~nans), var_temp_all(~nans), t(nans));
                    % Extrapolate
                    x = transpose(1:length(var_temp_all));   % Create a vector of indices
                    non_nans     = ~isnan(var_temp_all); 
                    var_temp_all = interp1(x(non_nans),var_temp_all(non_nans),x,'next','extrap');
                end
                % Store value
                var_{1,k1}   = var_temp_all;  
            end
            var_temp_all = [];             % Rest vector upon writing
        end
catch
    fprintf('Interpolation failed at var_{%i}', k1);
    var_{1,k1} = var_temp_all;
end

end