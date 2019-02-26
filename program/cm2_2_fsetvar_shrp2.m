%fset_var(as_, var_, M_data, num_mt, mt_start, mt_end)
 
%% ˜2_2.1    Assigning values to variable array 
M_var_trackN_all_ones   = [];
M_var_time_ILV_all      = [];
M_var_time              = [];
var_trackN_accx         = [];

%% ˜2_2.1.1  Set global varaiable list
if flg_analysis_mode == 2 || flg_analysis_mode == 3 || flg_analysis_mode == 4
    %DDRS [2] and SHRP2 [3] and MEISTER [4]
    try
        var_time            = var_{ff_varname(as_, as_{1})};                       
    catch
        var_time = [];
    end
end
        
if flg_analysis_mode == 2 || flg_analysis_mode == 3 || flg_analysis_mode == 4
    %DDRS [2] and SHRP2 [3] and MEISTER [4]
    dt                      = (var_time(2)-var_time(1))/1000;                % sampling time constant (sec)
    var_time                = var_time./1000;                                % convert to ms->sec         
end

if flg_analysis_mode == 2 || flg_analysis_mode == 3 || flg_analysis_mode == 4
    %DDRS
    if flg_analysis_mode == 2 || flg_analysis_mode == 4
        try    
            if max(var_{ff_varname(as_, as_{4})}+1) > 16
                M_var_trackN_all = [];
            else
                M_var_trackN_all = var_{ff_varname(as_, as_{4})}+1;              
            end
        catch
            M_var_trackN_all = [];
        end
    end
    %SHRP2
    if flg_analysis_mode == 3
        M_var_trackN_all = [];                                    
    end
end

%Only for SHRP2 where it has ILV channel
if flg_analysis_mode == 3
    for i_tc_tmp = 1:track_count
        if i_tc_tmp == 1
            M_var_trackN_all  = var_{ff_varname(as_, as_{(asn_org*i_tc_tmp)+i_asn(7)})};
        else
            temp_1 = var_{ff_varname(as_, as_{asn_org+(length(i_asn)*(i_tc_tmp-1))+i_asn(7)})};
            temp_2 = M_var_trackN_all;
            cat_temp = cat(2,temp_1,temp_2);
            M_var_trackN_all = nansum(cat_temp,2);
        end
        M_var_trackN_all(M_var_trackN_all == 0) = NaN;  %Convert zero to NaN for visual purposes
        M_var_trackN_all(M_var_trackN_all>1)    = 1;    %Cap all summation as 1
    end
    M_var_trackN_all_ones = M_var_trackN_all;
    clear i_tc_tmp asn_tmp temp_1 temp_2 cat_temp
end

%% ˜2_2.1.2  Set global ego variable list
%DDRS [2] and SHRP2 [3] and MEISTER [4]
if flg_analysis_mode == 2 || flg_analysis_mode == 3 || flg_analysis_mode == 4
    try
        var_ego_vel     = var_{ff_varname(as_, as_{2})};                                    % ego vehicle speed        
    catch
        var_ego_vel     = [];
    end
    try
        var_ego_vel_nan = var_{ff_varname(as_, as_{2})};                                    % ego vehicle speed without nans (prep)
    catch
        var_ego_vel_nan = [];
    end
    if flg_analysis_mode == 2
        try
            var_ego_accelx  = var_{ff_varname(as_, as_{3})}./9.8062;                                    % ego vehicle acceleration_x [G]
            if isempty(var_ego_accelx) == 1                                                             % If null value is detected
                var_ego_accelx(1,1)      = NaN;                                                         % dummy declaration
                var_ego_accelx           = vertcat(var_ego_accelx,diff(var_ego_vel_nan./3.6.*sz)./9.8062);    % ego vhiecle accel
                nans                     = isnan(var_ego_accelx);
                var_ego_accelx(nans)     = interp1(var_time(~nans), var_ego_accelx(~nans), var_time(nans)); 
            else
                var_ego_accelx  = fset_removenan(var_ego_accelx, var_time);
            end 
       catch
            var_ego_accelx  = [];
        end
    end
    if flg_analysis_mode == 4
        try
            var_ego_accelx  = var_{ff_varname(as_, as_{3})}./9.8062;                                         % ego vehicle acceleration_x [G]
            if isempty(var_ego_accelx) == 1                                                                  % If null value is detected
                var_ego_accelx(1,1)      = NaN;                                                              % dummy declaration
                var_ego_accelx           = vertcat(var_ego_accelx,diff(var_ego_vel_nan/3.6.*sz)./9.8062);    % ego vhiecle accel
                nans                     = isnan(var_ego_accelx);
                var_ego_accelx(nans)     = interp1(var_time(~nans), var_ego_accelx(~nans), var_time(nans)); 
            end
        catch
            var_ego_accelx  = [];            
        end
    end
    if flg_analysis_mode == 3
        try
            var_ego_accelx  = var_{ff_varname(as_, as_{3})};                                % ego vehicle acceleration_x [G]        
            var_ego_accelx  = fset_removenan(var_ego_accelx, var_time);
        catch
            var_ego_accelx  = [];
        end
    end
    try
        var_ego_apo         = var_{ff_varname(as_, as_{5})};                                % ego vehicle accelerator pedal operation
        var_ego_apo         = fset_removenan(var_ego_apo, var_time);
    catch
        var_ego_apo         = [];
    end
    try
        var_ego_bksw        = var_{ff_varname(as_, as_{6})};                                % ego vehicle break switch
        var_ego_bksw        = fset_removenan(var_ego_bksw, var_time);
    catch
        var_ego_bksw        = [];
    end
    try
        var_ego_swa         = var_{ff_varname(as_, as_{7})};                                % ego vehicle steering wheel angle
        var_ego_swa         = fset_removenan(var_ego_swa, var_time);
    catch
        var_ego_swa         = [];
    end
