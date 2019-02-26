%% Specify custom variable name here
% Column position will be remembered in colvars

%Define globally shared variables
as_         = [];                          % AnsiString storage 
var_        = [];                          % Variable storage 

%% ��1.1 Preset increment counters for radar variables
%Please add additional custom variables to "cm1_1_Dataset_unique"
  i_asn(1)  = 1; %i_posx
  i_asn(2)  = 2; %i_posy
  i_asn(3)  = 3; %i_velx
  i_asn(4)  = 4; %i_vely
  i_asn(5)  = 5; %i_accx
  i_asn(6)  = 6; %i_thw 
  i_asn(7)  = 7; %i_ilv ********PLEASE SET ILV STRING TO 7!******** 
  i_asn(8)  = 8; %i_lane
  i_asn_ilv = i_asn(7);
%% ��1.2 Timestamp, speed, longitudinal acceleration global variable declaration 
%========= NOTE:  PLEASE BE SURE TO KEEP THE FIRST 3 VARIABLES IN THIS ORDER =========
%AnsiString var names                                      % colval    % variable name
as_{1}   = 'time (s)';                                     %   1       % timestamp
as_{2}   = 'velocity';                                     %   2       % Ego vehicle velocity
as_{3}   = 'VehLong_A_Actl(m/s^2)';                        %   3       % Ego vehicle acceleration x
as_{4}   = 'EngAout_N_Actl(rpm)';                          %   4       % Egngine rpm
as_{5}   = 'Veh_V_ActlEng_Axl(kph)';                       %   5       % Ego vehicle velocity eng axle
as_{6}   = 'ApedPos_Pc_ActlArb(%)';                        %   6       % APO
as_{7}   = 'APS(%/s)';                                     %   7       % APS
as_{8}   = 'jerk(m/s^3)';                                  %   8       % Jerk
as_{9}   = 'grade(%)';                                     %   9       % Grade
as_{10}  = 'SteWhlRelCalib_An_Sns(Deg)';                   %   10      % SWA
as_{11}  = 'SteWhl_ChangeRate(deg/s)';                     %   11      % SWA rate
as_{12}  = 'SteAngReltv_An_Sns(deg)';                      %   12      % SWA relative
as_{13}  = 'SteWhlComp_An_Est(deg)';                       %   13      % SWA compensation angle estimated
as_{14}  = 'Lateral_Acceleration(g)';                      %   14      % Lateral acceleration
as_{15}  = 'BSM_BuzzerRequest(Binary)';                    %   15      % Push button
as_{16}  = 'BSM_Warn_R(State encoded)';                    %   16      % BSM warning Right
as_{17}  = 'BSM_Warn_L(State encoded)';                    %   17      % BSM warning Left

asn_org = length(as_);
%============== The rest of the variables can be in any arbitrary order ==============

