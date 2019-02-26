function [ind_ftype ind_ftarget ind_fvar  ind_filv] = fset_mindx(f_type, f_target, f_var, f_ilv, M_data)
%f_type   = 'var';
%f_target = 'ego';
%f_var    = 'posx';
%f_ilv    = 'non_ilv';

if findstr(f_target,'ego')==1
    f_target = 'ego';
else if findstr(f_target,'lead')==1
    f_target = 'lead';
    end    
end

temp        = struct2cell(M_data(1).type(:));
ind_ftype   = find(strcmp(temp(1,:),f_type),1);

temp2       = struct2cell(M_data(1).type(ind_ftype).target(:));
ind_ftarget = find(strcmp(temp2(1,:),f_target),1);

temp3       = struct2cell(M_data(1).type(ind_ftype).target(ind_ftarget).variable(:));
ind_fvar    = find(strcmp(temp3(1,:),f_var),1);

temp4       = struct2cell(M_data(1).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).ilv(:));
ind_filv    = find(strcmp(temp4(1,:),f_ilv),1);

%M_data(1).type(ind_ftype).target(ind_ftarget).variable(ind_fvar).data = 5;
end
