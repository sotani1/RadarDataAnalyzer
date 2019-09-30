function [ope_state, k_gon, k_grp, k_gof, k_bon, k_brp, timer_gon, timer_grp, timer_gof, timer_bon, timer_brp, var_time_gon, var_time_grp, var_time_gof, var_time_bon, var_time_brp, i_mt_plot] = f_am2_1_calc_gobo(var_time, var_ego_speed, M_data, dt, i_mt_plot, mt_start, mt_end, num_mt)
%% Åò4-1-1-2 Calculate GOBO
%   2019.07.08 Currently not the most robust logic.  Need to brush up over time.
%% Åò4-1-1-2-1 Initialize variables
thw_lim         = 999;     % Set measurable THW to 999 sec
coast_G         = -0.03;   % Sets coasting braking force
brepress_G      = -0.05;   % Sets braking repress force
grepress_G      =  0.05;   % Sets gas repress force
gon_G           =  0.03;   % Sets gas on force
timer_gon       = [];      % Timer for GAS ON 1.0        (GON)
timer_gon0      = 0;
timer_grp       = [];      % Timer for GAS REPRESS 2.0   (GRP)
timer_grp0      = 0;
timer_gof       = [];      % Timer for GAS OFF 3.0       (GOF)
timer_gof0      = 0; 
timer_bon       = [];      % Timer for BRAKE ON 4.0      (BON)
timer_bon0      = 0;
timer_brp       = [];      % Timer for BRAKE REPRESS 5.0 (BRP)
timer_brp0      = 0;
k_gon           = 1;       % Gass pedal ON counter
k_gof           = 1;       % Gas OFF counter
k_bon           = 1;       % Brake ON counter
k_brp           = 1;       % Brake REPRESS counter
k_grp           = 1;       % Gas REPRESS counter
var_time_gon    = [];      % GAS ON         1.0
var_time_grp    = [];      % GAS REPRESS    2.0
var_time_gof    = [];      % GAS OFF        3.0
var_time_bon    = [];      % BRAKE ON       4.0
var_time_brp    = [];      % BRAKRE REPRESS 5.0
time_ope_buffer = 1.0;     % Timer buffer to avoid frequent counting (0.5 sec)
ope_state       = [];      % [1]GAS_ON / [2]GAS_REPRESS / [3]GAS_OFF / [4]BRAKE_ON / [5]BRAKE_REPRESS / [0]NOTHING

%% Åò4-1-1-2-2 Call variables to analyze (1.Long_accel, 2.Accelerator Pedal Operation)
%Define accelx here
f_type = 'var'; f_target = 'ego'; f_var = 'accelx'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
var_accx = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
if isempty(var_accx) == 1
   var_accx = zeros(length(var_time(:)),1);
end

%Define APO here
f_type = 'var'; f_target = 'ego'; f_var = 'apo'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = ff_set_mindx(f_type, f_target, f_var, f_ilv, M_data);
var_apo = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;
if isempty(var_apo) == 1
   var_apo = zeros(length(var_time(:)),1);
end

dt_0 = dt;

