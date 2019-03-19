i_mt_plot = 1;

f_type = 'var'; f_target = 'lead'; f_var = 'speedx'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
var_trackN_vel = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
%Remove NaNs
nanx = isnan(var_trackN_vel);
t    = 1:numel(var_trackN_vel);
var_trackN_vel(nanx) = interp1(t(~nanx), var_trackN_vel(~nanx), t(nanx));

f_type = 'var'; f_target = 'lead'; f_var = 'thw_inv'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
f_type = 'var'; f_target = 'lead'; f_var = 'ttc_inv'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_risk = (1*plotvar_1) + (4*plotvar_2); 
%Remove NaNs
nanx = isnan(plotvar_risk);
t    = 1:numel(plotvar_risk);
plotvar_risk(nanx) = interp1(t(~nanx), plotvar_risk(~nanx), t(nanx));

M_test = [var_time, var_ego_vel_interp, var_ego_accelx, ope_state, var_ego_apo, var_ego_bksw, var_trackN_vel, plotvar_risk];
textHeader  =  {'time(s)', 'vsp(kph)', 'var_accx(G)', 'ope_state(-)', 'apo(%)', 'bksw(%)', 'lead_vsp(kph)', 'RiskFeel(-)'};
commaHeader = [textHeader;repmat({','},1,numel(textHeader))]; %insert commaas
commaHeader = commaHeader(:)';
textHeader  = cell2mat(commaHeader); %cHeader in text with commas

fid = fopen(as_save_csv,'w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);
dlmwrite(as_save_csv, M_test,'-append');

clear M_test textHeader plotvar_1 plotvar_2 plotvar_risk
clear f_ilv f_target f_type f_var h_an i_asn i_asn_ilv i_mt ind_filv ind_ftype ind_fvar fid;