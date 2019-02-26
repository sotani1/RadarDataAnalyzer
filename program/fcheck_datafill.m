function d1 = fcheck_datafill(d_tmp,imdata_temp)
    if(size(d_tmp,2) < length(imdata_temp))
        for i=size(d_tmp,2):length(imdata_temp)    
            d_tmp(:,size(d_tmp,2)+i-(size(d_tmp,2))) = NaN; 
        end
    end
d1 = d_tmp;
end
