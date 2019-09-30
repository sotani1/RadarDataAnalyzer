function [out] = ff_am3_1_1_mapcalc2(input_signal,mapdata)

    % Calculate magnitude of acceleration

    map_x_min = min(mapdata(:,1));
    map_x_max = max(mapdata(:,1));
    map_x_d   = mapdata(2,1) - mapdata(1,1);
    dstorebox = mapdata(:,3);

    for i=1:length(input_signal)
        for k= 1:length(map_x_min:map_x_d:map_x_max)
            if input_signal(i) > k * map_x_d - map_x_d + map_x_min && input_signal(i) <= k * map_x_d +  map_x_min 
                dstorebox(k) = dstorebox(k)+1;
            end
        end
    end
    
    if sum(dstorebox) ~= 0
        out = [mapdata(:,1) dstorebox dstorebox]; 
    else
        out = [mapdata(:,1) dstorebox*0 dstorebox];
    end
end









