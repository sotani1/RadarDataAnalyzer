function [out_acctime, out_statime, out_dectime] = f_am3_1_calc_acctime(dvsp, dt)
%% ��4-1-3-2-8 Calculates time spent in acceleration mode
%% ��4-1-3-2-8-1 Define variables
out_acctime=[];
out_statime=[];
out_dectime=[];

%% ��4-1-3-2-8-2 Partition segments into ACC/CRU/DEC (Assume �}1.5km/h=0.4m/s^2�j
acc_num=[];
sta_num=[];
dec_num=[];

for i=1:length(dvsp)
    if dvsp(i) > 0.4
        acc_num=[acc_num;i];
    elseif dvsp(i) < -0.4
        dec_num=[dec_num;i];
    else
        sta_num=[sta_num;i];
    end
end


%% ��4-1-3-2-8-3 Count for each time acceleartion is prolonged
ct=1;

for i=1:length(acc_num)-1
    if acc_num(i+1)-acc_num(i) <= 1
        ct = ct +1*dt;
    else
        out_acctime = [out_acctime;ct];
        ct = 1;
    end
end

ct=1;
for i=1:length(sta_num)-1
    if sta_num(i+1)-sta_num(i) <= 1
        ct = ct +1*dt;
    else
        out_statime = [out_statime;ct];
        ct = 1;
    end
end

ct=1;
for i=1:length(dec_num)-1
    if dec_num(i+1)-dec_num(i) <= 1
        ct = ct +1*dt;
    else
        out_dectime = [out_dectime;ct];
        ct = 1;
    end
end

end



