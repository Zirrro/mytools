
% Designed and Programmed by Ning Shuang.
% Reprogrammed and functionlized by WSure.
% Version 2.2. May 18th, 2023.

% Function for K-Parameters Outside Compensation Algorithm.

function [OutComp, k] = kcompout(FormattedData, OutCompData, WindLen, WindNum)

data = FormattedData;%%%自补偿数据选取
[M, N] = size(data);
data2 = OutCompData;
[M2, N2] = size(data2);

Bx = data(:, 1);
By = data(:, 2);
Bz = data(:, 3);
bx = data(:, 4);
by = data(:, 5);
bz = data(:, 6);

Bx2 = data2(:, 1);
By2 = data2(:, 2);
Bz2 = data2(:, 3);
bx2 = data2(:, 4);
by2 = data2(:, 5);
bz2 = data2(:, 6);

SegNum = floor(M/WindLen);
deta2 = zeros(M2, N2/2);

for n = 1:SegNum
    startn = WindLen * (n - 1) + 1;
    endn = WindLen * (n);

    Bxn = Bx(startn:endn);
    Byn = By(startn:endn);
    Bzn = Bz(startn:endn);
    bxn = bx(startn:endn);
    byn = by(startn:endn);
    bzn = bz(startn:endn);

    Bx2n = Bx2(startn:endn);
    By2n = By2(startn:endn);
    Bz2n = Bz2(startn:endn);
    bx2n = bx2(startn:endn);
    by2n = by2(startn:endn);
    bz2n = bz2(startn:endn);

    Y = [Bxn Byn Bzn];
    Y2 = [Bx2n By2n Bz2n];
    R = [ones(length(bxn), 1) bxn byn bzn];
    R2 = [ones(length(bx2n),1) bx2n by2n bz2n];

    k(:, :, n) = pinv(R) * Y;
end


for n = 1:SegNum
    startn = WindLen*(n-1)+1;
    endn = WindLen*(n);

    Bx2n = Bx2(startn:endn);
    By2n = By2(startn:endn);
    Bz2n = Bz2(startn:endn);
    bx2n = bx2(startn:endn);
    by2n = by2(startn:endn);
    bz2n = bz2(startn:endn);

    Y2 = [Bx2n By2n Bz2n];
    R2 = [ones(length(bx2n), 1) bx2n by2n bz2n];

    deta2(startn:endn,:) = Y2-R2*k(:, :, WindNum);
end

plot(deta2)

OutComp = deta2;

