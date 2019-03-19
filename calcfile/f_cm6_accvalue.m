function out_dvsp = f_cm6_accvalue(vsp, dvsp)
%% Construction of acceleartion map

%% Define variables (cm0)
    vsp_min     = 10;    
    vsp_max     = 200;    
    vsp_step    = 10;
    dvsp_step   = 0.05;
    vsplevel = zeros(length(vsp),1);
     %% Determine speed bins
        for i= 1:length(vsp)
            for n=1:(vsp_max-vsp_min)/vsp_step+1
                if vsp(i) <= vsp_min && vsp(i) >1
                    vsplevel(i) = 1;
                    
                elseif vsp(i) > vsp_max
                    vsplevel(i) = (vsp_max-vsp_min)/vsp_step+2;
                    
                elseif vsp(i) > vsp_min+(n-1)*vsp_step && vsp(i) <= vsp_min+n*vsp_step
                    vsplevel(i) = n+1;
                end
            end
        end
        
    %% Create acceleration bins              
        out_dvsp1  =[];    out_dvsp2  =[];   out_dvsp3  =[];   out_dvsp4  =[];
        out_dvsp5  =[];    out_dvsp6  =[];   out_dvsp7  =[];   out_dvsp8  =[];
        out_dvsp9  =[];    out_dvsp10 =[];   out_dvsp11 =[];   out_dvsp12 =[];
        out_dvsp13 =[];    out_dvsp14 =[];   out_dvsp15 =[];   out_dvsp16 =[];
        out_dvsp17 =[];    out_dvsp18 =[];   out_dvsp19 =[];   out_dvsp20 =[];    

    for i=1:length(dvsp)
            if vsplevel(i) == 1
                out_dvsp1 = [out_dvsp1;dvsp(i)];
            elseif vsplevel(i) == 2
                out_dvsp2 = [out_dvsp2;dvsp(i)];
            elseif vsplevel(i) == 3
                out_dvsp3 = [out_dvsp3;dvsp(i)];
            elseif vsplevel(i) == 4
                out_dvsp4 = [out_dvsp4;dvsp(i)];
            elseif vsplevel(i) == 5
                out_dvsp5 = [out_dvsp5;dvsp(i)];
            elseif vsplevel(i) == 6
                out_dvsp6 = [out_dvsp6;dvsp(i)];
            elseif vsplevel(i) == 7
                out_dvsp7 = [out_dvsp7;dvsp(i)];
            elseif vsplevel(i) == 8
                out_dvsp8 = [out_dvsp8;dvsp(i)];
            elseif vsplevel(i) == 9
                out_dvsp9 = [out_dvsp9;dvsp(i)];
            elseif vsplevel(i) == 10
                out_dvsp10 = [out_dvsp10;dvsp(i)];
            elseif vsplevel(i) == 11
                out_dvsp11 = [out_dvsp11;dvsp(i)];
            elseif vsplevel(i) == 12
                out_dvsp12 = [out_dvsp12;dvsp(i)];            
            elseif vsplevel(i) == 13
                out_dvsp13 = [out_dvsp13;dvsp(i)];            
            elseif vsplevel(i) == 14
                out_dvsp14 = [out_dvsp14;dvsp(i)];            
            elseif vsplevel(i) == 15
                out_dvsp15 = [out_dvsp15;dvsp(i)];            
            elseif vsplevel(i) == 16
                out_dvsp16 = [out_dvsp16;dvsp(i)];            
            elseif vsplevel(i) == 17
                out_dvsp17 = [out_dvsp17;dvsp(i)];            
            elseif vsplevel(i) == 18
                out_dvsp18 = [out_dvsp18;dvsp(i)];            
            elseif vsplevel(i) == 19
                out_dvsp19 = [out_dvsp19;dvsp(i)];            
            elseif vsplevel(i) == 20
                out_dvsp20 = [out_dvsp20;dvsp(i)];            
            end
    end
    out_dvsp = {out_dvsp1,  out_dvsp2,  out_dvsp3,  out_dvsp4,   out_dvsp5,   out_dvsp6,  ...
                out_dvsp7,  out_dvsp8,  out_dvsp9,  out_dvsp10,  out_dvsp11,  out_dvsp12, ...
                out_dvsp13, out_dvsp14, out_dvsp15, out_dvsp16,  out_dvsp17,  out_dvsp18, ...
                out_dvsp19, out_dvsp20};   
end
     