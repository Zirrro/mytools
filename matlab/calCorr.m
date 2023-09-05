function [corMat] = calCorr(inputData)
% 计算三通道之间的相关系数
corX = corr(inputData(:,1), inputData(:,4));
corY = corr(inputData(:,2), inputData(:,5));
corZ = corr(inputData(:,3), inputData(:,6));
corMat = [corX, corY, corZ];
end