end

var_ego_vel_interp      = fset_removenan(var_ego_vel, var_time);                            % ego vehicle speed with nan removed and interpolated
nans                    = isnan(var_ego_vel_nan);                                           % nan dummy variable
var_ego_vel_nan(nans)   = interp1(var_time(~nans), var_ego_vel_nan(~nans), var_time(nans)); % ego vehicle speed without nans (final)
var_ego_vel_nan         = fset_removenan(var_ego_vel_nan, var_time);
var_ego_jerkx(1,1)      = NaN;                                                              % dummy declaration
var_ego_jerkx           = vertcat(var_ego_jerkx,diff(var_ego_accelx));                      % ego vhiecle jerk
nans                    = isnan(var_ego_jerkx);
var_ego_jerkx(nans)     = interp1(var_time(~nans), var_ego_jerkx(~nans), var_time(nans));
var_ego_jerkx           = fset_removenan(var_ego_jerkx, var_time);
var_ego_dist            = cumtrapz(var_time, var_ego_vel_interp./3.6);                      % ego vehicle distance travelled 
var_ego_dist_brake      = var_ego_dist;                                                     % dummy set up
var_ego_dist_brake(var_ego_accelx>=-0.01 & var_ego_vel_nan>=0.5)=NaN;                       % ego vehicle distance travelled during braking

%% ˜2_2.1.3  Set global ego variable list
[num_mt, mt_start, mt_end]                = fcalc_mountain_shrp2(var_ego_vel_nan, 0.1, flg_mtn, var_time);  % find total number of mountains   
[num_mt_temp, mt_start_temp, mt_end_temp] = fcalc_mountain_shrp2(var_ego_vel_nan, 0.1, 1, var_time);        % find total number of mountains (flg_mtn == 0)
M_data                                    = fnames_filednames(num_mt);                                % Declare M_data matrix 

%% ˜2_2.1.4  Set up M_data matrix for global ego variable list
for i_mt = 1:num_mt
    M_start = mt_start(i_mt);  % Microtrip start time
    if M_start == 0
        M_start = M_start + 1;
    end
    M_end   = mt_end(i_mt);    % Microtrip end time
    %time
    M_var_time{int32(i_mt)}  = var_time(int32(M_start):int32(M_end));
    
    %====Ego====
    %Ego speedx
    f_type = 'var'; f_target = 'ego';    f_var = 'speedx'; f_ilv = 'non_ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    try
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_ego_vel_nan(int32(M_start):int32(M_end));
    catch
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
    end
    %Ego accelerationx
    f_type = 'var'; f_target = 'ego';    f_var = 'accelx'; f_ilv = 'non_ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    try
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_ego_accelx(int32(M_start):int32(M_end));
    catch
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
    end
    %Ego jerkx
    f_type = 'var'; f_target = 'ego';    f_var = 'jerkx'; f_ilv = 'non_ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    try
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_ego_jerkx(int32(M_start):int32(M_end));
    catch
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
    end
    %Ego apo
    f_type = 'var'; f_target = 'ego';    f_var = 'apo'; f_ilv = 'non_ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    try
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_ego_apo(int32(M_start):int32(M_end));    
    catch
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
    end
    %Ego bksw
    f_type = 'var'; f_target = 'ego';    f_var = 'bksw'; f_ilv = 'non_ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    try
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_ego_bksw(int32(M_start):int32(M_end));     
    catch
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
    end
    %Ego swa
    f_type = 'var'; f_target = 'ego';    f_var = 'swa'; f_ilv = 'non_ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    try
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_ego_swa(int32(M_start):int32(M_end));     
    catch
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
    end
