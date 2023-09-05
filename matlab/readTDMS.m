%  @Time    : 2023/8/22 9:02
%  @Author  : Salieri
%  @FileName: readTDMS.m
%  @Software: Matlab
%  @Comment : 读取TDMS文件

function res = readTDMS(filepath)
    % 参数判断部分
    if nargin == 1
        [filepart, name, suffix] = fileparts(filepath);
        if suffix ~= ".tdms"
            errordlg('请选择tdms文件')
        end
    elseif nargin == 0
        [fileName, filePath] = uigetfile('.tdms', '选择文件');
        filepath = [filePath fileName];
        [filepart, name, ~] = fileparts(filepath);
    end
    % 数据转换部分
    [ConvertedData,~,ChanNames, ~, ~]=convertTDMS(false,filepath);
    chCount=size(ChanNames{1,1},1);
    chLength = size(ConvertedData.Data.MeasuredData(3).Data, 1);
    res = zeros(chLength, chCount);
    for i = 1:chCount
        res(:, i) = ConvertedData.Data.MeasuredData(i+2).Data;
    end
    % 文件存储
    save(strcat(filepart, '\', name, '.mat'), "res")

    % test 采样率提取
    
end