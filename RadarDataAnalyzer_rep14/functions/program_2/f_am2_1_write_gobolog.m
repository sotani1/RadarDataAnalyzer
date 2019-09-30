function [V_ALL, as_header_gobo] = f_am2_1_write_gobolog(as_save_log, M_data, dt, i_mt_plot, var_time, var_ego_vel_interp, timer_gon, timer_grp, timer_gof, timer_bon, timer_brp, var_time_gon, var_time_grp, var_time_gof, var_time_bon, var_time_brp)
%% Åò4-1-1-3 Write GOBO log
%% Åò4-1-1-3-1 Initalize variables
% Declare variables here
f_type = 'var'; f_target = 'lead'; f_var = 'thw_inv'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target,f_var, f_ilv, M_data);
plotvar_thw_inv = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_thw_inv = ff_check_nanzero(plotvar_thw_inv, var_time); % Remove NaNs

f_type = 'var'; f_target = 'lead'; f_var = 'ttc_inv'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_ttc_inv = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_ttc_inv = ff_check_nanzero(plotvar_ttc_inv, var_time); % Remove NaNs

% Calculate risk feeling metric
plotvar_risk = (1*plotvar_thw_inv) + (4*plotvar_ttc_inv);   

f_type = 'var'; f_target = 'lead'; f_var = 'thw'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_thw = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_thw = ff_check_nanzero(plotvar_thw, var_time); % Remove NaNs

f_type = 'var'; f_target = 'lead'; f_var = 'ttc'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_ttc = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_ttc = ff_check_nanzero(plotvar_ttc, var_time); % Remove NaNs

f_type = 'var'; f_target = 'ego'; f_var = 'accelx'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_accx = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;

f_type = 'var'; f_target = 'ego'; f_var = 'longitude'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_long = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_long = ff_check_nanzero(plotvar_long, var_time); % Remove NaNs

f_type = 'var'; f_target = 'ego'; f_var = 'latitude'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_lat = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_lat = ff_check_nanzero(plotvar_lat, var_time); % Remove NaNs

%% Åò4-1-1-3-2 Compile data to write to gobolog csv
try
    %% Åò4-1-1-3-2-1 Ope_state 1.0 =GON=
    if isempty(timer_gon) ~= 1 && max(timer_gon) ~= 0 %Check to see if the entire gon vector is empty
        for i=1:length(timer_gon)
            if i == 27
                i = i*1;
            end
            i1 = (var_time_gon(i) - var_time(1))*(1/dt);
            if var_time_gon(i) == var_time(end)
                i2 = (var_time_gon(i) - var_time(1))*(1/dt);
            else
                i2 = (var_time_gon(i) - var_time(1))*(1/dt)+timer_gon(i)*(1/dt);
            end
            if i1 == 0
                i1 = 1;
            end
            if i2 == 0
                i2 = 1;
            end
            i1 = int32(i1);
            i2 = int32(i2);
            v_1a(i,1)  = i;                                          % Index 
            v_2a(i,1)  = var_time_gon(i);                            % Timestamp
            v_3a(i,1)  = floor((var_time_gon(i)-var_time(1))/60);    %Time [min]
            v_4a(i,1)  = round((var_time_gon(i)-var_time(1)) - (floor((var_time_gon(i)-var_time(1))/60)*60),0);    %Time [sec]            
            v_5a(i,1)  = 1;                                          % Ope_state
            v_6a(i,1)  = timer_gon(i);                               % Duration
            v_7a(i,1)  = mean(var_ego_vel_interp(i1:i2));            % Mean speed
            v_8a(i,1)  = max(plotvar_thw_inv(i1:i2));                % Max Inv_THW
            v_9a(i,1)  = max(plotvar_ttc_inv(i1:i2));                % Max Inv_TTC
            v_10a(i,1)  = max(plotvar_risk(i1:i2));                  % Max Risk Feeling
            v_11a(i,1)  = min(plotvar_thw(i1:i2));                   % Min THW
            v_12a(i,1) = min(plotvar_ttc(i1:i2));                    % Min TTC
            v_13a(i,1) = mean(plotvar_accx(i1:i2));                  % Mean Accx
            v_14a(i,1) = max(plotvar_accx(i1:i2));                   % Max Accx
            v_15a(i,1) = min(plotvar_accx(i1:i2));                   % Min Accx
            v_16a(i,1) = std(plotvar_accx(i1:i2));                   % Stdev Accx
            v_17a(i,1) = plotvar_lat(i);                             % Latitude
            v_18a(i,1) = plotvar_long(i);                            % Longitude
        end
    else
        v_1a(1,1)=0;
        v_2a(1,1)=0;
        v_3a(1,1)=0;
        v_4a(1,1)=0;
        v_5a(1,1)=0;
        v_6a(1,1)=0;
        v_7a(1,1)=0;
        v_8a(1,1)=0;
        v_9a(1,1)=0;
        v_10a(1,1)=0;
        v_11a(1,1)=0;
        v_12a(1,1)=0;
        v_13a(1,1)=0;
        v_14a(1,1)=0;
        v_15a(1,1)=0;
        v_16a(1,1)=0;
        v_17a(1,1)=0;
        v_18a(1,1)=0;        
    end
