function [V_ALL, as_header_gobo] = f_gobo_log(M_data, dt, i_mt_plot, var_time, var_ego_vel_interp, ope_state, k_gof, timer_gof, k_bon, timer_bon, var_time_gof, var_time_bon)

% Declare variables here
f_type = 'var'; f_target = 'lead'; f_var = 'thw_inv'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target,f_var, f_ilv, M_data);
plotvar_thw_inv = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
%Remove NaNs
nanx = isnan(plotvar_thw_inv);
t    = 1:numel(plotvar_thw_inv);
plotvar_thw_inv(nanx) = interp1(t(~nanx), plotvar_thw_inv(~nanx), t(nanx));

f_type = 'var'; f_target = 'lead'; f_var = 'ttc_inv'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_ttc_inv = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
%Remove NaNs
nanx = isnan(plotvar_ttc_inv);
t    = 1:numel(plotvar_ttc_inv);
plotvar_ttc_inv(nanx) = interp1(t(~nanx), plotvar_ttc_inv(~nanx), t(nanx));

plotvar_risk = (1*plotvar_thw_inv) + (4*plotvar_ttc_inv); 

f_type = 'var'; f_target = 'lead'; f_var = 'thw'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_thw = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
%Remove NaNs
nanx = isnan(plotvar_thw);
t    = 1:numel(plotvar_thw);
plotvar_thw(nanx) = interp1(t(~nanx), plotvar_thw(~nanx), t(nanx));

f_type = 'var'; f_target = 'lead'; f_var = 'ttc'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_ttc = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
%Remove NaNs
nanx = isnan(plotvar_ttc);
t    = 1:numel(plotvar_ttc);
plotvar_ttc(nanx) = interp1(t(~nanx), plotvar_ttc(~nanx), t(nanx));

f_type = 'var'; f_target = 'ego'; f_var = 'accelx'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_accx = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;

f_type = 'var'; f_target = 'ego'; f_var = 'longitude'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_long = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
%Remove NaNs
nanx = isnan(plotvar_long);
t    = 1:numel(plotvar_long);
plotvar_long(nanx) = interp1(t(~nanx), plotvar_long(~nanx), t(nanx));

f_type = 'var'; f_target = 'ego'; f_var = 'latitude'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_lat = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
%Remove NaNs
nanx = isnan(plotvar_lat);
t    = 1:numel(plotvar_lat);
plotvar_lat(nanx) = interp1(t(~nanx), plotvar_lat(~nanx), t(nanx));

try
    for i=1:length(timer_gof)
        t1 = var_time_gof(i)*(1/dt);
        if var_time_gof(i)*(1/dt) == var_time(end)
            t2 = var_time_gof(i)*(1/dt)+timer_gof(i)*(1/dt);
        else
            t2 = var_time_gof(i)*(1/dt);
        end
        if t1 == 0
            t1 = 1;
        end
        if t2 == 0
            t2 = 1;
        end
        v_1a(i,1)  = i;                               % Index 
        v_2a(i,1)  = var_time_gof(i);                 % Timestamp
        v_3a(i,1)  = 2;                               % Ope_state
        v_4a(i,1)  = timer_gof(i);                    % Duration
        v_5a(i,1)  = mean(var_ego_vel_interp(t1:t2)); % Mean speed
        v_6a(i,1)  = max(plotvar_thw_inv(t1:t2));     % Max Inv_THW
        v_7a(i,1)  = max(plotvar_ttc_inv(t1:t2));     % Max Inv_TTC
        v_8a(i,1)  = max(plotvar_risk(t1:t2));        % Max Risk Feeling
        v_9a(i,1)  = min(plotvar_thw(t1:t2));         % Min THW
        v_10a(i,1) = min(plotvar_ttc(t1:t2));         % Min TTC
        v_11a(i,1) = min(plotvar_accx(t1:t2));        % Min Accx
        v_12a(i,1) = plotvar_lat(i);                  % Latitude
        v_13a(i,1) = plotvar_long(i);                 % Longitude
    end
catch
    fprintf('There was an error in gof at i= %d', i);
end
v_6a(isnan(v_6a))=0;
v_7a(isnan(v_7a))=0;
v_8a(isnan(v_8a))=0;
v_9a(isnan(v_9a))=0;
v_10a(isnan(v_10a))=0;
v_11a(isnan(v_11a))=0;

V_2 = [v_1a, v_2a, v_3a, v_4a, v_5a, v_6a, v_7a, v_8a, v_9a, v_10a, v_11a, v_12a, v_13a];  % For ope_state(2)

try
    for i=1:length(timer_bon)
        t1 = var_time_bon(i)*(1/dt);
        if var_time_bon(i)*(1/dt) == var_time(end)
            t2 = var_time_bon(i)*(1/dt)+timer_bon(i)*(1/dt);
        else
            t2 = var_time_bon(i)*(1/dt);
        end
        if t1 == 0
            t1 = 1;
        end
        if t2 == 0
            t2 = 1;
        end
        v_1b(i,1)  = i;                               % Index 
        v_2b(i,1)  = var_time_bon(i);                 % Timestamp
        v_3b(i,1)  = 3;                               % Ope_state
        v_4b(i,1)  = timer_bon(i);                    % Duration
        v_5b(i,1)  = mean(var_ego_vel_interp(t1:t2)); % Mean speed
        v_6b(i,1)  = max(plotvar_thw_inv(t1:t2));     % Max Inv_THW
        v_7b(i,1)  = max(plotvar_ttc_inv(t1:t2));     % Max Inv_TTC
        v_8b(i,1)  = max(plotvar_risk(t1:t2));        % Max Risk Feeling
        v_9b(i,1)  = min(plotvar_thw(t1:t2));         % Min THW
        v_10b(i,1) = min(plotvar_ttc(t1:t2));         % Min TTC
        v_11b(i,1) = min(plotvar_accx(t1:t2));        % Min Accx
        v_12b(i,1) = plotvar_lat(i);                  % Latitude
        v_13b(i,1) = plotvar_long(i);                 % Longitude
    end
catch
    fprintf('There was an error in bon at i= %d', i);
end
v_6b(isnan(v_6b))=0;
v_7b(isnan(v_7b))=0;
v_8b(isnan(v_8b))=0;
v_9b(isnan(v_9b))=0;
v_10b(isnan(v_10b))=0;
v_11b(isnan(v_11b))=0;

V_3 = [v_1b, v_2b, v_3b, v_4b, v_5b, v_6b, v_7b, v_8b, v_9b, v_10b, v_11b, v_12b, v_13b];  % For ope_state(3)

V_ALL = [V_2; V_3];
as_header_gobo = {'Index', 'Time_sec', 'ope_state', 'Duration_sec', 'Speed_kph', '1/THW_Max(1/sec)', '1/TTC_Max(1/sec)', ...
                  'RiskFeel_Max(-)', 'THW_min(s)', 'TTC_min(s)', 'Accelx_min(G)', 'Latitude(-)', 'Longitude(-)'};

end