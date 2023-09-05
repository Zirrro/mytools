% 用于静态总场三轴合成的脚本
data_all = readsquidfiles;
fs = 1000;
% data_all = importdata('D:\xuexi\研三上\0827\data105000.mat');
data_all = data_all .*10000;

fluxgate_ch1 = data_all(:,1:3);
magnetic_impedance_sensor_ch2 = data_all(:,4:6);
fluxgate_ch3 = data_all(:,7:9);
magnetic_impedance_sensor_ch4 = data_all(:,10:12);

mis_ch2_offset1 = mean(magnetic_impedance_sensor_ch2(:,1));
mis_ch2_offset2 = mean(magnetic_impedance_sensor_ch2(:,2));
mis_ch2_offset3 = mean(magnetic_impedance_sensor_ch2(:,3));
mis_ch4_offset1 = mean(magnetic_impedance_sensor_ch4(:,1));
mis_ch4_offset2 = mean(magnetic_impedance_sensor_ch4(:,2));
mis_ch4_offset3 = mean(magnetic_impedance_sensor_ch4(:,3));

det_mis_ch2 = detrend(magnetic_impedance_sensor_ch2);
det_mis_ch4 = detrend(magnetic_impedance_sensor_ch4);

v1 = [mis_ch2_offset1, mis_ch2_offset2,mis_ch2_offset3];
v1 = diag(v1);
v2 = [mis_ch4_offset1, mis_ch4_offset2,mis_ch4_offset3];
v2 = diag(v2);

offsetCh2 = ones(size(magnetic_impedance_sensor_ch2,1),3)*v1;
offsetCh4 = ones(size(magnetic_impedance_sensor_ch4,1),3)*v2;

data_ch2 = det_mis_ch2 + offsetCh2;
data_ch4 = det_mis_ch4 + offsetCh4;

% figure(1)
% plot_second(getTMI(data_ch2),fs)
% legend('TMI')
% title('磁阻抗传感器ch2总场')
figure(2)
plot_second(getTMI(data_ch4),fs)
legend('TMI')
title('磁阻抗传感器ch4总场')