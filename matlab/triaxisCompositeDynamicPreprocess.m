% 动态三轴合成数据预处理脚本
data = readsquidfiles;
opdata = ones(size())
fs = 1000;

mis_ch2 = [data(:,4:6);
mis_ch4 = [data(:,10:12)];

mis_ch2_LP = LPDSTest(mis_ch2, 5, fs);
mis_ch4_LP = LPDSTest(mis_ch4, 5, fs);

mis_ch2_LP = mis_ch2_LP(10:end-9);
mis_ch2_LP = mis_ch2_LP(10:end-9);