
    close all
    %走行距離
    figure
    subplot(211),plot(map_mileage_all(:,1),map_mileage_all(:,2),'linewidth',2),grid
    if FlgEnglish == 1 
        xlabel('1DC distance[km]'),ylabel('Probability Density[%]')
    else    
        xlabel('1DCの走行距離[km]'),ylabel('確率密度[%]')
    end
    axis([0 100 0 30]);
    %一山の走行距離
    subplot(212),plot(map_mileage_yama(:,1),map_mileage_yama(:,2),'linewidth',2),grid
    if FlgEnglish == 1
        xlabel('Distance per microtrip[km]'),ylabel('Probability Density[%]')
    else
        xlabel('一山の走行距離[km]'),ylabel('確率密度[%]')
    end
        axis([0 10 0 60]);
    %車速
    figure
    subplot(211),plot(map_vspe(:,1),map_vspe(:,2),'linewidth',2),grid
    if FlgEnglish == 1
        xlabel('Speed[km/h]'),ylabel('Probability Density[%]')
    else
        xlabel('車速[km/h]'),ylabel('確率密度[%]')
    end
    %停車時間
    subplot(212),plot(map_stptime(:,1),map_stptime(:,2),'linewidth',2),grid
    if FlgEnglish == 1 
        xlabel('Stationary time[sec]'),ylabel('Probability Density[%]')
    else
        xlabel('停車時間[sec]'),ylabel('確率密度[%]')
    end
    axis([0 100 0 25]);
    %加速度(加速中)
    figure
    subplot(233),plot(map_dvsp1(110:201,1),map_dvsp_acc,'linewidth',2),grid
    if FlgEnglish == 1 
        xlabel('Acceleration[m/s^2]'),ylabel('Probability Density[%]')
    else
        xlabel('加速度[m/s^2]'),ylabel('確率密度[%]')    
    end
    %加速度(定常)
    subplot(232),plot(map_dvsp1(93:109,1),map_dvsp_sta,'linewidth',2),grid
    if FlgEnglish == 1
        xlabel('Acceleration[m/s^2]'),ylabel('Probability Density[%]')
    else
        xlabel('加速度[m/s^2]'),ylabel('確率密度[%]')      
    end
    %加速度(減速)
    subplot(231),plot(map_dvsp1(1:92,1),map_dvsp_dec,'linewidth',2),grid
    if FlgEnglish == 1
        xlabel('Accecleration[m/s^2]'),ylabel('Probability Density[%]')  
    else
        xlabel('加速度[m/s^2]'),ylabel('確率密度[%]')  
    end
    %加速継続時間
    subplot(236),plot(map_acctime(:,1),map_acctime(:,2),'linewidth',2),grid
    if FlgEnglish == 1
        xlabel('Acc duration[sec]'),ylabel('Probability Density[%]')    
    else 
        xlabel('加速継続時間[sec]'),ylabel('確率密度[%]')
    end 
    axis([0 30 0 100]);
    %定常継続時間
    subplot(235),plot(map_statime(:,1),map_statime(:,2),'linewidth',2),grid
    if FlgEnglish == 1
        xlabel('Cru duration[sec]'),ylabel('Probability Density[%]')    
    else 
        xlabel('定常継続時間[sec]'),ylabel('確率密度[%]')
    end
    axis([0 100 0 100]);
    %減速継続時間
    subplot(234),plot(map_dectime(:,1),map_dectime(:,2),'linewidth',2),grid
    if FlgEnglish == 1
        xlabel('Dec duration[sec]'),ylabel('Probability Density[%]')    
    else 
        xlabel('減速継続時間[sec]'),ylabel('確率密度[%]')
    end
    axis([0 30 0 100]);
    %勾配
    figure
    subplot(311),plot(map_grade(:,1),map_grade(:,2),'linewidth',2),grid
    if FlgEnglish == 1
        xlabel('Grade[%]'),ylabel('Probability Density[%]')    
    else 
        xlabel('勾配[%]'),ylabel('確率密度[%]')
    end
    axis([-10 10 0 6]);
    %勾配変化量
    subplot(312),plot(map_dgdl(:,1),map_dgdl(:,2),'linewidth',2),grid
    if FlgEnglish == 1
        xlabel('Rate of change of grade[%/10m]'),ylabel('Probability Density[%]')    
    else 
        xlabel('勾配変化量[%/10m]'),ylabel('確率密度[%]')   
    end
    %勾配変化量
    subplot(313),plot(map_gl(:,1),map_gl(:,2),'linewidth',2),grid
    if FlgEnglish == 1
        xlabel('Road grade duration[km]'),ylabel('Probability Density[%]')    
    else   
        xlabel('勾配継続[km]'),ylabel('確率密度[%]')  
    end
    axis([0 0.2 0 60]);
