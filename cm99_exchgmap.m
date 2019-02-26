% シミュレーション用のマップ形式に変換する

%% IG-ON～OFFまでの走行距離
    [map_mileage_all_x map_mileage_all_y] = func_map2simmap(map_mileage_all(:,2),map_mileage_all(:,1));

%% 一山の走行距離
    [map_mileage_yama_x map_mileage_yama_y] = func_map2simmap(map_mileage_yama(:,2),map_mileage_yama(:,1));

%% 車速
    [map_vspe_x map_vspe_y] = func_map2simmap(map_vspe(:,2),map_vspe(:,1));

%% 停車時間
    [map_stptime_x map_stptime_y] = func_map2simmap(map_stptime(:,2),map_stptime(:,1));

%% 加速走行の継続時間
    [map_acctime_x map_acctime_y] = func_map2simmap(map_acctime(:,2),map_acctime(:,1));

%% 定常走行の継続時間
    [map_statime_x map_statime_y] = func_map2simmap(map_statime(:,2),map_statime(:,1));

%% 減速走行の継続時間
    [map_dectime_x map_dectime_y] = func_map2simmap(map_dectime(:,2),map_dectime(:,1));    
    
%% 加速時の加速度
    [map_accvalue_x1  map_accvalue_y1] = func_map2simmap(map_dvsp_acc(:,1),map_dvsp1(110:201,1));
    [map_accvalue_x2  map_accvalue_y2] = func_map2simmap(map_dvsp_acc(:,2),map_dvsp1(110:201,1));
    [map_accvalue_x3  map_accvalue_y3] = func_map2simmap(map_dvsp_acc(:,3),map_dvsp1(110:201,1));
    [map_accvalue_x4  map_accvalue_y4] = func_map2simmap(map_dvsp_acc(:,4),map_dvsp1(110:201,1));
    [map_accvalue_x5  map_accvalue_y5] = func_map2simmap(map_dvsp_acc(:,5),map_dvsp1(110:201,1));
    [map_accvalue_x6  map_accvalue_y6] = func_map2simmap(map_dvsp_acc(:,6),map_dvsp1(110:201,1));
    [map_accvalue_x7  map_accvalue_y7] = func_map2simmap(map_dvsp_acc(:,7),map_dvsp1(110:201,1));
    [map_accvalue_x8  map_accvalue_y8] = func_map2simmap(map_dvsp_acc(:,8),map_dvsp1(110:201,1));
    [map_accvalue_x9  map_accvalue_y9] = func_map2simmap(map_dvsp_acc(:,9),map_dvsp1(110:201,1));
    [map_accvalue_x10 map_accvalue_y10] = func_map2simmap(map_dvsp_acc(:,10),map_dvsp1(110:201,1));
    [map_accvalue_x11 map_accvalue_y11] = func_map2simmap(map_dvsp_acc(:,11),map_dvsp1(110:201,1));
    [map_accvalue_x12 map_accvalue_y12] = func_map2simmap(map_dvsp_acc(:,12),map_dvsp1(110:201,1));
    [map_accvalue_x13 map_accvalue_y13] = func_map2simmap(map_dvsp_acc(:,13),map_dvsp1(110:201,1));
    [map_accvalue_x14 map_accvalue_y14] = func_map2simmap(map_dvsp_acc(:,14),map_dvsp1(110:201,1));
    [map_accvalue_x15 map_accvalue_y15] = func_map2simmap(map_dvsp_acc(:,15),map_dvsp1(110:201,1));
    [map_accvalue_x16 map_accvalue_y16] = func_map2simmap(map_dvsp_acc(:,16),map_dvsp1(110:201,1));
    [map_accvalue_x17 map_accvalue_y17] = func_map2simmap(map_dvsp_acc(:,17),map_dvsp1(110:201,1));
    [map_accvalue_x18 map_accvalue_y18] = func_map2simmap(map_dvsp_acc(:,18),map_dvsp1(110:201,1));
    [map_accvalue_x19 map_accvalue_y19] = func_map2simmap(map_dvsp_acc(:,19),map_dvsp1(110:201,1));
    [map_accvalue_x20 map_accvalue_y20] = func_map2simmap(map_dvsp_acc(:,20),map_dvsp1(110:201,1));
 
