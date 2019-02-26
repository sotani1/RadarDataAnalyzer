%% Åò2_2.1 Upload data

%imdata = list of csv files
col_val     = []; %array to determine column number of particular variable string
track_count = []; %array to store radar track counts
i_tc        = 1;  %counter to store number of radar track counts

for j=1:length(imdata.textdata)
        %Specificy which column is associate with which variable
        for k1 = 1:length(as_)
            %Compare column name with as_ value
            if strcmp(imdata.textdata(1,j), as_(k1)) == 1
                col_val(j)  = j;
                var_{k1}     = d(:,col_val(j));
                break;
            end
        end
        %count number of TRACK objects
        as_track_temp = strtok(imdata.textdata(1,j),'_');        
        if findstr(char(as_track_temp), 'TRACK') == 1
            track_count(i_tc) = str2double(as_track_temp{1}(6:end));
        end
end
track_count = max(track_count);  %Total number of tracks
clear j i_tc
%% Velocity profile NaN post-processÅ@
    %Microtrip detection will not work with NAN, so interpolation is required for speed profile
    var_ego_vel_nan = var_{2};
    nans = isnan(var_ego_vel_nan);
    var_ego_vel_nan(nans) = interp1(var_{1}(~nans), var_ego_vel_nan(~nans), var_{1}(nans));

%% Determine number of microtrips
[num_mt, mt_start mt_end] = fcalc_mountain(var_ego_vel_nan, 0.1, flg_mtn);
%% Set variables
M_data = fnames_filednames(num_mt);                               %Empty matrix
%if flg_analysis_mode == 2
%    cm2_2_fsetvar_jay;
%else
%    cm2_2_fsetvar;
%end
    %M_out  = fset_var(as_, var_, M_data, num_mt, mt_start, mt_end);   %Fill matrix with variable values
    
clear j as_track_temp nans ans k1