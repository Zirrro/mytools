function [result] = findAngle(data, email)
%暴力寻找适合的欧拉角 2D版本
% 输入为列向量


startTime = datetime;
tic
step = 0.001;
startAngle = 28.5;
endAngle = 28;
result = zeros(round(abs((startAngle - endAngle))/step) + 1, 2);
h = waitbar(0, '计算中');
count = 1;

for t = startAngle:-step:endAngle
    t1 = deg2rad(t);
    R = [cos(t1), sin(t1),0;
           -sin(t1),cos(t1),0;
           0,0,1];
% 对前三列数据进行旋转
dataR = (R * data(:,1:3)')';
% 求前三列数据与后三列数据的相关系数
corX = corr(dataR(:,1),data(:,4));
corY = corr(dataR(:,2),data(:,5));
% 记录旋转的角度及与1的标准差，写入result中
result(count,:) = [t, (1-corX)^2 + (1-corY)^2];
count = count+1;
waitbar(count/(abs((startAngle - endAngle)/step) + 1), h)
end

toc
time = toc;
endTime = datetime;

if nargin == 2 && email == 1
%发送邮件告知计算已完成
save result.mat result
Email('shimahfy@gmail.com','遍历寻找欧拉角已完成',[strcat('计算已完成，花费时间', num2str(time), '秒') 10 ...
    strcat('计算开始于', string(startTime), '结束于', string(endTime))] , 'result.mat')
end
figure
plot(result(:,2))
delete(h)