%% ��1.3 Radar variable declaration 
%AnsiString var names                                     % colval           % variable name
as_{asn_org+i_asn(1)}  = 'D11(@)';                        %   asn_org+1      % Track1 vehicle lonogitudinal position
as_{asn_org+i_asn(2)}  = 'D12(@)';                        %   asn_org+2      % Track1 vehicle lateral position
as_{asn_org+i_asn(3)}  = 'D16(@)';                        %   asn_org+3      % Track1 vehicle longitudinal speed
as_{asn_org+i_asn(4)}  = 'NA';                            %   asn_org+4      % Track1 vehicle lateral speed
as_{asn_org+i_asn(5)}  = 'NA';                            %   asn_org+5      % Track1 vehicle acceleration
as_{asn_org+i_asn(6)}  = 'NA';                            %   asn_org+6      % Track1 vehicle headway 
as_{asn_org+i_asn(7)}  = 'NA';                            %   asn_org+7      % Track1 vehicle flag Obj(1)
as_{asn_org+i_asn(8)}  = 'NA';                            %   asn_org+8      % Track1 poisition lead vehicle
asn = length(as_);
as_{asn+i_asn(1)}  = 'D21(@)';                            %   asn_org+9      % Track2 vehicle lonogitudinal position
as_{asn+i_asn(2)}  = 'D22(@)';                            %   asn_org+10     % Track2 vehicle lateral position
as_{asn+i_asn(3)}  = 'D26(@)';                            %   asn_org+11     % Track2 vehicle longitudinal speed
as_{asn+i_asn(4)}  = 'NA';                                %   asn_org+12     % Track2 vehicle lateral speed
as_{asn+i_asn(5)}  = 'NA';                                %   asn_org+13     % Track2 vehicle acceleration
as_{asn+i_asn(6)}  = 'NA';                                %   asn_org+14     % Track2 vehicle headway 
as_{asn+i_asn(7)}  = 'NA';                                %   asn_org+15     % Track2 vehicle flag Obj(1)
as_{asn+i_asn(8)}  = 'NA';                                %   asn_org+16     % Track2 poisition lead vehicle
asn = length(as_);                                            
as_{asn+i_asn(1)}  = 'D31(@)';                            %   asn_org+17     % Track3 vehicle lonogitudinal position
as_{asn+i_asn(2)}  = 'D32(@)';                            %   asn_org+18     % Track3 vehicle lateral position
as_{asn+i_asn(3)}  = 'D36(@)';                            %   asn_org+19     % Track3 vehicle longitudinal speed
as_{asn+i_asn(4)}  = 'NA';                                %   asn_org+20     % Track3 vehicle lateral speed
as_{asn+i_asn(5)}  = 'NA';                                %   asn_org+21     % Track3 vehicle acceleration
as_{asn+i_asn(6)}  = 'NA';                                %   asn_org+22     % Track3 vehicle headway 
as_{asn+i_asn(7)}  = 'NA';                                %   asn_org+23     % Track3 vehicle flag Obj(1)
as_{asn+i_asn(8)}  = 'NA';                                %   asn_org+24     % Track3 poisition lead vehicle
asn = length(as_);                                           
as_{asn+i_asn(1)}  = 'D41(@)';                            %   asn_org+25     % Track4 vehicle lonogitudinal position
as_{asn+i_asn(2)}  = 'D42(@)';                            %   asn_org+26     % Track4 vehicle lateral position
as_{asn+i_asn(3)}  = 'D46(@)';                            %   asn_org+27     % Track4 vehicle longitudinal speed
as_{asn+i_asn(4)}  = 'NA';                                %   asn_org+28     % Track4 vehicle lateral speed
as_{asn+i_asn(5)}  = 'NA';                                %   asn_org+29     % Track4 vehicle acceleration
as_{asn+i_asn(6)}  = 'NA';                                %   asn_org+30     % Track4 vehicle headway 
as_{asn+i_asn(7)}  = 'NA';                                %   asn_org+31     % Track4 vehicle flag Obj(1)
as_{asn+i_asn(8)}  = 'NA';                                %   asn_org+32     % Track4 poisition lead vehicle
asn = length(as_);                                            
as_{asn+i_asn(1)}  = 'D51(@)';                            %   asn_org+33     % Track5 vehicle lonogitudinal position
as_{asn+i_asn(2)}  = 'D52(@)';                            %   asn_org+34     % Track5 vehicle lateral position
as_{asn+i_asn(3)}  = 'D56(@)';                            %   asn_org+35     % Track5 vehicle longitudinal speed
as_{asn+i_asn(4)}  = 'NA';                                %   asn_org+36     % Track5 vehicle lateral speed
as_{asn+i_asn(5)}  = 'NA';                                %   asn_org+37     % Track5 vehicle acceleration
as_{asn+i_asn(6)}  = 'NA';                                %   asn_org+38     % Track5 vehicle headway 
as_{asn+i_asn(7)}  = 'NA';                                %   asn_org+39     % Track5 vehicle flag Obj(1)
as_{asn+i_asn(8)}  = 'NA';                                %   asn_org+40     % Track5 poisition lead vehicle
asn = length(as_);                                            
as_{asn+i_asn(1)}  = 'D61(@)';                            %   asn_org+41     % TRACK6 vehicle lonogitudinal position
as_{asn+i_asn(2)}  = 'D62(@)';                            %   asn_org+42     % TRACK6 vehicle lateral position
as_{asn+i_asn(3)}  = 'D66(@)';                            %   asn_org+43     % TRACK6 vehicle longitudinal speed
as_{asn+i_asn(4)}  = 'NA';                                %   asn_org+44     % TRACK6 vehicle lateral speed
as_{asn+i_asn(5)}  = 'NA';                                %   asn_org+45     % TRACK6 vehicle acceleration
as_{asn+i_asn(6)}  = 'NA';                                %   asn_org+46     % TRACK6 vehicle headway 
as_{asn+i_asn(7)}  = 'NA';                                %   asn_org+47     % TRACK6 vehicle flag Obj(1)
as_{asn+i_asn(8)}  = 'NA';                                %   asn_org+48     % TRACK6 poisition lead vehicle
asn = length(as_);                                          
as_{asn+i_asn(1)}  = 'D71(@)';                            %   asn_org+49     % TRACK7 vehicle lonogitudinal position
as_{asn+i_asn(2)}  = 'D72(@)';                            %   asn_org+50     % TRACK7 vehicle lateral position
as_{asn+i_asn(3)}  = 'D76(@)';                            %   asn_org+51     % TRACK7 vehicle longitudinal speed
as_{asn+i_asn(4)}  = 'NA';                                %   asn_org+52     % TRACK7 vehicle lateral speed
as_{asn+i_asn(5)}  = 'NA';                                %   asn_org+53     % TRACK7 vehicle acceleration
as_{asn+i_asn(6)}  = 'NA';                                %   asn_org+54     % TRACK7 vehicle headway 
as_{asn+i_asn(7)}  = 'NA';                                %   asn_org+55     % TRACK7 vehicle flag Obj(1)
as_{asn+i_asn(8)}  = 'NA';                                %   asn_org+56     % TRACK7 poisition lead vehicle
asn = length(as_);                                      
as_{asn+i_asn(1)}  = 'D81(@)';                            %   asn_org+57     % TRACK8 vehicle lonogitudinal position
as_{asn+i_asn(2)}  = 'D82(@)';                            %   asn_org+58     % TRACK8 vehicle lateral position
as_{asn+i_asn(3)}  = 'D86(@)';                            %   asn_org+59     % TRACK8 vehicle longitudinal speed
as_{asn+i_asn(4)}  = 'NA';                                %   asn_org+60     % TRACK8 vehicle lateral speed
as_{asn+i_asn(5)}  = 'NA';                                %   asn_org+61     % TRACK8 vehicle acceleration
as_{asn+i_asn(6)}  = 'NA';                                %   asn_org+62     % TRACK8 vehicle headway 
as_{asn+i_asn(7)}  = 'NA';                                %   asn_org+63     % TRACK8 vehicle flag Obj(1)
as_{asn+i_asn(8)}  = 'NA';                                %   asn_org+64     % TRACK8 poisition lead vehicle
asn = length(as_);                                            
as_{asn+i_asn(1)}  = 'D91(@)';                            %   asn_org+65     % TRACK9 vehicle lonogitudinal position
as_{asn+i_asn(2)}  = 'D92(@)';                            %   asn_org+66     % TRACK9 vehicle lateral position
as_{asn+i_asn(3)}  = 'D96(@)';                            %   asn_org+67     % TRACK9 vehicle longitudinal speed
as_{asn+i_asn(4)}  = 'NA';                                %   asn_org+68     % TRACK9 vehicle lateral speed
as_{asn+i_asn(5)}  = 'NA';                                %   asn_org+69     % TRACK9 vehicle acceleration
as_{asn+i_asn(6)}  = 'NA';                                %   asn_org+70     % TRACK9 vehicle headway 
as_{asn+i_asn(7)}  = 'NA';                                %   asn_org+71     % TRACK9 vehicle flag Obj(1)
as_{asn+i_asn(8)}  = 'NA';                                %   asn_org+72     % TRACK9 poisition lead vehicle
asn = length(as_);                                            
as_{asn+i_asn(1)}  = 'D101(@)';                           %   asn_org+73     % TRACK10 vehicle lonogitudinal position
as_{asn+i_asn(2)}  = 'D102(@)';                           %   asn_org+74     % TRACK10 vehicle lateral position
as_{asn+i_asn(3)}  = 'D106(@)';                           %   asn_org+75     % TRACK10 vehicle longitudinal speed
as_{asn+i_asn(4)}  = 'NA';                                %   asn_org+76     % TRACK10 vehicle lateral speed
as_{asn+i_asn(5)}  = 'NA';                                %   asn_org+77     % TRACK10 vehicle acceleration
as_{asn+i_asn(6)}  = 'NA';                                %   asn_org+78     % TRACK10 vehicle headway 
as_{asn+i_asn(7)}  = 'NA';                                %   asn_org+79     % TRACK10 vehicle flag Obj(1)
as_{asn+i_asn(8)}  = 'NA';                                %   asn_org+80     % TRACK10 poisition lead vehicle
asn = length(as_);                                           
as_{asn+i_asn(1)}  = 'D111(@)';                           %   asn_org+81     % TRACK11 vehicle lonogitudinal position
as_{asn+i_asn(2)}  = 'D112(@)';                           %   asn_org+82     % TRACK11 vehicle lateral position
as_{asn+i_asn(3)}  = 'D116(@)';                           %   asn_org+83     % TRACK11 vehicle longitudinal speed
as_{asn+i_asn(4)}  = 'NA';                                %   asn_org+84     % TRACK11 vehicle lateral speed
as_{asn+i_asn(5)}  = 'NA';                                %   asn_org+85     % TRACK11 vehicle acceleration
as_{asn+i_asn(6)}  = 'NA';                                %   asn_org+86     % TRACK11 vehicle headway 
as_{asn+i_asn(7)}  = 'NA';                                %   asn_org+87     % TRACK11 vehicle flag Obj(1)
as_{asn+i_asn(8)}  = 'NA';                                %   asn_org+88     % TRACK11 poisition lead vehicle
asn = length(as_);                                    
as_{asn+i_asn(1)}  = 'D121(@)';                           %   asn_org+89     % TRACK12 vehicle lonogitudinal position
as_{asn+i_asn(2)}  = 'D122(@)';                           %   asn_org+90     % TRACK12 vehicle lateral position
as_{asn+i_asn(3)}  = 'D126(@)';                           %   asn_org+91     % TRACK12 vehicle longitudinal speed
as_{asn+i_asn(4)}  = 'NA';                                %   asn_org+84     % TRACK12 vehicle lateral speed
as_{asn+i_asn(5)}  = 'NA';                                %   asn_org+85     % TRACK12 vehicle acceleration
as_{asn+i_asn(6)}  = 'NA';                                %   asn_org+86     % TRACK12 vehicle headway 
as_{asn+i_asn(7)}  = 'NA';                                %   asn_org+87     % TRACK12 vehicle flag Obj(1)
as_{asn+i_asn(8)}  = 'NA';                                %   asn_org+88     % TRACK12 poisition lead vehicle
asn = length(as_);                                       
as_{asn+i_asn(1)}  = 'D131(@)';                           %   asn_org+89     % TRACK13 vehicle lonogitudinal position
as_{asn+i_asn(2)}  = 'D132(@)';                           %   asn_org+90     % TRACK13 vehicle lateral position
as_{asn+i_asn(3)}  = 'D136(@)';                           %   asn_org+91     % TRACK13 vehicle longitudinal speed
as_{asn+i_asn(4)}  = 'NA';                                %   asn_org+92     % TRACK13 vehicle lateral speed
as_{asn+i_asn(5)}  = 'NA';                                %   asn_org+93     % TRACK13 vehicle acceleration
as_{asn+i_asn(6)}  = 'NA';                                %   asn_org+94     % TRACK13 vehicle headway 
as_{asn+i_asn(7)}  = 'NA';                                %   asn_org+95     % TRACK13 vehicle flag Obj(1)
as_{asn+i_asn(8)}  = 'NA';                                %   asn_org+96     % TRACK13 poisition lead vehicle
asn = length(as_);                                      
as_{asn+i_asn(1)}  = 'D141(@)';                           %   asn_org+97     % TRACK14 vehicle lonogitudinal position
as_{asn+i_asn(2)}  = 'D142(@)';                           %   asn_org+98     % TRACK14 vehicle lateral position
as_{asn+i_asn(3)}  = 'D146(@)';                           %   asn_org+99     % TRACK14 vehicle longitudinal speed
as_{asn+i_asn(4)}  = 'NA';                                %   asn_org+100    % TRACK14 vehicle lateral speed
as_{asn+i_asn(5)}  = 'NA';                                %   asn_org+101    % TRACK14 vehicle acceleration
as_{asn+i_asn(6)}  = 'NA';                                %   asn_org+102    % TRACK14 vehicle headway 
as_{asn+i_asn(7)}  = 'NA';                                %   asn_org+103    % TRACK14 vehicle flag Obj(1)
as_{asn+i_asn(8)}  = 'NA';                                %   asn_org+104    % TRACK14 poisition lead vehicle
asn = length(as_);                                         
as_{asn+i_asn(1)}  = 'D151(@)';                           %   asn_org+105    % TRACK15 vehicle lonogitudinal position
as_{asn+i_asn(2)}  = 'D152(@)';                           %   asn_org+106    % TRACK15 vehicle lateral position
as_{asn+i_asn(3)}  = 'D156(@)';                           %   asn_org+107    % TRACK15 vehicle longitudinal speed
as_{asn+i_asn(4)}  = 'NA';                                %   asn_org+108    % TRACK15 vehicle lateral speed
as_{asn+i_asn(5)}  = 'NA';                                %   asn_org+109    % TRACK15 vehicle acceleration
as_{asn+i_asn(6)}  = 'NA';                                %   asn_org+110    % TRACK15 vehicle headway 
as_{asn+i_asn(7)}  = 'NA';                                %   asn_org+111    % TRACK15 vehicle flag Obj(1)
as_{asn+i_asn(8)}  = 'NA';                                %   asn_org+112    % TRACK15 poisition lead vehicle
asn = length(as_);                              
as_{asn+i_asn(1)}  = 'D161(@)';                           %   asn_org+113    % TRACK16 vehicle lonogitudinal position
as_{asn+i_asn(2)}  = 'D162(@)';                           %   asn_org+114    % TRACK16 vehicle lateral position
as_{asn+i_asn(3)}  = 'D166(@)';                           %   asn_org+115    % TRACK16 vehicle longitudinal speed
as_{asn+i_asn(4)}  = 'NA';                                %   asn_org+116    % TRACK16 vehicle lateral speed
as_{asn+i_asn(5)}  = 'NA';                                %   asn_org+117    % TRACK16 vehicle acceleration
as_{asn+i_asn(6)}  = 'NA';                                %   asn_org+118    % TRACK16 vehicle headway 
as_{asn+i_asn(7)}  = 'NA';                                %   asn_org+119    % TRACK16 vehicle flag Obj(1)
as_{asn+i_asn(8)}  = 'NA';                                %   asn_org+120    % TRACK16 poisition lead vehicle