catch
    fprintf('There was an error in f_gobo_log gon at i= %d for file %s', i, as_save_log);
end
if isempty(timer_gon) ~= 1 
    v_6a(isnan(v_6a))  =0;
    v_7a(isnan(v_7a))  =0;
    v_8a(isnan(v_8a))  =0;
    v_9a(isnan(v_9a))  =0;
    v_10a(isnan(v_10a))=0;
    v_11a(isnan(v_11a))=0;
end
    V_1 = [v_1a, v_2a, v_3a, v_4a, v_5a, v_6a, v_7a, v_8a, v_9a, v_10a, v_11a, v_12a, v_13a, v_14a, v_15a, v_16a, v_17a, v_18a];  % For ope_state(1)    
try    
    %% Åò4-1-1-3-2-2 Ope_state 2.0 =GRP=
    if isempty(timer_grp) ~= 1 && max(timer_grp) ~= 0
        for i=1:length(timer_grp)
            i1 = (var_time_grp(i) - var_time(1))*(1/dt);
            if var_time_grp(i) == var_time(end)
                i2 = (var_time_grp(i) - var_time(1))*(1/dt);
            else
                i2 = (var_time_grp(i) - var_time(1))*(1/dt) + timer_grp(i)*(1/dt);
            end
            if i1 == 0
                i1 = 1;
            end
            if i2 == 0
                i2 = 1;
            end
            i1 = int32(i1);
            i2 = int32(i2);
            v_1b(i,1)  = i;                                          % Index 
            v_2b(i,1)  = var_time_grp(i);                            % Timestamp
            v_3b(i,1)  = floor((var_time_grp(i)-var_time(1))/60);    %Time [min]
            v_4b(i,1)  = round((var_time_grp(i)-var_time(1)) - (floor((var_time_grp(i)-var_time(1))/60)*60),0);    %Time [sec]
            v_5b(i,1)  = 2;                                          % Ope_state
            v_6b(i,1)  = timer_grp(i);                               % Duration
            v_7b(i,1)  = mean(var_ego_vel_interp(i1:i2));            % Mean speed
            v_8b(i,1)  = max(plotvar_thw_inv(i1:i2));                % Max Inv_THW
            v_9b(i,1)  = max(plotvar_ttc_inv(i1:i2));                % Max Inv_TTC
            v_10b(i,1)  = max(plotvar_risk(i1:i2));                  % Max Risk Feeling
            v_11b(i,1)  = min(plotvar_thw(i1:i2));                   % Min THW
            v_12b(i,1) = min(plotvar_ttc(i1:i2));                    % Min TTC
            v_13b(i,1) = mean(plotvar_accx(i1:i2));                  % Mean Accx
            v_14b(i,1) = max(plotvar_accx(i1:i2));                   % Max Accx
            v_15b(i,1) = min(plotvar_accx(i1:i2));                   % Min Accx
            v_16b(i,1) = std(plotvar_accx(i1:i2));                   % Stdev Accx
            v_17b(i,1) = plotvar_lat(i);                             % Latitude
            v_18b(i,1) = plotvar_long(i);                            % Longitude
        end
    else
        v_1b(1,1)=0;
        v_2b(1,1)=0;
        v_3b(1,1)=0;
        v_4b(1,1)=0;
        v_5b(1,1)=0;
        v_6b(1,1)=0;
        v_7b(1,1)=0;
        v_8b(1,1)=0;
        v_9b(1,1)=0;
        v_10b(1,1)=0;
        v_11b(1,1)=0;
        v_12b(1,1)=0;
        v_13b(1,1)=0;
        v_14b(1,1)=0;
        v_15b(1,1)=0;
        v_16b(1,1)=0;
        v_17b(1,1)=0;
        v_18b(1,1)=0;        
    end
