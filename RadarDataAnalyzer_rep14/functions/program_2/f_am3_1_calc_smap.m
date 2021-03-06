function M_data_fq = f_am3_1_calc_smap(vsp_min,         vsp_step,        vsp_max,      dvsp_step,   ...
                                       out_mileage_all, out_mileage_mt,  out_vspe,     dt,          ...
                                       out_stptime,     out_dvsp,        out_acctime,  out_statime, ...
                                       out_dectime)
%% ��4-1-3-2-9 Generate frequency plots
%% ��4-1-3-2-9-1 Plot sequence for frequency distribution maps
    M_data_fq = f_am3_1_1_set_fieldnames(1);
    i_mt = 1;
%% ��4-1-3-2-9-2 Define variables to store in structure (Need to input: max, min, step-size)
    f_type = 'maps'; f_maps = 'map_mileage_all';
    [ind_ftype, ind_fmaps]  = ff_am3_1_1_struct_call(f_type, f_maps, M_data_fq, i_mt);
    M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data   = ff_am3_1_1_makemap( 0.5, 1000,      0.5); % Distance travelled 
    map_mileage_all = M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data;            % Save for later use
    f_type = 'maps'; f_maps = 'map_mileage_mt';
    [ind_ftype, ind_fmaps]  = ff_am3_1_1_struct_call(f_type, f_maps, M_data_fq, i_mt);
    M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data   = ff_am3_1_1_makemap( 0.1,  500,      0.1); % Distance travelled per microtrip
    map_mileage_mt = M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data;             % Save for later use
    f_type = 'maps'; f_maps = 'map_vspe';
    [ind_ftype, ind_fmaps]  = ff_am3_1_1_struct_call(f_type, f_maps, M_data_fq, i_mt);
    M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data   = ff_am3_1_1_makemap(   1,  vsp_max,    1); % Vehicle speed
    map_vspe = M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data;                   % Save for later use
    f_type = 'maps'; f_maps = 'map_stptime';
    [ind_ftype, ind_fmaps]  = ff_am3_1_1_struct_call(f_type, f_maps, M_data_fq, i_mt);
    M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data   = ff_am3_1_1_makemap(   1,  600,        1); % Idling time
    map_stptime = M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data;                % Save for later use       
    f_type = 'maps'; f_maps = 'map_acctime';
    [ind_ftype, ind_fmaps]  = ff_am3_1_1_struct_call(f_type, f_maps, M_data_fq, i_mt);
    M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data   = ff_am3_1_1_makemap(   1,  100,        1); % Travelled time during ACC state (acceleration)
    map_acctime = M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data;                % Save for later use       
    f_type = 'maps'; f_maps = 'map_statime';
    [ind_ftype, ind_fmaps]  = ff_am3_1_1_struct_call(f_type, f_maps, M_data_fq, i_mt);
    M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data   = ff_am3_1_1_makemap(   1,  300,        1); % Travelled time during CRU state (cruise)
    map_statime = M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data;                % Save for later use  
    f_type = 'maps'; f_maps = 'map_dectime';
    [ind_ftype, ind_fmaps]  = ff_am3_1_1_struct_call(f_type, f_maps, M_data_fq, i_mt);
    M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data   = ff_am3_1_1_makemap(   1,  100,        1); % Travelled time during DEC state (deceleration)
    map_dectime = M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data;                % Save for later use  
    f_type = 'maps'; f_maps = 'map_dvsp_x_vsp';
    [ind_ftype, ind_fmaps]  = ff_am3_1_1_struct_call(f_type, f_maps, M_data_fq, i_mt);
    M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data   = vsp_min:vsp_step:vsp_max; % accel x axis
    f_type = 'maps'; f_maps = 'map_dvsp_y_dvsp';
    [ind_ftype, ind_fmaps]  = ff_am3_1_1_struct_call(f_type, f_maps, M_data_fq, i_mt);
    M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data   = (-5:dvsp_step:5)';        % accel y axis
    
    %No need to collect entire map       
    map_dvsp1         = ff_am3_1_1_makemap(-5,5,dvsp_step);
    map_dvsp2         = ff_am3_1_1_makemap(-5,5,dvsp_step);
    map_dvsp3         = ff_am3_1_1_makemap(-5,5,dvsp_step);
    map_dvsp4         = ff_am3_1_1_makemap(-5,5,dvsp_step);
    map_dvsp5         = ff_am3_1_1_makemap(-5,5,dvsp_step);
    map_dvsp6         = ff_am3_1_1_makemap(-5,5,dvsp_step);
    map_dvsp7         = ff_am3_1_1_makemap(-5,5,dvsp_step);
    map_dvsp8         = ff_am3_1_1_makemap(-5,5,dvsp_step);
    map_dvsp9         = ff_am3_1_1_makemap(-5,5,dvsp_step);
    map_dvsp10        = ff_am3_1_1_makemap(-5,5,dvsp_step);
    map_dvsp11        = ff_am3_1_1_makemap(-5,5,dvsp_step);
    map_dvsp12        = ff_am3_1_1_makemap(-5,5,dvsp_step);
    map_dvsp13        = ff_am3_1_1_makemap(-5,5,dvsp_step);
    map_dvsp14        = ff_am3_1_1_makemap(-5,5,dvsp_step);
    map_dvsp15        = ff_am3_1_1_makemap(-5,5,dvsp_step);
    map_dvsp16        = ff_am3_1_1_makemap(-5,5,dvsp_step);
    map_dvsp17        = ff_am3_1_1_makemap(-5,5,dvsp_step);
    map_dvsp18        = ff_am3_1_1_makemap(-5,5,dvsp_step);
    map_dvsp19        = ff_am3_1_1_makemap(-5,5,dvsp_step);
    map_dvsp20        = ff_am3_1_1_makemap(-5,5,dvsp_step);
    map_dvsp21        = ff_am3_1_1_makemap(-5,5,dvsp_step);

