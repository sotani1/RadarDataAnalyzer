%% Åò4-1-1 Calculate Gas-On-Brake-Off(GOBO) sequences 

%% Åò4-1-1-1 Initialize directories to store GOBO results
Gobofolder     = [Opefolder '\dfolder_gobo\'];        % Directory to store reduced time-series csv files including gobo_state 
Gobofolder_log = [Opefolder '\dfolder_gobo_log\'];    % Directory to store gobo summary results LAT/LONG/RISK FEELING
as_save        = D(k).name(1:end-4);                  % The name of the file to save (ansi string type)
as_save_log    = strcat(as_save,'_gobo_log.csv');     % The name of the file to save (ansi string type) for summary log

%% Åò4-1-1-2 Calculate GOBO
[ope_state, k_gon, k_grp, k_gof, k_bon, k_brp, timer_gon, timer_grp, timer_gof, timer_bon, timer_brp, var_time_gon, var_time_grp, var_time_gof, var_time_bon, var_time_brp, i_mt_plot] = f_am2_1_calc_gobo(var_time, var_ego_vel_nan, M_data, dt, i_mt, mt_start, mt_end, num_mt);

%% Åò4-1-1-3 Save GOBO log to V_ALL 
[V_ALL, as_header_gobo] = f_am2_1_write_gobolog(as_save_log, M_data, dt, i_mt_plot, var_time, var_ego_vel_interp, timer_gon, timer_grp, timer_gof, timer_bon, timer_brp, var_time_gon, var_time_grp, var_time_gof, var_time_bon, var_time_brp);

%% Åò4-1-1-4 Write GOBO log
d_save      = V_ALL;
commaHeader = [as_header_gobo;repmat({','},1,numel(as_header_gobo))]; % Insert commaas
commaHeader = commaHeader(:)';
textHeader  = cell2mat(commaHeader);                                  % comma Header in text with commas
as_save2    = repmat({as_save}, [size(d_save,1),1]);
as_mat      = [as_save2, num2cell(V_ALL)];
cd(Gobofolder_log)
try
    as_mat2 = [as_header_gobo; as_mat];
    
    fid = fopen(as_save_log,'w');
    for i=1:size(as_mat2,1)
        if i==1
            fprintf(fid,'%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s\n',as_mat2{i,:});
        else
            fprintf(fid,'%s, %d, %g, %d, %g, %g, %g, %g, %g, %g, %g, %g, %g, %g, %g, %g, %g, %g, %g\n',as_mat2{i,:});
        end
    end
    fclose(fid);
catch
    if fid == -1
        fprintf('ERROR run_makegobo:  CSV file already opened. Please close.'); 
    end
end

%% Move to original folder
cd(Prgfolder2)                         % Prgfolder2

clear d_save as_save_log as_save2 ans jj ans4