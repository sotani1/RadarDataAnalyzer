function out_vspe = f_am3_1_calc_vspe(vsp)
%% ˜4-1-3-2-5 Vehicle Speed Equivalent (Speed calculation Only account for speed > 1 kph)
    out_vspe=[];

    for i=1:length(vsp)
        if vsp(i) >= 1
            out_vspe = [out_vspe;vsp(i)];
        end
    end
