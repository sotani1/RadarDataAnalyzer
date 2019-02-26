%Runprogram function

h = waitbar(0,'Please wait...'); %Execution progress bar
%2016/12/05  
    
for k=1+2:length(D) 
  clear d imdata
  cd(Datafolder);                      % Set cd to datafolder
  imdata = importdata(D(k).name);      % Read list of csv files
  d=imdata.data;                       % Store list of csv files
  cd(Prgfolder);                       % Tet cd to progfolder  
  d = fcheck_datafill(d, imdata.textdata); % Checks to see all data columns are filled
  
  %Begin logic----------------------------------------------------------
    cm1_varlist                        % Set rule for variable list
    cm2_1_dataset_unique               % Read data for unique variables
    
    %cm1_2_Dataset_global               % Read data for global variables  
    
  %End logic------------------------------------------------------
  h = waitbar(k/length(D),h); % ˆ—ó‘Ô•\¦—p
    %D(k).name
end



close(h)