%% Total distance travelled
    f_type = 'maps'; f_maps = 'map_mileage_all';
    [ind_ftype, ind_fmaps]  = ff_am3_1_1_struct_call(f_type, f_maps, M_data_fq, i_mt);
    M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data   = ff_am3_1_1_mapcalc(out_mileage_all,map_mileage_all);

%% Distance travelled per microtrip
    f_type = 'maps'; f_maps = 'map_mileage_mt';
    [ind_ftype, ind_fmaps]  = ff_am3_1_1_struct_call(f_type, f_maps, M_data_fq, i_mt);
    M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data   = ff_am3_1_1_mapcalc(out_mileage_mt,map_mileage_mt);

%% Vehicle Speed
    f_type = 'maps'; f_maps = 'map_vspe';
    [ind_ftype, ind_fmaps]  = ff_am3_1_1_struct_call(f_type, f_maps, M_data_fq, i_mt);
    M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data   = ff_am3_1_1_mapcalc_vspe(out_vspe,map_vspe,dt);

%% Idle Time
    f_type = 'maps'; f_maps = 'map_stptime';
    [ind_ftype, ind_fmaps]  = ff_am3_1_1_struct_call(f_type, f_maps, M_data_fq, i_mt);
    M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data   = ff_am3_1_1_mapcalc(out_stptime,map_stptime);
    
