function [vsp, dvsp, vsp_valid, dt]  = f_am3_1_calc_dvsp(var_time, var_ego_vel, var_ego_accelx) 
%% Should implement a try catch sequence here
time = var_time;
vsp  = var_ego_vel;
%% NaN post-processing
%%s.otani If NaN exists, remove and replace with linear interpolation
nans      = isnan(vsp);
vsp(nans) = interp1(time(~nans), vsp(~nans), time(nans));

%% Discretize acceleration values
  %Acceleration-------------------------------------------------------------  
  dt   = (time(2)-time(1));        % Time unit(s)
  rt   = 1.0;                      % Time steps 30ms,40ms,50ms,60ms,100ms,120ms sampling rates
  dvsp = [];                       % Acceleration(m/s^2)
  dvsp = var_ego_accelx .* 9.8062;
    
  %Check for vsp validity--------------------------------------------------
  if max(vsp) == 0
      vsp_valid = 0;
  else
      vsp_valid = 1;
  end
  %----------------------------------------------------------------------           
end   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    