%% 定常時の加速度
    [map_stavalue_x1  map_stavalue_y1] = func_map2simmap(map_dvsp_sta(:,1),map_dvsp1(93:109,1));
    [map_stavalue_x2  map_stavalue_y2] = func_map2simmap(map_dvsp_sta(:,2),map_dvsp1(93:109,1));
    [map_stavalue_x3  map_stavalue_y3] = func_map2simmap(map_dvsp_sta(:,3),map_dvsp1(93:109,1));
    [map_stavalue_x4  map_stavalue_y4] = func_map2simmap(map_dvsp_sta(:,4),map_dvsp1(93:109,1));
    [map_stavalue_x5  map_stavalue_y5] = func_map2simmap(map_dvsp_sta(:,5),map_dvsp1(93:109,1));
    [map_stavalue_x6  map_stavalue_y6] = func_map2simmap(map_dvsp_sta(:,6),map_dvsp1(93:109,1));
    [map_stavalue_x7  map_stavalue_y7] = func_map2simmap(map_dvsp_sta(:,7),map_dvsp1(93:109,1));
    [map_stavalue_x8  map_stavalue_y8] = func_map2simmap(map_dvsp_sta(:,8),map_dvsp1(93:109,1));
    [map_stavalue_x9  map_stavalue_y9] = func_map2simmap(map_dvsp_sta(:,9),map_dvsp1(93:109,1));
    [map_stavalue_x10 map_stavalue_y10] = func_map2simmap(map_dvsp_sta(:,10),map_dvsp1(93:109,1));
    [map_stavalue_x11 map_stavalue_y11] = func_map2simmap(map_dvsp_sta(:,11),map_dvsp1(93:109,1));
    [map_stavalue_x12 map_stavalue_y12] = func_map2simmap(map_dvsp_sta(:,12),map_dvsp1(93:109,1));
    [map_stavalue_x13 map_stavalue_y13] = func_map2simmap(map_dvsp_sta(:,13),map_dvsp1(93:109,1));
    [map_stavalue_x14 map_stavalue_y14] = func_map2simmap(map_dvsp_sta(:,14),map_dvsp1(93:109,1));
    [map_stavalue_x15 map_stavalue_y15] = func_map2simmap(map_dvsp_sta(:,15),map_dvsp1(93:109,1));
    [map_stavalue_x16 map_stavalue_y16] = func_map2simmap(map_dvsp_sta(:,16),map_dvsp1(93:109,1));
    [map_stavalue_x17 map_stavalue_y17] = func_map2simmap(map_dvsp_sta(:,17),map_dvsp1(93:109,1));
    [map_stavalue_x18 map_stavalue_y18] = func_map2simmap(map_dvsp_sta(:,18),map_dvsp1(93:109,1));
    [map_stavalue_x19 map_stavalue_y19] = func_map2simmap(map_dvsp_sta(:,19),map_dvsp1(93:109,1));
    [map_stavalue_x20 map_stavalue_y20] = func_map2simmap(map_dvsp_sta(:,20),map_dvsp1(93:109,1));

%% 減速時の加速度（減速度）
    [map_decvalue_x1  map_decvalue_y1] = func_map2simmap(flipud(map_dvsp_dec(:,1)),flipud(map_dvsp1(1:92,1)));
    [map_decvalue_x2  map_decvalue_y2] = func_map2simmap(flipud(map_dvsp_dec(:,2)),flipud(map_dvsp1(1:92,1)));
    [map_decvalue_x3  map_decvalue_y3] = func_map2simmap(flipud(map_dvsp_dec(:,3)),flipud(map_dvsp1(1:92,1)));
    [map_decvalue_x4  map_decvalue_y4] = func_map2simmap(flipud(map_dvsp_dec(:,4)),flipud(map_dvsp1(1:92,1)));
    [map_decvalue_x5  map_decvalue_y5] = func_map2simmap(flipud(map_dvsp_dec(:,5)),flipud(map_dvsp1(1:92,1)));
    [map_decvalue_x6  map_decvalue_y6] = func_map2simmap(flipud(map_dvsp_dec(:,6)),flipud(map_dvsp1(1:92,1)));
    [map_decvalue_x7  map_decvalue_y7] = func_map2simmap(flipud(map_dvsp_dec(:,7)),flipud(map_dvsp1(1:92,1)));
    [map_decvalue_x8  map_decvalue_y8] = func_map2simmap(flipud(map_dvsp_dec(:,8)),flipud(map_dvsp1(1:92,1)));
    [map_decvalue_x9  map_decvalue_y9] = func_map2simmap(flipud(map_dvsp_dec(:,9)),flipud(map_dvsp1(1:92,1)));
    [map_decvalue_x10 map_decvalue_y10] = func_map2simmap(flipud(map_dvsp_dec(:,10)),flipud(map_dvsp1(1:92,1)));
    [map_decvalue_x11 map_decvalue_y11] = func_map2simmap(flipud(map_dvsp_dec(:,11)),flipud(map_dvsp1(1:92,1)));
    [map_decvalue_x12 map_decvalue_y12] = func_map2simmap(flipud(map_dvsp_dec(:,12)),flipud(map_dvsp1(1:92,1)));
    [map_decvalue_x13 map_decvalue_y13] = func_map2simmap(flipud(map_dvsp_dec(:,13)),flipud(map_dvsp1(1:92,1)));
    [map_decvalue_x14 map_decvalue_y14] = func_map2simmap(flipud(map_dvsp_dec(:,14)),flipud(map_dvsp1(1:92,1)));
    [map_decvalue_x15 map_decvalue_y15] = func_map2simmap(flipud(map_dvsp_dec(:,15)),flipud(map_dvsp1(1:92,1)));
    [map_decvalue_x16 map_decvalue_y16] = func_map2simmap(flipud(map_dvsp_dec(:,16)),flipud(map_dvsp1(1:92,1)));
    [map_decvalue_x17 map_decvalue_y17] = func_map2simmap(flipud(map_dvsp_dec(:,17)),flipud(map_dvsp1(1:92,1)));
    [map_decvalue_x18 map_decvalue_y18] = func_map2simmap(flipud(map_dvsp_dec(:,18)),flipud(map_dvsp1(1:92,1)));
    [map_decvalue_x19 map_decvalue_y19] = func_map2simmap(flipud(map_dvsp_dec(:,19)),flipud(map_dvsp1(1:92,1)));
    [map_decvalue_x20 map_decvalue_y20] = func_map2simmap(flipud(map_dvsp_dec(:,20)),flipud(map_dvsp1(1:92,1)));

  
%% end