%% ��4-1-3-2-9-3 Construct Speed Acceleration Frequency Map
 % Partition maps into ACC/CRU/DEC
    map_dvsp1(1:92,:)     = ff_am3_1_1_mapcalc2(out_dvsp{1,1},map_dvsp1(1:92,:));
    map_dvsp1(93:109,:)   = ff_am3_1_1_mapcalc2(out_dvsp{1,1},map_dvsp1(93:109,:));
    map_dvsp1(110:201,:)  = ff_am3_1_1_mapcalc2(out_dvsp{1,1},map_dvsp1(110:201,:));
    map_dvsp2(1:92,:)     = ff_am3_1_1_mapcalc2(out_dvsp{1,2},map_dvsp2(1:92,:));
    map_dvsp2(93:109,:)   = ff_am3_1_1_mapcalc2(out_dvsp{1,2},map_dvsp2(93:109,:));
    map_dvsp2(110:201,:)  = ff_am3_1_1_mapcalc2(out_dvsp{1,2},map_dvsp2(110:201,:));
    map_dvsp3(1:92,:)     = ff_am3_1_1_mapcalc2(out_dvsp{1,3},map_dvsp3(1:92,:));
    map_dvsp3(93:109,:)   = ff_am3_1_1_mapcalc2(out_dvsp{1,3},map_dvsp3(93:109,:));
    map_dvsp3(110:201,:)  = ff_am3_1_1_mapcalc2(out_dvsp{1,3},map_dvsp3(110:201,:));
    map_dvsp4(1:92,:)     = ff_am3_1_1_mapcalc2(out_dvsp{1,4},map_dvsp4(1:92,:));
    map_dvsp4(93:109,:)   = ff_am3_1_1_mapcalc2(out_dvsp{1,4},map_dvsp4(93:109,:));
    map_dvsp4(110:201,:)  = ff_am3_1_1_mapcalc2(out_dvsp{1,4},map_dvsp4(110:201,:));
    map_dvsp5(1:92,:)     = ff_am3_1_1_mapcalc2(out_dvsp{1,5},map_dvsp5(1:92,:));
    map_dvsp5(93:109,:)   = ff_am3_1_1_mapcalc2(out_dvsp{1,5},map_dvsp5(93:109,:));
    map_dvsp5(110:201,:)  = ff_am3_1_1_mapcalc2(out_dvsp{1,5},map_dvsp5(110:201,:));
    map_dvsp6(1:92,:)     = ff_am3_1_1_mapcalc2(out_dvsp{1,6},map_dvsp6(1:92,:));
    map_dvsp6(93:109,:)   = ff_am3_1_1_mapcalc2(out_dvsp{1,6},map_dvsp6(93:109,:));
    map_dvsp6(110:201,:)  = ff_am3_1_1_mapcalc2(out_dvsp{1,6},map_dvsp6(110:201,:));
    map_dvsp7(1:92,:)     = ff_am3_1_1_mapcalc2(out_dvsp{1,7},map_dvsp7(1:92,:));
    map_dvsp7(93:109,:)   = ff_am3_1_1_mapcalc2(out_dvsp{1,7},map_dvsp7(93:109,:));
    map_dvsp7(110:201,:)  = ff_am3_1_1_mapcalc2(out_dvsp{1,7},map_dvsp7(110:201,:));
    map_dvsp8(1:92,:)     = ff_am3_1_1_mapcalc2(out_dvsp{1,8},map_dvsp8(1:92,:));
    map_dvsp8(93:109,:)   = ff_am3_1_1_mapcalc2(out_dvsp{1,8},map_dvsp8(93:109,:));
    map_dvsp8(110:201,:)  = ff_am3_1_1_mapcalc2(out_dvsp{1,8},map_dvsp8(110:201,:));
    map_dvsp9(1:92,:)     = ff_am3_1_1_mapcalc2(out_dvsp{1,9},map_dvsp9(1:92,:));
    map_dvsp9(93:109,:)   = ff_am3_1_1_mapcalc2(out_dvsp{1,9},map_dvsp9(93:109,:));
    map_dvsp9(110:201,:)  = ff_am3_1_1_mapcalc2(out_dvsp{1,9},map_dvsp9(110:201,:));
    map_dvsp10(1:92,:)    = ff_am3_1_1_mapcalc2(out_dvsp{1,10},map_dvsp10(1:92,:));
    map_dvsp10(93:109,:)  = ff_am3_1_1_mapcalc2(out_dvsp{1,10},map_dvsp10(93:109,:));
    map_dvsp10(110:201,:) = ff_am3_1_1_mapcalc2(out_dvsp{1,10},map_dvsp10(110:201,:));    
    map_dvsp11(1:92,:)    = ff_am3_1_1_mapcalc2(out_dvsp{1,11},map_dvsp11(1:92,:));
    map_dvsp11(93:109,:)  = ff_am3_1_1_mapcalc2(out_dvsp{1,11},map_dvsp11(93:109,:));
    map_dvsp11(110:201,:) = ff_am3_1_1_mapcalc2(out_dvsp{1,11},map_dvsp11(110:201,:));
    map_dvsp12(1:92,:)    = ff_am3_1_1_mapcalc2(out_dvsp{1,12},map_dvsp12(1:92,:));
    map_dvsp12(93:109,:)  = ff_am3_1_1_mapcalc2(out_dvsp{1,12},map_dvsp12(93:109,:));
    map_dvsp12(110:201,:) = ff_am3_1_1_mapcalc2(out_dvsp{1,12},map_dvsp12(110:201,:));
    map_dvsp13(1:92,:)    = ff_am3_1_1_mapcalc2(out_dvsp{1,13},map_dvsp13(1:92,:));
    map_dvsp13(93:109,:)  = ff_am3_1_1_mapcalc2(out_dvsp{1,13},map_dvsp13(93:109,:));
    map_dvsp13(110:201,:) = ff_am3_1_1_mapcalc2(out_dvsp{1,13},map_dvsp13(110:201,:));
    map_dvsp14(1:92,:)    = ff_am3_1_1_mapcalc2(out_dvsp{1,14},map_dvsp14(1:92,:));
    map_dvsp14(93:109,:)  = ff_am3_1_1_mapcalc2(out_dvsp{1,14},map_dvsp14(93:109,:));
    map_dvsp14(110:201,:) = ff_am3_1_1_mapcalc2(out_dvsp{1,14},map_dvsp14(110:201,:));
    map_dvsp15(1:92,:)    = ff_am3_1_1_mapcalc2(out_dvsp{1,15},map_dvsp15(1:92,:));
    map_dvsp15(93:109,:)  = ff_am3_1_1_mapcalc2(out_dvsp{1,15},map_dvsp15(93:109,:));
    map_dvsp15(110:201,:) = ff_am3_1_1_mapcalc2(out_dvsp{1,15},map_dvsp15(110:201,:));
    map_dvsp16(1:92,:)    = ff_am3_1_1_mapcalc2(out_dvsp{1,16},map_dvsp16(1:92,:));
    map_dvsp16(93:109,:)  = ff_am3_1_1_mapcalc2(out_dvsp{1,16},map_dvsp16(93:109,:));
    map_dvsp16(110:201,:) = ff_am3_1_1_mapcalc2(out_dvsp{1,16},map_dvsp16(110:201,:));
    map_dvsp17(1:92,:)    = ff_am3_1_1_mapcalc2(out_dvsp{1,17},map_dvsp17(1:92,:));
    map_dvsp17(93:109,:)  = ff_am3_1_1_mapcalc2(out_dvsp{1,17},map_dvsp17(93:109,:));
    map_dvsp17(110:201,:) = ff_am3_1_1_mapcalc2(out_dvsp{1,17},map_dvsp17(110:201,:));
    map_dvsp18(1:92,:)    = ff_am3_1_1_mapcalc2(out_dvsp{1,18},map_dvsp18(1:92,:));
    map_dvsp18(93:109,:)  = ff_am3_1_1_mapcalc2(out_dvsp{1,18},map_dvsp18(93:109,:));
    map_dvsp18(110:201,:) = ff_am3_1_1_mapcalc2(out_dvsp{1,18},map_dvsp18(110:201,:));
    map_dvsp19(1:92,:)    = ff_am3_1_1_mapcalc2(out_dvsp{1,19},map_dvsp19(1:92,:));
    map_dvsp19(93:109,:)  = ff_am3_1_1_mapcalc2(out_dvsp{1,19},map_dvsp19(93:109,:));
    map_dvsp19(110:201,:) = ff_am3_1_1_mapcalc2(out_dvsp{1,19},map_dvsp19(110:201,:));
    map_dvsp20(1:92,:)    = ff_am3_1_1_mapcalc2(out_dvsp{1,20},map_dvsp20(1:92,:));
    map_dvsp20(93:109,:)  = ff_am3_1_1_mapcalc2(out_dvsp{1,20},map_dvsp20(93:109,:));
    map_dvsp20(110:201,:) = ff_am3_1_1_mapcalc2(out_dvsp{1,20},map_dvsp20(110:201,:));
    map_dvsp21(1:92,:)    = ff_am3_1_1_mapcalc2(out_dvsp{1,21},map_dvsp21(1:92,:));
    map_dvsp21(93:109,:)  = ff_am3_1_1_mapcalc2(out_dvsp{1,21},map_dvsp21(93:109,:));
    map_dvsp21(110:201,:) = ff_am3_1_1_mapcalc2(out_dvsp{1,21},map_dvsp21(110:201,:));    
       
    map_dvsp = [map_dvsp1(:,2)  map_dvsp2(:,2)  map_dvsp3(:,2)  map_dvsp4(:,2)  map_dvsp5(:,2) ...
                map_dvsp6(:,2)  map_dvsp7(:,2)  map_dvsp8(:,2)  map_dvsp9(:,2)  map_dvsp10(:,2) ...
                map_dvsp11(:,2) map_dvsp12(:,2) map_dvsp13(:,2) map_dvsp14(:,2) map_dvsp15(:,2) ...
                map_dvsp16(:,2) map_dvsp17(:,2) map_dvsp18(:,2) map_dvsp19(:,2) map_dvsp20(:,2) ...
                map_dvsp21(:,2)];         

    f_type = 'maps'; f_maps = 'map_dvsp';
    [ind_ftype, ind_fmaps]  = ff_am3_1_1_struct_call(f_type, f_maps, M_data_fq, i_mt);
    M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data   = map_dvsp;
    
    f_type = 'maps'; f_maps = 'map_dvsp_dec';
    [ind_ftype, ind_fmaps]  = ff_am3_1_1_struct_call(f_type, f_maps, M_data_fq, i_mt);
    M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data = map_dvsp(  1: 92,:);
    f_type = 'maps'; f_maps = 'map_dvsp_sta';
    [ind_ftype, ind_fmaps]  = ff_am3_1_1_struct_call(f_type, f_maps, M_data_fq, i_mt);
    M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data = map_dvsp( 93:109,:);
    f_type = 'maps'; f_maps = 'map_dvsp_acc';
    [ind_ftype, ind_fmaps]  = ff_am3_1_1_struct_call(f_type, f_maps, M_data_fq, i_mt);
    M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data = map_dvsp(110:201,:);
    
    f_type = 'maps'; f_maps = 'map_acctime';
    [ind_ftype, ind_fmaps]  = ff_am3_1_1_struct_call(f_type, f_maps, M_data_fq, i_mt);
    M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data   = ff_am3_1_1_mapcalc(out_acctime,map_acctime);
    
    f_type = 'maps'; f_maps = 'map_statime';
    [ind_ftype, ind_fmaps]  = ff_am3_1_1_struct_call(f_type, f_maps, M_data_fq, i_mt);
    M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data   = ff_am3_1_1_mapcalc(out_statime,map_statime);
    
    f_type = 'maps'; f_maps = 'map_dectime';
    [ind_ftype, ind_fmaps]  = ff_am3_1_1_struct_call(f_type, f_maps, M_data_fq, i_mt);
    M_data_fq(i_mt).type(ind_ftype).maps(ind_fmaps).data.data   = ff_am3_1_1_mapcalc(out_dectime,map_dectime);
    
end    
    