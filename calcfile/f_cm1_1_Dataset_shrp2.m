function [vsp, dvsp, vsp_valid, dt]  = f_cm1_1_Dataset_shrp2(iflg_ftest, var_time, var_ego_vel, var_ego_accelx) 
%% Should implement a try catch sequence here
%Flag ftest_varname
if iflg_ftest == 1
    time = var_time;
    vsp  = var_ego_vel;
end
%% NaN post-processing
    %%s.otani If NaN exists, remove and replace with linear interpolation
    nans = isnan(vsp);
    vsp(nans) = interp1(time(~nans), vsp(~nans), time(nans));

%% Discretize acceleration values
  %Acceleration-------------------------------------------------------------  
  %dt = (time(2)-time(1))/1000; % Time unit(s)
  dt = (time(2)-time(1)); % Time unit(s)
  rt = 1.0;                    % Time steps 30ms,40ms,50ms,60ms,100ms,120ms sampling rates
        
  dvsp = [];                   % Acceleration(m/s^2)
  %for i=1:length(vsp)-rt/dt
  %    dvsp = [dvsp;(vsp(i+uint32(rt/dt))-vsp(i))/3.6/rt]; 
  %end
  dvsp = var_ego_accelx .* 9.8062;
    
  %Check for vsp validity--------------------------------------------------
  if max(vsp) == 0
      vsp_valid = 0;
  else
      vsp_valid = 1;
  end
  %----------------------------------------------------------------------           
end   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    