catch
    fprintf('There was an error in f_gobo_log grp at i= %d for file %s', i, as_save_log);
end
if isempty(timer_grp) ~= 1
    v_6b(isnan(v_6b))=0;
    v_7b(isnan(v_7b))=0;
    v_8b(isnan(v_8b))=0;
    v_9b(isnan(v_9b))=0;
    v_10b(isnan(v_10b))=0;
    v_11b(isnan(v_11b))=0;
end
V_2 = [v_1b, v_2b, v_3b, v_4b, v_5b, v_6b, v_7b, v_8b, v_9b, v_10b, v_11b, v_12b, v_13b, v_14b, v_15b, v_16b, v_17b, v_18b];  % For ope_state(2)

try
    %% Åò4-1-1-3-2-3 Ope_state 3.0 =GOF=
    if isempty(timer_gof) ~= 1  && max(timer_gof) ~= 0   
        for i=1:length(timer_gof)
            i1 = (var_time_gof(i) - var_time(1))*(1/dt);
            if var_time_gof(i) == var_time(end)
                i2 = (var_time_gof(i) - var_time(1))*(1/dt);
            else
                i2 = (var_time_gof(i) - var_time(1))*(1/dt) + timer_gof(i)*(1/dt);
            end
            if i1 == 0
                i1 = 1;
            end
            if i2 == 0
                i2 = 1;
            end
            i1 = int32(i1);
            i2 = int32(i2);
            v_1c(i,1)  = i;                                          % Index 
            v_2c(i,1)  = var_time_gof(i);                            % Timestamp
            v_3c(i,1)  = floor((var_time_gof(i)-var_time(1))/60);    %Time [min]
            v_4c(i,1)  = round((var_time_gof(i)-var_time(1)) - (floor((var_time_gof(i)-var_time(1))/60)*60),0);    %Time [sec]
            v_5c(i,1)  = 2;                                          % Ope_state
            v_6c(i,1)  = timer_gof(i);                               % Duration
            v_7c(i,1)  = mean(var_ego_vel_interp(i1:i2));            % Mean speed
            v_8c(i,1)  = max(plotvar_thw_inv(i1:i2));                % Max Inv_THW
            v_9c(i,1)  = max(plotvar_ttc_inv(i1:i2));                % Max Inv_TTC
            v_10c(i,1)  = max(plotvar_risk(i1:i2));                  % Max Risk Feeling
            v_11c(i,1)  = min(plotvar_thw(i1:i2));                   % Min THW
            v_12c(i,1) = min(plotvar_ttc(i1:i2));                    % Min TTC
            v_13c(i,1) = mean(plotvar_accx(i1:i2));                  % Mean Accx
            v_14c(i,1) = max(plotvar_accx(i1:i2));                   % Max Accx
            v_15c(i,1) = min(plotvar_accx(i1:i2));                   % Min Accx
            v_16c(i,1) = std(plotvar_accx(i1:i2));                   % Stdev Accx
            v_17c(i,1) = plotvar_lat(i);                             % Latitude
            v_18c(i,1) = plotvar_long(i);                            % Longitude
        end
    else
        v_1c(1,1)=0;
        v_2c(1,1)=0;
        v_3c(1,1)=0;
        v_4c(1,1)=0;
        v_5c(1,1)=0;
        v_6c(1,1)=0;
        v_7c(1,1)=0;
        v_8c(1,1)=0;
        v_9c(1,1)=0;
        v_10c(1,1)=0;
        v_11c(1,1)=0;
        v_12c(1,1)=0;
        v_13c(1,1)=0;
        v_14c(1,1)=0;
        v_15c(1,1)=0;
        v_16c(1,1)=0;
        v_17c(1,1)=0;
        v_18c(1,1)=0;
    end
catch
    fprintf('There was an error in f_gobo_log gof at i= %d for file %s', i, as_save_log);
end
if isempty(timer_gof) ~= 1  
    v_6c(isnan(v_6c))=0;
    v_7c(isnan(v_7c))=0;
    v_8c(isnan(v_8c))=0;
    v_9c(isnan(v_9c))=0;
    v_10c(isnan(v_10c))=0;
    v_11c(isnan(v_11c))=0;
