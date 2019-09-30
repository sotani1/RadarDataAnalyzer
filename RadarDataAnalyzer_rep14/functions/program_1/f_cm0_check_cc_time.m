function flg = f_cm0_check_cc_time(var_time, var_, as_, cc_timer)
%% Åò2-1-3-3-3 Check for cruise control enabled / time less than 5 mins (Unique script requested by VTTI)
dt = (var_time(2)-var_time(1))/1000;
if (length(var_time)*dt) < cc_timer
    flg = 1;  % Set flag to one if the trip file is less than 5 minutes (will ignore the run_all sequence altogether)
elseif max(var_{ff_set_varname(as_, as_{12})}) == 0
    flg = 2;  % Set flag to two if the trip contains cruise control activation (will still execute run_all sequence)
else
    flg = 0;  % Otherwise, don't do anything
end
