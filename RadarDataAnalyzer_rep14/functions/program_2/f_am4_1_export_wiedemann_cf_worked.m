function f_am4_1_export_wiedemann_cf(arr_mtndn_ind, arr_mtnup_ind, M_var_wied, k_mtn, D, k, Opefolder)

Wiedfolder    = [Opefolder '\dfolder_wied'];                     % Stores wiedemann folder
as_save       = D(k).name(1:end-4);                              % The name of the file to save (ansi string type)

textHeader    =  {'time(s)', 'delta_s(m)', 'delta_v(kph)', 'ego_speed(kph)', 'ego_acc(G)', 'RF(-)'};      % Define headers here
commaHeader   = [textHeader;repmat({','},1,numel(textHeader))];  % Insert commaas
commaHeader   = commaHeader(:)';                                 % Reformat commaHeader
textHeader    = cell2mat(commaHeader);                           % Comma header in text with commas

var_time      = M_var_wied(:,1);
var_ego_speed = M_var_wied(:,2);
var_x         = M_var_wied(:,3);
var_y         = M_var_wied(:,4);
var_ego_acc   = M_var_wied(:,5);
var_ego_RF    = M_var_wied(:,6);

    % Determine whether the car following started from t==0 or after t>0
    if length(arr_mtndn_ind) == length(arr_mtnup_ind)
        if arr_mtnup_ind(length(arr_mtnup_ind)) > arr_mtndn_ind(length(arr_mtndn_ind))
            % Two-tail Left Entry Right exit
            tail_md = 3;
        else
            % Two-tail No exit
            tail_md = 0;
        end
    else
        if arr_mtndn_ind(1) < arr_mtnup_ind(1)
            tail_md = 1; % One-tail Left entry
        elseif arr_mtnup_ind(length(arr_mtnup_ind)) > arr_mtndn_ind(length(arr_mtndn_ind))
            tail_md = 2; % One-tail Right exit
        end
    end
    
    % Save all delta_s and delta_v values here
    for i=1:k_mtn
        % Two-tail Left Entry Right Exit
        if tail_md == 0
            var_t_save{i} = var_time(int32(arr_mtnup_ind(i)):(int32(arr_mtndn_ind(i))));                 % [1]
            var_x_save{i} = var_x(int32(arr_mtnup_ind(i)):(int32(arr_mtndn_ind(i))));                    % [3]
            var_y_save{i} = var_y(int32(arr_mtnup_ind(i)):(int32(arr_mtndn_ind(i))));                    % [4]
            var_speed{i}  = var_ego_speed(int32(arr_mtnup_ind(i)):(int32(arr_mtndn_ind(i))));            % [2]
            var_acc{i}    = var_ego_acc(int32(arr_mtnup_ind(i)):(int32(arr_mtndn_ind(i))));              % [5]
            var_rf{i}     = var_ego_RF(int32(arr_mtnup_ind(i)):(int32(arr_mtndn_ind(i))));               % [6]   
        elseif tail_md == 1
            if i == 1
                var_t_save{i} = var_time(1:(int32(arr_mtndn_ind(i))));                                   % [1]
                var_x_save{i} = var_x(1:(int32(arr_mtndn_ind(i))));                                      % [3]
                var_y_save{i} = var_y(1:(int32(arr_mtndn_ind(i))));                                      % [4]
                var_speed{i}  = var_ego_speed(1:(int32(arr_mtndn_ind(i))));                              % [2]
                var_acc{i}    = var_ego_acc(1:(int32(arr_mtndn_ind(i))));                                % [5]
                var_rf{i}     = var_ego_RF(1:(int32(arr_mtndn_ind(i))));                                 % [6]
            else
                var_t_save{i} = var_time((int32(arr_mtnup_ind(i-1)):(int32(arr_mtndn_ind(i)))));         % [1]
                var_x_save{i} = var_x((int32(arr_mtnup_ind(i-1)):(int32(arr_mtndn_ind(i)))));            % [3]
                var_y_save{i} = var_y((int32(arr_mtnup_ind(i-1)):(int32(arr_mtndn_ind(i)))));            % [4]
                var_speed{i}  = var_ego_speed((int32(arr_mtnup_ind(i-1)):(int32(arr_mtndn_ind(i)))));    % [2]
                var_acc{i}    = var_ego_acc((int32(arr_mtnup_ind(i-1)):(int32(arr_mtndn_ind(i)))));      % [5]
                var_rf{i}     = var_ego_RF((int32(arr_mtnup_ind(i-1)):(int32(arr_mtndn_ind(i)))));       % [6]
            end
        elseif tail_md == 2
            % Right Exit
            if i == k_mtn
                var_t_save{i} = var_time(int32(arr_mtndn_ind(i-1)):(int32(arr_mtnup_ind(i))));           % [1]
                var_x_save{i} = var_x(int32(arr_mtndn_ind(i-1)):(int32(arr_mtnup_ind(i))));              % [3]
                var_y_save{i} = var_y(int32(arr_mtndn_ind(i-1)):(int32(arr_mtnup_ind(i))));              % [4]
                var_speed{i}  = var_ego_speed(int32(arr_mtndn_ind(i-1)):(int32(arr_mtnup_ind(i))));      % [2]
                var_acc{i}    = var_ego_acc(int32(arr_mtndn_ind(i-1)):(int32(arr_mtnup_ind(i))));        % [5]
                var_rf{i}     = var_ego_RF(int32(arr_mtndn_ind(i-1)):(int32(arr_mtnup_ind(i))));         % [6] 
            else
                var_t_save{i} = var_time((int32(arr_mtnup_ind(i)):(int32(arr_mtndn_ind(i)))));           % [1]
                var_x_save{i} = var_x((int32(arr_mtnup_ind(i)):(int32(arr_mtndn_ind(i)))));              % [3]
                var_y_save{i} = var_y((int32(arr_mtnup_ind(i)):(int32(arr_mtndn_ind(i)))));              % [4]
                var_speed{i}  = var_ego_speed((int32(arr_mtnup_ind(i)):(int32(arr_mtndn_ind(i)))));      % [2]
                var_acc{i}    = var_ego_acc((int32(arr_mtnup_ind(i)):(int32(arr_mtndn_ind(i)))));        % [5]
                var_rf{i}     = var_ego_RF((int32(arr_mtnup_ind(i)):(int32(arr_mtndn_ind(i)))));         % [6]
            end
        elseif tail_md == 3
            if i == 1
                % Left Entry
                var_t_save{i} = var_time(1:(int32(arr_mtndn_ind(i))));                                   % [1]
                var_x_save{i} = var_x(1:(int32(arr_mtndn_ind(i))));                                      % [3]
                var_y_save{i} = var_y(1:(int32(arr_mtndn_ind(i))));                                      % [4]
                var_speed{i}  = var_ego_speed(1:(int32(arr_mtndn_ind(i))));                              % [2]
                var_acc{i}    = var_ego_acc(1:(int32(arr_mtndn_ind(i))));                                % [5]
                var_rf{i}     = var_ego_RF(1:(int32(arr_mtndn_ind(i))));                                 % [6]
             elseif i == k_mtn
                 % Right Exit
                 var_t_save{i} = var_time(int32(arr_mtndn_ind(i-1)):(int32(arr_mtnup_ind(i))));          % [1]
                 var_x_save{i} = var_x(int32(arr_mtndn_ind(i-1)):(int32(arr_mtnup_ind(i))));             % [3]
                 var_y_save{i} = var_y(int32(arr_mtndn_ind(i-1)):(int32(arr_mtnup_ind(i))));             % [4]
                 var_speed{i}  = var_ego_speed(int32(arr_mtndn_ind(i-1)):(int32(arr_mtnup_ind(i))));     % [2]
                 var_acc{i}    = var_ego_acc(int32(arr_mtndn_ind(i-1)):(int32(arr_mtnup_ind(i))));       % [5]
                 var_rf{i}     = var_ego_RF(int32(arr_mtndn_ind(i-1)):(int32(arr_mtnup_ind(i))));        % [6]                
            else
                % Everything else
                var_t_save{i} = var_time(int32(arr_mtnup_ind(i-1)):(int32(arr_mtndn_ind(i))));           % [1]
                var_x_save{i} = var_x(int32(arr_mtnup_ind(i-1)):(int32(arr_mtndn_ind(i))));              % [3]
                var_y_save{i} = var_y(int32(arr_mtnup_ind(i-1)):(int32(arr_mtndn_ind(i))));              % [4]
                var_speed{i}  = var_ego_speed(int32(arr_mtnup_ind(i-1)):(int32(arr_mtndn_ind(i))));      % [2]
                var_acc{i}    = var_ego_acc(int32(arr_mtnup_ind(i-1)):(int32(arr_mtndn_ind(i))));        % [5]
                var_rf{i}     = var_ego_RF(int32(arr_mtnup_ind(i-1)):(int32(arr_mtndn_ind(i))));         % [6]                    
            end
        end
        
        % Calculate metrics here
        % (m1) V_Max
        m1     = max(var_speed{i});
        % (m2) V_min    
        m2     = min(var_speed{i});
        % (m3) S_min    
        m3     = int32(min(var_y_save{i}));
        % (m4) A_min    
        m4     = round(min(var_acc{i}),3);
        % (m5) RF_Max
        m5    = round(max(var_rf{i}),2);
        % (m6) Duration  (m7a) Start video minute  (m8a) End video minute
        A0 = var_time(int32(arr_mtndn_ind(1)));
        A1 = var_time(int32(arr_mtndn_ind(i)));
        if i>1
            A2 = var_time(int32(arr_mtnup_ind(i-1)));
        else
            A2 = 0;
        end
        A3 = var_time(int32(arr_mtnup_ind(i)));
        B1 = var_time(1);
        if tail_md == 1
            if i==1
                m6       = A0-B1;
                m7a      = 0;                                                        % (m7a) Start video minute 
                m7b      = 0;                                                        % (m7b) Start video second
                m8a      = floor(int32((A1-B1)/60));                                 % (m8a) End video minute
                m8b      = round(double((A1-B1)-(floor(int32(A1-B1)/60)*60)),0);     % (m8b) End video second
            else
                m6       = A1-A2;
                m7a      = floor(((A2-B1)/60));                                      % (m7a) Start video minute
                m7b      = round(double((A2-B1)-(floor((A2-B1)/60)*60)),0);          % (m7b) Start video second
                m8a      = floor(((A1-B1)/60));                                      % (m8a) End video minute
                m8b      = round(double((A1-B1)-(floor((A1-B1)/60)*60)),0);          % (m8b) End video second
            end
        else
            m6      = A3-A1;
            m7a     = floor(int32(A3-B1)/60);                                        % (m7a) Start video minute
            m7b     = round(double((A3-B1)-(floor((A3-B1)/60)*60)),0);               % (m7b) Start video second
            m8a     = floor(int32(A1-B1)/60);                                        % (m8a) End video minute
            m8b     = round(double((A1-B1)-(floor((A1-B1)/60)*60)),0);               % (m8b) End video second
        end
   
        as_save_csv    = strcat(as_save, '@_wied', string(i), '_vmx_', string(m1),  '_vmn_',  string(m2),  '_smn_', string(m3)  ...
                                                            , '_amn_', string(m4),  '_rfmx_', string(m5),  '_dur_', string(m6)  ...
                                                            , '_vms_', string(m7a), '_vss_',  string(m7b), '_vme_', string(m8a) ...
                                                            , '_vse_', string(m8b), '_.csv'); % The name of the file to save (ansi string type) for summary log
        cd(Wiedfolder);
        fid = fopen(as_save_csv,'w'); 
        fprintf(fid,'%s\n',textHeader);
        fclose(fid);
        dlmwrite(char(as_save_csv), [var_t_save{i}, var_x_save{i}, var_y_save{i}, var_speed{i}, var_acc{i}, var_rf{i}],'-append');
    end

end



