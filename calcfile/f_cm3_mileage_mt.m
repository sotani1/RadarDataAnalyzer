function out_mileage_mt = f_cm3_mileage_mt(vsp, dt)
%Calculates microtrips based on vsp values%

%% Initializing parameters
    out_mileage_mt = []; % Distance travelled per microtrip
    vsp_state      = []; % Speed state (0:Idle, 1:Transitj
    num_mt         =  1; % Number of micro trips
    vstate_rising  = []; % Upward slope edge
    vstate_falling = []; % Downward slope edge
   
%% Determining speed states 
    for i=1:length(vsp)
        if vsp(i) > 0
            vsp_state = [vsp_state;1];
        else
            vsp_state = [vsp_state;0];
        end
    end

%% Determining edge changes (Detect speed inflection states when vsp_state==1)
    %Log the first change in edge
    if vsp_state(1) == 1
        vstate_rising =[vstate_rising;1];
    end
    %Detect next change in edge
    for i=1:length(vsp_state)-1              
        if vsp_state(i) == 0 && vsp_state(i+1) == 1
            vstate_rising = [vstate_rising;i+1];
        end
        if vsp_state(i) == 1 && vsp_state(i+1) == 0
            vstate_falling = [vstate_falling;i];
        end
    end
    %If the vsp is reset while in motion
    if vsp_state(length(vsp_state)) == 1
        vstate_falling = [vstate_falling;length(vsp_state)];
    end
    
 %% Calculate distance travelled
    for i=1:length(vstate_rising)
        temp_mileage_mt = 0; 
        for n=vstate_rising(i):vstate_falling(i)
            temp_mileage_mt = temp_mileage_mt + vsp(n)*dt/3600;
        end
        out_mileage_mt = [out_mileage_mt;temp_mileage_mt];
    end
%% 
end
