cd(Prgfolder);
close all;

%Declaring your plotting variables here
plotvar_1 = [];      % x val
plotvar_2 = [];      % y val
plotvar_3 = [];      % z val
plotvar_4 = [];      % time val
i_tk_plot = [];      % track number to plot
i_mt_plot = [];      % microtrip number to plot
plotvar_bk_dist = 0; % brake distance variable
figure('units','normalized','outerposition',[0 0 1 1])

% Plot for first microtrip
i_mt_plot = 1;
% Plot for first radar target
i_tk_plot = 1;
time_lwr = M_var_time{i_mt_plot}(1);
time_upr = M_var_time{i_mt_plot}(end);
%time_lwr = 185;
%time_upr = 200;

%Check to see if lead car is stopped
f_type = 'var'; f_target = 'lead'; f_var = 'speedx'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
try
    plotvar_lead    = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
    plotvar_lead_1b = plotvar_lead(int32((time_lwr-M_var_time{i_mt_plot}(1))*10+1):int32((time_upr-M_var_time{i_mt_plot}(1))*10+1));
    if nanmean(plotvar_lead_1b) < 2.5
        Flg_leadstp = 1;
    else
        Flg_leadstp = 0;
    end
catch
end

%f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'speedx'; f_ilv = 'ilv' ;
%[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
%plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
%f_type = 'var'; f_target = 'lead'; f_var = 'posx'; f_ilv = 'ilv' ;
%[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
%plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
%plotvar_3 = M_var_time{i_mt_plot};
%plotvar_4 = M_var_time{i_mt_plot};
%subplot1 = subplot(2,3,1);
%f3Dscatter(plotvar_1, plotvar_2, ...
%           plotvar_3, 5, plotvar_4, subplot1, ...
%           time_lwr, time_upr,'scatter');
%%xlim([0 50]);
%%ylim([0 60]);
%title(strcat('M',num2str(i_mt_plot),'_Track',num2str(i_tk_plot),'_posx vs VehicleSpeed'), 'interpreter', 'none');

%% Plotting risk level 2018.3.30
%1-1
try
    f_type = 'var'; f_target = 'lead'; f_var = 'thw_inv'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
    f_type = 'var'; f_target = 'lead'; f_var = 'ttc_inv'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
    plotvar_3 = M_var_time{i_mt_plot};
    plotvar_4 = M_var_time{i_mt_plot};
    f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'accelx'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    plotvar_5 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
    plotvar_risk = (1*plotvar_1) + (4*plotvar_2); 
catch
end

%subplot1 = subplot(2,3,1);
%f3Dscatter(plotvar_risk, plotvar_5, ...
%           plotvar_3, 5, plotvar_4, subplot1, ...
%           time_lwr, time_upr,'scatter');
%%xlim([0 1]);
%ylim([0 0.7]);
%title(strcat('M',num2str(i_mt_plot), '_Track', num2str(i_tk_plot),'Risk Level vs accel_x'), 'interpreter', 'none');

%% Plotting relative position and speed for Volpe Meeting 2018.3.30
f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'speedx'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1_tmpA = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
f_type = 'var'; f_target = 'lead'; f_var = 'speedx'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1_tmpB = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_1 = plotvar_1_tmpB - plotvar_1_tmpA;
f_type = 'var'; f_target = 'lead'; f_var = 'posx'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_3 = M_var_time{i_mt_plot};
plotvar_4 = M_var_time{i_mt_plot};
subplot2 = subplot(2,3,1);
try
    f3Dscatter(plotvar_1, plotvar_2, ...
               plotvar_3, 5, plotvar_4, subplot2, ...
               time_lwr, time_upr,'scatter');
    %xlim([0 150]);
    %xlim([0 50]);
    %ylim([-0.5 0.1]);
    title(strcat('M',num2str(i_mt_plot),'Relative Position vs Relative Speed'), 'interpreter', 'none');
catch
end
clear plotvar_1_tmpA plotvar_1_tmpB

%%
%1-2
f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'speedx'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'accelx'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
%plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data*9.8062;
plotvar_3 = M_var_time{i_mt_plot};
plotvar_4 = M_var_time{i_mt_plot};
subplot2 = subplot(2,3,2);
try
    f3Dscatter(plotvar_1, plotvar_2, ...
               plotvar_3, 5, plotvar_4, subplot2, ...
               time_lwr, time_upr,'scatter');
    %xlim([0 150]);
    xlim([0 120]);
    %ylim([-0.5 0.1]);
    ylim([-5 5]);
    title(strcat('M',num2str(i_mt_plot),'_Ego_accelx (m/s^2) vs VehicleSpeed'), 'interpreter', 'none');
    set(gca,'color','none');
catch
end

%1-3
plotvar_1 = M_var_time{i_mt_plot};
f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'jerkx'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_3 = M_var_time{i_mt_plot};
plotvar_4 = M_var_time{i_mt_plot};
subplot3 = subplot(2,3,3);
try
    f3Dscatter(plotvar_1, plotvar_2, ...
               plotvar_3, 5, plotvar_4, subplot3, ...
               time_lwr, time_upr,'plot3');
    title(strcat('M',num2str(i_mt_plot),'_Ego_jerkx vs time'), 'interpreter', 'none');
catch
end

%1-4
f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'speedx'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
f_type = 'var'; f_target = 'lead'; f_var = 'thw'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_3 = M_var_time{i_mt_plot};
plotvar_4 = M_var_time{i_mt_plot};
subplot4 = subplot(2,3,4);
try
    f3Dscatter(plotvar_1, plotvar_2, ...
               plotvar_3, 5, plotvar_4, subplot4, ...
               time_lwr, time_upr,'scatter');
    %xlim([0 150]);
    %xlim([0 50]);
    %ylim([0 8]);
    title(strcat('M',num2str(i_mt_plot),'_Track',num2str(i_tk_plot),'_HEADWAY vs VehicleSpeed'), 'interpreter', 'none');
catch
end

%1-5
f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'speedx'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
f_type = 'var'; f_target = 'lead'; f_var = 'ttc'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_3 = M_var_time{i_mt_plot};
plotvar_4 = M_var_time{i_mt_plot};
subplot5 = subplot(2,3,5);
try
    f3Dscatter(plotvar_1, plotvar_2, ...
              plotvar_3, 5,plotvar_4 , subplot5, ...
               time_lwr, time_upr,'scatter');
    %xlim([0 150]);
    %xlim([0 50]);
    %ylim([-50 50]);
    ylim([-15 15]);
    title(strcat('M',num2str(i_mt_plot),'_Track',num2str(i_tk_plot),'_TTC vs VehicleSpeed'), 'interpreter', 'none');
catch
end

%1-6
f_type = 'var'; f_target = 'lead'; f_var = 'thw_inv'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
f_type = 'var'; f_target = 'lead'; f_var = 'ttc_inv'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_3 = M_var_time{i_mt_plot};
plotvar_4 = M_var_time{i_mt_plot};
subplot6 = subplot(2,3,6);
try
    f3Dscatter(plotvar_1, plotvar_2, ...
               plotvar_3, 5, plotvar_4, subplot6, ...
               time_lwr, time_upr,'scatter');
    xlim([0 1]);
    ylim([0 0.7]);
    title(strcat('M',num2str(i_mt_plot), '_Track', num2str(i_tk_plot),'_TTC_INV vs THW_INV'), 'interpreter', 'none');
    hold on
    f_RF_constcalc(subplot6,time_upr);
    hold off
catch
end
%%f_type = 'var'; f_target = 'lead'; f_var = 'ttc_delta_inv'; f_ilv = 'ilv' ;
%%[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
%%plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
%%f_type = 'var'; f_target = 'lead'; f_var = 'ttc_inv'; f_ilv = 'ilv' ;
%%[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
%%plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
%%plotvar_3 = M_var_time{i_mt_plot};
%%plotvar_4 = M_var_time{i_mt_plot};
%%subplot6 = subplot(2,4,7);
%%f3Dscatter(plotvar_1, plotvar_2, ...
%%           plotvar_3, 5, plotvar_4, subplot6, ...
%%           time_lwr, time_upr,'scatter');
%xlim([0 1]);
%ylim([0 0.7]);
%%title(strcat('M',num2str(i_mt_plot), '_Track', num2str(i_tk_plot),'_TTC_INV vs TTC_DELTA_INV'), 'interpreter', 'none');

%%f_type = 'var'; f_target = 'lead'; f_var = 'ttc_delta'; f_ilv = 'ilv' ;
%%[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
%%plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
%%f_type = 'var'; f_target = 'lead'; f_var = 'ttc_inv'; f_ilv = 'ilv' ;
%%[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
%%plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
%%plotvar_3 = M_var_time{i_mt_plot};
%%plotvar_4 = M_var_time{i_mt_plot};
%%subplot6 = subplot(2,4,8);
%%f3Dscatter(plotvar_1, plotvar_2, ...
%%           plotvar_3, 5, plotvar_4, subplot6, ...
%%           time_lwr, time_upr,'scatter');
%%%xlim([0 1]);
%%%ylim([0 0.7]);
%%title(strcat('M',num2str(i_mt_plot), '_Track', num2str(i_tk_plot),'_TTC_INV vs TTC_DELTA'), 'interpreter', 'none');

%Save scatter plot values
try
    f_makescatter(D, dt, time_lwr, time_upr, k, i_mt_plot, i_tk_plot, Flg_leadstp, Prgfolder, Scatfolder);
catch
end
%%
%2-1
plotvar_1b = [];
plotvar_2b = [];
figure('units','normalized','outerposition',[0 0 1 1]);
subplot(6,2,1);
f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'speedx'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1b = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plot(M_var_time{i_mt_plot}, plotvar_1b);
hold on;
try
    f_type = 'var'; f_target = 'lead'; f_var = 'speedx'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    plotvar_1b = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
    plot(M_var_time{i_mt_plot},plotvar_1b)
    xlim([time_lwr time_upr]);
catch
end
hold off;
ylabel('vspeed', 'interpreter', 'none');
xlim([time_lwr time_upr]);
legend('Ego Car', 'Lead Car');
xlim_tmp = get(gca,'ylim');
set(gca, 'ylim', [0 xlim_tmp(2)]);
xlim_tmp = get(gca,'ylim');
%ylim([0 150]);
pos = get(gcf,'Position');
h = subplot(6,2,2);
f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'speedx'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1b = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_1b_hist = plotvar_1b(int32((time_lwr-M_var_time{i_mt_plot}(1)+dt)*sz):int32((time_upr-M_var_time{i_mt_plot}(1)+dt)*sz));
h1 = histfit(plotvar_1b_hist,16);
xlim(xlim_tmp);
view(90,-90);
pos = get(h,'Position');
h_an = annotation('textbox','String',{char(strcat({'Mean:   '},  {num2str(round(nanmean(plotvar_1b_hist),2))})), ...
                                      char(strcat({'Stdev:  '},  {num2str(round(nanstd(plotvar_1b_hist),2))})),  ...
                                      char(strcat({'Min:    '},  {num2str(round(nanmin(plotvar_1b_hist),2))})),  ...
                                      char(strcat({'Max:    '},  {num2str(round(nanmax(plotvar_1b_hist),2))}))   ...
                                       });
var_plot(1,1) = round(nanmax(plotvar_1b_hist),2);
set(h_an, 'Position', [pos(1)+0.03 pos(2)-0.02 pos(3)/4 pos(4)+0.02]);
set(h, 'Position', [pos(1)-0.07 pos(2) pos(3)/4 pos(4)]);

%2-2
h = subplot(6,2,3);
plotvar_1b = var_ego_dist_brake;
plot(M_var_time{i_mt_plot},plotvar_1b(int32((M_var_time{i_mt_plot}(1)+dt)*sz):int32((M_var_time{i_mt_plot}(end)+dt)*sz)));
ylabel('distance_x', 'interpreter', 'none');
xlim([time_lwr time_upr]);
xlim_tmp = get(gca,'ylim');

pos = get(h,'Position');
plotvar_temp    =  plotvar_1b(int32((time_lwr+dt)*sz):int32((time_upr+dt)*sz));  %Determine braking distance
plotvar_temp_o  =  plotvar_1b(int32((time_lwr+dt)*sz));

%Calculate braking distance
for i2=1:int32((time_upr+dt)*sz)-int32((time_lwr+dt)*sz)
    if plotvar_temp(i2) ~= 0 || isnan(plotvar_temp(i2))==0 
        if i2>1
            if (plotvar_temp(i2-1) == 0 || isnan(plotvar_temp(i2-1))==1 && (isnan(plotvar_temp(i2))==0))
                plotvar_temp_o = plotvar_temp(i2);
            end
            if (isnan(plotvar_temp(i2-1))==0 && isnan(plotvar_temp(i2))==0)
                plotvar_bk_dist = plotvar_bk_dist + (plotvar_temp(i2)-plotvar_temp_o);
                plotvar_temp_o  = plotvar_temp(i2);
            end
        end
        if (i2==int32((time_lwr+dt)*sz)) && (isnan(plotvar_temp(i2))==0)
            plotvar_temp_o = plotvar_temp(i2);
        end
    end
end    
h_an = annotation('textbox','String',{char(strcat({'Bk Distance:  '},     {num2str(round(plotvar_bk_dist,2))})), ...
                                      char(strcat({'DistMin:   '   },     {num2str(round(nanmin(plotvar_temp(plotvar_temp>0)),2))})),                                           ...
                                      char(strcat({'DistMax:   '   },     {num2str(round(nanmax(plotvar_temp),2))})),                                                           ...
                                      char(strcat({'TimeTotal: '   },     {num2str(int32(time_upr-time_lwr))})),                                                                ...
                                      char(strcat({'TimeMin:   '   },     {num2str(int32(time_lwr))})),                                                                         ...
                                      char(strcat({'TimeMax:   '   },     {num2str(int32(time_upr))})),                                                                         ...
                                      char(strcat({'Vid Start: '   },     {num2str(floor(time_lwr/60))} , {' m '} , num2str(round((time_lwr)-(floor(time_lwr/60)*60),0)), {' sec'})),    ...
                                      char(strcat({'Vid End:   '   },     {num2str(floor(time_upr/60))} , {' m '} , num2str(round((time_upr)-(floor(time_upr/60)*60),0)), {' sec'}))     ...
                                      });
if nanmax(plotvar_temp) == nanmin(plotvar_temp)
    var_plot(2,1) = 0;
else
    var_plot(2,1) = round(nanmax(plotvar_temp)-nanmin(plotvar_temp(plotvar_temp>0)),2);
end
var_plot(3,1) = int32(time_upr-time_lwr);
set(h_an, 'Position', [pos(1)+0.37 pos(2)-0.02 pos(3)/4 pos(4)+0.02]);
clear plotvar_temp;

%2-3
subplot(6,2,5)
f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'accelx'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1b = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plot(M_var_time{i_mt_plot},plotvar_1b)
ylabel('accel_x', 'interpreter', 'none');
xlim([time_lwr time_upr]);
xlim_tmp = get(gca,'ylim');

%histfit for ego_accel_x
h = subplot(6,2,6);
try
    plotvar_1b_hist = plotvar_1b(int32((time_lwr-M_var_time{i_mt_plot}(1)+dt)*sz):int32((time_upr-M_var_time{i_mt_plot}(1)+dt)*sz));
    h1 = histfit(plotvar_1b_hist,16);
    xlim(xlim_tmp);
    view(90,-90);
    pos = get(h,'Position');
    h_an = annotation('textbox','String',{char(strcat({'Mean:   '},  {num2str(round(nanmean(plotvar_1b_hist),2))})), ...
                                          char(strcat({'Stdev:  '},  {num2str(round(nanstd(plotvar_1b_hist),2))})),  ...
                                          char(strcat({'Min:    '},  {num2str(round(nanmin(plotvar_1b_hist),2))})),  ...
                                          char(strcat({'Max:    '},  {num2str(round(nanmax(plotvar_1b_hist),2))}))   ...
                                           }); 
    var_plot(4,1) = round(nanmin(plotvar_1b_hist),2);
    var_plot(5,1) = round(nanmean(plotvar_1b_hist),2);
    var_plot(6,1) = round(nanstd(plotvar_1b_hist),2);
    set(h_an, 'Position', [pos(1)+0.03 pos(2)-0.02 pos(3)/4 pos(4)+0.02]);
    set(h, 'Position', [pos(1)-0.07 pos(2) pos(3)/4 pos(4)]);
catch
end

%2-4
subplot(6,2,7)
try
    f_type = 'var'; f_target = 'lead'; f_var = 'thw'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    plotvar_1b = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
    plot(M_var_time{i_mt_plot},plotvar_1b);
    ylabel('THW', 'interpreter', 'none');
    xlim([time_lwr time_upr]);
    ylim([0 2]);
    xlim_tmp = get(gca,'ylim');
catch
end

%histfit for THW
try
    h = subplot(6,2,8);
    plotvar_1b_hist = plotvar_1b(int32((time_lwr-M_var_time{i_mt_plot}(1)+dt)*sz):int32((time_upr-M_var_time{i_mt_plot}(1)+dt)*sz));
catch
end

try
    h1      = histfit(plotvar_1b_hist(~isinf(plotvar_1b_hist)),max([16*int32((round(nanmax(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))/16) 16]));
    xlim(xlim_tmp);
    view(90,-90);
    pos = get(h,'Position');
    h_an = annotation('textbox','String',{char(strcat({'Mean:   '},  {num2str(round(nanmean(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))})), ...
                                          char(strcat({'Stdev:  '},  {num2str(round(nanstd(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))})),  ...
                                          char(strcat({'Min:    '},  {num2str(round(nanmin(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))})),  ...
                                          char(strcat({'Max:    '},  {num2str(round(nanmax(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))}))   ...
                                           });
    var_plot(7,1) = round(nanmin(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2);
    var_plot(8,1) = round(nanmean(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2);
    var_plot(9,1) = round(nanstd(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2);
    set(h_an, 'Position', [pos(1)+0.03 pos(2)-0.02 pos(3)/4 pos(4)+0.02]);
    set(h, 'Position', [pos(1)-0.07 pos(2) pos(3)/4 pos(4)]);    
catch ME
    h_an_ME = annotation('textbox','String', 'Too few datapoints for histogram');
    pos = get(h,'Position');
    h_an = annotation('textbox','String',{char(strcat({'Mean:   '},  {num2str(round(nanmean(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))})), ...
                                          char(strcat({'Stdev:  '},  {num2str(round(nanstd(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))})),  ...
                                          char(strcat({'Min:    '},  {num2str(round(nanmin(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))})),  ...
                                          char(strcat({'Max:    '},  {num2str(round(nanmax(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))}))   ...
                                           });
    var_plot(7,1) = round(nanmin(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2);
    var_plot(8,1) = round(nanmean(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2);
    var_plot(9,1) = round(nanstd(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2);
    set(h_an, 'Position', [pos(1)+0.03 pos(2)-0.02 pos(3)/4 pos(4)+0.02]);
    set(h_an_ME, 'Position', [pos(1)-0.07 pos(2) pos(3)/4 pos(4)]);
end

%2-5
subplot(6,2,9)
try
    f_type = 'var'; f_target = 'lead'; f_var = 'ttc'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    plotvar_1b = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
    plot(M_var_time{i_mt_plot},plotvar_1b);
    ylabel('TTC', 'interpreter', 'none');
    xlim([time_lwr time_upr]);
    ylim([0 15]);
catch
end

h = subplot(6,2,10);
%histfit for TTC
try
    f_type = 'var'; f_target = 'lead'; f_var = 'ttc'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    plotvar_1b      = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
    plotvar_1b_hist = plotvar_1b(int32((time_lwr-M_var_time{i_mt_plot}(1)+dt)*sz):int32((time_upr-M_var_time{i_mt_plot}(1)+dt)*sz));
catch
end

try
    h1      = histfit(plotvar_1b_hist(~isinf(plotvar_1b_hist)),max([16*int32((round(nanmax(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))/16) 16]));
    xlim([0 15]);
    view(90,-90);
    pos = get(h,'Position');
    set(h, 'Position', [pos(1)-0.07 pos(2) pos(3)/4 pos(4)]);
    plotvar_1b_hist_tmp = plotvar_1b_hist(~isinf(plotvar_1b_hist));
    plotvar_1b_hist_tmp(plotvar_1b_hist_tmp <= 0) = nan;
    b = nanmin(plotvar_1b_hist_tmp);
    h_an = annotation('textbox','String',{char(strcat({'Mean:    '},  {num2str(round(nanmean(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))})), ...
                                          char(strcat({'Stdev:   '},  {num2str(round(nanstd(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))})),  ...
                                          char(strcat({'Min >0:  '},  {num2str(round(b,2))})),                        ...
                                          char(strcat({'Max:     '},  {num2str(round(nanmax(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))}))   ...
                                           });
    var_plot(10,1) = round(b,2);
    var_plot(11,1) = round(nanmean(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2);
    var_plot(12,1) = round(nanstd(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2);
    set(h_an, 'Position', [pos(1)+0.03 pos(2)-0.02 pos(3)/4 pos(4)+0.02]);
catch ME
    h_an_ME = annotation('textbox','String', 'Too few datapoints for histogram');
    pos = get(h,'Position');
    h_an = annotation('textbox','String',{char(strcat({'Mean:   '},  {num2str(round(nanmean(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))})), ...
                                          char(strcat({'Stdev:  '},  {num2str(round(nanstd(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))})),  ...
                                          char(strcat({'Min:    '},  {num2str(round(nanmin(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))})),  ...
                                          char(strcat({'Max:    '},  {num2str(round(nanmax(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))}))   ...
                                           });
    var_plot(10,1) = round(nanmin(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2);
    var_plot(11,1) = round(nanmean(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2);
    var_plot(12,1) = round(nanstd(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2);
    set(h_an, 'Position', [pos(1)+0.03 pos(2)-0.02 pos(3)/4 pos(4)+0.02]);
    set(h_an_ME, 'Position', [pos(1)-0.07 pos(2) pos(3)/4 pos(4)]);
    set(h, 'Position', [pos(1)-0.07 pos(2) pos(3)/4 pos(4)]);
end

%histfit for Risk Feeling

set(h, 'Position', [pos(1)-0.07 pos(2) pos(3)/4 pos(4)]);
%2-6
subplot(6,2,11)
%f_type = 'var'; f_target = 'lead'; f_var = 'ttc'; f_ilv = 'ilv' ;
%[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
%plotvar_1b = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
try
    plot(M_var_time{i_mt_plot},plotvar_risk);
    ylabel('Risk Feeling', 'interpreter', 'none');
    xlim([time_lwr time_upr]);
    ylim([0 5]);
catch
end

h = subplot(6,2,12);
try
    plotvar_1b_hist = plotvar_risk(int32((time_lwr-M_var_time{i_mt_plot}(1)+dt)*sz):int32((time_upr-M_var_time{i_mt_plot}(1)+dt)*sz));
    h1      = histfit(plotvar_1b_hist(~isinf(plotvar_1b_hist)),max([16*int32((round(nanmax(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))/16) 16]));
    xlim(xlim_tmp);
    view(90,-90);
    pos = get(h,'Position');
    set(h, 'Position', [pos(1)-0.07 pos(2) pos(3)/4 pos(4)]);
    h_an = annotation('textbox','String',{char(strcat({'Mean:   '},  {num2str(round(nanmean(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))})), ...
                                          char(strcat({'Stdev:  '},  {num2str(round(nanstd(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))})),  ...
                                          char(strcat({'Min:    '},  {num2str(round(nanmin(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))})),  ...
                                          char(strcat({'Max:    '},  {num2str(round(nanmax(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))}))   ...
                                           });
    var_plot(7,1) = round(nanmin(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2);
    var_plot(8,1) = round(nanmean(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2);
    var_plot(9,1) = round(nanstd(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2);
    set(h_an, 'Position', [pos(1)+0.03 pos(2)-0.02 pos(3)/4 pos(4)+0.02]);
catch ME
    h_an_ME = annotation('textbox','String', 'Too few datapoints for histogram');
    pos = get(h,'Position');
    set(h, 'Position', [pos(1)-0.07 pos(2) pos(3)/4 pos(4)]);
    h_an = annotation('textbox','String',{char(strcat({'Mean:   '},  {num2str(round(nanmean(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))})), ...
                                          char(strcat({'Stdev:  '},  {num2str(round(nanstd(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))})),  ...
                                          char(strcat({'Min:    '},  {num2str(round(nanmin(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))})),  ...
                                          char(strcat({'Max:    '},  {num2str(round(nanmax(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2))}))   ...
                                           });
    var_plot(7,1) = round(nanmin(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2);
    var_plot(8,1) = round(nanmean(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2);
    var_plot(9,1) = round(nanstd(plotvar_1b_hist(~isinf(plotvar_1b_hist))),2);
    set(h_an, 'Position', [pos(1)+0.03 pos(2)-0.02 pos(3)/4 pos(4)+0.02]);
    set(h_an_ME, 'Position', [pos(1)-0.07 pos(2) pos(3)/4 pos(4)]);
end

var_plot(13,1) = int32(time_lwr);
var_plot(14,1) = int32(time_upr);

as_plot{1,1}  = char('Max Speed');
as_plot{2,1}  = char('Braking distance');
as_plot{3,1}  = char('Time to Braking');
as_plot{4,1}  = char('G_Min');
as_plot{5,1}  = char('G_mean');
as_plot{6,1}  = char('G_std');
as_plot{7,1}  = char('THW_min');
as_plot{8,1}  = char('THW_mean');
as_plot{9,1}  = char('THW_std');
as_plot{10,1} = char('TTC_min');
as_plot{11,1} = char('TTC_mean');
as_plot{12,1} = char('TTC_std');
as_plot{13,1} = char('Start');
as_plot{14,1} = char('End');

C = [as_plot num2cell(var_plot)];
text(100,-10,strcat('M',num2str(i_mt_plot)));

clear t h h1 b plotvar_1b_hist_tmp xlim_tmp pos k1 f1 i2;
clear f_ilv f_target f_type f_var h_an i_asn i_asn_ilv i_mt ind_filv ind_ftype ind_fvar;
clear plotvar_1 plotvar_1b plotvar_1b_hist plotvar_2 plotvar_2b plotvar_3 plotvar_4 plotvar_5;
clear mt_end mt_start as_plot var_plot;
clear plotvar_lead plotvar_lead_1b;

cd(Opefolder);