%% ˜2_2.1.5  Set radar variable list (Please refer to cm1_varlist ˜1.1  to establish the column index)
    for i_tc=1:track_count
        asn_ctr = asn_org + length(i_asn)*(i_tc-1);
        % The as_{asn_ctr+i_asn} is referring to the order of ˜1.3 Radar variable declaration
        try
            % Nth track vehicle x position
            %CANape
            if flg_analysis_mode == 1
                var_trackN_posx         = getfield(var_,as_{asn_ctr+i_asn(1)});          
            else
                %DDRS or SHRP2
                if flg_analysis_mode == 2 || flg_analysis_mode == 3
                    var_trackN_posx     = var_{ff_varname(as_, as_{asn_ctr+i_asn(1)})};
                end    
            end    
        catch
            var_trackN_posx         = [];
        end
        try
            % Nth track vehicle y position
            %CANape
            if flg_analysis_mode == 1
                var_trackN_posy         = getfield(var_,as_{asn_ctr+i_asn(2)});          
            else
                %DDRS or SHRP2
                if flg_analysis_mode == 2 || flg_analysis_mode == 3
                   var_trackN_posy      = var_{ff_varname(as_, as_{asn_ctr+i_asn(2)})}; 
                end    
            end
        catch
            var_trackN_posy         = [];
        end
        try
            % Nth track vehicle x speed increment
            %CANape
            if flg_analysis_mode == 1
                var_trackN_velx_tmp     = getfield(var_,as_{asn_ctr+i_asn(3)});          
            else
                %DDRS or SHRP2
                if flg_analysis_mode == 2 || flg_analysis_mode ==3
                    if flg_analysis_mode == 2
                        var_trackN_velx_tmp = var_{ff_varname(as_, as_{asn_ctr+i_asn(3)})}-70; %J.Chen offset 70 m/s 
                    else
                        if flg_analysis_mode == 3
                            var_trackN_velx_tmp = var_{ff_varname(as_, as_{asn_ctr+i_asn(3)})};
                        end
                    end
                end
            end
        catch
            var_trackN_velx_tmp     = [];
        end
        try
            % Nth track vehicle x speed adjusted  
            var_trackN_velx         = var_ego_vel + (var_trackN_velx_tmp.*3.6);      
        catch
            var_trackN_velx         = [];
        end
        try
            % Nth track vehicle acceleration 
            %CANape
            if flg_analysis_mode == 1
                var_trackN_accx         = getfield(var_,as_{asn_ctr+i_asn(5)});                     
            else
                %DDRS or SHRP2
                if flg_analysis_mode == 2 || flg_analysis_mode == 3
                    var_trackN_accx     = var_{ff_varname(as_, as_{asn_ctr+i_asn(5)})};
                end
            end
        catch
            var_trackN_accx(1,1)    = NaN;
            var_trackN_accx         = vertcat(var_trackN_accx,diff(var_trackN_velx));                          
        end
        try
            % Nth track vehicle thw
            %CANape
            if flg_analysis_mode == 1 
                var_trackN_thw          = getfield(var_,as_{asn_ctr+i_asn(6)});          
            else
                %DDRS or SHRP2
                if flg_analysis_mode == 2 || flg_analysis_mode == 3
                    var_trackN_thw      = var_{ff_varname(as_, as_{asn_ctr+i_asn(6)})};
                end
            end
        catch
            var_trackN_thw          = var_trackN_posx ./ (var_ego_vel/3.6);
        end
        try
            % Nth track is lead vehicle
            %CANape
            if flg_analysis_mode == 1
                var_trackN_ILV          = getfield(var_,as_{asn_ctr+i_asn(7)})+1;        
            else
                %DDRS or SHRP2
                if flg_analysis_mode == 2 || flg_analysis_mode == 3
                    var_trackN_ILV      = var_{ff_varname(as_, as_{asn_ctr+i_asn(7)})};
                end
            end
        catch
            if flg_analysis_mode == 1
                var_trackN_ILV((getfield(var_,as_{i_asn(4)})+1)~=i_tc,1) = 2;            % Dummy
                var_trackN_ILV((getfield(var_,as_{i_asn(4)})+1)==i_tc,1) = 1;            % Assign all values equal to i_tc as one
                var_trackN_ILV((getfield(var_,as_{i_asn(4)})+1)~=i_tc,1) = 0;            % Otherwise assign zero
                var_trackN_ILV(var_trackN_posx > 327,1) = 0;                             % Disregard if position greater than 327m
            end
            if flg_analysis_mode == 2
                var_trackN_ILV((var_{ff_varname(as_, as_{i_asn(4)})}+1)~=i_tc,1) = 2;    % Dummy
                var_trackN_ILV((var_{ff_varname(as_, as_{i_asn(4)})}+1)==i_tc,1) = 1;    % Assign all values equal to i_tc as one
                var_trackN_ILV((var_{ff_varname(as_, as_{i_asn(4)})}+1)~=i_tc,1) = 0;    % Otherwise assign zero
                var_trackN_ILV(var_trackN_posx > 327,1) = 0;                             % Disregard if position greater than 327m
            end    
            if i_tc == 1
                M_var_trackN_all_ones = var_trackN_ILV;
            else
                M_var_trackN_all_ones   =  M_var_trackN_all_ones + var_trackN_ILV;
            end
        end
        try
            % Nth track lane position
            %CANape
            if flg_analysis_mode == 1
                var_trackN_lane         = getfield(var_,as_{asn_ctr+i_asn(8)});          
            else
                %DDRS or SHRP2
                if flg_analysis_mode == 2 || flg_analysis_mode == 3
                    var_trackN_lane     = var_{ff_varname(as_, as_{asn_ctr+i_asn(8)})};
                end
            end
        catch
            var_trackN_lane         = [];
        end
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
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_ILV(int32(M_start):int32(M_end));
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        %Speed Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'speedx'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_velx(int32(M_start):int32(M_end));
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        %Speed Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'speedx'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_velx(int32(M_start):int32(M_end)) .* M_var_trackN_ILV{i_mt};
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        %Accelerataion_x Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'accelx'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_accx(int32(M_start):int32(M_end));
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        M_var_temp = var_trackN_accx(int32(M_start):int32(M_end));
        M_var_temp(M_var_temp == 0) = NaN;
        %Accelerataion_x Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'accelx'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_var_temp .* M_var_trackN_ILV{i_mt};
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        %X_POS Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'posx'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_posx(int32(M_start):int32(M_end));
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        M_var_temp = var_trackN_posx(int32(M_start):int32(M_end));
        M_var_temp(M_var_temp == 0) = NaN;
        %X_POS Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'posx'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_var_temp .* M_var_trackN_ILV{i_mt};
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        %X_VEL Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'speedx'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data     = var_trackN_velx(int32(M_start):int32(M_end));
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        M_var_temp = var_trackN_velx(int32(M_start):int32(M_end));
        M_var_temp(M_var_temp == 0) = NaN;
        %X_VEL Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'speedx'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_var_temp .* M_var_trackN_ILV{i_mt};
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        %Headway Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'thw'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_thw(int32(M_start):int32(M_end));
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        M_var_temp = var_trackN_thw(M_start:M_end);
        M_var_temp(M_var_temp == 0) = NaN;
        %Headway Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'thw'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_var_temp .* M_var_trackN_ILV{i_mt};
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        %Headway_INV Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'thw_inv'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_thw_inv(int32(M_start):int32(M_end));
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        M_var_temp = var_trackN_thw_inv(M_start:M_end);
        M_var_temp(M_var_temp == 0) = NaN;
        %Headway_INV Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'thw_inv'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_var_temp .* M_var_trackN_ILV{i_mt};
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        %TTC Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'ttc'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_ttc(int32(M_start):int32(M_end));
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        M_var_temp = var_trackN_ttc(M_start:M_end);
        M_var_temp(M_var_temp == 0) = NaN;   
        %TTC Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'ttc'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_var_temp .* M_var_trackN_ILV{i_mt};
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        %TTC_INV Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'ttc_inv'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_ttc_inv(int32(M_start):int32(M_end));
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        M_var_temp = var_trackN_ttc_inv(M_start:M_end);
        M_var_temp(M_var_temp == 0) = NaN;
        %TTC_INV Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'ttc_inv'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_var_temp .* M_var_trackN_ILV{i_mt};
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        %TTC_DELTA Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'ttc_delta'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_ttc_delta(int32(M_start):int32(M_end));
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        M_var_temp = var_trackN_ttc_delta(int32(M_start):int32(M_end));
        M_var_temp(M_var_temp == 0) = NaN;
        %TTC_DELTA Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'ttc_delta'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_var_temp .* M_var_trackN_ILV{i_mt};
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;        
        %THW_DELTA Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'thw_delta'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_thw_delta(M_start:M_end);
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        M_var_temp = var_trackN_thw_delta(int32(M_start):int32(M_end));
        M_var_temp(M_var_temp == 0) = NaN;
        %THW_DELTA Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'thw_delta'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_var_temp .* M_var_trackN_ILV{i_mt};
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;                        
        %TTC_DELTA_INV Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'ttc_delta_inv'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_ttc_delta_inv(M_start:M_end);
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        M_var_temp = var_trackN_ttc_delta_inv(int32(M_start):int32(M_end));
        M_var_temp(M_var_temp == 0) = NaN;
        %TTC_DELTA_INV Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'ttc_delta_inv'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_var_temp .* M_var_trackN_ILV{i_mt};
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;        
        %THW_DELTA_INV Lead Vehicle
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'thw_delta_inv'; f_ilv = 'non_ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_trackN_thw_delta_inv(M_start:M_end);
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
        M_var_temp = var_trackN_thw_delta_inv(int32(M_start):int32(M_end));
        M_var_temp(M_var_temp == 0) = NaN;
        %THW_DELTA_INV Lead Vehicle ILV
        f_type = 'var'; f_target = strcat('track',num2str(i_tc)); f_var = 'thw_delta_inv'; f_ilv = 'ilv' ;
        [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
        try
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = M_var_temp .* M_var_trackN_ILV{i_mt};
        catch
            M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
        end
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;                                
        
        clear i_tc f_type f_target f_var f_ilv ind_ftype ind_ftarget ind_fvar ind_filv 
        clear var_trackN_accx var_trackN_lane var_trackN_posx var_trackN_posy var_trackN_thw var_trackN_thw_inv var_trackN_velx var_trackN_velx_tmp
    end
    
    %% ˜2_2.1.6  Set ego ILV variable list
    %================= ILV variables =====================
    %Speed Ego Vehicle ILV
    f_type = 'var'; f_target = 'ego'; f_var = 'speedx'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    try
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_ego_vel(int32(M_start):int32(M_end)).* M_var_trackN_all_ones(int32(M_start):int32(M_end));
    catch
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
    end
    M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
    %Accelerationx Ego Vehicle ILV
    f_type = 'var'; f_target = 'ego'; f_var = 'accelx'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    try
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_ego_accelx(int32(M_start):int32(M_end)).* M_var_trackN_all_ones(int32(M_start):int32(M_end));
    catch
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
    end
    M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
    %Jerkx Ego Vehicle ILV
    f_type = 'var'; f_target = 'ego'; f_var = 'jerkx'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    try
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_ego_jerkx(int32(M_start):int32(M_end)).* M_var_trackN_all_ones(int32(M_start):int32(M_end));
    catch
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
    end
    M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;
    %Apo Ego Vehicle ILV
    f_type = 'var'; f_target = 'ego'; f_var = 'apo'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    try
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_ego_apo(int32(M_start):int32(M_end)).* M_var_trackN_all_ones(int32(M_start):int32(M_end));
    catch
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
    end
    M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;   
    %Bksw Ego Vehicle ILV
    f_type = 'var'; f_target = 'ego'; f_var = 'bksw'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    try
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_ego_bksw(int32(M_start):int32(M_end)).* M_var_trackN_all_ones(int32(M_start):int32(M_end));
    catch
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
    end
    M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;       
    %Swa Ego Vehicle ILV
    f_type = 'var'; f_target = 'ego'; f_var = 'swa'; f_ilv = 'ilv' ;
    [ind_ftype, ind_ftarget, ind_fvar, ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data);
    try
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = var_ego_swa(int32(M_start):int32(M_end)).* M_var_trackN_all_ones(int32(M_start):int32(M_end));
    catch
        M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data = [];
    end
    M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data(M_data(i_mt).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(ind_filv).data.data == 0) = NaN;   
    
    %% ˜2_2.1.7  Set Lead variable list
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

