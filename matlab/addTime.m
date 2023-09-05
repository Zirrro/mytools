function output = addTime(data, fs)
    data = [(1/fs:1/fs:length(data)/fs)', data];
    output = data;
end