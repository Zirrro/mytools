function [result] = offsetRemoval(inputData)
result = zeros(size(inputData, 1), size(inputData, 2));
for i = 1:size(inputData, 2)
    result(:, i) = inputData(:, i) - mean(inputData(:, i));
end