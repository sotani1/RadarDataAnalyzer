function out_mileage_all = f_am3_1_calc_mileage_all(vsp, dt)
%% Åò4-1-3-2-3 Calculates total distance travelled

    %% Initialize value
        out_mileage_all = 0;

    %% Ditance travelled calculation
    for i=1:length(vsp)
        out_mileage_all = out_mileage_all + vsp(i)*dt/3600;
    end

end

