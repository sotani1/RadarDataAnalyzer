function [out1 out2]=func_map2simmap(in1,in2)
    % in1:�m�����x���@map_***(:,2)   
    % in2:�l           map_***(:,1)  

    % out1�FSim�ł�x���F0�`100�@�i�m���̐ώZ�l�j
    % out2�F�m���ɉ������l
    
    % �m�����i�[���̐ݒ�
        ok_i=[];

    %
    for i=1:length(in1)
        if in1(i) ~= 0;
            ok_i =[ok_i;i];
        end
    end
    out1 = in1(ok_i);

    %�m����ώZ����i100�ɂȂ�j
    for i=2:length(out1)
        out1(i) = out1(i)+out1(i-1);
    end

    out1 = [0;out1(1:length(out1)-1)];   
    
    out2 = in2(ok_i);
end