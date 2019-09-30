function out_stptime = f_am3_1_calc_stptime(vsp)
%% ˜4-1-3-2-6 Calculates total Idle Time
    out_stptime =[];
    teisya_kaisi=[];
    teisya_owari=[];
    % When vehicle is stopped
    for i=2:length(vsp)
        if i==length(vsp)
            i=i*1;
        end
        if vsp(i-1) >=1 && vsp(i) < 1
            teisya_kaisi = [teisya_kaisi;i];
        end
        if (vsp(i-1)>1 && i==length(vsp)) || i==length(vsp) && isnan(vsp(i))==1
            teisya_kaisi = [teisya_kaisi;i];
        end
        if vsp(i-1) <=1 && vsp(i) > 1
            teisya_owari = [teisya_owari;i];
        end
    end

    % Calculate time the vehicle was stopped
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


