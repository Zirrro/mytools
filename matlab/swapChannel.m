function [result] =  swapChannel(data, row1, row2)
swapdata = data(:,row1);
data(:,row1) = data(:,row2);
data(:,row2) = swapdata;
result = data;
end