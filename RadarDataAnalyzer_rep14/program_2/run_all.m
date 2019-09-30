%% Åò4-1 Script to run for all trip files  
%% Åò4-1-1 Calculate Gas-On-Brake-Off(GOBO) sequences   
am2_1_makegobo;  % Stores files in *** 'dfolder_gobo_log' ***
cd(Gobofolder)   % Store Gobo files here
%% Åò4-1-2 Write Gas-On-Brake-Off(GOBO) occurence result to csv   
am2_2_writegobo; % Save extracted result as CSV file here Stores files in *** 'dfolder_gobo' ***      
% Begin sequence for calcfile
cd(Prgfolder2);
if flg_cctime ~= 1
%% Åò4-1-3 Create speed/acceleration frequency distribution map (SAFD)       
    am3_makemap; 
    %Clear all old variables
    cm100_clear
    %Save results as MAT file in *** 'dfolder_map' ***
    cd(Mapfolder) % Move to Mapfolder
    as_save = D(k).name(1:end-4);
    as_save = strcat(as_save, '_SMap.mat');  
    save(as_save, 'S_Map')
    M_smap_all = M_smap_all+S_Map.type(2).maps(10).data.data;  
    save('M_smap_all.mat', 'M_smap_all');
end