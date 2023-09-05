function  plot_second(data, fs)
%     figure
    sz = size(data);
    len = sz(1);
    X = 1/fs:1/fs:len/fs;
    plot(X,data)
    xlabel('Time(s)')
    ylabel('B(nT)')
end