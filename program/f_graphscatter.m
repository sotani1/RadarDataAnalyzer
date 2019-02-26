D2 =dir(Scatfolder); %Get the list of all scat mat files 
cd(Scatfolder);

clear time_lwr;
clear time_upr;
clear imscat;

Flg_ones = 1;

subplot_temp = subplot(1,1,1);

for k3=1+2:length(D2) 
    imscat = load(D2(k3).name);
    time_lwr(k3-2) = num2cell(imscat.scat.time_lwr);
    time_upr(k3-2) = num2cell(imscat.scat.time_upr);
    if imscat.scat.flg_ledastp ~= 1
        if Flg_ones == 1
        f3Dscatter(imscat.scat.xdata,      imscat.scat.ydata,                       ...
                   imscat.scat.zdata_ones, 5, imscat.scat.tdata_ones, subplot_temp, ...
                   0, 2,'scatter');        
        else
        f3Dscatter(imscat.scat.xdata,      imscat.scat.ydata,                       ...
                  imscat.scat.zdata,       5, imscat.scat.tdata,      subplot_temp, ...
                   nanmin(cell2mat(time_lwr)), nanmax(cell2mat(time_upr)),'scatter');
        end
    end
    hold on;
end
xlim([0 1.0]);
ylim([0 0.7]);
zlim([0 5E10]);
hold off;

