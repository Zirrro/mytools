function outputData = deleteTrailingZeros(inputData)
    for i = size(inputData, 1):-1:1
        if inputData(i,1) ~= 0
            break;
        end
    end
    outputData = inputData(1:i,:);
end