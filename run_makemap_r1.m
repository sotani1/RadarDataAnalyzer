% Subset to run DVSP/VSP calculations for SHRP2

%% Instructions
% Automated batch script to process all data in 'dfolder'
% Unify file format consistency (interchangeable thru other commands)
% Files will be processed on TOP ->  DOWN order
% DO NOT change folder names

%% For English speaking users
   FlgEnglish = 1;
   
%% Specify Directory
   Opefolder = pwd;                             %Working Folder
   Prgfolder = [Opefolder '\calcfile'];         %Program Folder

   %% SHRP2 data is to be loaded into the variable Datafolder
   Datafolder = [Opefolder '\dfolder\'];        %Folder for SHRP2 data
   Mapfolder  = [Opefolder '\dfolder_map\'];
   D=dir(Datafolder);                           %Stores directory of datafolder 
%% Start program
    cd(Prgfolder);
    cm0_run_program_ed;
    
%% Show frequency plot
    map_plot = 0; %Show plot of the result (1:Display graph 0:Do not display graph)
  %---------------------------
    if map_plot == 1
        cd(Prgfolder);      %Move to program folder
        makegraph_resultmap %Run plotting algorithm
    end
  %---------------------------
  
%% Move to data folder
    cd(Mapfolder)        % OpeFolder
    as_save = D(k).name(1:end-4);
    as_save = strcat(as_save, '_SMap.mat');
    save (as_save)       % Save result

   
%% Move to original folder
    cd(Opefolder)        % OpeFolder
 