%% Åò4-1-1-2-3 State transition sequence
try
    for i = 1 : length(var_time)
       %% Åò4-1-1-2-3-1 Determine if vehicle is in motion or not
        if var_ego_speed(i) > 1.0    
            %Begin GOBO analysis here
            if i>1  
              %% Åò4-1-1-2-3-1-1 General entry/dip decision making (Must come from Gas OFF or Brake OFF) after first row
              %% Åò4-1-1-2-3-1-1-1 === GAS ON state [1] ===
                if (var_accx(i) >= gon_G && var_accx(i) < grepress_G) && timer_gof0 > time_ope_buffer
                    % If state transitions from BON, store values in vector
                    if i~= 1
                        if ope_state(i-1) == 2.0 
                            if k_grp == 1
                                timer_grp(k_grp)   = timer_grp0;
                            else
                                timer_grp(k_grp-1) = timer_grp0;
                            end
                            timer_grp0 = 0;
                        end                       
                        if ope_state(i-1) == 3.0 
                            var_time_gof(k_gof)    = var_time(i);
                            if k_gof == 1
                                timer_gof(k_gof)   = timer_gof0;
                            else
                                timer_gof(k_gof-1) = timer_gof0;
                            end
                            timer_gof0 = 0;
                        end
                        if ope_state(i-1) == 4.0
                            var_time_bon(k_bon)    = var_time(i);
                            if k_bon == 1
                                timer_bon(k_bon)   = timer_bon0;
                            else
                                timer_bon(k_bon-1) = timer_bon0;
                            end
                            timer_bon0 = 0;
                        end
                        if ope_state(i-1) == 5.0
                            var_time_brp(k_brp)    = var_time(i);
                            if k_brp == 1
                                timer_brp(k_brp)   = timer_brp0;
                            else
                                timer_brp(k_brp-1) = timer_brp0;
                            end
                            timer_brp0 = 0;
                        end
                    end
                    % Accel ON state
                    if timer_gon0 < time_ope_buffer
                        ope_state(i) = 1.0;
                        % If timer is empty, begin incrementing sequence
                        if timer_gon0 == 0
                            k_gon = k_gon + 1;
                            var_time_gon(k_gon-1) = var_time(i);
                        end
                        timer_gon0 = timer_gon0 + dt;
                    else
                        ope_state(i) = 1.0;
                        timer_gon0 = timer_gon0 + dt;
                    end
              %% Åò4-1-1-2-3-1-1-2 === GAS REPRESS state [2] ===
                elseif var_accx(i) >= grepress_G && timer_grp0 < time_ope_buffer
                    % If state transitions from GON,store values in vector
                    if i~= 1
                        if ope_state(i-1) == 1.0
                            if k_gon == 1
                                timer_gon(k_gon)   = timer_gon0;
                            else
                                timer_gon(k_gon-1) = timer_gon0;
                            end
                            timer_gon0 = 0;
                        end
                        if ope_state(i-1) == 3.0 
                            if k_gof == 1
                                timer_gof(k_gof)   = timer_gof0;
                            else
                                timer_gof(k_gof-1) = timer_gof0;
                            end
                            timer_gof0 = 0;
                        end                       
                        if ope_state(i-1) == 4.0
                            var_time_bon(k_bon)    = var_time(i);
                            if k_bon == 1
                                timer_bon(k_bon)   = timer_bon0;
                            else
                                timer_bon(k_bon-1) = timer_bon0;
                            end
                            timer_bon0 = 0;
                        end
                        if ope_state(i-1) == 5.0
                            var_time_brp(k_brp)    = var_time(i);
                            if k_brp == 1
                                timer_brp(k_brp)   = timer_brp0;
                            else
                                timer_brp(k_brp-1) = timer_brp0;
                            end
                            timer_brp0 = 0;
                        end                       
                    end
                    % Accel REPRESS state
                    if timer_grp0 < time_ope_buffer
                        ope_state(i) = 2.0;
                        if timer_grp0 == 0
                            k_grp = k_grp + 1;
                            var_time_grp(k_grp-1) = var_time(i);
                        end
                        timer_grp0 = timer_grp0 + dt;
                    else
                        ope_state(i) = 2.0;
                        timer_grp0 = timer_grp0 + dt;
                    end                 
              %% Åò4-1-1-2-3-1-1-3 === GAS OFF state [3] ===
                elseif var_accx(i) < 0 && var_accx(i) >= coast_G && timer_gof0 < time_ope_buffer
                % If state transitions from BON, store values in vector
                    if i~= 1
                        if ope_state(i-1) == 1.0                %Coming from acceleration
                            %if timer_gon0 > time_ope_buffer
                                if k_gon == 1
                                   timer_gon(k_gon)   = timer_gon0;
                                else
                                   timer_gon(k_gon-1) = timer_gon0;     
                                end    
                                timer_gon0 = 0;
                            %end
                        end                         
                        if ope_state(i-1) == 2.0                %Coming from acceleration (REPRESS)
                            if k_grp == 1
                                timer_grp(k_grp)   = timer_grp0;
                            else
                                timer_grp(k_grp-1) = timer_grp0;     
                            end    
                            timer_grp0 = 0;
                        end                       
                        if ope_state(i-1) == 4.0                %Coming from braking
                            if k_bon == 1
                                timer_bon(k_bon)   = timer_bon0;
                            else
                                timer_bon(k_bon-1) = timer_bon0;     
                            end    
                            timer_bon0 = 0;
                        end
                        if ope_state(i-1) == 5.0                %Coming from braking (REPRESS)
                            if k_brp == 1
                                timer_brp(k_brp)   = timer_brp0;
                            else
                                timer_brp(k_brp-1) = timer_brp0;     
                            end    
                            timer_brp0 = 0;
                        end                       
                    end
                    % Recurring Lift Off state
                    if timer_gon0 > time_ope_buffer                   % Check to see if the state is still at GAS ON state (GON)
                        if timer_gof0 < time_ope_buffer                   % If timer_gof is less than the set time_ope_buffer
                            if timer_gof0 == 0                                % If a new gas off sequence is detected
                                k_gof = k_gof + 1;                                % Increment gas off counter
                                timer_gof0 = dt;                                  % Add dt to timer_gof
                                var_time_gof(k_gof-1) = var_time(i);              % Store the time when gof begins
                            else   
                                timer_gof0 = timer_gof0 + dt;                 % If the timer_gof is still continuing, increment by dt
                            end
                        else                                              % If timer_gof is greater than time_ope_buffer
                            if isempty(timer_gof)                             
                                timer_gof(k_gof-1) = timer_gof0;              % If first gof detection, store as zeroth value
                            else
                                timer_gof(k_gof)   = timer_gof0;              % Otherwise, store regularly
                            end
                            timer_gof0 = 0;                               % Reset timer
                            var_time_gof(k_gof)    = var_time(i);         % Store time of occurence
                            k_gof = k_gof + 1;                            % Increment k_gof counter
                        end
                        ope_state(i) = 3.0;                               % Set state to gof
                    else
                        ope_state(i) = 2.0;                           % Otherwise, keep it at GAS ON state (GON)
                        timer_gon0 = timer_gon0 + dt;
                    end
              %% Åò4-1-1-2-3-1-1-4 === BRAKE ON state [4] ===   
                elseif var_apo(i) == 0 && var_accx(i) < coast_G && var_accx(i) > brepress_G && timer_gof0 > time_ope_buffer
                    if i~= 1
                        if ope_state(i-1) == 1.0                 % Coming from accel side
                           if k_gon == 1
                               timer_gon(k_gon)   = timer_gon0;
                           else
                               timer_gon(k_gon-1) = timer_gon0;     
                           end    
                           timer_gon0 = 0;
                        end                         
                        if ope_state(i-1) == 2.0                 % Coming from accel side (REPRESS)
                            if k_grp == 1
                                timer_grp(k_grp)   = timer_grp0;
                            else
                                timer_grp(k_grp-1) = timer_grp0;     
                            end    
                            timer_grp0 = 0;
                        end                         
                        if ope_state(i-1) == 3.0                 % Coming from cruising
                            if isempty(timer_gof)
                                timer_gof(k_gof) = timer_gof0;
                            else
                                timer_gof(k_gof-1) = timer_gof0;
                            end   
                            timer_gof0 = 0;
                        end
                        if ope_state(i-1) == 5.0                 % Coming from braking (REPRESS)
                            if isempty(timer_brp)
                                timer_brp(k_brp) = timer_brp0;
                            else
                                timer_brp(k_brp-1) = timer_brp0;
                            end   
                            timer_brp0 = 0;
                        end                       
                    end
                    % Brake ON state
                    if timer_bon0 < time_ope_buffer
                        ope_state(i) = 4.0;
                        if timer_bon0 == 0
                             k_bon = k_bon + 1;
                             var_time_bon(k_bon-1) = var_time(i);
                        end
                        timer_bon0 = timer_bon0 + dt;
                    else
                        ope_state(i) = 4.0;
                        timer_bon0 = timer_bon0 + dt;
                    end
              %% Åò4-1-1-2-3-1-1-5 === BRAKE REPRESS state [5] ===
                elseif var_apo(i) == 0 && var_accx(i) <= brepress_G && timer_gof0 > time_ope_buffer
                %  If state transitions from GOF, store values in vector
                    if i~= 1
                        if ope_state(i-1) == 1.0                % Coming from accel side
                            if k_gon == 1
                                timer_gon(k_gon)   = timer_gon0;
                            else
                                timer_gon(k_gon-1) = timer_gon0;     
                            end    
                            timer_gon0 = 0;
                        end                         
                        if ope_state(i-1) == 2.0                % Coming from accel side (REPRESS)
                            if k_grp == 1
                                timer_grp(k_grp)   = timer_grp0;
                            else
                                timer_grp(k_grp-1) = timer_grp0;     
                            end    
                            timer_grp0 = 0;
                        end                        
                        if ope_state(i-1) == 3.0
                            if isempty(timer_gof)
                                timer_gof(k_gof) = timer_gof0;
                            else
                                timer_gof(k_gof-1) = timer_gof0;
                            end   
                            timer_gof0 = 0;
                        end
                        if ope_state(i-1) == 4.0
                           if isempty(timer_bon)
                               timer_bon(k_bon) = timer_bon0;
                           else
                               timer_bon(k_bon-1) = timer_bon0;
                           end   
                           timer_bon0 = 0;
                        end                       
                    end
                    % Brake REPRESS state
                    if timer_brp0 < time_ope_buffer
                        ope_state(i) = 5.0;
                            if timer_brp0 == 0
                                k_brp = k_brp + 1;
                                var_time_brp(k_brp-1) = var_time(i);
                            end
                        timer_brp0 = timer_brp0 + dt;
                    else
                        ope_state(i) = 5.0;
                        timer_brp0 = timer_brp0 + dt;
                    end
                else
              %% Åò4-1-1-2-3-1-1-6 General entry/dip decision making === TIMER CONTINUATION (No state change and state timer is less than time_ope_buffer) ===   
              %% Åò4-1-1-2-3-1-1-6-1 Do timer changes here for all states
                    if var_accx(i) >= coast_G && var_accx(i) < 0
                        sw_value = 3.0;       % Coasting
                    elseif var_accx(i) < coast_G  && var_accx(i) > brepress_G
                        sw_value = 4.0;       % Brake ON
                    elseif var_accx(i) <= brepress_G
                        sw_value = 5.0;       % Brake REPRESS
                    elseif var_accx(i) >= grepress_G
                        sw_value = 2.0;       % Throttle REPRESS
                    elseif var_accx(i) >= 0 && var_accx(i) < grepress_G
                        sw_value = 1.0;       % Throttle ON
                    end
                    switch(sw_value)
              %% Åò4-1-1-2-3-1-1-6-2 === GAS REPRESS state [2] ===
                        case 2
                            % REPRESS
                            ope_state(i) = 2.0;
                            if ope_state(i-1) == 1.0
                                if k_gon == 1
                                    timer_gon(k_gon) = timer_gon0;
                                else
                                    timer_gon(k_gon-1) = timer_gon0;
                                end
                                timer_gon0 = 0;
                            end                             
                            if ope_state(i-1) == 3.0
                                if k_gof == 1
                                    timer_gof(k_gof) = timer_gof0;
                                else
                                    timer_bof(k_gof-1) = timer_gof0;
                                end
                                timer_gof0 = 0;
                            end                           
                            if ope_state(i-1) == 4.0
                                if k_bon == 1
                                    timer_bon(k_bon) = timer_bon0;
                                else
                                    timer_bon(k_bon-1) = timer_bon0;
                                end
                                timer_bon0 = 0;
                            end
                            % BRP
                            if ope_state(i-1) == 5.0
                                if k_brp == 1
                                    timer_brp(k_brp) = timer_brp0;
                                    k_brp = k_brp + 1;
                                else
                                    timer_brp(k_brp-1) = timer_brp0;
                                end
                                timer_brp0 = 0;
                                k_brp = k_brp + 1;
                            end
                            % Increment Accel REPRESS counter
                            if timer_grp0 == 0
                                var_time_grp(k_grp) = var_time(i);
                                k_grp = k_grp + 1;
                            end
                            timer_grp0 = timer_grp0 + dt;                       
              %% Åò4-1-1-2-3-1-1-6-3 === GAS OFF state [3] ===
                        case 3
                            % Coasting
                            ope_state(i) = 3.0;
                            if ope_state(i-1) == 1.0
                                if k_gon == 1
                                    timer_gon(k_gon) = timer_gon0;
                                else
                                    timer_gon(k_gon-1) = timer_gon0;
                                end
                                timer_gon0 = 0;
                            end                             
                            if ope_state(i-1) == 2.0
                                if k_grp == 1
                                    timer_grp(k_grp) = timer_grp0;
                                else
                                    timer_grp(k_grp-1) = timer_grp0;
                                end
                                timer_grp0 = 0;
                            end                           
                            if ope_state(i-1) == 4.0
                                if k_bon == 1
                                    timer_bon(k_bon) = timer_bon0;
                                else
                                    timer_bon(k_bon-1) = timer_bon0;
                                end
                                timer_bon0 = 0;
                                k_bon = k_bon + 1;
                            end
                            % BRP
                            if ope_state(i-1) == 5.0
                                if k_brp == 1
                                   timer_brp(k_brp) = timer_brp0;
                                else
                                   timer_brp(k_brp-1) = timer_brp0;
                                end
                                timer_brp0 = 0;
                            end
                            % Increment Coasting (GOF) counter
                            if timer_gof0 == 0
                                var_time_gof(k_gof) = var_time(i);
                                k_gof = k_gof + 1;
                            end
                            timer_gof0 = timer_gof0 + dt;
              %% Åò4-1-1-2-3-1-1-6-4 === BRAKE ON state [4] ===    
                        case 4                       
                            % Braking
                            ope_state(i) = 4.0;
                            if ope_state(i-1) == 1.0
                                if k_gon == 1
                                    timer_gon(k_gon) = timer_gon0;
                                else
                                    timer_gon(k_gon-1) = timer_gon0;
                                end
                                timer_gon0 = 0;
                            end                           
                            if ope_state(i-1) == 2.0
                                if k_grp == 1
                                    timer_grp(k_grp) = timer_grp0;
                                else
                                    timer_grp(k_grp-1) = timer_grp0;
                                end
                                timer_grp0 = 0;
                            end
                            if ope_state(i-1) == 3.0
                                if k_gof == 1
                                    timer_gof(k_gof) = timer_gof0;
                                else
                                    timer_gof(k_gof-1) = timer_gof0;
                                end
                                timer_gof0 = 0;
                            end                           
                            if ope_state(i-1) == 5.0
                                if k_brp == 1
                                    timer_brp(k_brp) = timer_brp0;
                                else
                                    timer_brp(k_brp-1) = timer_brp0;
                                end
                                timer_brp0 = 0;
                            end                           
                            if timer_bon0 == 0
                                % Start of brake ON
                                var_time_bon(k_bon) = var_time(i);
                                k_bon = k_bon + 1;
                                % end
                            end
                            timer_bon0 = timer_bon0 + dt;
              %% Åò4-1-1-2-3-1-1-6-5 === BRAKE REPRESS state [5] ===   
                        case 5                       
                            % Brake repress
                            ope_state(i) = 5.0;
                            if ope_state(i-1) == 1.0
                                if k_gon == 1
                                    timer_gon(k_gon) = timer_gon0;
                                else
                                    timer_gon(k_gon-1) = timer_gon0;
                                end
                                timer_gon0 = 0;
                            end                           
                            if ope_state(i-1) == 2.0
                                if k_grp == 1
                                    timer_grp(k_grp) = timer_grp0;
                                else
                                    timer_grp(k_grp-1) = timer_grp0;
                                end
                                timer_grp0 = 0;
                            end                           
                            if ope_state(i-1) == 3.0
                                if k_gof == 1
                                    timer_gof(k_gof) = timer_gof0;
                                else
                                    timer_gof(k_gof-1) = timer_gof0;
                                end
                                timer_gof0 = 0;
                            end
                            if ope_state(i-1) == 4.0
                                if k_bon == 1
                                    timer_bon(k_bon) = timer_bon0;
                                else
                                    timer_bon(k_bon-1) = timer_bon0;
                                end
                                timer_bon0 = 0;
                            end                           
                            if timer_brp0 == 0
                                % Start of brake REPRESS
                                var_time_brp(k_brp) = var_time(i);
                                k_brp = k_brp + 1;
                                % end
                            end
                            timer_brp0 = timer_brp0 + dt;                           
              %% Åò4-1-1-2-3-1-1-6-6  === GAS ON state [1] === 
                        case 1
                            % Accel ON
                            ope_state(i) = 1.0;
                            if ope_state(i-1) == 2.0
                                if k_grp == 1
                                    timer_grp(k_grp) = timer_grp0;
                                else
                                    timer_grp(k_grp-1) = timer_grp0;
                                end
                                timer_grp0 = 0;
                            end
                            if ope_state(i-1) == 3.0
                                if k_gof == 1
                                    timer_gof(k_gof) = timer_gof0;
                                else
                                    timer_gof(k_gof-1) = timer_gof0;
                                end
                                timer_gof0 = 0;
                            end
                            if ope_state(i-1) == 4.0
                                if k_bon == 1
                                    timer_bon(k_bon) = timer_bon0;
                                else
                                    timer_bon(k_bon-1) = timer_bon0;
                                end
                                timer_bon0 = 0;
                            end
                            if ope_state(i-1) == 5.0
                                if k_brp == 1
                                    timer_brp(k_brp) = timer_brp0;
                                else
                                    timer_brp(k_brp-1) = timer_brp0;
                                end
                                timer_brp0 = 0;
                            end                            
                            if timer_gon0 == 0
                                % Start of ACCEL ON
                                var_time_gon(k_gon) = var_time(i);
                                k_gon = k_gon + 1;
                                % end
                            end
                            timer_gon0 = timer_gon0 + dt;
                    end
                end
            elseif i == 1
          %% Åò4-1-1-2-3-1-2  General entry/dip decision making (Must come from Gas OFF or Brake OFF) during the first row
                if var_accx(i) >= gon_G && var_accx(i) < grepress_G   
                 %% Åò4-1-1-2-3-1-2-1 === GAS ON state [1] ===
                    ope_state(i) = 1.0;
                    var_time_gon(k_gon) = var_time(i);
                    timer_gon(k_gon) = timer_gon0;
                    if k_gon == 1
                        timer_gon0 = dt;
                    elseif timer_gon0 == []
                        timer_gon0 = dt;
                    else
                        timer_go0 = timer_gon0 + dt;
                    end
                    k_gon = k_gon + 1;
                elseif var_accx(i) >= grepress_G
                 %% Åò4-1-1-2-3-1-2-2 === GAS REPRESS state [2] ===
                    ope_state(i) = 2.0;
                    var_time_grp(k_grp) = var_time(i);
                    timer_grp(k_grp) = timer_grp0;
                    if k_grp == 1
                        timer_grp0 = dt;
                    elseif timer_grp0 == []
                        timer_grp0 = dt;
                    else
                        timer_grp0 = timer_grp0 + dt;
                    end
                    k_grp = k_grp + 1;
                elseif var_apo(i) == 0 && var_accx(i) >= coast_G
                 %% Åò4-1-1-2-3-1-2-3 === GAS OFF state [3] ===
                    ope_state(i) = 3.0;
                    var_time_gof(k_gof) = var_time(i);
                    timer_gof(k_gof) = timer_gof0;                   
                    if k_gof == 1
                        timer_gof0 = dt;
                    elseif timer_gof0 == []
                        timer_gof0 = dt;
                    else
                        timer_gof0 = timer_gof0 + dt;
                    end
                    k_gof = k_gof + 1;
                elseif var_apo(i) == 0 && var_accx(i) < coast_G && var_accx(i) > brepress_G
                 %% Åò4-1-1-2-3-1-2-4 === BRAKE ON state [4] ===
                    ope_state(i) = 4.0;
                    var_time_bon(k_bon) = var_time(i);
                    timer_bon(k_bon) = timer_bon0;                   
                    if k_bon == 1
                        timer_bon0 = dt;
                    elseif timer_bon0 == []
                        timer_bon0 = dt;
                    else
                        timer_bon0 = timer_bon0 + dt;
                    end
                    k_bon = k_bon + 1;
                elseif var_apo(i) == 0 && var_accx(i) <= brepress_G
                 %% Åò4-1-1-2-3-1-2-5 === BRAKE REPRESS state [5] ===
                    ope_state(i) = 5.0;
                    var_time_brp(k_brp) = var_time(i);
                    timer_brp(k_brp) = timer_brp0;                   
                    if k_brp == 1
                        timer_brp0 = dt;
                    elseif timer_brp0 == []
                        timer_brp0 = dt;
                    else
                        timer_brp0 = timer_brp0 + dt;
                    end
                    k_brp = k_brp + 1;
                else
                 %% Åò4-1-1-2-3-1-2-6 === NOTHING state [0] ===                
                    ope_state(i) = 0.0;  %Nothing
                end
            end
        else
       %% Åò4-1-1-2-3-2 If vehicle is not in motion but pedal is pressed === GAS ON [1] or GAS REPRESS [2] ===
            if var_apo(i) > 0
                if var_accx(i) >= grepress_G
                    ope_state(i) = 2.0;
                        if k_grp == 1
                            timer_grp(k_grp) = timer_gon0;
                        else
                            timer_grp(k_grp - 1) = timer_grp0;
                        end
                else
                    ope_state(i) = 1.0;
                        if k_gon == 1
                            timer_gon(k_gon) = timer_gon0;
                        else
                            timer_gon(k_gon - 1) = timer_gon0;
                        end
                end
            else
       %% Åò4-1-1-2-3-3 If vehicle is not in motion after second time-step === Continue to increment timer ===                
                % After second loop (Does not increase k_ counter)
                if i~= 1
                    if ope_state(i-1) == 1.0
                        if k_gon == 1
                            timer_gon(k_gon) = timer_gon0;
                        else
                            timer_gon(k_gon - 1) = timer_gon0;
                        end
                        timer_gon0 = 0;
                    elseif ope_state(i-1) == 2.0
                        if k_grp == 1
                            timer_grp(k_grp) = timer_grp0;
                        else
                            timer_grp(k_grp-1) = timer_grp0;
                        end
                        timer_grp0 = 0;
                    elseif ope_state(i-1) == 3.0
                        if k_gof == 1
                            timer_gof(k_gof) = timer_gof0;
                        else
                            timer_gof(k_gof-1) = timer_gof0;
                        end
                        timer_gof0 = 0;
                    elseif ope_state(i-1) == 4.0
                        if k_bon == 1 
                            timer_bon(k_bon) = timer_bon0;
                        else
                            timer_bon(k_bon-1) = timer_bon0;
                        end
                        timer_bon0 = 0;
                    elseif ope_state(i-1) == 5.0
                        if k_brp == 1
                            timer_brp(k_brp) = timer_brp0;
                        else
                            timer_brp(k_brp-1) = timer_brp0;
                        end
                        timer_brp0 = 0;                       
                    end
                end
                ope_state(i) = 0.0;   % If there is no lead vehicle out in front
            end
        end
       %% Åò4-1-1-2-4 If final value in time-series
        if i == length(var_time)
            if ope_state(i-1) == 1.0
                var_time_gon(k_gon) = var_time(i);
                timer_gon(k_gon) = timer_gon0;
                k_gon = k_gon + 1;
                timer_gon0 = 0;
            elseif ope_state(i-1) == 2.0
                var_time_grp(k_grp) = var_time(i);
                timer_grp(k_grp) = timer_grp0;
                k_grp = k_grp + 1;
                timer_grp0 = 0;
            elseif ope_state(i-1) == 3.0
                var_time_gof(k_gof) = var_time(i);
                timer_gof(k_gof) = timer_gof0;
                k_gof = k_gof + 1;
                timer_gof0 = 0;
            elseif ope_state(i-1) == 4.0
                var_time_bon(k_bon) = var_time(i);
                timer_bon(k_bon) = timer_bon0; 
                k_bon = k_bon + 1;
                timer_bon0 = 0;
            elseif ope_state(i-1) == 5.0
                var_time_brp(k_brp) = var_time(i);
                timer_brp(k_brp) = timer_brp0; 
                k_brp = k_brp + 1;
                timer_brp0 = 0;               
            end
        end
    end
catch
    fprintf('f_gobo: There was an error at i == %i', i);
end

ope_state = transpose(ope_state);

end