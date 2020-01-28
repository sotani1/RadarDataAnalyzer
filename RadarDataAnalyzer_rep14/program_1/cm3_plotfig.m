Opefolder         = pwd;                                   % Work Folder
Opefolder         = erase(Opefolder, '\program');
Prgfolder         = [Opefolder '\program'];                % Program Folder
Datafolder        = [Opefolder '\dfolder'];                % Data Folder
Logfolder         = [Opefolder '\log_data'];               % Log Folder
D=dir(Datafolder);    
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
sz = 2;

s_max  = 60; 
s_min  = 0;
dv_max = 20;
dv_min = -20;

% Plot for first microtrip
i_mt_plot = 1;

% Plot for first radar target
i_tk_plot = 1;
time_lwr = M_var_time{i_mt_plot}(1);
time_upr = M_var_time{i_mt_plot}(end);
%time_lwr = 1096;
%time_upr = 1197;
%time_lwr = var_time(arr_mtnup_ind(31));
%time_upr = var_time(arr_mtndn_ind(32));

%Check to see if lead car is stopped
f_type = 'var'; f_target = 'lead'; f_var = 'speedx'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_lead    = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
if isempty(plotvar_lead) ~= 1
    plotvar_lead_1b = plotvar_lead(int32((time_lwr-M_var_time{i_mt_plot}(1))*10+1):int32((time_upr-M_var_time{i_mt_plot}(1))*10+1));
    if nanmean(plotvar_lead_1b) < 2.5
        Flg_leadstp = 1;
    else
        Flg_leadstp = 0;
    end
end

f_type = 'var'; f_target = 'lead'; f_var = 'thw_inv'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
f_type = 'var'; f_target = 'lead'; f_var = 'ttc_inv'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_3 = M_var_time{i_mt_plot};
plotvar_4 = M_var_time{i_mt_plot};
f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'accelx'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_5 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_risk = (1*plotvar_1) + (4*plotvar_2); 

subplot1 = subplot(2,3,1);
if isempty(plotvar_lead) ~= 1
    f3Dscatter(plotvar_risk, plotvar_5, ...
               plotvar_3, 5, plotvar_4, subplot1, ...
               time_lwr, time_upr,'scatter');
    %xlim([0 1]);
    %ylim([0 0.7]);
    title(strcat('M',num2str(i_mt_plot), '_Track', num2str(i_tk_plot),'Risk Level vs accel_x'), 'interpreter', 'none');
end

f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'speedx'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'accelx'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_3 = M_var_time{i_mt_plot};
plotvar_4 = M_var_time{i_mt_plot};
subplot2 = subplot(2,3,2);
f3Dscatter(plotvar_1, plotvar_2, ...
           plotvar_3, 5, plotvar_4, subplot2, ...
           time_lwr, time_upr,'scatter');
%xlim([0 150]);
%ylim([-0.5 0.1]);
title(strcat('M',num2str(i_mt_plot),'_Ego_accelx vs VehicleSpeed'), 'interpreter', 'none');

