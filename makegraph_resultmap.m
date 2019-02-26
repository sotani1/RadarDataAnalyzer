
    close all
    %sŁ
    figure
    subplot(211),plot(map_mileage_all(:,1),map_mileage_all(:,2),'linewidth',2),grid
    if FlgEnglish == 1 
        xlabel('1DC distance[km]'),ylabel('Probability Density[%]')
    else    
        xlabel('1DCĚsŁ[km]'),ylabel('mŚ§x[%]')
    end
    axis([0 100 0 30]);
    %ęRĚsŁ
    subplot(212),plot(map_mileage_yama(:,1),map_mileage_yama(:,2),'linewidth',2),grid
    if FlgEnglish == 1
        xlabel('Distance per microtrip[km]'),ylabel('Probability Density[%]')
    else
        xlabel('ęRĚsŁ[km]'),ylabel('mŚ§x[%]')
    end
        axis([0 10 0 60]);
    %ÔŹ
    figure
    subplot(211),plot(map_vspe(:,1),map_vspe(:,2),'linewidth',2),grid
    if FlgEnglish == 1
        xlabel('Speed[km/h]'),ylabel('Probability Density[%]')
    else
        xlabel('ÔŹ[km/h]'),ylabel('mŚ§x[%]')
    end
    %âÔÔ
    subplot(212),plot(map_stptime(:,1),map_stptime(:,2),'linewidth',2),grid
    if FlgEnglish == 1 
        xlabel('Stationary time[sec]'),ylabel('Probability Density[%]')
    else
        xlabel('âÔÔ[sec]'),ylabel('mŚ§x[%]')
    end
    axis([0 100 0 25]);
    %ÁŹx(ÁŹ)
    figure
    subplot(233),plot(map_dvsp1(110:201,1),map_dvsp_acc,'linewidth',2),grid
    if FlgEnglish == 1 
        xlabel('Acceleration[m/s^2]'),ylabel('Probability Density[%]')
    else
        xlabel('ÁŹx[m/s^2]'),ylabel('mŚ§x[%]')    
    end
    %ÁŹx(čí)
    subplot(232),plot(map_dvsp1(93:109,1),map_dvsp_sta,'linewidth',2),grid
    if FlgEnglish == 1
        xlabel('Acceleration[m/s^2]'),ylabel('Probability Density[%]')
    else
        xlabel('ÁŹx[m/s^2]'),ylabel('mŚ§x[%]')      
    end
    %ÁŹx(¸Ź)
    subplot(231),plot(map_dvsp1(1:92,1),map_dvsp_dec,'linewidth',2),grid
    if FlgEnglish == 1
        xlabel('Accecleration[m/s^2]'),ylabel('Probability Density[%]')  
    else
        xlabel('ÁŹx[m/s^2]'),ylabel('mŚ§x[%]')  
    end
    %ÁŹpąÔ
    subplot(236),plot(map_acctime(:,1),map_acctime(:,2),'linewidth',2),grid
    if FlgEnglish == 1
        xlabel('Acc duration[sec]'),ylabel('Probability Density[%]')    
    else 
        xlabel('ÁŹpąÔ[sec]'),ylabel('mŚ§x[%]')
    end 
    axis([0 30 0 100]);
    %čípąÔ
    subplot(235),plot(map_statime(:,1),map_statime(:,2),'linewidth',2),grid
    if FlgEnglish == 1
        xlabel('Cru duration[sec]'),ylabel('Probability Density[%]')    
    else 
        xlabel('čípąÔ[sec]'),ylabel('mŚ§x[%]')
    end
    axis([0 100 0 100]);
    %¸ŹpąÔ
    subplot(234),plot(map_dectime(:,1),map_dectime(:,2),'linewidth',2),grid
    if FlgEnglish == 1
        xlabel('Dec duration[sec]'),ylabel('Probability Density[%]')    
    else 
        xlabel('¸ŹpąÔ[sec]'),ylabel('mŚ§x[%]')
    end
    axis([0 30 0 100]);
    %ůz
    figure
    subplot(311),plot(map_grade(:,1),map_grade(:,2),'linewidth',2),grid
    if FlgEnglish == 1
        xlabel('Grade[%]'),ylabel('Probability Density[%]')    
    else 
        xlabel('ůz[%]'),ylabel('mŚ§x[%]')
    end
    axis([-10 10 0 6]);
    %ůzĎťĘ
    subplot(312),plot(map_dgdl(:,1),map_dgdl(:,2),'linewidth',2),grid
    if FlgEnglish == 1
        xlabel('Rate of change of grade[%/10m]'),ylabel('Probability Density[%]')    
    else 
        xlabel('ůzĎťĘ[%/10m]'),ylabel('mŚ§x[%]')   
    end
    %ůzĎťĘ
    subplot(313),plot(map_gl(:,1),map_gl(:,2),'linewidth',2),grid
    if FlgEnglish == 1
        xlabel('Road grade duration[km]'),ylabel('Probability Density[%]')    
    else   
        xlabel('ůzpą[km]'),ylabel('mŚ§x[%]')  
    end
    axis([0 0.2 0 60]);