end
V_3 = [v_1c, v_2c, v_3c, v_4c, v_5c, v_6c, v_7c, v_8c, v_9c, v_10c, v_11c, v_12c, v_13c, v_14c, v_15c, v_16c, v_17c, v_18c];  % For ope_state(3)

try
    %% Åò4-1-1-3-2-4 Ope_state 4.0 =BON=
    if isempty(timer_bon) ~= 1 && max(timer_bon) ~= 0   
        for i=1:length(timer_bon)
            %if i==287
            %    i=i*1;
            %end
            i1 = (var_time_bon(i) - var_time(1))*(1/dt);
            if var_time_bon(i) == var_time(end)
                i2 = (var_time_bon(i) - var_time(1))*(1/dt);
            else
                i2 = (var_time_bon(i) - var_time(1))*(1/dt)+timer_bon(i)*(1/dt);
            end
            if i1 == 0
                i1 = 1;
            end
            if i2 == 0
                i2 = 1;
            end
            i1 = int32(i1);
            i2 = int32(i2);
            v_1d(i,1)  = i;                                          % Index 
            v_2d(i,1)  = var_time_bon(i);                            % Timestamp
            v_3d(i,1)  = floor((var_time_bon(i)-var_time(1))/60);    %Time [min]
            v_4d(i,1)  = round((var_time_bon(i)-var_time(1)) - (floor((var_time_bon(i)-var_time(1))/60)*60),0);    %Time [sec]
            v_5d(i,1)  = 2;                                          % Ope_state
            v_6d(i,1)  = timer_bon(i);                               % Duration
            v_7d(i,1)  = mean(var_ego_vel_interp(i1:i2));            % Mean speed
            v_8d(i,1)  = max(plotvar_thw_inv(i1:i2));                % Max Inv_THW
            v_9d(i,1)  = max(plotvar_ttc_inv(i1:i2));                % Max Inv_TTC
            v_10d(i,1)  = max(plotvar_risk(i1:i2));                  % Max Risk Feeling
            v_11d(i,1)  = min(plotvar_thw(i1:i2));                   % Min THW
            v_12d(i,1) = min(plotvar_ttc(i1:i2));                    % Min TTC
            v_13d(i,1) = mean(plotvar_accx(i1:i2));                  % Mean Accx
            v_14d(i,1) = max(plotvar_accx(i1:i2));                   % Max Accx
            v_15d(i,1) = min(plotvar_accx(i1:i2));                   % Min Accx
            v_16d(i,1) = std(plotvar_accx(i1:i2));                   % Stdev Accx
            v_17d(i,1) = plotvar_lat(i);                             % Latitude
            v_18d(i,1) = plotvar_long(i);                            % Longitude
        end
    else
        v_1d(1,1)=0;
        v_2d(1,1)=0;
        v_3d(1,1)=0;
        v_4d(1,1)=0;
        v_5d(1,1)=0;
        v_6d(1,1)=0;
        v_7d(1,1)=0;
        v_8d(1,1)=0;
        v_9d(1,1)=0;
        v_10d(1,1)=0;
        v_11d(1,1)=0;
        v_12d(1,1)=0;
        v_13d(1,1)=0;
        v_14d(1,1)=0;
        v_15d(1,1)=0;
        v_16d(1,1)=0;
        v_17d(1,1)=0;
        v_18d(1,1)=0;
    end
catch
    fprintf('There was an error in f_gobo_log brp at i= %d for file %s', i, as_save_log);
end
if isempty(timer_bon) ~= 1  
    v_6d(isnan(v_6d))=0;
    v_7d(isnan(v_7d))=0;
    v_8d(isnan(v_8d))=0;
    v_9d(isnan(v_9d))=0;
    v_10d(isnan(v_10d))=0;
    v_11d(isnan(v_11d))=0;
end
V_4 = [v_1d, v_2d, v_3d, v_4d, v_5d, v_6d, v_7d, v_8d, v_9d, v_10d, v_11d, v_12d, v_13d, v_14d, v_15d, v_16d, v_17d, v_18d];  % For ope_state(4)

