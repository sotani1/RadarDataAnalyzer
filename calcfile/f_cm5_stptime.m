function out_stptime = f_cm5_stptime(vsp)
%% Calculates total time vehicle is idle or stopped
    out_stptime =[];
    teisya_kaisi=[];
    teisya_owari=[];
    %When vehicle is stopped
    for i=2:length(vsp)
        if vsp(i-1) >=1 && vsp(i) < 1
            teisya_kaisi = [teisya_kaisi;i];
        end
        if vsp(i-1) <=1 && vsp(i) > 1
            teisya_owari = [teisya_owari;i];
        end
    end

    %Calculate time the vehicle was stopped
    if vsp(1) > 1
        for i = 1:length(teisya_owari)
            out_stptime=[out_stptime;teisya_owari(i)-teisya_kaisi(i)];
        end
    else
        for i = 1:length(teisya_owari)-1
          out_stptime=[out_stptime;teisya_owari(i+1)-teisya_kaisi(i)];
        end
    end

end


