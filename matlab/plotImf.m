function plotImf(data)
    for i = 1:size(data, 2)
        subplot(size(data, 2),1,i)
        plot(data(:, i))
    end
end