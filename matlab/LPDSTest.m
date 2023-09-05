function [LPDSData] = LPDSTest(DataMat, AimedFreq, Fs)
% 降采样函数，输入数据为列向量
LP=lowpass(DataMat, AimedFreq, Fs);
LPDSData=downsample(LP,Fs/(AimedFreq*2));

plot(LPDSData);

end

