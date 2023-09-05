function [result] = myResample(data ,p, q, prev, next)
%自用重采样函数，前后补充指定点的数据，输入为列向量
%   p, q与原始resample函数中的定义相同，p代表目标频率，q代表原始频率。
%   prev指前面补充的数据点数量，next指末尾补充的数据点数量。

sz = size(data);

prevData = zeros(prev, sz(2)); 
nextData = zeros(next, sz(2));

% 在前面添加数据
count = 1;
for i = prev:-1:1
    prevData(i, :) = data(count, :);
    count = count + 1;
end

% 在后面添加数据
for i = next:-1:1
    nextData(i, :) = data(sz(1) + 1 - i, :);
end

data = [prevData; data; nextData];

% 重采样
data = resample(data, p, q);
% result = data(prev:sz(1) + prev - next, :);
result = data;
end