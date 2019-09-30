function f_RF_constcalc(fig, time_upr)

RF_100  = 1.00;
RF_200  = 2.00;
RF_300  = 3.00;
RF_400  = 4.00;
RF_500  = 5.00;

THW_INV = [0 2];
Beta    = 1/4;

TTC_INV_RF_100 = -Beta .* [THW_INV] + RF_100 * Beta;
TTC_INV_RF_200 = -Beta .* [THW_INV] + RF_200 * Beta;
TTC_INV_RF_300 = -Beta .* [THW_INV] + RF_300 * Beta;
TTC_INV_RF_400 = -Beta .* [THW_INV] + RF_400 * Beta;
TTC_INV_RF_500 = -Beta .* [THW_INV] + RF_500 * Beta;

fig;


plot3(THW_INV, TTC_INV_RF_100, [time_upr time_upr], 'k')
hold on
plot3(THW_INV, TTC_INV_RF_200, [time_upr time_upr], 'k')
hold on
plot3(THW_INV, TTC_INV_RF_300, [time_upr time_upr], 'k')
hold on
plot3(THW_INV, TTC_INV_RF_400, [time_upr time_upr], 'k')
hold on
plot3(THW_INV, TTC_INV_RF_500, [time_upr time_upr], 'k')
hold on
hold off

end


