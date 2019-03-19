%fset_var(as_, var_, M_data, num_mt, mt_start, mt_end)
 
%% ˜2_2.1    Assigning values to variable array 
%% ˜2_2.1.1  Set global varaiable list
M_var_trackN_all        = getfield(var_,as_{4})+1;                        % array to determine total ILV counts
M_var_trackN_all_ones   = [];
M_var_time_ILV_all      = [];

%% ˜2_2.1.2  Read time vector
if flg_analysis_mode == 1
    try
        var_time                = getfield(var_,as_{1});                          % universal time variable
        %var_time                = var_time./1000;                                % convert to ms->sec          
        dt                      = (var_time(2)-var_time(1));                      % sampling time constant (sec) 
        %dt                      = (var_time(2)-var_time(1))/1000;                % sampling time constant (sec)
    catch
        var_time = [];
    end
end

%% ˜2_2.1.3  Read time sample
%CANape
if flg_analysis_mode == 1    
        dt                      = (var_time(2)-var_time(1));                     % sampling time constant (sec) 
end


%% ˜2_2.1.2  Set global ego variable list
var_ego_vel             = getfield(var_,as_{2});                                            % ego vehicle speed
var_ego_vel_interp      = fset_removenan(var_ego_vel, var_time);                            % ego vehicle speed with nan removed and interpolated
var_ego_vel_nan         = getfield(var_,as_{2});                                            % ego vehicle speed without nans (prep)
nans                    = isnan(var_ego_vel_nan);                                           % nan dummy variable
var_ego_vel_nan(nans)   = interp1(var_time(~nans), var_ego_vel_nan(~nans), var_time(nans)); % ego vehicle speed without nans (final)
var_ego_accelx          = getfield(var_,as_{3})./9.8062;                                    % ego vehicle acceleration_x [G]
var_ego_jerkx(1,1)      = NaN;                                                              % dummy declaration
var_ego_jerkx           = vertcat(var_ego_jerkx, diff(var_ego_accelx));                      % ego vhiecle jerk
var_ego_dist            = cumtrapz(var_time, var_ego_vel_interp./3.6);                      % ego vehicle distance travelled 
var_ego_dist_brake      = var_ego_dist;                                                     % dummy set up
var_ego_dist_brake(var_ego_accelx>=-0.01 & var_ego_vel_nan>=0.5)=NaN;                       % ego vehicle distance travelled during braking
var_ego_apo             = getfield(var_,as_{8});                                            % ego apo
var_ego_bksw            = getfield(var_,as_{7});                                            % brake switch 

try
    var_env_curvature   = getfield(var_,as_{9});                                            % Curvature
catch
    var_env_curvature   = [];
end
try
    var_env_latdist     = getfield(var_,as_{10});                                           % Lateral distance from left lane marking        
catch
    var_env_latdist     = [];
end
try
    var_env_width       = getfield(var_,as_{11});                                           % Lane width     
catch
    var_env_width       = [];
end
        
[num_mt, mt_start mt_end] = fcalc_mountain(var_ego_vel_nan, 0.1, flg_mtn);                  % find total number of mountains

%num_mt = 3;
%mt_start = var_.t(1);
%mt_end   = var_.t(end);

M_data = fnames_filednames(num_mt);                                                         % Declare M_data matrix 

