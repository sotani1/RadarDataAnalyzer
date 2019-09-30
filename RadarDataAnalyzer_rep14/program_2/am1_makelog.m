%% Åò3-1 run_am1_makelog  Calculate number of times risk exceeds threshold, stores values into Logfolder
% Use this additional module (am) to write log files for high risk values
if flg_50k == 1
    % Run this code if flg_50k is enabled
   %% Åò3-1-1  Initialize risk feeling variables
    RFT       = 1.5; % Set risk feeling threshold here
    alpha_thw = 1;   % Alpha value to calculate risk
    beta_ttc  = 4;   % Beta to calculate risk
   %% Åò3-1-2  Calculate amount of times risk feeling exceeded threshold
    [k_rf, d_timer, d_time, var_rfl] = f_am1_calc_riskcount(var_time, RFT, M_data, i_mt, alpha_thw, beta_ttc, dt);
   %% Åò3-1-3  Write the resulsts to CSV under 'dfolder_log' directory
    [Stbl_rf, as_header] = f_am1_write_riskcount(var_time, k_rf, d_timer, d_time, var_rfl, M_data, dt, i_mt);
    
   %% Åò3-1-4 Move to data folder
    Logfolder  = [Opefolder '\dfolder_log\'];
    cd(Logfolder)                      % Store csv results into Logfolder
    as_save = D(k).name(1:end-4);
    as_save = strcat(as_save,'_A',int2str(alpha_thw), 'B', int2str(beta_ttc), '_log.csv');
    d_save  = Stbl_rf;
    d_save  = array2table(d_save);
    d_save.Properties.VariableNames = as_header;
    writetable(d_save, as_save);       % Save result
end

%% Move to original folder
cd(Prgfolder2)                         % Prgfolder2

clear RFT alpha_thw beta_ttc k_rf flg_rf d_timer d_time d_rf var_rf as_header d_save as_save as_header