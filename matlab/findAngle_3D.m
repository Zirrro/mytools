function [result] = findAngle_3D(data, email)
%暴力寻找适合的欧拉角 3D版本
% 输入为列向量

tic
startTime = datetime;
step_x = 0.01;
step_y = 0.01;
step_z = 0.01;
startAngle_x = -5;
endAngle_x = -6;
startAngle_y = -3;
endAngle_y = -4;
startAngle_z = 29;
endAngle_z = 28;


result = zeros(round(abs((startAngle_x - endAngle_x)/step_x + 1) * abs((startAngle_y - endAngle_y)/step_y) + 1) * abs((startAngle_z - endAngle_z)/step_z) + 1, 7);
h = waitbar(0, '计算中');
count_x = 1;
count_y = 1;
count_z = 1;
count = 1;

for a = startAngle_z:-step_z:endAngle_z
    a1 = deg2rad(a);
    Ra = [cos(a1), sin(a1),0;
        -sin(a1),cos(a1),0;
        0,0,1];
    for b = startAngle_y:-step_y:endAngle_y
        b1 = deg2rad(b);
        Rb = [cos(b1), 0, -sin(b1);
            0,1,0;
            sin(b1), 0, cos(b1)];
        for c = startAngle_x:-step_x:endAngle_x
            c1 = deg2rad(c);
            Rc = [1, 0, 0;
                0, cos(c1), sin(c1);
                0, -sin(c1), cos(c1)];
            % 对前三列数据进行旋转
            R = Rc*Rb*Ra;
            dataR = (R * data(:,1:3)')';
            % 求前三列数据与后三列数据的相关系数
            cor_x = corr(dataR(:,1),data(:,4));
            cor_y = corr(dataR(:,2),data(:,5));
            cor_z = corr(dataR(:,3),data(:,6));
            result(count, :) = [a, b, c, (1-cor_x)^2 + (1-cor_y)^2 + (1-cor_z)^2, cor_z, cor_y, cor_x];
            count = count + 1;
            count_x = count_x + 1;

            % 更新进度条
            waitbar(count/(abs((startAngle_x - endAngle_x)/step_x +1)* ...
                abs((startAngle_y - endAngle_y)/step_y + 1)* ...
                abs((startAngle_z - endAngle_z)/step_z) + 1), h)
        end
        count_y = count_y + 1;
    end
    count_z = count_z + 1;
end
delete(h)

toc
endTime = datetime;
time = toc;
figure
plot(result(:, 4))

if nargin == 2 && email == 1
    [M, I] = min(result(:, 4));
    save result.mat result
    exportgraphics(gcf, 'result.png', 'Resolution', 300)
    str1 = append('计算已完成，花费时间', num2str(time), '秒。');
    str2 = append('计算开始于 ', char(startTime));
    str3 = append( '计算结束于 ', char(endTime));
    str4 = append('本次计算参数为：');
    str5 = append('startAngle_x = ', num2str(startAngle_x), '   endAngle_x = ', num2str(endAngle_x), '   step_x = ', num2str(step_x));
    str6 = append('startAngle_y = ', num2str(startAngle_y), '   endAngle_y = ', num2str(endAngle_y), '   step_y = ', num2str(step_y));
    str7 = append('startAngle_z = ', num2str(startAngle_z), '   endAngle_z = ', num2str(endAngle_z), '   step_z = ', num2str(step_z));
    str8 = append('最小值为 ', num2str(M));
    str9 = append('对应角度分别为(ZYX):', num2str(result(I,1)),',  ' ,num2str(result(I,2)), ',  ',num2str(result(I,3)));
    Email('shimahfy@gmail.com', '计算已完成', [str1 10 str2 10 str3 10 str4 10 str5 10 str6 10 str7 10 str8 10 str9], {'result.mat', 'result.png'})
end

