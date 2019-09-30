%% Åò2-1-3-3-2 Store values into "var_", "var_time" and "M_data"

col_val     = []; % array to determine column number of particular variable string
track_count = []; % array to store radar track counts
i_tc        = 1;  % counter to store number of radar track counts

%% Åò2-1-3-3-2-1 Read csv file and store each variable value into "var_"
for j=1:length(imdata.textdata)
    % Specify which column is associate with which variable
    for k1 = 1:length(as_)
        % Compare column name with as_ value
        if strcmp(imdata.textdata(1,j), as_(k1)) == 1  % memo: imdata == list of csv files
            col_val(j)  = j;
            var_{k1}     = d(:,col_val(j));
            break;
        end
    end
    % Count number of RADAR TRACK objects
    as_track_temp = strtok(imdata.textdata(1,j),'_');        
    if findstr(char(as_track_temp), 'TRACK') == 1
        track_count(i_tc) = str2double(as_track_temp{1}(6:end));
    end
end

%% Åò2-1-3-3-2-2 Interpolate/Extrapolate function for missing or uneven files
[var_, flg_wrinkle] = f_cm2_1_check_tinterval(var_, as_);    % Missing datapoints is referred to as 'wrinkle'
track_count = max(track_count);                              % Total number of tracks
clear j i_tc                                                 % Clear unused counter values

%% Åò2-1-3-3-2-3 Store Velocity profile Variable and conduct NaN post-processingÅ@
% Microtrip detection will not work with NAN, so interpolation is required for speed profile
var_ego_vel_nan = var_{2};
var_interp      = var_{2};
nans            = isnan(var_ego_vel_nan);
non_nans        = ~isnan(var_ego_vel_nan); 
if min(nans) == 1
    var_ego_vel_nan = var_{11};  % Use GPS speed if Network speed is empty (if every value in vector was NaN)
    var_interp      = var_{11};
    nans            = isnan(var_ego_vel_nan);
    non_nans        = ~isnan(var_ego_vel_nan); 
end
try
    var_ego_vel_nan(nans) = interp1(var_{1}(~nans), var_ego_vel_nan(~nans), var_{1}(nans));
    x = 1:length(var_ego_vel_nan);                                                       % Create a vector of indices
    var_ego_vel_nan = interp1(x(non_nans),var_ego_vel_nan(non_nans),x,'next','extrap');  % Interp/Exterp missing velocity NaN values
    var_ego_vel_nan = transpose(var_ego_vel_nan);                                        % Velocity vecotor with corrected NaN values
catch
    var_ego_vel_nan = [];
end
    
var_time = var_{1}; % Universal time variable

clear j as_track_temp nans ans k1 var_interp x