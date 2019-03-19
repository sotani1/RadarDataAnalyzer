Gobofolder     = [Opefolder '\dfolder_gobo\'];
Gobofolder_log = [Opefolder '\dfolder_gobo_log\'];
as_save = D(k).name(1:end-4);
as_save_csv = strcat(as_save,'_gobo.csv');
as_save_log = strcat(as_save,'_gobo_log.csv');

%% Calculate GOBO
cd(Opefolder);
[ope_state, k_gof, timer_gof, k_bon, timer_bon, var_time_gof,var_time_bon] = f_gobo(var_time, var_ego_vel_interp, M_data, dt, i_mt);

%% Move to data folder
cd(Gobofolder)   % Store Gobo files here
test_ed;         % Save extracted result as CSV file here

%% Write GOBO log
cd(Gobofolder_log)
[V_ALL, as_header_gobo] = f_gobo_log(M_data, dt, i_mt_plot, var_time, var_ego_vel_interp, ope_state, k_gof, timer_gof, k_bon, timer_bon, var_time_gof, var_time_bon);

d_save  = [V_ALL];
d_save = array2table(d_save);
%d_save.Properties.VariableNames = string(as_header_gobo);
commaHeader = [as_header_gobo;repmat({','},1,numel(as_header_gobo))]; %insert commaas
commaHeader = commaHeader(:)';
textHeader  = cell2mat(commaHeader); %cHeader in text with commas

fid = fopen(as_save_log,'w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);
dlmwrite(as_save_log, V_ALL,'-append');
   
%% Move to original folder
cd(Opefolder)        % OpeFolder

clear as_header d_save as_save_csv as_save_log as_save