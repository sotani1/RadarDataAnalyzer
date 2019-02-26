function [ind_ftype, ind_fmaps] = f_struct_call(f_type, f_maps, M_data, i_mt)
%f_type   = 'maps';
%f_maps   = 'map_dvsp';

temp        = struct2cell(M_data(i_mt).type(:));
ind_ftype   = find(strcmp(temp(1,:),f_type),1);

temp2       = struct2cell(M_data(i_mt).type(ind_ftype).maps(:));
ind_fmaps   = find(strcmp(temp2(1,:),f_maps),1);
end
