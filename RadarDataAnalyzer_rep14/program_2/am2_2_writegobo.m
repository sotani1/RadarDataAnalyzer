%% Åò4-1-2 Write Gas-On-Brake-Off(GOBO) occurence result to csv   
try
    %% Åò4-1-2-1 Initialize variables
    var_ego_vel_interp                            = ff_check_nanzero(var_ego_vel_interp, var_time);  % Vel = Ego vehicle speed
    var_ego_vel_interp(isnan(var_ego_vel_interp)) = 0;
    var_ego_accelx                                = ff_check_nanzero(var_ego_accelx, var_time);      % Accelx = Longitudinal acceleration
    var_ego_accelx(isnan(var_ego_accelx))         = 0;    
    var_ego_apo                                   = ff_check_nanzero(var_ego_apo, var_time);         % APO = Accelerator Pedal Operation
    var_ego_apo(isnan(var_ego_apo))               = 0;     
    var_ego_bksw                                  = ff_check_nanzero(var_ego_bksw, var_time);        % BKSW = Brake switch operation
    var_ego_bksw(isnan(var_ego_bksw))             = 0;
    var_ego_aps(1,1)                              = 0;
    var_ego_aps                                   = vertcat(var_ego_aps, diff(var_ego_apo));         % APS = First time derivative of APO
    i_mt_plot                                     = 1;
  
    f_type = 'var'; f_target = 'lead'; f_var = 'speedx'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
    var_trackN_vel = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
    % Remove NaNs
    var_trackN_vel = ff_check_nanzero(var_trackN_vel, var_time);
    var_trackN_vel(isnan(var_trackN_vel))=0;
    
    f_type = 'var'; f_target = 'lead'; f_var = 'thw_inv'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
    plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
    f_type = 'var'; f_target = 'lead'; f_var = 'ttc_inv'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
    plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
    plotvar_risk = (1*plotvar_1) + (4*plotvar_2); 
    % Remove NaNs
    plotvar_risk = ff_check_nanzero(plotvar_risk, var_time);
    plotvar_risk(isnan(plotvar_risk))=0;
    
    %% Åò4-1-2-2 Prepare gobo csv file    
    %% Åò4-1-2-2-1 Prepare values and headers 
    % Values
    M_test = [var_time, var_ego_vel_interp, var_ego_accelx, ope_state, var_ego_apo, var_ego_aps, var_ego_bksw, var_trackN_vel, plotvar_risk];
    % Headers
    textHeader  =  {'time(s)', 'vsp(kph)', 'var_accx(G)', 'ope_state(-)', 'apo(%)', 'aps(%/s)', 'bksw(MPa)', 'lead_vsp(kph)', 'RiskFeel(-)'};
    commaHeader = [textHeader;repmat({','},1,numel(textHeader))];  % Insert commaas
    commaHeader = commaHeader(:)';                                 % Reformat commaHeader
    textHeader  = cell2mat(commaHeader);                           % Comma header in text with commas

    plotvar_temp   = var_ego_vel_interp ./ 3.6;                    % Vehicle speed in m/s
    plotvar_temp_o = [];
    plotvar_x_dist = 0;

    %% Åò4-1-2-2-2 Prepare APS values (Custom metric) 
    for i2=1:length(var_time)
        if plotvar_temp(i2) ~= 0 || isnan(plotvar_temp(i2))==0 
            if i2>1
                if (plotvar_temp(i2-1) == 0 || isnan(plotvar_temp(i2-1))==1 && (isnan(plotvar_temp(i2))==0))
                    plotvar_temp_o = plotvar_temp(i2);
                end
                if (isnan(plotvar_temp(i2-1))==0 && isnan(plotvar_temp(i2))==0)
                    plotvar_x_dist  = plotvar_x_dist + (plotvar_temp(i2)*dt);
                    plotvar_temp_o  = plotvar_temp(i2);
                end
            end
            if (i2==1 && isnan(plotvar_temp(i2))==0)
                plotvar_temp_o = plotvar_temp(i2);
            end
        end
    end
    
    I_aps               = sum(abs(var_ego_aps));       % Integrated APS values (take absolute value for negative APS)
    plotvar_x_dist_km   = plotvar_x_dist/1000;         % Convert distance travelled to km
    plotvar_x_dist_mile = plotvar_x_dist_km/1.6;       % Convert distance travelled to miles
    I_aps_mile          = I_aps / plotvar_x_dist_mile; % APS/MILE metric calculation
    
    %% Åò4-1-2-2-3 Check APS values (if above threshold, ignore csv_write command)     
    if I_aps_mile > 6000 || (I_aps_mile == 0 && flg_cctime ~= 2)
        flg_cctime = 1;     % Flag to nullify gobo_write command in the case APS is above 6000
    end
    %% Åò4-1-2-3 Write gobo result to csv         
    if flg_cctime ~= 1 
        as_save_csv    = strcat(as_save,'_APS_', string(round(I_aps_mile)), '_CC_', string(flg_cctime), '_gobo.csv'); 
        cd(Gobofolder);
        fid = fopen(as_save_csv,'w'); 
        fprintf(fid,'%s\n',textHeader);
        fclose(fid);
        dlmwrite(char(as_save_csv), M_test,'-append');
    end
catch
    fprintf('Error at %s', as_save);
end

clear M_test textHeader plotvar_1 plotvar_2 plotvar_risk plotvar_temp plotvar_temp_o I_aps plotvar_x_dist_km plotvar_x_dist_mile I_aps_mile
clear f_ilv f_target f_type f_var h_an i_asn i_asn_ilv i_mt ind_filv ind_ftype ind_fvar fid var_ego_aps 
clear as_save_csv as_save