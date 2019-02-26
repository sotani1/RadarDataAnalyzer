function [m_total ,teisya_owari ,teisya_kaisi] = f_writelog(M_data, Logfolder, Prgfolder, var_time, i_mt_plot, time_upr, time_lwr, dt, sz, M_var_time)

%% ˜1.1.1 Establish trigger variables

% Pull data from M_data struct
alpha    = 1;
beta     = 4;

% Set up timestamp variables
time_lwr = M_var_time{i_mt_plot}(1);
time_upr = M_var_time{i_mt_plot}(end);

% 1/THW
f_type = 'var'; f_target = 'lead'; f_var = 'thw_inv'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
% 1/TTC
f_type = 'var'; f_target = 'lead'; f_var = 'ttc_inv'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
% Risk Feeling (RF)
plotvar_rf = (alpha * plotvar_1) + (beta * plotvar_2); 
% RF first derivative
plotvar_rf_dx(1,1) = NaN;                                               % dummy declaration
plotvar_rf_dx      = 2*vertcat(plotvar_rf_dx,diff(plotvar_rf));         % first time derivative of risk feeling

plot(var_time, plotvar_rf_dx);

%% ˜1.2.1 Establish matrix to store trigger information
M_trigger = [];

%% ˜1.3.1 Detect triggers
% Variable storage increment
i_rf_dx = 1;

% Search time stamp counter

for i2=1:int32((time_upr+dt)*sz)-int32((time_lwr+dt)*sz)
    % Function to store variables of interest
    if plotvar_rf_dx(i2) > 1
        test__min = num2str(floor((i2*(dt))/60));
        test__sec = num2str(round((i2*(dt))-(floor((i2*(dt))/60)*60),0));
        char_store(i_rf_dx) = char(strcat({'Vid Start: '   },     {num2str(test__min)} , {' m '} , num2str(round((time_lwr)-(floor(time_lwr/60)*60),0)), {' sec'}));
    end
end 



cd(Logfolder);

%save(as_savename,'scat');
cd(Prgfolder);

end