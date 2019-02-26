%% Generate map data
    %Initialize parameters
    vsp_min     = 0;    
    vsp_max     = 200;    
    vsp_step    = 10;
    dvsp_step   = 0.05;
    iflg_test   = 1;

%% Read file sequence
    
%Start sequence
    %for k=1+2:length(D) 
            if iflg_test == 0
                clear d imdata
                cd(Datafolder);                   % Current directory to folder containing data
                imdata = importdata(D(k).name);   % Read data
                d=imdata.data;                    % Store data fields in "d" matrix
                cd(Prgfolder);                    % Restore directory to program folder
            end
        %Start routine----------------------------------------------------------
            [vsp, dvsp, vsp_valid, dt]              = f_cm1_1_Dataset_shrp2(iflg_test, var_time, var_ego_vel, var_ego_accelx); %Read data fields and construct additional features
        if vsp_valid == 1
            out_mileage_all                         = f_cm2_mileage_all(vsp, dt);  % Calculates total distance travelled
            out_mileage_mt                          = f_cm3_mileage_mt(vsp, dt);   % Calculates distance travelled per microtrip
            out_vspe                                = f_cm4_vsp(vsp);              % Vehicle Speed
            out_stptime                             = f_cm5_stptime(vsp);          % Idle Time
            out_dvsp                                = f_cm6_accvalue(vsp, dvsp);   % Acceleration
            [out_acctime, out_statime, out_dectime] = f_cm7_acctime(dvsp, dt);     % Time spent in ACC mode
            S_Map                                   = f_cm98_calcmap(vsp_min,         vsp_step,        vsp_max,      dvsp_step,   ...
                                                                     out_mileage_all, out_mileage_mt,  out_vspe,     dt,          ...
                                                                     out_stptime,     out_dvsp,        out_acctime,  out_statime, ...
                                                                     out_dectime);% Generate frequency plots
        end
        %End routine------------------------------------------------------
    %end
    


    %cm99_exchgmap

%%
clear vsp_min vsp_max vsp_step dvsp_step iflg_test out_mileage_all out_mileage_mt out_vspe out_stptime out_dvsp out_acctime out_statime out_dectime vsp vsp_valid
