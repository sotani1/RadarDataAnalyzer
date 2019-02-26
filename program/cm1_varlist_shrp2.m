%% Specify custom variable name here
% Column position will be remembered in colvars

%Define globally shared variables
as_         = [];                          % AnsiString storage 

%% Åò1.1 Preset increment counters for radar variables
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
%% Åò1.2 Timestamp, speed, longitudinal acceleration global variable declaration 
%========= NOTE:  PLEASE BE SURE TO KEEP THE FIRST 3 VARIABLES IN THIS ORDER =========
%AnsiString var names                                     % colval   % variable name
as_{1}  = 'vtti.timestamp';                               %   1      % timestamp
as_{2}  = 'vtti.speed_network';                           %   2      % Ego vehicle velocity
as_{3}  = 'vtti.accel_x';                                 %   3      % Ego vehicle acceleration x
as_{4}  = 'NA';                                           %   4      % ********* Top priority object ID *********
as_{5}  = 'vtti.pedal_gas_position';                      %   5      % APO
as_{6}  = 'vtti.pedal_brake_state';                       %   6      % Brake state
as_{7}  = 'vtti.steering_wheel_position';                 %   7      % Steering wheel angle
asn_org = length(as_);
%============== The rest of the variables can be in any arbitrary order ==============

%% Åò1.3 Radar variable declaration 
%AnsiString var names                                     % colval   % variable name
as_{asn_org+i_asn(1)}  = 'TRACK1_X_POS_PROCESSED';        %   4      % Track1 vehicle lonogitudinal position
as_{asn_org+i_asn(2)}  = 'TRACK1_Y_POS_PROCESSED';        %   5      % Track1 vehicle lateral position
as_{asn_org+i_asn(3)}  = 'TRACK1_X_VEL_PROCESSED';        %   6      % Track1 vehicle longitudinal speed
as_{asn_org+i_asn(4)}  = 'TRACK1_Y_VEL_PROCESSED';        %   7      % Track1 vehicle lateral speed
as_{asn_org+i_asn(5)}  = 'TRACK1_X_ACC_ESTIMATED';        %   8      % Track1 vehicle acceleration
as_{asn_org+i_asn(6)}  = 'TRACK1_HEADWAY';                %   9      % Track1 vehicle headway 
as_{asn_org+i_asn(7)}  = 'TRACK1_IS_LEAD_VEHICLE';        %   10     % Track1 vehicle flag Obj(1)
as_{asn_org+i_asn(8)}  = 'TRACK1_LANE';                   %   11     % Track1 poisition lead vehicle
asn = length(as_);
as_{asn+i_asn(1)}  = 'TRACK2_X_POS_PROCESSED';            %   12     % Track2 vehicle lonogitudinal position
as_{asn+i_asn(2)}  = 'TRACK2_Y_POS_PROCESSED';            %   13     % Track2 vehicle lateral position
as_{asn+i_asn(3)}  = 'TRACK2_X_VEL_PROCESSED';            %   14     % Track2 vehicle longitudinal speed
as_{asn+i_asn(4)}  = 'TRACK2_Y_VEL_PROCESSED';            %   15     % Track2 vehicle lateral speed
as_{asn+i_asn(5)}  = 'TRACK2_X_ACC_ESTIMATED';            %   16     % Track2 vehicle acceleration
as_{asn+i_asn(6)}  = 'TRACK2_HEADWAY';                    %   17     % Track2 vehicle headway 
as_{asn+i_asn(7)}  = 'TRACK2_IS_LEAD_VEHICLE';            %   18     % Track2 vehicle flag Obj(1)
as_{asn+i_asn(8)}  = 'TRACK2_LANE';                       %   19     % Track2 poisition lead vehicle
asn = length(as_);                                    
as_{asn+i_asn(1)}  = 'TRACK3_X_POS_PROCESSED';            %   20     % Track3 vehicle lonogitudinal position
as_{asn+i_asn(2)}  = 'TRACK3_Y_POS_PROCESSED';            %   21     % Track3 vehicle lateral position
as_{asn+i_asn(3)}  = 'TRACK3_X_VEL_PROCESSED';            %   22     % Track3 vehicle longitudinal speed
as_{asn+i_asn(4)}  = 'TRACK3_Y_VEL_PROCESSED';            %   23     % Track3 vehicle lateral speed
as_{asn+i_asn(5)}  = 'TRACK3_X_ACC_ESTIMATED';            %   24     % Track3 vehicle acceleration
as_{asn+i_asn(6)}  = 'TRACK3_HEADWAY';                    %   25     % Track3 vehicle headway 
as_{asn+i_asn(7)}  = 'TRACK3_IS_LEAD_VEHICLE';            %   26     % Track3 vehicle flag Obj(1)
as_{asn+i_asn(8)}  = 'TRACK3_LANE';                       %   27     % Track3 poisition lead vehicle
asn = length(as_);                                    
as_{asn+i_asn(1)}  = 'TRACK4_X_POS_PROCESSED';            %   28     % Track4 vehicle lonogitudinal position
as_{asn+i_asn(2)}  = 'TRACK4_Y_POS_PROCESSED';            %   29     % Track4 vehicle lateral position
as_{asn+i_asn(3)}  = 'TRACK4_X_VEL_PROCESSED';            %   30     % Track4 vehicle longitudinal speed
as_{asn+i_asn(4)}  = 'TRACK4_Y_VEL_PROCESSED';            %   31     % Track4 vehicle lateral speed
as_{asn+i_asn(5)}  = 'TRACK4_X_ACC_ESTIMATED';            %   32     % Track4 vehicle acceleration
as_{asn+i_asn(6)}  = 'TRACK4_HEADWAY';                    %   33     % Track4 vehicle headway 
as_{asn+i_asn(7)}  = 'TRACK4_IS_LEAD_VEHICLE';            %   34     % Track4 vehicle flag Obj(1)
as_{asn+i_asn(8)}  = 'TRACK4_LANE';                       %   35     % Track4 poisition lead vehicle
asn = length(as_);                                    
as_{asn+i_asn(1)}  = 'TRACK5_X_POS_PROCESSED';            %   36     % Track5 vehicle lonogitudinal position
as_{asn+i_asn(2)}  = 'TRACK5_Y_POS_PROCESSED';            %   37     % Track5 vehicle lateral position
as_{asn+i_asn(3)}  = 'TRACK5_X_VEL_PROCESSED';            %   38     % Track5 vehicle longitudinal speed
as_{asn+i_asn(4)}  = 'TRACK5_Y_VEL_PROCESSED';            %   39     % Track5 vehicle lateral speed
as_{asn+i_asn(5)}  = 'TRACK5_X_ACC_ESTIMATED';            %   40     % Track5 vehicle acceleration
as_{asn+i_asn(6)}  = 'TRACK5_HEADWAY';                    %   41     % Track5 vehicle headway 
as_{asn+i_asn(7)}  = 'TRACK5_IS_LEAD_VEHICLE';            %   42     % Track5 vehicle flag Obj(1)
as_{asn+i_asn(8)}  = 'TRACK5_LANE';                       %   43     % Track5 poisition lead vehicle
asn = length(as_);                                    
as_{asn+i_asn(1)}  = 'TRACK6_X_POS_PROCESSED';            %   44     % TRACK6 vehicle lonogitudinal position
as_{asn+i_asn(2)}  = 'TRACK6_Y_POS_PROCESSED';            %   45     % TRACK6 vehicle lateral position
as_{asn+i_asn(3)}  = 'TRACK6_X_VEL_PROCESSED';            %   46     % TRACK6 vehicle longitudinal speed
as_{asn+i_asn(4)}  = 'TRACK6_Y_VEL_PROCESSED';            %   47     % TRACK6 vehicle lateral speed
as_{asn+i_asn(5)}  = 'TRACK6_X_ACC_ESTIMATED';            %   48     % TRACK6 vehicle acceleration
as_{asn+i_asn(6)}  = 'TRACK6_HEADWAY';                    %   49     % TRACK6 vehicle headway 
as_{asn+i_asn(7)}  = 'TRACK6_IS_LEAD_VEHICLE';            %   50     % TRACK6 vehicle flag Obj(1)
as_{asn+i_asn(8)}  = 'TRACK6_LANE';                       %   51     % TRACK6 poisition lead vehicle
asn = length(as_);                                    
as_{asn+i_asn(1)}  = 'TRACK7_X_POS_PROCESSED';            %   52     % TRACK7 vehicle lonogitudinal position
as_{asn+i_asn(2)}  = 'TRACK7_Y_POS_PROCESSED';            %   53     % TRACK7 vehicle lateral position
as_{asn+i_asn(3)}  = 'TRACK7_X_VEL_PROCESSED';            %   54     % TRACK7 vehicle longitudinal speed
as_{asn+i_asn(4)}  = 'TRACK7_Y_VEL_PROCESSED';            %   55     % TRACK7 vehicle lateral speed
as_{asn+i_asn(5)}  = 'TRACK7_X_ACC_ESTIMATED';            %   56     % TRACK7 vehicle acceleration
as_{asn+i_asn(6)}  = 'TRACK7_HEADWAY';                    %   57     % TRACK7 vehicle headway 
as_{asn+i_asn(7)}  = 'TRACK7_IS_LEAD_VEHICLE';            %   58     % TRACK7 vehicle flag Obj(1)
as_{asn+i_asn(8)}  = 'TRACK7_LANE';                       %   59     % TRACK7 poisition lead vehicle
asn = length(as_);                                    
as_{asn+i_asn(1)}  = 'TRACK8_X_POS_PROCESSED';            %   60     % TRACK8 vehicle lonogitudinal position
as_{asn+i_asn(2)}  = 'TRACK8_Y_POS_PROCESSED';            %   61     % TRACK8 vehicle lateral position
as_{asn+i_asn(3)}  = 'TRACK8_X_VEL_PROCESSED';            %   62     % TRACK8 vehicle longitudinal speed
as_{asn+i_asn(4)}  = 'TRACK8_Y_VEL_PROCESSED';            %   63     % TRACK8 vehicle lateral speed
as_{asn+i_asn(5)}  = 'TRACK8_X_ACC_ESTIMATED';            %   64     % TRACK8 vehicle acceleration
as_{asn+i_asn(6)}  = 'TRACK8_HEADWAY';                    %   65     % TRACK8 vehicle headway 
as_{asn+i_asn(7)}  = 'TRACK8_IS_LEAD_VEHICLE';            %   66     % TRACK8 vehicle flag Obj(1)
as_{asn+i_asn(8)}  = 'TRACK8_LANE';                       %   67     % TRACK8 poisition lead vehicle
