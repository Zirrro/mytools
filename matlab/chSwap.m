function swapData = chSwap(data, channel_mat, coe_mat)
sz = size(data);
swapData = zeros(sz(1), size(channel_mat, 2));
for i = 1:size(channel_mat,2)
    swapData(:, i) = data(:,channel_mat(i));
end
swapData = swapData * diag(coe_mat);
end