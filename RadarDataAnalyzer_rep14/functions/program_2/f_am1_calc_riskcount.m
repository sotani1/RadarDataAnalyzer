function [k d_timer d_time RFL] = f_am1_calc_riskcount(var_time, RFT, M_data, i_mt_plot, alpha_thw, beta_ttc, st)
    %% ˜3-1-2  Calculate amount of times risk feeling exceeded threshold
    
    %% ˜3-1-2-1 Initialize Risk Feeling varibles
    % RFT (Risk Feeling Threshold) set to 1.5
    % Read THW and TTC values
    f_type = 'var'; f_target = 'lead'; f_var = 'thw_inv'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
    plotvar_1 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
    f_type = 'var'; f_target = 'lead'; f_var = 'ttc_inv'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
    plotvar_2 = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
    % Set up Risk Feeling Variable
    RFL = (alpha_thw*plotvar_1) + (beta_ttc*plotvar_2); % Risk Feeling

    % Initialize working varaibles
    flg     = [];  % Risk Feeling Flag
    d_rf    = [];  % Matrix to store risk feeling
    d_timer = [];  % Matrix to store timer values
    d_time  = [];  % Matrix to store time
    timer   = 0;   % Timer to count values when RF is greater than treshold
    k       = 0;   % Counter to count RF(i) > RFT
    timer_0 = 0;   % Previous timer value
    i0      = 0;   % Store previous index for sanity check
    
    if min(isnan(RFL)) == 1
        flg = zeros(size(RFL));
        return
    end
    
    %% ˜3-1-2-2 Calculate timer value when RF > RF_THRESH
    for i = 1:length(var_time)
        if isempty(RFL) == 1
            break;
        end
        if i == 1 
            if RFL(i) > RFT
                k       = k + 1;
                timer   = st;
                d_rf(k) = k;
                flg(i)  = 1;
                continue;
            else
                timer   = 0;
                flg(i)  = 0;
                continue;
            end
        else
            if RFL(i) >= RFL(i-1)
                if RFL(i) >= RFT
                    if timer>0
                        timer   = timer + st;
                    else
                        if timer == 0
                            %If timer is less than 1, the RF is probably buzzing so keep the previous value
                            if timer_0 < 1 && (i-i0)*st < 1 
                                timer     = (i-i0)*st + timer_0;
                            else
                                k         = k+1;                                
                                timer     = st;
                                d_rf(k)   = k;
                                d_time(k) = var_time(i+1);
                            end
                        end
                    end
                    flg(i) = 1;
                    continue;
                else
                    flg(i) = 0;
                    continue;
                end
            else
                if i == length(var_time)
                    if k == 0
                        k = 1;  %If nothing is detected, increment counter
                        d_timer(k)   = timer;
                        timer_0      = timer;
                        d_time(k)    = 0;
                        timer        = 0;
                        flg(i)       = 0;
                        i0           = i;
                    end
                    break
                end    
                if RFL(i-1) >= RFL(i)
                    if RFL(i) >= RFT 
                        timer   = timer + st;
                        flg(i)  = 1;
                        continue;
                    else
                        if RFL(i-1) >= RFT
                            if k == 0
                                k = 1; %If nothing is detected, increment counter
                            end
                            d_timer(k)   = timer;
                            timer_0      = timer;
                            timer        = 0;
                            flg(i)       = 0;
                            i0           = i;
                            continue;
                        end
                    end
                end
                if isnan(RFL(i)) == 1
                    if RFL(i-1) >= RFT
                        if k == 0
                            k = 1;  %If nothing is detected, increment counter
                        end
                        d_timer(k)   = timer;
                        timer_0      = timer;
                        timer        = 0;
                        flg(i)       = 0;
                        i0           = i;
                        continue;
                    end
                end
            flg(i) = 0;
            continue;
            end
        end
    end
    flg = transpose(flg);
end
