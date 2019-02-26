function f_makescatter(D_temp, dt_temp, time_lwr_temp, time_upr_temp, k_temp, i_mt_plot_temp, i_tk_plot_temp, Flg_ledastp_temp, Prgfolder_temp, Scatfolder_temp)
    h2 = gca;
    as_savename_temp = D_temp(k_temp).name(1:end-4);
    as_savename_num = strrep(as_savename_temp, 'File_ID_','');
    as_savename = strcat(as_savename_num, '_M', num2str(i_mt_plot_temp), '_T', num2str(i_tk_plot_temp), '_LS', num2str(Flg_ledastp_temp));
    
    scat.tdata       = get(get(gca,'Children'),'CData');
    scat.xdata       = get(get(gca,'Children'),'XData');
    scat.xdata       = scat.xdata(int32(((time_lwr_temp - scat.tdata(1))/dt_temp)+1):int32(((time_upr_temp - scat.tdata(1))/dt_temp)+1));
    scat.ydata       = get(get(gca,'Children'),'YData');
    scat.ydata       = scat.ydata(int32(((time_lwr_temp - scat.tdata(1))/dt_temp)+1):int32(((time_upr_temp - scat.tdata(1))/dt_temp)+1));
    scat.zdata       = get(get(gca,'Children'),'ZData');
    scat.zdata       = scat.zdata(int32(((time_lwr_temp - scat.tdata(1))/dt_temp)+1):int32(((time_upr_temp - scat.tdata(1))/dt_temp)+1));
    %Adjust tdata as well
    scat.tdata       = scat.tdata(int32(((time_lwr_temp - scat.tdata(1))/dt_temp)+1):int32(((time_upr_temp - scat.tdata(1))/dt_temp)+1));
    %Ones 
    scat.tdata_ones  = ones(int32(((time_upr_temp - scat.tdata(1))/dt_temp)+1)-int32(((time_lwr_temp - scat.tdata(1))/dt_temp)+1)+1,1);
    if str2double(as_savename_num) < 10
        scat.zdata_ones  = (str2double(as_savename_num)*10+i_mt_plot_temp) .* ones(1,int32(((time_upr_temp - scat.tdata(1))/dt_temp)+1)-int32(((time_lwr_temp - scat.tdata(1))/dt_temp)+1)+1);
    else if str2double(as_savename_num) >= 10
        scat.zdata_ones  = (str2double(as_savename_num)*100+i_mt_plot_temp) .* ones(1,int32(((time_upr_temp - scat.tdata(1))/dt_temp)+1)-int32(((time_lwr_temp - scat.tdata(1))/dt_temp)+1)+1);    
        end
    end
    %scat.zdata_ones  = ones(1,int32(((time_upr_temp - scat.tdata(1))/dt_temp)+1)-int32(((time_lwr_temp - scat.tdata(1))/dt_temp)+1)+1);
    scat.time_lwr    = time_lwr_temp;
    scat.time_upr    = time_upr_temp;
    scat.i_mt_plot   = i_mt_plot_temp;
    scat.i_tk_plot   = i_tk_plot_temp;
    scat.flg_ledastp = Flg_ledastp_temp;
    cd(Scatfolder_temp);

    save(as_savename,'scat');
    cd(Prgfolder_temp);
    clear h2;
end