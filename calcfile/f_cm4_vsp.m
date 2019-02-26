function out_vspe = f_cm4_vsp(vsp)
%% Speed calculation Only account for speed > 1 kph

    out_vspe=[];

    for i=1:length(vsp)
        if vsp(i) >= 1
            out_vspe = [out_vspe;vsp(i)];
        end
    end
    
    
    

