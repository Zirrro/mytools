function plotKcoe(k)

    le = size(k,3);
    k = k(2:4,:,:);
    figure
    subplot(3,3,1)
    plot(reshape(k(1,1,:),le,1))
    subplot(3,3,2)
    plot(reshape(k(1,2,:),le,1))
    subplot(3,3,3)
    plot(reshape(k(1,3,:),le,1))
    subplot(3,3,4)
    plot(reshape(k(2,1,:),le,1))
    subplot(3,3,5)
    plot(reshape(k(2,2,:),le,1))
    subplot(3,3,6)
    plot(reshape(k(2,3,:),le,1))
    subplot(3,3,7)
    plot(reshape(k(3,1,:),le,1))
    subplot(3,3,8)
    plot(reshape(k(3,2,:),le,1))
    subplot(3,3,9)
    plot(reshape(k(3,3,:),le,1))
    hold off
    sgtitle('K系数变化趋势')
end