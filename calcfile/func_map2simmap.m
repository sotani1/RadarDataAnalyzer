function [out1 out2]=func_map2simmap(in1,in2)
    % in1:確率密度情報　map_***(:,2)   
    % in2:値           map_***(:,1)  

    % out1：Simでのx軸：0～100　（確率の積算値）
    % out2：確率に応じた値
    
    % 確率情報格納箱の設定
        ok_i=[];

    %
    for i=1:length(in1)
        if in1(i) ~= 0;
            ok_i =[ok_i;i];
        end
    end
    out1 = in1(ok_i);

    %確率を積算する（100になる）
    for i=2:length(out1)
        out1(i) = out1(i)+out1(i-1);
    end

    out1 = [0;out1(1:length(out1)-1)];   
    
    out2 = in2(ok_i);
end