%% ˜2_2.1.3  Set global ego variable list
for i_mt = 1:num_mt
    M_start = mt_start(i_mt);  % Microtrip start time
    M_end   = mt_end(i_mt);    % Microtrip end time
    %time
    M_var_time{int32(i_mt)}        = var_time(M_start:M_end);
    %====Ego====
    %Ego speedx
    f_type = 'var'; f_target = 'ego';    f_var = 'speedx'; f_ilv = 'non_ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_ego_vel_nan(M_start:M_end);
    %Ego accelerationx
    f_type = 'var'; f_target = 'ego';    f_var = 'accelx'; f_ilv = 'non_ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_ego_accelx(M_start:M_end);
    %Ego jerkx
    f_type = 'var'; f_target = 'ego';    f_var = 'jerkx'; f_ilv = 'non_ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_ego_jerkx(M_start:M_end);
    %Ego apo
    f_type = 'var'; f_target = 'ego';    f_var = 'apo'; f_ilv = 'non_ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_ego_apo(M_start:M_end);
    %Ego bksw
    f_type = 'var'; f_target = 'ego';    f_var = 'bksw'; f_ilv = 'non_ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_ego_bksw(M_start:M_end);
    %====Env====
    %Curve
    f_type = 'var'; f_target = 'env';    f_var = 'curve'; f_ilv = 'non_ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_env_curvature(M_start:M_end);    
    %Lateral distance from left centerline
    f_type = 'var'; f_target = 'env';    f_var = 'curve'; f_ilv = 'non_ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_env_latdist(M_start:M_end);    
    %Lane width
    f_type = 'var'; f_target = 'env';    f_var = 'width'; f_ilv = 'non_ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_env_latdist(M_start:M_end);    
       
    
