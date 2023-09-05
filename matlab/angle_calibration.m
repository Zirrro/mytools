function [outputArg1, outputArg2, outputArg3] = angle_calibration(data, fs)
%基于磁通门测量数据的角度校正
%  输入数据为六列向量，以第一组数据为基准，第二组数据校正到第一组数据
%  输出参数1为经过校正后的六列向量
%  输出参数2为对应的欧拉角，顺序为ZYX，单位为度
%  输出参数3为校正后数据之间的相关性

sz = size(data);

% 系数校正
% tmi1 = sqrt(data(fix(sz/10),1)^2 + data(fix(sz/10),2)^2 + data(fix(sz/10),3)^2);
% tmi2 = sqrt(data(fix(sz/10),4)^2 + data(fix(sz/10),5)^2 + data(fix(sz/10),6)^2);

tmi1 = sqrt(mean(data(:,1))^2 + mean(data(:,2))^2 + mean(data(:,3))^2);
tmi2 = sqrt(mean(data(:,4))^2 + mean(data(:,5))^2 + mean(data(:,6))^2);

% 尝试一下拟合
% 模型：y = kx + b；

c = tmi1/tmi2;
i = [1,1,1,c,c,c];
v = diag(i);
data = data*v;

% 获取两组数据的向量
v1 = [median(data(:, 1)), median(data(:, 2)), median(data(:, 3))];
v2 = [median(data(:, 4)), median(data(:, 5)), median(data(:, 6))];

% v1 = [mean(data(:, 1)), mean(data(:, 2)), mean(data(:, 3))];
% v2 = [mean(data(:, 4)), mean(data(:, 5)), mean(data(:, 6))];

% v1 = [data(fix(sz/10),1), data(fix(sz/10),2), data(fix(sz/10),3)];
% v2 = [data(fix(sz/10),4), data(fix(sz/10),5), data(fix(sz/10),6)];

figure(1)
quiver3(0,0,0,v1(1),v1(2),v1(3));
hold on
quiver3(0,0,0,v2(1),v2(2),v2(3));
hold off
legend('磁通门1向量方向','磁通门2向量方向')

% 旋转矩阵m
m = getRotationMat(v1, v2);
result = zeros(sz(1), 3);

    for i = 1:sz(1)
        result(i, :) = (m*data(i, 4:6)')';
    end

X =1/fs:1/fs:sz(1)/fs;
figure(2)
plot(X, data(:,1:3))
hold on
plot(X, result)
xlabel("Time(s)")
ylabel('B(nT)')
legend('x','y','z','校正后x','校正后y','校正后z')
hold off
outputArg1 = [data(:,1:3), result];
outputArg2 = rad2deg(rotm2eul(m));
c1 = corr(data(:,1),data(:,4));
c2 = corr(data(:,2),data(:,5));
c3 = corr(data(:,3),data(:,6));
c4 = corr(data(:,1),result(:,1));
c5 = corr(data(:,2),result(:,2));
c6 = corr(data(:,3),result(:,3));
outputArg3 = [c1,c2,c3;c4,c5,c6];

R = corrcoef(outputArg1);
imagesc(R);
colorbar;

end

function [outputArg1] = getRotationMat(v1, v2)
% 输入为两向量，获取向量v2旋转到v1的旋转矩阵
q = vrrotvec(v2, v1);
m = vrrotvec2mat(q);
outputArg1 = m;
end  