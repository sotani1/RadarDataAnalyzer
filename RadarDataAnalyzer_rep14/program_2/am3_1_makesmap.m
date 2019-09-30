%% Åò4-1-3-2 Run additional module to generate SMap
%% Åò4-1-3-2-1 Initialize parameters
    vsp_min     = 0;    % Vehicle speed min value
    vsp_max     = 200;  % Vehicle speed max value 
    vsp_step    = 10;   % Vehicle speed bin size
    max_dvsp    = 5;    % Max acceleration value (m/s^2)  
    min_dvsp    = -5;   % Min acceleration value (m/s^2)
    dvsp_step   = 0.05; % Acceleration bin size  (m/s^2)
    
    %M_smap_all        = zeros(((max_dvsp -min_dvsp)/dvsp_step+1),((vsp_max-vsp_min)/vsp_step+1));
    
%% Read file sequence
    %% Åò4-1-3-2-2 Return vsp, dvsp, dt values
    [vsp, dvsp, vsp_valid, dt]                  = f_am3_1_calc_dvsp(var_time, var_ego_vel, var_ego_accelx); % Read data fields and construct additional features
    if vsp_valid == 1
        out_mileage_all                         = f_am3_1_calc_mileage_all(vsp, dt); % Åò4-1-3-2-3 Calculates total distance travelled
        out_mileage_mt                          = f_am3_1_calc_mileage_mt(vsp, dt);  % Åò4-1-3-2-4 Calculates distance travelled per microtrip
        out_vspe                                = f_am3_1_calc_vspe(vsp);            % Åò4-1-3-2-5 Calculates Vehicle Speed Equivalent
        out_stptime                             = f_am3_1_calc_stptime(vsp);         % Åò4-1-3-2-6 Calculates total Idle Time
        out_dvsp                                = f_am3_1_calc_accvalue(vsp_min, vsp_max, vsp_step, vsp, dvsp);  % Åò4-1-3-2-7 Constructs Acceleration Map
        [out_acctime, out_statime, out_dectime] = f_am3_1_calc_acctime(dvsp, dt);    % Åò4-1-3-2-8 Calculates time spent in acceleration mode
        S_Map                                   = f_am3_1_calc_smap(vsp_min,         vsp_step,        vsp_max,      dvsp_step,   ...
                                                                    out_mileage_all, out_mileage_mt,  out_vspe,     dt,          ...
                                                                    out_stptime,     out_dvsp,        out_acctime,  out_statime, ...
                                                                    out_dectime);    % Åò4-1-3-2-9 Generate frequency plots
    end

clear vsp_min vsp_max vsp_step dvsp_step iflg_test out_mileage_all out_mileage_mt out_vspe out_stptime out_dvsp out_acctime out_statime out_dectime vsp vsp_valid