% Jerk Plot (return to normal when done) 20190930
%plotvar_1 = M_var_time{i_mt_plot};
%f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'jerkx'; f_ilv = 'non_ilv' ;
%[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
%plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
%plotvar_3 = M_var_time{i_mt_plot};
%plotvar_4 = M_var_time{i_mt_plot};
%subplot3 = subplot(2,3,3);
%f3Dscatter(plotvar_1, plotvar_2, ...
%           plotvar_3, 5, plotvar_4, subplot3, ...
%           time_lwr, time_upr,'plot3');
%title(strcat('M',num2str(i_mt_plot),'_Ego_jerkx vs time'), 'interpreter', 'none');

f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'speedx'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
f_type = 'var'; f_target = 'lead'; f_var = 'speedx'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1b = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_1  = -(plotvar_1b - plotvar_1); % Wiedemann has the signs flipped
f_type = 'var'; f_target = strcat('lead',num2str(i_tk_plot)); f_var = 'posx'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_3  = M_var_time{i_mt_plot};
plotvar_4  = M_var_time{i_mt_plot};
subplot2 = subplot(2,3,3);
f3Dscatter(plotvar_1, plotvar_2, ...
           plotvar_3, 5, plotvar_4, subplot2, ...
           time_lwr, time_upr,'scatter');
xlim([-20 20]);
ylim([10 60]);
title(strcat('M',num2str(i_mt_plot),'_Lead_distance vs Relative Speed'), 'interpreter', 'none');

f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'speedx'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
f_type = 'var'; f_target = 'lead'; f_var = 'thw'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_3 = M_var_time{i_mt_plot};
plotvar_4 = M_var_time{i_mt_plot};
subplot4 = subplot(2,3,4);
if isempty(plotvar_lead) ~= 1
    f3Dscatter(plotvar_1, plotvar_2, ...
               plotvar_3, 5, plotvar_4, subplot4, ...
               time_lwr, time_upr,'scatter');
    %xlim([0 150]);
    %ylim([0 8]);
    title(strcat('M',num2str(i_mt_plot),'_Track',num2str(i_tk_plot),'_HEADWAY vs VehicleSpeed'), 'interpreter', 'none');
end
f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'speedx'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
f_type = 'var'; f_target = 'lead'; f_var = 'ttc'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_3 = M_var_time{i_mt_plot};
plotvar_4 = M_var_time{i_mt_plot};
subplot5 = subplot(2,3,5);
if isempty(plotvar_lead) ~= 1
    f3Dscatter(plotvar_1, plotvar_2, ...
               plotvar_3, 5,plotvar_4 , subplot5, ...
               time_lwr, time_upr,'scatter');
    %xlim([0 150]);
    %ylim([-50 50]);
    ylim([-15 15]);
    title(strcat('M',num2str(i_mt_plot),'_Track',num2str(i_tk_plot),'_TTC vs VehicleSpeed'), 'interpreter', 'none');
end
f_type = 'var'; f_target = 'lead'; f_var = 'thw_inv'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
f_type = 'var'; f_target = 'lead'; f_var = 'ttc_inv'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_3 = M_var_time{i_mt_plot};
plotvar_4 = M_var_time{i_mt_plot};
subplot6 = subplot(2,3,6);
if isempty(plotvar_lead) ~= 1
    f3Dscatter(plotvar_1, plotvar_2, ...
               plotvar_3, 5, plotvar_4, subplot6, ...
               time_lwr, time_upr,'scatter');
    %xlim([0 1]);
    %ylim([0 0.7]);
    title(strcat('M',num2str(i_mt_plot), '_Track', num2str(i_tk_plot),'_TTC_INV vs THW_INV'), 'interpreter', 'none');
end

%% Second scatter plot here
figure('units','normalized','outerposition',[0 0 1 1])
subplot1a = subplot(1,3,1);
f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'speedx'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
f_type = 'var'; f_target = 'lead'; f_var = 'speedx'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1b = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_1  = -(plotvar_1b - plotvar_1); %Wiedemann has the signs flipped
f_type = 'var'; f_target = strcat('lead',num2str(i_tk_plot)); f_var = 'posx'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_3  = M_var_time{i_mt_plot};
plotvar_4  = M_var_time{i_mt_plot};
f3Dscatter(plotvar_1, plotvar_2,     ...
           plotvar_3, 5, plotvar_4,  ...
           subplot1a, time_lwr,      ...
           time_upr,'scatter');
c1 = colormap(subplot1a, parula);
c1 = colorbar;
xlim([dv_min dv_max]);
ylim([s_min s_max]);
title(strcat('M',num2str(i_mt_plot),'_Lead_distance vs Relative Speed'), 'interpreter', 'none');

%time_lwr1 = time_lwr - var_time(1);
%time_upr1 = time_upr - var_time(1);
time_lwr1 = ((time_lwr-var_time(1))/dt)+1;
time_upr1 = ((time_upr-var_time(1))/dt)+1;

subplot2a = subplot(1,3,2);
f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'speedx'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
f_type = 'var'; f_target = 'lead'; f_var = 'speedx'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1b = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_1  = -(plotvar_1b - plotvar_1); %Wiedemann has the signs flipped
f_type = 'var'; f_target = strcat('lead',num2str(i_tk_plot)); f_var = 'posx'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'accelx'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_3 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
scatter3(plotvar_1(int32(time_lwr1):int32(time_upr1)),...
         plotvar_2(int32(time_lwr1):int32(time_upr1)),...
         plotvar_3(int32(time_lwr1):int32(time_upr1)),...
         5,...
         plotvar_3(int32(time_lwr1):int32(time_upr1)));
c2 = colormap(subplot2a, flipud(jet));
c2 = colorbar;
xlim([dv_min dv_max]);
ylim([s_min s_max]);
view(0, 90)
title(strcat('M',num2str(i_mt_plot),'_Lead_distance vs Relative Speed vs Accel'), 'interpreter', 'none');

subplot3a = subplot(1,3,3);
f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'speedx'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
f_type = 'var'; f_target = 'lead'; f_var = 'speedx'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1b = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_1  = -(plotvar_1b - plotvar_1); %Wiedemann has the signs flipped
f_type = 'var'; f_target = strcat('lead',num2str(i_tk_plot)); f_var = 'posx'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_3  = plotvar_risk;
scatter3(plotvar_1(int32(time_lwr1):int32(time_upr1)),...
         plotvar_2(int32(time_lwr1):int32(time_upr1)),...
         plotvar_3(int32(time_lwr1):int32(time_upr1)),...
         5,...
         plotvar_3(int32(time_lwr1):int32(time_upr1)));
c3 = colormap(subplot3a, jet);
c3 = colorbar;
xlim([dv_min dv_max]);
ylim([s_min s_max]);
view(0, 90)
title(strcat('M',num2str(i_mt_plot),'_Lead_distance vs Relative Speed vs RF'), 'interpreter', 'none');
%% Time-series plot here

plotvar_1b = [];
plotvar_2b = [];
figure('units','normalized','outerposition',[0 0 1 1]);
subplot(6,2,1);
f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'speedx'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1b = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plot(M_var_time{i_mt_plot}, plotvar_1b);
hold on;
f_type = 'var'; f_target = 'lead'; f_var = 'speedx'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1b = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
if isempty(plotvar_lead) ~= 1
    plot(M_var_time{i_mt_plot},plotvar_1b)
    xlim([time_lwr time_upr]);
end
hold off;
ylabel('vspeed', 'interpreter', 'none');
xlim([time_lwr time_upr]);
legend('Ego Car', 'Lead Car');
xlim_tmp = get(gca,'ylim');
set(gca, 'ylim', [0 xlim_tmp(2)]);
xlim_tmp = get(gca,'ylim');
pos = get(gcf,'Position');
h = subplot(6,2,2);
f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'speedx'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1b = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plotvar_1b_hist = plotvar_1b(int32((time_lwr-M_var_time{i_mt_plot}(1)+dt)*(1/dt)):int32((time_upr-M_var_time{i_mt_plot}(1)+dt)*(1/dt)));
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

h = subplot(6,2,3);
plotvar_1b = var_ego_dist_brake;
plotvar_1b_hist = plotvar_1b(int32((time_lwr-M_var_time{i_mt_plot}(1)+dt)*(1/dt)):int32((time_upr-M_var_time{i_mt_plot}(1)+dt)*(1/dt)));
ylabel('distance_x', 'interpreter', 'none');
xlim([time_lwr time_upr]);
xlim_tmp = get(gca,'ylim');

pos = get(h,'Position');
plotvar_temp    =  plotvar_1b(int32((time_lwr-M_var_time{i_mt_plot}(1)+dt)*(1/dt)):int32((time_upr-M_var_time{i_mt_plot}(1)+dt)*(1/dt)));  %Determine braking distance
plotvar_temp_o  =  plotvar_1b(int32((time_lwr-M_var_time{i_mt_plot}(1)+dt)*(1/dt)));

%Calculate braking distance
for i2=1:int32((time_upr+dt)*(1/dt))-int32((time_lwr+dt)*(1/dt))
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
        if (i2==int32((time_lwr+dt)*(1/dt))) && (isnan(plotvar_temp(i2))==0)
            plotvar_temp_o = plotvar_temp(i2);
        end
    end
end    
h_an = annotation('textbox','String',{char(strcat({'Bk Distance:  '},     {num2str(round(plotvar_bk_dist,2))})), ...
                                      char(strcat({'DistMin:   '   },     {num2str(round(nanmin(plotvar_temp(plotvar_temp>0)),2))})),                                           ...
                                      char(strcat({'DistMax:   '   },     {num2str(round(nanmax(plotvar_temp),2))})),                                                           ...
                                      char(strcat({'TimeTotal: '   },     {num2str(int32(time_upr-time_lwr))})),                                                                ...
                                      char(strcat({'TimeMin:   '   },     {num2str(int32(time_lwr-var_time(1)))})),                                                                         ...
                                      char(strcat({'TimeMax:   '   },     {num2str(int32(time_upr-var_time(1)))})),                                                                         ...
                                      char(strcat({'Vid Start: '   },     {num2str(floor((time_lwr-var_time(1))/60))} , {' m '} , num2str(round(((time_lwr-var_time(1)))-(floor((time_lwr-var_time(1))/60)*60),0)), {' sec'})),    ...
                                      char(strcat({'Vid End:   '   },     {num2str(floor((time_upr-var_time(1))/60))} , {' m '} , num2str(round(((time_upr-var_time(1)))-(floor((time_upr-var_time(1))/60)*60),0)), {' sec'}))     ...
                                      });
var_plot(2,1) = round(nanmax(plotvar_temp)-nanmin(plotvar_temp(plotvar_temp>0)),2);
var_plot(3,1) = int32(time_upr-time_lwr);
set(h_an, 'Position', [pos(1)+0.37 pos(2)-0.02 pos(3)/4 pos(4)+0.02]);
clear plotvar_temp;

subplot(6,2,5)
f_type = 'var'; f_target = strcat('ego',num2str(i_tk_plot)); f_var = 'accelx'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1b = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
plot(M_var_time{i_mt_plot},plotvar_1b)
ylabel('accel_x', 'interpreter', 'none');
xlim([time_lwr time_upr]);
xlim_tmp = get(gca,'ylim');

%histfit for ego_accel_x
h = subplot(6,2,6);
plotvar_1b_hist = plotvar_1b(int32((time_lwr-M_var_time{i_mt_plot}(1)+dt)*(1/dt)):int32((time_upr-M_var_time{i_mt_plot}(1)+dt)*(1/dt)));
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
subplot(6,2,7)
f_type = 'var'; f_target = 'lead'; f_var = 'thw'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1b = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
if isempty(plotvar_lead) ~= 1
    plot(M_var_time{i_mt_plot},plotvar_1b);
    ylabel('THW', 'interpreter', 'none');
    xlim([time_lwr time_upr]);
    ylim([0 2]);
    xlim_tmp = get(gca,'ylim');
end
%histfit for THW
h = subplot(6,2,8);
if isempty(plotvar_lead) ~= 1
    plotvar_1b_hist = plotvar_1b(int32((time_lwr-M_var_time{i_mt_plot}(1)+dt)*(1/dt)):int32((time_upr-M_var_time{i_mt_plot}(1)+dt)*(1/dt)));
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


set(h, 'Position', [pos(1)-0.07 pos(2) pos(3)/4 pos(4)]);
subplot(6,2,9)
f_type = 'var'; f_target = 'lead'; f_var = 'ttc'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1b = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
if isempty(plotvar_lead) ~= 1
    plot(M_var_time{i_mt_plot},plotvar_1b);
    ylabel('TTC', 'interpreter', 'none');
    xlim([time_lwr time_upr]);
    ylim([0 15]);
end
h = subplot(6,2,10);

%histfit for TTC
f_type = 'var'; f_target = 'lead'; f_var = 'ttc'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
plotvar_1b      = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
if isempty(plotvar_lead) ~= 1
    plotvar_1b_hist = plotvar_1b(int32((time_lwr-M_var_time{i_mt_plot}(1)+dt)*(1/dt)):int32((time_upr-M_var_time{i_mt_plot}(1)+dt)*(1/dt)));
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
subplot(6,2,11)
if isempty(plotvar_lead) ~= 1
    plot(M_var_time{i_mt_plot},plotvar_risk);
    ylabel('Risk Feeling', 'interpreter', 'none');
    xlim([time_lwr time_upr]);
    ylim([0 5]);
end
h = subplot(6,2,12);
if isempty(plotvar_lead) ~= 1
    plotvar_1b_hist = plotvar_risk(int32((time_lwr-M_var_time{i_mt_plot}(1)+dt)*(1/dt)):int32((time_upr-M_var_time{i_mt_plot}(1)+dt)*(1/dt)));
end
try
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

clear t h h1 b plotvar_1b_hist_tmp xlim_tmp sz pos k1 f1 i2
clear f_ilv f_target f_type f_var h_an i_asn i_asn_ilv i_mt ind_filv ind_ftype ind_fvar
clear plotvar_1 plotvar_1b plotvar_1b_hist plotvar_2 plotvar_2b plotvar_3 plotvar_4 plotvar_5
clear mt_end mt_start as_plot var_plot
clear plotvar_lead plotvar_lead_1b
clear time_upr time_lwr time_upr1 time_lwr1 c1 c2 c3 s_max s_min dv_max dv_min

cd(Opefolder);