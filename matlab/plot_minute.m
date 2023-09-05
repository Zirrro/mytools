function plot_minute(matrixData, sampleRate)
    % 获取矩阵数据的行数和列数
    [numRows, numCols] = size(matrixData);
    
    % 计算时间间隔（以分钟为单位）
    timeInterval = 1 / sampleRate;
    
    % 计算横坐标范围
    x = (0 : numCols-1) * timeInterval;
    
    % 绘制图形
    plot(x, matrixData);
    
    % 添加标题和标签
    title('Matrix Data Plot');
    xlabel('Time (minutes)');
    ylabel('Data');
    
    % 调整图形显示
    grid on;
    legend('Channel 1', 'Channel 2', 'Channel 3'); % 如果有多个通道，您可以根据需要修改通道的标签
end
