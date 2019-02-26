function [m_total ,teisya_owari ,teisya_kaisi] = fcalc_mountain(vsp, vsp_thresh, flg_mtn)
%--------------------------------------------------------------------------
out_stptime  = [];
teisya_kaisi = [];
teisya_owari = [];
m_total      = 0;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
if vsp(1)>1
    teisya_owari = [teisya_owari;1];
end

for i=2:length(vsp)
    if (vsp(i-1) >= vsp_thresh && vsp(i) < vsp_thresh)
        teisya_kaisi = [teisya_kaisi;i];
    end
    if (vsp(i-1) <=vsp_thresh && vsp(i) > vsp_thresh) || (isnan(vsp(i-1)) && vsp(i) > vsp_thresh)
        teisya_owari = [teisya_owari;i];
        m_total  = m_total + 1;
    end
    if (vsp(i-1)>1 && i==length(vsp))
        teisya_kaisi = [teisya_kaisi;i];
        m_total  = m_total + 1;
    end
end


if vsp(1) > vsp_thresh
    for i = 1:length(teisya_owari)
        out_stptime=[out_stptime;teisya_owari(i)-teisya_kaisi(i)];
    end
else
    for i = 1:length(teisya_owari)-1
        out_stptime=[out_stptime;teisya_owari(i+1)-teisya_kaisi(i)];
    end
end

if flg_mtn == 0
    if isempty(teisya_kaisi) == 1
        teisya_kaisi = 0;
        teisya_owari = 0;
    end
    teisya_kaisi = teisya_kaisi(length(teisya_kaisi));
    teisya_owari = teisya_owari(1);
    m_total = 1;
end

%--------------------------------------------------------------------------


