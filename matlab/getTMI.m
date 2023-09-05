function [TMI] = getTMI (data)
    % 输入数据为列向量
    TMI = sqrt(data(:,1).^2 + data(:,2).^2 + data(:,3).^2);
end