try
    %% Åò4-1-1-3-2-5 Ope_state 5.0 =BRP=
    if isempty(timer_brp) ~= 1 && max(timer_brp) ~= 0   
        for i=1:length(timer_brp)
            i1 = (var_time_brp(i) - var_time(1))*(1/dt);
            if var_time_brp(i) == var_time(end)
                i2 = (var_time_brp(i) - var_time(1))*(1/dt);
            else
                i2 = (var_time_brp(i) - var_time(1))*(1/dt)+timer_brp(i)*(1/dt);
            end
            if i1 == 0
                i1 = 1;
            end
            if i2 == 0
                i2 = 1;
            end
            i1 = int32(i1);
            i2 = int32(i2);
            v_1e(i,1)  = i;                                          % Index 
            v_2e(i,1)  = var_time_brp(i);                            % Timestamp
            v_3e(i,1)  = floor((var_time_brp(i)-var_time(1))/60);    %Time [min]
            v_4e(i,1)  = round((var_time_brp(i)-var_time(1)) - (floor((var_time_brp(i)-var_time(1))/60)*60),0);    %Time [sec]
            v_5e(i,1)  = 2;                                          % Ope_state
            v_6e(i,1)  = timer_brp(i);                               % Duration
            v_7e(i,1)  = mean(var_ego_vel_interp(i1:i2));            % Mean speed
            v_8e(i,1)  = max(plotvar_thw_inv(i1:i2));                % Max Inv_THW
            v_9e(i,1)  = max(plotvar_ttc_inv(i1:i2));                % Max Inv_TTC
            v_10e(i,1)  = max(plotvar_risk(i1:i2));                  % Max Risk Feeling
            v_11e(i,1)  = min(plotvar_thw(i1:i2));                   % Min THW
            v_12e(i,1) = min(plotvar_ttc(i1:i2));                    % Min TTC
            v_13e(i,1) = mean(plotvar_accx(i1:i2));                  % Mean Accx
            v_14e(i,1) = max(plotvar_accx(i1:i2));                   % Max Accx
            v_15e(i,1) = min(plotvar_accx(i1:i2));                   % Min Accx
            v_16e(i,1) = std(plotvar_accx(i1:i2));                   % Stdev Accx
            v_17e(i,1) = plotvar_lat(i);                             % Latitude
            v_18e(i,1) = plotvar_long(i);                            % Longitude
        end
    else
        v_1e(1,1)=0;
        v_2e(1,1)=0;
        v_3e(1,1)=0;
        v_4e(1,1)=0;
        v_5e(1,1)=0;
        v_6e(1,1)=0;
        v_7e(1,1)=0;
        v_8e(1,1)=0;
        v_9e(1,1)=0;
        v_10e(1,1)=0;
        v_11e(1,1)=0;
        v_12e(1,1)=0;
        v_13e(1,1)=0;
        v_14e(1,1)=0;
        v_15e(1,1)=0;
        v_16e(1,1)=0;
        v_17e(1,1)=0;
        v_18e(1,1)=0;
    end
catch
    fprintf('There was an error in f_gobo_log brp at i= %d for file %s', i, as_save_log);
end
if isempty(timer_brp) ~= 1 
    v_6e(isnan(v_6e))=0;
    v_7e(isnan(v_7e))=0;
    v_8e(isnan(v_8e))=0;
    v_9e(isnan(v_9e))=0;
    v_10e(isnan(v_10e))=0;
    v_11e(isnan(v_11e))=0;
end
V_5 = [v_1e, v_2e, v_3e, v_4e, v_5e, v_6e, v_7e, v_8e, v_9e, v_10e, v_11e, v_12e, v_13e, v_14e, v_15e, v_16e, v_17e, v_18e];  % For ope_state(5)

%% Åò4-1-1-3-3 Compile all vectors to V_ALL matrix to used for gobolog
V_ALL = [V_1; V_2; V_3; V_4; V_5];
as_header_gobo = {'FileID(-)', 'Index(-)', 'Time_tot(sec)', 'Time(min)', 'Time(sec)', 'ope_state(-)', 'Duration(sec)', 'Speed_ave(kph)', '1/THW_Max(1/sec)', '1/TTC_Max(1/sec)', ...
                  'RiskFeel_Max(-)', 'THW_min(s)', 'TTC_min(s)', 'Accelx_ave(G)', 'Accelx_max(G)', 'Accelx_min(G)', 'Accelx_stdev', 'Latitude(-)', 'Longitude(-)'};

end