function [m_total ,teisya_owari ,teisya_kaisi] = f_cm2_2_calc_mountain(vsp, vsp_thresh, flg_mtn, var_time, flg_analysis_mode)
%% Åò2-1-3-3-4-1 && 2-1-3-3-4-3-1 Determine number of microtrips  

% A standard velocity profile checking function to see if there was a stop/start sequence initiated between microtrips.
% For more documentation about microtrips, please visit <https://www.researchgate.net/figure/Typical-mode-feature-collection-using-micro-trip-extraction_fig1_324531468>

%% Åò2-1-3-3-4-1-1 Initialize --------------------------------------------
out_stptime  = [];
teisya_kaisi = [];
teisya_owari = [];
m_total      = 0;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%% Åò2-1-3-3-4-1-2 Check for when vehicle is stopped and the vehicle restarts (Sorry in Japanese)
if vsp(1)>1
    teisya_owari = [teisya_owari;1]; % If vehicle restarts, increment the teisya_owari variable
end

for i=2:length(vsp)
    if (vsp(i-1) >= vsp_thresh && vsp(i) < vsp_thresh) 
        teisya_kaisi = [teisya_kaisi;i];    % If the vehicle speed is less than a certain threshold, assume that it is stopped
    end
    if (vsp(i-1) <=vsp_thresh && vsp(i) > vsp_thresh) || (isnan(vsp(i-1)) && vsp(i) > vsp_thresh)
        if flg_analysis_mode == 3
            if i~= 2
                teisya_owari = [teisya_owari;i];
                m_total  = m_total + 1;
            end 
        else            
            teisya_owari = [teisya_owari;i];    % If the vehicle speed goes above the threshold, assume that it is in motion again
            m_total  = m_total + 1;             % Upon this instance, increment the microtrip counter
        end
    end
    if flg_analysis_mode == 3
        if (vsp(i-1)>1 && i==length(vsp)) || i==length(vsp) && isnan(vsp(i))==1
            teisya_kaisi = [teisya_kaisi;i];    % If the last datapoint is still in motion, close the microtrip
         m_total  = m_total + 1;             % Be sure to increment the microtrip counter as well
        end
    else
        if (vsp(i-1)>1 && i==length(vsp))
            teisya_kaisi = [teisya_kaisi;i];
            m_total  = m_total + 1;
        end
    end
end

if isempty(teisya_kaisi) == 1
    teisya_kaisi = length(vsp);             % Even if no microtrips are detected (vehicle stationary), store increment teisya_kaisi
end
%% Åò2-1-3-3-4-1-3 Calculate total stopped time of vehicle
if vsp(1) > vsp_thresh
    for i = 1:length(teisya_owari)
        out_stptime=[out_stptime;teisya_owari(i)-teisya_kaisi(i)];   % If vehicle is already in motion at the start of the trip
    end
else
    for i = 1:length(teisya_owari)-1
        out_stptime=[out_stptime;teisya_owari(i+1)-teisya_kaisi(i)]; % For all other instances
    end
end

if flg_mtn == 0
    teisya_kaisi = length(var_time);
    teisya_owari = 1;
    m_total = 1;
end

%--------------------------------------------------------------------------


