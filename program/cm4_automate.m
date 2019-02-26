% cm4_automate
% automation script

cd(Prgfolder);

%determine u variable
u = var_ego_vel;
u = [var_time, u];

%determine v variable
v = var_ego_accelx;
v = [var_time, v];

%determine other variables
apo       = var_.CAN1__EngVehicleSpThrottle_ApedPos_Pc_ActlArb;
apo       = [var_time, apo];
bk_switch = var_.CAN1__EngControlData_BrkOnOffSwtch_D_Actl;
bk_switch = [var_time, bk_switch];

sim('StateTransition_MRCC', [time_lwr time_upr]);
%set_param('StateTransition_MRCC','StopTime', var_time(end));

cd(Opefolder);

clear apo bk_switch u v
