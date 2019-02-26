function out_mileage_all = f_cm2_mileage_all(vsp, dt)
%% Calculates distance travelled

    %% Initialize value
        out_mileage_all = 0;

    %% Ditance travelled calculation
    for i=1:length(vsp)
        out_mileage_all = out_mileage_all + vsp(i)*dt/3600;
    end

end