%% ˜2_2.1.4  Set radar variable list (Please refer to cm1_varlist ˜1.1  to establish the column index)
    for i_tc=1:track_count
        asn_ctr = asn_org + length(i_asn)*(i_tc-1);
        % Get fields
        try
            var_trackN_posx         = getfield(var_,as_{asn_ctr+i_asn(1)});          % Nth track vehicle x position
        catch
            var_trackN_posx         = [];
        end
        try
            var_trackN_posy         = getfield(var_,as_{asn_ctr+i_asn(2)});          % Nth track vehicle y position
        catch
            var_trackN_posy         = [];
        end
        try
            var_trackN_velx_tmp     = getfield(var_,as_{asn_ctr+i_asn(3)});          % Nth track vehicle x speed increment
        catch
            var_trackN_velx_tmp     = [];
        end
        try
            var_trackN_velx         = var_ego_vel + (var_trackN_velx_tmp.*3.6);      % Nth track vehicle x speed adjusted to kph added ego vel 
        catch
            var_trackN_velx         = [];
        end
        try
            var_trackN_accx         = getfield(var_,as_{asn_ctr+i_asn(5)});          % Nth track vehicle acceleration
        catch
            var_trackN_accx(1,1)    = NaN;
            var_trackN_accx         = vertcat(var_trackN_accx,diff(var_trackN_velx));                          
        end
        try
            var_trackN_thw          = getfield(var_,as_{asn_ctr+i_asn(6)});          % Nth track vehicle thw
        catch
            var_trackN_thw          = var_trackN_posx ./ (var_ego_vel/3.6);
        end
        try
            var_trackN_ILV          = getfield(var_,as_{asn_ctr+i_asn(7)})+1;        % Nth track is lead vehicle
        catch
            var_trackN_ILV((getfield(var_,as_{i_asn(4)})+1)~=i_tc,1) = 2;            % Dummy
            var_trackN_ILV((getfield(var_,as_{i_asn(4)})+1)==i_tc,1) = 1;            % Assign all values equal to i_tc as one
            var_trackN_ILV((getfield(var_,as_{i_asn(4)})+1)~=i_tc,1) = 0;
            
            var_trackN_ILV(var_trackN_posx > 327,1) = 0;
            if i_tc == 1
                M_var_trackN_all_ones = var_trackN_ILV;
            else
                M_var_trackN_all_ones   =  M_var_trackN_all_ones + var_trackN_ILV;
            end
        end
        try
            var_trackN_lane         = getfield(var_,as_{asn_ctr+i_asn(8)});          % Nth track lane position
        catch
            var_trackN_lane         = [];
        end        
        %Calculated fields
        try
            var_trackN_ttc          = -1*(var_trackN_posx ./ var_trackN_velx_tmp) ;  % change sign if SHRP2 data
        catch
            var_trackN_ttc          = [];
        end
        try
            var_trackN_thw_inv      = 1./var_trackN_thw;                             % thw_inv  
        catch
            var_trackN_thw_inv      = [];
        end
        try
            var_trackN_ttc_inv      = 1./var_trackN_ttc;                             % ttc_inv
        catch
            var_trackN_ttc_inv      = [];
        end
        try
            var_trackN_ttc_delta(1,1)  = NaN;                                                 % dummy variable
            var_trackN_ttc_delta       = vertcat(var_trackN_ttc_delta,diff(var_trackN_ttc));  % Delta TTC
            var_trackN_ttc_delta(var_trackN_ttc_delta==0) = 1E-9;                             % cap zero value
            var_trackN_ttc_delta_inv   = 1./var_trackN_ttc_delta;                             % Delta TTC INV
            var_trackN_thw_delta(1,1)  = NaN;                                                 % dummy variable
            var_trackN_thw_delta       = vertcat(var_trackN_thw_delta,diff(var_trackN_thw));  % Delta THW
            var_trackN_thw_delta(var_trackN_thw_delta==0) = 1E-9;                             % cap zero value
            var_trackN_thw_delta_inv   = 1./var_trackN_thw_delta;                             % Delta THW INV            
        catch
            var_trackN_ttc_delta   = [];
            var_trackN_thw_delta   = [];
        end
        
        %====Recurring loop per track number====
        %Is lead vehicle (ILV)
        M_var_trackN_ILV{i_mt}  = var_trackN_ILV(M_start:M_end);
        %time
        M_var_time_ILV{i_mt}    = M_var_time{i_mt} .* M_var_trackN_ILV{i_mt};
        M_var_time_ILV{i_mt}(M_var_time_ILV{i_mt} == 0) = NaN;
        
            if i_tc == 1
                M_var_time_ILV_all{i_mt} = M_var_time_ILV{i_mt};
            else
                M_var_time_ILV_all{i_mt} = nansum([M_var_time_ILV_all{i_mt}  M_var_time_ILV{i_mt}],2);
            end
            M_var_time_ILV_all{i_mt}(M_var_time_ILV_all{i_mt} == 0) = NaN;

        clear i_tc_tmp
        
        %Is Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'ILV'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_ILV(M_start:M_end);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        %Speed Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'speedx'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_velx(M_start:M_end);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        %Speed Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'speedx'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_velx(M_start:M_end) .* M_var_trackN_ILV{i_mt};
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        %Accelerataion_x Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'accelx'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_accx(M_start:M_end);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        M_var_temp = var_trackN_accx(M_start:M_end);
        M_var_temp(M_var_temp == 0) = NaN;
        %Accelerataion_x Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'accelx'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_var_temp .* M_var_trackN_ILV{i_mt};
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        %X_POS Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'posx'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_posx(M_start:M_end);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        M_var_temp = var_trackN_posx(M_start:M_end);
        M_var_temp(M_var_temp == 0) = NaN;
        %X_POS Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'posx'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_var_temp .* M_var_trackN_ILV{i_mt};
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        %Y_POS Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'posy'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_posy(M_start:M_end);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        M_var_temp = var_trackN_posy(M_start:M_end);
        M_var_temp(M_var_temp == 0) = NaN;
        %Y_POS Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'posy'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_var_temp .* M_var_trackN_ILV{i_mt};
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;        
        %X_VEL Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'speedx'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data     = var_trackN_velx(M_start:M_end);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        M_var_temp = var_trackN_velx(M_start:M_end);
        M_var_temp(M_var_temp == 0) = NaN;
        %X_VEL Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'speedx'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_var_temp .* M_var_trackN_ILV{i_mt};
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        %Headway Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'thw'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_thw(M_start:M_end);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        M_var_temp = var_trackN_thw(M_start:M_end);
        M_var_temp(M_var_temp == 0) = NaN;
        %Headway Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'thw'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_var_temp .* M_var_trackN_ILV{i_mt};
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        %Headway_INV Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'thw_inv'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_thw_inv(M_start:M_end);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        M_var_temp = var_trackN_thw_inv(M_start:M_end);
        M_var_temp(M_var_temp == 0) = NaN;
        %Headway_INV Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'thw_inv'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_var_temp .* M_var_trackN_ILV{i_mt};
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        %TTC Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'ttc'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_ttc(M_start:M_end);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        M_var_temp = var_trackN_ttc(M_start:M_end);
        M_var_temp(M_var_temp == 0) = NaN;   
        %TTC Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'ttc'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_var_temp .* M_var_trackN_ILV{i_mt};
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        %TTC_INV Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'ttc_inv'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_ttc_inv(M_start:M_end);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        M_var_temp = var_trackN_ttc_inv(M_start:M_end);
        M_var_temp(M_var_temp == 0) = NaN;
        %TTC_INV Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'ttc_inv'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_var_temp .* M_var_trackN_ILV{i_mt};
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        %TTC_DELTA Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'ttc_delta'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_ttc_delta(M_start:M_end);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        M_var_temp = var_trackN_ttc_delta(M_start:M_end);
        M_var_temp(M_var_temp == 0) = NaN;
        %TTC_DELTA Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'ttc_delta'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_var_temp .* M_var_trackN_ILV{i_mt};
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;        
        %THW_DELTA Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'thw_delta'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_thw_delta(M_start:M_end);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        M_var_temp = var_trackN_thw_delta(M_start:M_end);
        M_var_temp(M_var_temp == 0) = NaN;
        %THW_DELTA Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'thw_delta'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_var_temp .* M_var_trackN_ILV{i_mt};
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;                        
        %TTC_DELTA_INV Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'ttc_delta_inv'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_ttc_delta_inv(M_start:M_end);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        M_var_temp = var_trackN_ttc_delta_inv(M_start:M_end);
        M_var_temp(M_var_temp == 0) = NaN;
        %TTC_DELTA_INV Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'ttc_delta_inv'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_var_temp .* M_var_trackN_ILV{i_mt};
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;        
        %THW_DELTA_INV Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'thw_delta_inv'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_thw_delta_inv(M_start:M_end);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        M_var_temp = var_trackN_thw_delta_inv(M_start:M_end);
        M_var_temp(M_var_temp == 0) = NaN;
        %THW_DELTA_INV Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'thw_delta_inv'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_var_temp .* M_var_trackN_ILV{i_mt};
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;                                
        
        clear i_tc f_type f_target f_var f_ilv ind_ftype ind_ftarget ind_fvar ind_filv 
        clear var_trackN_accx var_trackN_lane var_trackN_posx var_trackN_posy var_trackN_thw var_trackN_thw_inv var_trackN_velx var_trackN_velx_tmp
    end
    %% ˜2_2.1.5  Set global ILV variable list
    %================= ILV variables =====================
    %Speed Ego Vehicle ILV
    f_type = 'var'; f_target = 'ego'; f_var = 'speedx'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_ego_vel(M_start:M_end).* M_var_trackN_all_ones(M_start:M_end);
    M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
    %Accelerationx Ego Vehicle ILV
    f_type = 'var'; f_target = 'ego'; f_var = 'accelx'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_ego_accelx(M_start:M_end).* M_var_trackN_all_ones(M_start:M_end);
    M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
    %Jerkx Ego Vehicle ILV
    f_type = 'var'; f_target = 'ego'; f_var = 'jerkx'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_ego_jerkx(M_start:M_end).* M_var_trackN_all_ones(M_start:M_end);
    M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
    %====Env====
    %Curve
    f_type = 'var'; f_target = 'env';    f_var = 'curve'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_env_curvature(M_start:M_end);    
    %Lateral distance from left centerline
    f_type = 'var'; f_target = 'env';    f_var = 'curve'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_env_latdist(M_start:M_end);    
    %Lane width
    f_type = 'var'; f_target = 'env';    f_var = 'width'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_env_latdist(M_start:M_end);  
    %% ˜2_2.1.6  Set Lead variable list
    %Lead Vehicle ILV
    for i_tc_tmp2 = 1:track_count
        %ILV flag addition
        f_type = 'var' ; f_target = 'lead' ; f_var = 'ILV' ; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);        
        f_type2 = 'var'; f_target2 = strcat('track',num2str(i_tc_tmp2)); f_var2 = 'ILV'; f_ilv2 = 'ilv' ;
        [ind_ftype2, ind_ftarget2, ind_fvar2, ind_filv2] = fset_mindx(f_type2, f_target2, f_var2, f_ilv2, M_data);
        trackN_ILV_tmp = M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data;
        %Input into M_data
        if i_tc_tmp2 == 1
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = i_tc_tmp2 .* int32(trackN_ILV_tmp);
        else    
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data + i_tc_tmp2 .* int32(trackN_ILV_tmp);
        end
        %Convert 0 to NaN
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
    end
   
    %posx
        f_type = 'var' ; f_target = 'lead' ; f_var = 'posx' ; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv]     = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);   
        for i_tc_tmp2 = 1:track_count
            f_type2 = 'var'; f_target2 = strcat('track',num2str(i_tc_tmp2)); f_var2 = 'posx'; f_ilv2 = 'ilv' ;
            [ind_ftype2, ind_ftarget2, ind_fvar2, ind_filv2] = fset_mindx(f_type2, f_target2, f_var2, f_ilv2, M_data);
            if i_tc_tmp2 ==1 
                %1st track assign as 1st vector
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data;
            else
                %2nd tracks onwards, keep adding vector to lead variable
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = nansum([M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data],2);
            end
            %Convert 0 to NaN
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        end

    %posy
        f_type = 'var' ; f_target = 'lead' ; f_var = 'posy' ; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv]     = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);   
        for i_tc_tmp2 = 1:track_count
            f_type2 = 'var'; f_target2 = strcat('track',num2str(i_tc_tmp2)); f_var2 = 'posy'; f_ilv2 = 'ilv' ;
            [ind_ftype2, ind_ftarget2, ind_fvar2, ind_filv2] = fset_mindx(f_type2, f_target2, f_var2, f_ilv2, M_data);
            if i_tc_tmp2 ==1 
                %1st track assign as 1st vector
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data;
            else
                %2nd tracks onwards, keep adding vector to lead variable
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = nansum([M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data],2);
            end
            %Convert 0 to NaN
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        end        
        
    %speedx
        f_type = 'var' ; f_target = 'lead' ; f_var = 'speedx' ; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv]     = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);   
        for i_tc_tmp2 = 1:track_count
            f_type2 = 'var'; f_target2 = strcat('track',num2str(i_tc_tmp2)); f_var2 = 'speedx'; f_ilv2 = 'ilv' ;
            [ind_ftype2, ind_ftarget2, ind_fvar2, ind_filv2] = fset_mindx(f_type2, f_target2, f_var2, f_ilv2, M_data);
            if i_tc_tmp2 ==1 
                %1st track assign as 1st vector
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data;
            else
                %2nd tracks onwards, keep adding vector to lead variable
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = nansum([M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data],2);
            end
            %Convert 0 to NaN
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        end

    %accelx
        f_type = 'var' ; f_target = 'lead' ; f_var = 'accelx' ; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv]     = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);   
        for i_tc_tmp2 = 1:track_count
            f_type2 = 'var'; f_target2 = strcat('track',num2str(i_tc_tmp2)); f_var2 = 'accelx'; f_ilv2 = 'ilv' ;
            [ind_ftype2, ind_ftarget2, ind_fvar2, ind_filv2] = fset_mindx(f_type2, f_target2, f_var2, f_ilv2, M_data);
            if i_tc_tmp2 ==1 
                %1st track assign as 1st vector
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data;
            else
                %2nd tracks onwards, keep adding vector to lead variable
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = nansum([M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data],2);
            end
            %Convert 0 to NaN
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        end

    %jerkx
        f_type = 'var' ; f_target = 'lead' ; f_var = 'jerkx' ; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv]     = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);   
        for i_tc_tmp2 = 1:track_count
            f_type2 = 'var'; f_target2 = strcat('track',num2str(i_tc_tmp2)); f_var2 = 'jerkx'; f_ilv2 = 'ilv' ;
            [ind_ftype2, ind_ftarget2, ind_fvar2, ind_filv2] = fset_mindx(f_type2, f_target2, f_var2, f_ilv2, M_data);
            if i_tc_tmp2 ==1 
                %1st track assign as 1st vector
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data;
            else
                %2nd tracks onwards, keep adding vector to lead variable
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = nansum([M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data],2);
            end
            %Convert 0 to NaN
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        end

    %thw
        f_type = 'var' ; f_target = 'lead' ; f_var = 'thw' ; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv]     = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);   
        for i_tc_tmp2 = 1:track_count
            f_type2 = 'var'; f_target2 = strcat('track',num2str(i_tc_tmp2)); f_var2 = 'thw'; f_ilv2 = 'ilv' ;
            [ind_ftype2, ind_ftarget2, ind_fvar2, ind_filv2] = fset_mindx(f_type2, f_target2, f_var2, f_ilv2, M_data);
            if i_tc_tmp2 ==1 
                %1st track assign as 1st vector
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data;
            else
                %2nd tracks onwards, keep adding vector to lead variable
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = nansum([M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data],2);
            end
            %Convert 0 to NaN
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        end        

    %ttc
        f_type = 'var' ; f_target = 'lead' ; f_var = 'ttc' ; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv]     = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);   
        for i_tc_tmp2 = 1:track_count
            f_type2 = 'var'; f_target2 = strcat('track',num2str(i_tc_tmp2)); f_var2 = 'ttc'; f_ilv2 = 'ilv' ;
            [ind_ftype2, ind_ftarget2, ind_fvar2, ind_filv2] = fset_mindx(f_type2, f_target2, f_var2, f_ilv2, M_data);
            if i_tc_tmp2 ==1 
                %1st track assign as 1st vector
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data;
            else
                %2nd tracks onwards, keep adding vector to lead variable
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = nansum([M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data],2);
            end
            %Convert 0 to NaN
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        end            

    %thw_inv
        f_type = 'var' ; f_target = 'lead' ; f_var = 'thw_inv' ; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv]     = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);   
        for i_tc_tmp2 = 1:track_count
            f_type2 = 'var'; f_target2 = strcat('track',num2str(i_tc_tmp2)); f_var2 = 'thw_inv'; f_ilv2 = 'ilv' ;
            [ind_ftype2, ind_ftarget2, ind_fvar2, ind_filv2] = fset_mindx(f_type2, f_target2, f_var2, f_ilv2, M_data);
            if i_tc_tmp2 ==1 
                %1st track assign as 1st vector
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data;
            else
                %2nd tracks onwards, keep adding vector to lead variable
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = nansum([M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data],2);
            end
            %Convert 0 to NaN
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        end           

    %ttc_inv
        f_type = 'var' ; f_target = 'lead' ; f_var = 'ttc_inv' ; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv]     = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);   
        for i_tc_tmp2 = 1:track_count
            f_type2 = 'var'; f_target2 = strcat('track',num2str(i_tc_tmp2)); f_var2 = 'ttc_inv'; f_ilv2 = 'ilv' ;
            [ind_ftype2, ind_ftarget2, ind_fvar2, ind_filv2] = fset_mindx(f_type2, f_target2, f_var2, f_ilv2, M_data);
            if i_tc_tmp2 ==1 
                %1st track assign as 1st vector
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data;
            else
                %2nd tracks onwards, keep adding vector to lead variable
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = nansum([M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data],2);
            end
            %Convert 0 to NaN
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        end           

    %ttc_delta
        f_type = 'var' ; f_target = 'lead' ; f_var = 'ttc_delta' ; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv]     = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);   
        for i_tc_tmp2 = 1:track_count
            f_type2 = 'var'; f_target2 = strcat('track',num2str(i_tc_tmp2)); f_var2 = 'ttc_delta'; f_ilv2 = 'ilv' ;
            [ind_ftype2, ind_ftarget2, ind_fvar2, ind_filv2] = fset_mindx(f_type2, f_target2, f_var2, f_ilv2, M_data);
            if i_tc_tmp2 ==1 
                %1st track assign as 1st vector
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data;
            else
                %2nd tracks onwards, keep adding vector to lead variable
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = nansum([M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data],2);
            end
            %Convert 0 to NaN
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        end
        
    %thw_delta
        f_type = 'var' ; f_target = 'lead' ; f_var = 'thw_delta' ; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv]     = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);   
        for i_tc_tmp2 = 1:track_count
            f_type2 = 'var'; f_target2 = strcat('track',num2str(i_tc_tmp2)); f_var2 = 'thw_delta'; f_ilv2 = 'ilv' ;
            [ind_ftype2, ind_ftarget2, ind_fvar2, ind_filv2] = fset_mindx(f_type2, f_target2, f_var2, f_ilv2, M_data);
            if i_tc_tmp2 ==1 
                %1st track assign as 1st vector
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data;
            else
                %2nd tracks onwards, keep adding vector to lead variable
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = nansum([M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data],2);
            end
            %Convert 0 to NaN
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        end           

    %ttc_delta_inv
        f_type = 'var' ; f_target = 'lead' ; f_var = 'ttc_delta_inv' ; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv]     = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);   
        for i_tc_tmp2 = 1:track_count
            f_type2 = 'var'; f_target2 = strcat('track',num2str(i_tc_tmp2)); f_var2 = 'ttc_delta_inv'; f_ilv2 = 'ilv' ;
            [ind_ftype2, ind_ftarget2, ind_fvar2, ind_filv2] = fset_mindx(f_type2, f_target2, f_var2, f_ilv2, M_data);
            if i_tc_tmp2 ==1 
                %1st track assign as 1st vector
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data;
            else
                %2nd tracks onwards, keep adding vector to lead variable
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = nansum([M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data],2);
            end
            %Convert 0 to NaN
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        end          
        
    %thw_delta_inv
        f_type = 'var' ; f_target = 'lead' ; f_var = 'thw_delta_inv' ; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv]     = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);   
        for i_tc_tmp2 = 1:track_count
            f_type2 = 'var'; f_target2 = strcat('track',num2str(i_tc_tmp2)); f_var2 = 'thw_delta_inv'; f_ilv2 = 'ilv' ;
            [ind_ftype2, ind_ftarget2, ind_fvar2, ind_filv2] = fset_mindx(f_type2, f_target2, f_var2, f_ilv2, M_data);
            if i_tc_tmp2 ==1 
                %1st track assign as 1st vector
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data;
            else
                %2nd tracks onwards, keep adding vector to lead variable
                M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = nansum([M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data M_data(i_mt).type(ind_ftype2).target(ind_ftarget2).variable(ind_fvar2).ilv(ind_filv2).data.data],2);
            end
            %Convert 0 to NaN
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        end          
        
    clear M_end M_start M_var_temp M_var_time_ILV nans
    clear i_tc_tmp2 f_type f_target f_var f_ilv ind_ftype ind_ftarget ind_fvar ind_filv
    clear f_type2 f_target2 f_var2 f_ilv2 ind_ftype2 ind_ftarget2 ind_fvar2 ind_filv2
end

