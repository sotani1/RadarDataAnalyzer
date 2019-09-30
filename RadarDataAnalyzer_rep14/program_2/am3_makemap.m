%% Åò4-1-3 Create speed/acceleration frequency distribution map (SAFD)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Instructions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Automated batch script to process all data in 'dfolder'
  % Unify file format consistency (interchangeable thru other commands)
  % Files will be processed on TOP ->  DOWN order
  % DO NOT change folder names
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Åò4-1-3-1 Specify Directory
    Datafolder = [Opefolder '\dfolder\'];          % Folder for SHRP2 data
    Mapfolder  = [Opefolder '\dfolder_map\'];      % Folder for SAFD map data 
    D=dir(Datafolder);                             % Stores directory of datafolder 
%% Åò4-1-3-2 Run additional module to generate SMap
    am3_1_makesmap;
