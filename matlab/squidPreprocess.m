% SQUID 双系统数据预处理脚本

%% 读取数据
% data_sys1 = readsquidfiles1('D:\xuexi\研二下\20230426-28横沙岛\ch1.mat');
% data_sys2 = readsquidfiles1('D:\xuexi\研二下\20230426-28横沙岛\ch4.mat');
data_sys1 = data0100(:,1:3);
data_sys2 = data0100(:,4:6);
sz1 = size(data_sys1);
sz2 = size(data_sys2);
Fs = 2000;

%% 时间对准 取系统一比系统二快为正
delay = 830;
swapFlag = 0;
if delay < 0
    temp = data_sys1;
    datasys_1 = data_sys2;
    data_sys2 = temp;
    swapFlag = 1;
end
data_sys1 = data_sys1(1:sz1(1) - abs(delay),:);
data_sys2 = data_sys2(abs(delay) + 1:sz2(1),:);
if swapFlag == 1
    temp = data_sys1;
    datasys_1 = data_sys2;
    data_sys2 = temp;
end
datat = [data_sys1, data_sys2];

%% 欧拉角校正
% Angle_Z = 0;
% Angle_Y = 0;
% Angle_X = 0;
% data = rotate_3D(data, Angle_Z, Angle_Y, Angle_X);


%% 灵敏度系数以及对应通道调整
% channel = [1, 2, 3, 4, 5, 6];
% coe = [17.6, 17.6, 17.6, 17.6, 17.6, 17.6];
% data = chSwap(data, channel, coe);

%% 低通滤波
% data = LPDSTest(data, 100, Fs);
%% 带通滤波
% filorder = 20;  %滤波器阶数
% cutf1 = 0.1;  %滤波频率1
% cutf2 = 100;  %滤波频率2
% samplerate = 2000;  %采样频率
% d = designfilt('bandpassfir', 'FilterOrder', filorder, ...
%          'CutoffFrequency1', cutf1, 'CutoffFrequency2', cutf2, ...
%          'SampleRate', samplerate);
% y = filtfilt(d, data);
% plotWithTime(y, 2000)

% fpass = [0.1 100];
% data = bandpass(data, fpass, Fs);


%% 高通滤波
% data = highpass(data, 1, Fs);
%% k系数补偿
% [kcompData, k] = kcomp(data, Fs, 300*Fs);
%% 保存
% save data.mat data