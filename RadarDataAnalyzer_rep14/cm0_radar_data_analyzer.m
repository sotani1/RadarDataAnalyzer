%% cm0_radar_data_analyzer                  Coded by Edward Otani
%2018/03/30  Version 3.0.1
%2019/02/23  Version 4.0.1
%2019/03/25  Version 5.0.1
%2019/04/03  Version 5.1.1
%2019/04/16  Version 5.1.2
%2019/05/04  Version 5.1.3
%2019/05/29  Version 5.2.1
%2019/07/04  Version 5.2.1b  Cleaned up code.  Removed unnnecessary files.

%% ˜1-1 Initializing script (clear functions)
% Close everything at the start of the script set to 1 if you do not want to close windows
flg_app = 0;
if flg_app == 0
    clear all;
    close all;
    clc;
end

%% ˜1-2 Initialize global variables
M_time_tot        = [];
V_var_time        = [];
M_var_time        = [];
vsp_min           = 0;                % Vehicle speed min value
vsp_max           = 200;              % Vehicle speed max value 
vsp_step          = 10;               % Vehicle speed bin size
max_dvsp          = 5;                % Max acceleration value (m/s^2)  
min_dvsp          = -5;               % Min acceleration value (m/s^2)
dvsp_step         = 0.05;             % Acceleration bin size  (m/s^2)
cc_timer          = 300;              % Timer for cutoff (min) 5 min = 300 sec
M_smap_all        = zeros(((max_dvsp -min_dvsp)/dvsp_step+1),((vsp_max-vsp_min)/vsp_step+1));
flg_time_interp   = 0;                % Time interpolation flag (please set to zero always) 
flg_mtn           = 0;                % Calcmountain execution flag
flg_analysis_mode = 3;                % CANape(1), SHRP2(3)
flg_50k           = 1;                % Flag to run the dataset for 50k trip files
flg_all           = 1;                % Flag to run all dataset

%% ˜1-3 Set sampling rate variable (Please assign your corresponding sampling rates based on your file format)
if flg_analysis_mode == 1
    sz = 100;                         % CANape
else
    if flg_analysis_mode == 3    
        sz = 10;                      % SHRP2
    end
end

%% ˜1-4 Set directory variables (Folder directories)
Opefolder         = pwd;                                   % Work Folder
Prgfolder1        = [Opefolder '\program_1'];              % Program Folder (Core Modules)
Prgfolder2        = [Opefolder '\program_2'];              % Program Folder (Additional Modules)
Datafolder        = [Opefolder '\dfolder'];                % Data Folder
Funcfolder        = [Opefolder '\functions'];              % Function Folder

D=dir(Datafolder);                                         % Get the list of all MAT files in datafolder
addpath(genpath(Funcfolder));                              % Add function folder to active directory path

%% ˜1-5 Track counts of radar targets present in data
if flg_analysis_mode == 1
    i_lim             = 16;      % CANape have 16 object ID's each
else if flg_analysis_mode == 3 || flg_analysis_mode == 5
    i_lim             = 8;       % SHRP2 has max of 8 object ID's
    end
end
track_count           = i_lim;   % Store total radar target count in this variable

poolobj = gcp('nocreate');
delete(poolobj);
cd(Datafolder);

%% ˜2-1 Read data from multiple file types
%   For loop to read csv values and store into variable "var_" and fieldnames
%   Variable "D" is the variable that stores the list of csv files read from directory 'd_folder'
for k = 1+2:length(D)
    % ˜2-1-1 Read variables from MAT files
    if flg_analysis_mode == 1
        var_          = load(D(k).name);
        fieldname_var = fieldnames(var_);
    else
    % ˜2-1-2 Read variables from csv files
        if flg_analysis_mode == 3
            clear imdata d size_check_imdata size_check_d
            imdata = importdata(D(k).name);                            % Read list of csv files
            d=imdata.data;                                             % Store list of csv files
            imdata.textdata = strrep(imdata.textdata(:,:), '"', '');   % Clean up text data (Remove apostrahpes and such)
            size_check_imdata = size(imdata.textdata);
            size_check_d      = size(d);                               % Store number of rows read from data 
            if size_check_imdata(1,2) > size_check_d(1,2)
                d(:,size_check_imdata(1,2)) = d(:,size_check_d(1,2));  % If last row is not detected, fill in with NaNs
            end
        end
    end
    
   %% ˜2-1-3 Run core modules (cm) - Data storage sequence
    cd(Prgfolder1);                                                 % The majority of 2-1-3 happens in the 'program' directory    
    %  *Basic functions*
    %   1. cm1_varlist: User provides channel name that corresponds to each variable.  Variations (1) SHRP2 (2) DDRS (3) Meister
    %   2. cm2_1_dataset_unique: Matches variable name in CSV column to matrix stored as "var_"
    %   3. cm2_2_setvar: Set generic parameter dictionary.  Variations (1) fsetvar (for MAT files) (2) _SHRP2 (for csv files)  
    if flg_analysis_mode == 1
        % ˜2-1-3-1 CANape (MAT File)
        if flg_analysis_mode == 1
            cm1_varlist;                                            % ˜2-1-3-1-1    Assign channel names *USER INPUT REQUIRED*
            cm2_2_setvar;                                           % ˜2-1-3-1-2    Create generic parameter dictionary and stores values into "var_", "var_time" and "M_data"
        end
    else
        % ˜2-1-3-3 SHRP2  (CSV File)
        if flg_analysis_mode == 3
            cm1_varlist_shrp2;                                      % ˜2-1-3-3-1    Assign channel names *USER INPUT REQUIRED*
            cm2_1_dataset_unique;                                   % ˜2-1-3-3-2    Store values into "var_", "var_time" (interp/extrap)
            flg_cctime = f_cm0_check_cc_time(var_time, var_, as_, cc_timer);  % ˜2-1-3-3-3    Check for cruise control enabled / time less than 5 mins (Unique script requested by VTTI)
            if flg_cctime == 1
                cd(Opefolder)                                       % If cruise control detected or total trip time less than 5 minutes, skip analysis (Unique script requested by VTTI)
                continue;
            end
            cm2_2_setvar_shrp2;                                     % ˜2-1-3-3-4    Create generic parameter dictionary and stores values into "var_", "var_time" and "M_data" for CSV files
        end
    end
   
   %% Run additional modules (am) - Custom metric analysis and data export
   %% ˜3-1 Script to run for first 50k trip files
    cd(Prgfolder2);
    if flg_50k == 1
        run_50k;
    end
   %% ˜4-1 Script to run for all trip files  
    if flg_all == 1
        run_all;
    end
    
   %% Move to original folder
    cd(Opefolder)        % OpeFolder 
    
end

clear i_cnt i_lim i_cnt2 i_vt i_vt2 i_vt_temp size_check_imdata size_check_d D as_save Mapfolder Opefolder 
clear dt i_mt_plot k M_var_time var_ego_dist_brake imdata flg_time_interp
clear flg_mtn sz 
clear Calcfolder Datafolder Gobofolder Gobofolder_log Logfolder flg_50k flg_all
