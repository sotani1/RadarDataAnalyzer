function [Stbl_rf, as_header] = f_am1_write_riskcount(var_time, k_rf, d_timer, d_time, var_rfl, M_data, dt, i_mt_plot)
%% Åò3-1-3  Write the resulsts to CSV under 'dfolder_log' directory

%% Åò3-1-3-1 Initialize variables
Stbl_rf   = [];  % Table working variable
num_var   = 10;  % Number of variables to display in table
i_tk_plot = 1;   % Required for plotting purposes
%% Åò3-1-3-2 Calculate observational variables pertaining to high Risk Levels
    for i=1 : k_rf
        for j = 1 : num_var
            if j == 1
                %Time [sec_total]
                Stbl_rf(i,j) = d_time(i);
                continue;
            end
            if j == 2
                %Time [min]
                Stbl_rf(i,j) = floor((d_time(i)-var_time(1))/60);
                continue;
            end
            if j == 3
                %Time [sec]
                Stbl_rf(i,j) = round((d_time(i)-var_time(1)) - (floor((d_time(i)-var_time(1))/60)*60),0);
                continue;
            end
            if j == 4
                try
                    %Speed [kph]
                    f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'speedx'; f_ilv = 'non_ilv' ;
                    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
                    plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
                    Stbl_rf(i,j) = plotvar_1(int32((d_time(i)-var_time(1))/dt));
                    continue;
                catch
                    Stbl_rf(i,j) = 0;
                    continue;
                end
            end
            if j == 5    
                try
                    %RFL [-]
                    plotvar_1 = var_rfl;
                    Stbl_rf(i,j) = plotvar_1(int32((d_time(i)-var_time(1))/dt));
                    continue;
                catch
                    Stbl_rf(i,j) = 0;
                    continue;
                end
            end
            if j == 6
                try
                    %Duration [sec]
                    Stbl_rf(i,j) = d_timer(i);
                    continue;
                catch
                    Stbl_rf(i,j) = 0;
                    continue;
                end
            end
            if j == 7
                try
                    %Longitudinal Acceleration [G]
                    f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'accelx'; f_ilv = 'non_ilv' ;
                    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
                    plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
                    Stbl_rf(i,j) = plotvar_1(int32((d_time(i)-var_time(1))/dt)); 
                    continue;
                catch
                    Stbl_rf(i,j) = 0;
                    continue;
                end
            end
            if j == 8
                try
                    %Relative Speed [m/s]
                    f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'speedx'; f_ilv = 'ilv' ;
                    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
                    plotvar_1_tmpA = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
                    f_type = 'var'; f_target = 'lead'; f_var = 'speedx'; f_ilv = 'ilv' ;
                    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
                    plotvar_1_tmpB = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
                    plotvar_1 = plotvar_1_tmpB - plotvar_1_tmpA;
                    Stbl_rf(i,j) = plotvar_1(int32((d_time(i)-var_time(1))/dt));
                    continue;
                catch
                    Stbl_rf(i,j) = 0;
                    continue;
                end
            end
            if j == 9
                try
                    %THW [s]
                    f_type = 'var'; f_target = 'lead'; f_var = 'thw'; f_ilv = 'ilv' ;
                    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
                    plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
                    Stbl_rf(i,j) = plotvar_1(int32((d_time(i)-var_time(1))/dt));
                    continue;
                catch
                    Stbl_rf(i,j) = 0;
                    continue;
                end
            end
            if j == 10
                try
                    %TTC [s]
                    f_type = 'var'; f_target = 'lead'; f_var = 'ttc'; f_ilv = 'ilv' ;
                    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
                    plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
                    Stbl_rf(i,j) = plotvar_1(int32((d_time(i)-var_time(1))/dt));
                    continue;
                catch
                    Stbl_rf(i,j) = 0;
                    continue;
                end
            end
        end
    end    

%% Åò3-1-3-3  Return header values of the summary table
as_header = {'Time_sec_tot', 'T_min', 'T_sec', 'Speed_kph', 'RF', 'Duration_sec', 'LongAccel_G', 'RelSpeed_mps', 'THW_sec', 'TTC_sec'};    
if isempty(Stbl_rf) == 1
    Stbl_rf = [0 0 0 0 0 0 0 0 0 0];
end
    
end
