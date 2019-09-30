function [out] = ff_am3_1_1_mapcalc_vspe(input_signal,mapdata,dtime)
    
    map_x_min = min(mapdata(:,1));
    map_x_max = max(mapdata(:,1));
    map_x_d   = mapdata(2,1) - mapdata(1,1);
    dstorebox = mapdata(:,3);

    for i=1:length(input_signal)
        if input_signal(i) <= map_x_min
            dstorebox(1) = dstorebox(1)+1;
        elseif input_signal > map_x_max
            dstorebox(length(dstorebox)) = dstorebox(length(dstorebox))+1;
        else
            for k= 1:length(map_x_min:map_x_d:map_x_max)
            if input_signal(i) > k * map_x_d - map_x_d + map_x_min && input_signal(i) <= k * map_x_d +  map_x_min 
                dstorebox(k) = dstorebox(k)+1*dtime;
            end
        end      
        end
    end
    
    if sum(dstorebox) ~= 0
        out = [mapdata(:,1) dstorebox dstorebox]; 
    else
        out = [mapdata(:,1) dstorebox*0 dstorebox];
    end
end









