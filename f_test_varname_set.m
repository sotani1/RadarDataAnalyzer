%% Coded by Mazda North American Operations 
%2018/03/30  Version 3.0.1
%2019/02/23  Version 4.0.1
clear all;
close all;
clc;

%function f_test_varname_set(flg_app, dir_dataname) 
flg_app = 0;
if flg_app == 0
    clear all;
    close all;
    clc;
end

M_time_tot        = [];
V_var_time        = [];
M_var_time        = [];
flg_time_interp   = 0;                                     % Time interpolation flag (please set to zero always) 
flg_mtn           = 0;                                     % Calcmountain execution flag
flg_app           = 0;                                     % GUI execution flag
flg_analysis_mode = 3;                                     % CANape(1), DDRS(2), SHRP2(3), MEISTER(4);

if flg_analysis_mode == 1
    sz = 100;
else
    sz = 10;
    if flg_analysis_mode == 2
        sz = 1/.216;
    end
end

Opefolder         = pwd;                                   % Work Folder
Prgfolder         = [Opefolder '\program'];                % Program Folder
if flg_app == 1
    Datafolder    = dir_dataname;                          % Set directory from GUI
    Vidfolder     = dir_vidname;                           % Video Folder
else
    Datafolder    = [Opefolder '\dfolder'];                % Data Folder
    Vidfolder     = [Opefolder '\vfolder'];                % Video Folder
end

Logfolder       = [Opefolder '\log_data'];                 % Log Folder
Scatfolder      = [Opefolder '\scat_data'];                % Scatter Folder
D=dir(Datafolder);                                         % Get the list of all MAT files in datafolder 

Calcfolder      = [Opefolder '\calcfile'];                 % Calcfolder for map plots
    

%% Logic c/p
%Track amoung of radar data present in data
if flg_analysis_mode == 1 || flg_analysis_mode == 2 || flg_analysis_mode == 4
    i_lim             = 16;      % CANape and DDRS have 16 object ID's each
else if flg_analysis_mode == 3
    i_lim             = 8;       % SHRP2 has max of 8 object ID's
    end
end
track_count           = i_lim;

cd(Datafolder);

for k = 1+2:length(D)
    if flg_analysis_mode == 1
        var_          = load(D(k).name);
        fieldname_var = fieldnames(var_);
    else
        if flg_analysis_mode == 2 || flg_analysis_mode == 3 || flg_analysis_mode == 4
            %for k=1+2:length(D) 
                clear imdata d size_check_imdata size_check_d
                imdata = importdata(D(k).name);          % Read list of csv files
                d=imdata.data;                           % Store list of csv files
                imdata.textdata = strrep(imdata.textdata(:,:), '"', '');
                size_check_imdata = size(imdata.textdata);
                size_check_d      = size(d);
                % if last row is not detected, fill in with NaNs
                if size_check_imdata(1,2) > size_check_d(1,2)
                    d(:,size_check_imdata(1,2)) = d(:,size_check_d(1,2));
                end
            %end
        end
    end
    cd(Prgfolder);

    %% Logic c/p end

    %% Start
    if flg_time_interp == 1
        cm1_varlist_time_interp;
    end

    %for k=1+2:length(D) 
      cd(Prgfolder);                       % Tet cd to progfolder  
      
      % Logic to read custom channel names ----------------------------------------------------------
      if flg_analysis_mode ~= 2 && flg_analysis_mode ~= 4
          if flg_analysis_mode == 3
              cm1_varlist_shrp2;
              cm2_1_dataset_unique               % Read data for unique variables
              cm2_2_fsetvar_shrp2;
          else
              if flg_analysis_mode == 1
                cm1_varlist;
                cm2_2_fsetvar;
              end
          end
          
      else
        if flg_analysis_mode == 2 || flg_analysis_mode == 4
          d = fcheck_datafill(d, imdata.textdata);     % Checks to see all data columns are filled  
          if flg_analysis_mode == 2
              cm1_varlist_ddrs;                        % Specifically for DDRS
          else
              cm1_varlist_meister;                     % Specifically for MEISTER
          end
          cm2_1_dataset_unique;                        % Read data for unique variables
          cm2_2_fsetvar_shrp2;
        end
      end

    %% Calculate all risk feelings
    %run_makelog_r1;
    
    as_ = transpose(as_);
    cd(Opefolder);
    
    %% Begin sequence for calcfile
     %run_makemap_r1;
    
    %% Begin gobo sequence
    run_makegobo;
    
    %% Clear all old variables
     %cm100_clear

end

clear i_cnt i_lim i_cnt2 i_vt i_vt2 i_vt_temp size_check_imdata size_check_d
