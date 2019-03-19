function [ope_state, k_gof, timer_gof, k_bon, timer_bon, var_time_gof,var_time_bon] = f_gobo(var_time, var_ego_speed, M_data, dt, i_mt_plot)

thw_lim         = 999;     % Set measurable THW to 999 sec
coast_G         = -0.05;   % Sets coasting braking force to -0.04G
timer_gof       = [];      % Timer for gas OFF
timer_gof0      = 0; 
timer_bon       = [];      % Timer for brake ON
timer_bon0      = 0;
k_gof           = 1;       % Gas OFF counter
k_bon           = 1;       % Brake ON counter
var_time_gof    = [];      
var_time_bon    = [];
time_ope_buffer = 1.0;     % Timer buffer to avoid frequent counting (0.5 sec)
ope_state       = [];      % (1)APO/(2)LO/(3)BK/(0)Not car-following operation state here

%Define THW here
f_type = 'var'; f_target = 'lead'; f_var = 'thw_inv'; f_ilv = 'ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
var_thw = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;

%Define accelx here
f_type = 'var'; f_target = 'ego'; f_var = 'accelx'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
var_accx = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;

%Define APO here
f_type = 'var'; f_target = 'ego'; f_var = 'apo'; f_ilv = 'non_ilv' ;
[ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
var_apo = M_data(i_mt_plot).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data;


try
    for i = 1 : length(var_time)
        if i==34
            i=i*1;
        end
       if k_bon == 2
           k_bon = k_bon*1;
       end
       %This determines if car-following or not
       %if var_thw(i) <= thw_lim && var_ego_speed(i) > 1.0
       if var_ego_speed(i) > 1.0    
           %Begin GOBO analysis here
           if i>1
               % === ACCELEARATION 1.0 ===
               if var_apo(i) > 0
                   %If state transitions from BON,store values in vector
                   if i~= 1
                       if ope_state(i-1) == 3.0
                           var_time_bon(k_bon) = var_time(i);
                           %if isempty(timer_bon)
                           if k_bon == 1
                               %timer_bon(k_bon-1) = timer_bon0;
                               timer_bon(k_bon) = timer_bon0;
                           else
                               timer_bon(k_bon-1) = timer_bon0;
                           end
                           timer_bon0 = 0;
                       end
                   end
                   %If state transitions from GOF, store values in vector
                   if i~= 1
                       if ope_state(i-1) == 2.0 
                           var_time_gof(k_gof) = var_time(i);
                           %if isempty(timer_gof)
                           if k_gof == 1
                               timer_gof(k_gof) = timer_gof0;
                           else
                               timer_gof(k_gof-1) = timer_gof0;
                           end
                           timer_gof0 = 0;
                       end
                   end                   
                   %Accel state
                   ope_state(i) = 1.0;
               % === COASTING 2.0 ===
               elseif var_apo(i) == 0 && var_accx(i) >= coast_G && timer_bon0 > time_ope_buffer
                   %If state transitions from BON,store values in vector
                   if i~= 1
                       if ope_state(i-1) == 3.0                %Coming from braking side
                           if k_bon == 1
                               timer_bon(k_bon) = timer_bon0;
                           else
                               timer_bon(k_bon-1) = timer_bon0;     
                           end    
                           timer_bon0 = 0;
                       end
                   end
                   if var_apo(i-1) > 0
                       %First Lift Off state
                       ope_state(i) = 2.0;
                       if timer_gof0 == 0
                           %If entering the sequence for the first time
                           timer_gof0 = dt;
                           var_time_gof(k_gof) = var_time(i);
                           if isempty(timer_gof)
                               timer_gof(k_gof-1) = timer_gof0;
                           else
                               timer_gof(k_gof) = timer_gof0;
                           end
                           k_gof = k_gof + 1;
                       elseif timer_gof0 < time_ope_buffer
                           %Set timer to avoid chattering
                           timer_gof0 = timer_gof0 + dt;
                       else
                           timer_gof0 = timer_gof0 + dt;           % === Need breakpoint test here ===          
                       end    
                   else
                       %Recurring Lift Off state
                       if timer_gof0 < time_ope_buffer
                           if timer_gof0 == 0
                               k_gof = k_gof + 1;
                               timer_gof0 = dt;
                               var_time_gof(k_gof-1) = var_time(i);
                           else   
                               timer_gof0 = timer_gof0 + dt;
                           end
                       else
                           if isempty(timer_gof)
                               timer_gof(k_gof-1) = timer_gof0;
                           else
                               timer_gof(k_gof) = timer_gof0;
                           end
                           timer_gof0 = 0;                       %Reset timer
                           var_time_gof(k_gof) = var_time(i);
                           k_gof = k_gof + 1;                    %Increment k_gof counter
                       end
                       ope_state(i) = 2.0;
                   end
               % === BRAKING 3.0 ===    
               elseif var_apo(i) == 0 && var_accx(i) < coast_G && timer_gof0 > time_ope_buffer
                   %If state transitions from GOF, store values in vector
                   if i~= 1
                       if ope_state(i-1) == 2.0
                           if isempty(timer_gof)
                               timer_gof(k_gof-1) = timer_gof0;
                           else
                               timer_gof(k_gof-1)   = timer_gof0;
                           end   
                           timer_gof0 = 0;
                       end
                   end
                   %Brake ON state
                   if timer_bon0 < time_ope_buffer
                       ope_state(i) = 3.0;
                       if timer_bon0 == 0
                           k_bon = k_bon + 1;
                           var_time_bon(k_bon-1) = var_time(i);
                           %timer_bon(k_bon) = timer_bon0;
                       end
                       timer_bon0 = timer_bon0 + dt;
                   else
                       ope_state(i) = 3.0;
                       timer_bon0 = timer_bon0 + dt;
                   end
               else
                   %Do timer changes here for all states
                   if var_apo(i) == 0 && var_accx(i) >= coast_G
                       sw_value = 2.0;
                       if timer_bon0 ~= 0 && timer_bon0 < time_ope_buffer
                           sw_value = 3.0;
                       end
                   elseif var_apo(i) == 0 && var_accx(i) < coast_G  
                       sw_value = 3.0;
                   else
                       sw_value = 1;
                   end
                   switch(sw_value) 
                       % === COASTING (2) ===
                       case 2
                           ope_state(i) = 2.0;
                           if ope_state(i-1) == 3.0
                               timer_bon(k_bon) = timer_bon0;
                               timer_bon0 = 0;
                               k_bon = k_bon + 1;
                           end
                           if timer_gof0 == 0
                               var_time_gof(k_gof) = var_time(i);
                               k_gof = k_gof + 1;
                           end
                           timer_gof0 = timer_gof0 + dt;
                       % === BRAKING (3) ===    
                       case 3                       
                           ope_state(i) = 3.0;
                           if ope_state(i-1) == 2.0
                               if isempty(timer_gof)
                                   timer_gof(k_gof-1) = timer_gof0;
                               else
                                   timer_gof(k_gof-1) = timer_gof0;
                               end
                               timer_gof0 = 0;
                           end
                           if timer_bon0 == 0
                               %Start of brake ON
                               var_time_bon(k_bon) = var_time(i);
                               if timer_bon0 == 0 && k_bon ~= 1
                                   k_bon = k_bon + 1;
                               end
                           end
                           timer_bon0 = timer_bon0 + dt;
                       case 1
                       % === NEITHER (1) ===    
                           ope_state(i) = 1;
                   end    
               end
           elseif i == 1
               %for the first counter
               if var_apo(i) > 0 && var_accx(i) >= 0.4/9.8062
                   % Accel state
                   ope_state(i) = 1.0;
               elseif var_apo(i) == 0 && var_accx(i) >= coast_G
                   % Lift off state
                   ope_state(i) = 2.0;
                   var_time_gof(k_gof) = var_time(i);
                   timer_gof(k_gof) = timer_gof0;
                   k_gof = k_gof + 1;
                   if k_gof == 1
                       timer_gof0 = dt;
                   elseif timer_gof0 == []
                       timer_gof0 = dt;
                   else
                       timer_gof0 = timer_gof0 + dt;
                   end
               elseif var_apo(i) == 0 && var_accx(i) < coast_G
                   % Brake ON state
                   ope_state(i) = 3.0;
                   var_time_bon(k_bon) = var_time(i);
                   timer_bon(k_bon) = timer_bon0;
                   k_bon = k_bon + 1;
                   if k_bon == 1
                       timer_bon0 = dt;
                   elseif timer_bon0 == []
                       timer_bon0 = dt;
                   else
                       timer_bon0 = timer_bon0 + dt;
                   end
               else
                   ope_state(i) = 0.0;  %Nothing
               end
           end
       else
           if var_apo(i) > 0
               ope_state(i) = 1.0;
           else
               if i~= 1 
                   if ope_state(i-1) == 3.0
                       timer_bon(k_bon-1) = timer_bon0;
                       timer_bon0 = 0;
                   elseif ope_state(i-1) == 2.0
                       timer_gof(k_gof-1) = timer_gof0;
                       timer_gof0 = 0;
                   end
               end
               ope_state(i) = 0.0;   %If there is no lead vehicle out in front
           end
       end
       if i == length(var_time)
           if ope_state(i) == 2.0
               var_time_gof(k_gof) = var_time(i);
               timer_gof(k_gof) = timer_gof0;
               k_gof = k_gof + 1;
               timer_gof0 = 0;
           elseif ope_state(i-1) == 3.0
               var_time_bon(k_bon) = var_time(i);
               timer_bon(k_bon) = timer_bon0; 
               k_bon = k_bon + 1;
               timer_bon0 = 0;
           end
       end
    timer_gof_all(i) = timer_gof0;
    timer_bon_all(i) = timer_bon0;
    end
catch
    fprintf('There was an error at i == %i', i);
end

ope_state = transpose(ope_state);

end