function f3Dscatter(var_x, var_y, var_z, var_size, var_color, subplot_temp, t1, t2, type)

if strcmp(type, 'scatter') == 1
    scatter3(var_x,var_y,...             
    var_z,var_size,var_color,'Parent',subplot_temp,'Marker','square');
    view(2);                             %rotate view orthogonally
    zlim(gca,[t1 t2]);                   %set z_axis limit 
    colorbar;                            %set colorbar
    set(subplot_temp,'CLim',[t1 t2]);    %set limits of colorbar
elseif strcmp(type, 'plot3') == 1
    plot3(var_x, var_y, var_z);
    view(2); 
    xlim(gca, [t1 t2]);
else
end



