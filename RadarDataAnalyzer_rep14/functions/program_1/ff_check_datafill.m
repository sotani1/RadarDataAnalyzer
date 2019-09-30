function d1 = ff_check_datafill(d_tmp,imdata_temp)
%% Åò2-1-3-4-1    Checks to see all data columns are filled  
    if(size(d_tmp,2) < length(imdata_temp))
        for i=size(d_tmp,2):length(imdata_temp)    
            d_tmp(:,size(d_tmp,2)+i-(size(d_tmp,2))) = NaN; 
        end
    end
d1 = d_tmp;
end
