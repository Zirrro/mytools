function objective = findAngleObjectiveFcn(Z_angle,Y_angle,X_angle, data)
% This function should return a scalar representing an optimization objective.

% Example: Concession stand profit
% revenue = 3*soda + 5*popcorn + 2*candy;
% cost = 1*soda + 2*popcorn + 0.75*candy;
% objective = revenue - cost; % profit

% Edit the lines below with your calculations.

% 长时间观测数据路径
% data = importdata("D:\xuexi\研二下\20230426-28横沙岛\SQUID-1 4-ch 0427 长时间观测\data2000.mat");

% 初始化
radz = deg2rad(Z_angle);
rady = deg2rad(Y_angle);
radx = deg2rad(X_angle);
Rz = [cos(radz), sin(radz),0;
    -sin(radz),cos(radz),0;
    0,0,1];
Ry = [cos(rady), 0, -sin(rady);
    0,1,0;
    sin(rady), 0, cos(rady)];
Rx = [1, 0, 0;
    0, cos(radx), sin(radx);
    0, -sin(radx), cos(radx)];

% 对前三列数据进行旋转
R = Rz * Ry * Rx;
dataR = (R * data(:,1:3)')';

% 求前三列数据与后三列数据的相关系数
cor_x = corr(dataR(:,1),data(:,4));
cor_y = corr(dataR(:,2),data(:,5));
cor_z = corr(dataR(:,3),data(:,6));

objective = (1-cor_x)^2 + (1-cor_y)^2 + (1-cor_z)^2;
end