
% Designed and Programmed by Ning Shuang.
% Reprogrammed and functionlized by WSure.
% Reprogrammed by Yan Jiaxi @ 2023/6/28 
% Version 2.2

% Function for K-Parameters Compensation Algorithm.

function [ResultData, k] = kcomp(FormattedData, Fs, WindLen)

OutCompData = FormattedData;

data = FormattedData;
data2 = OutCompData;
sz = size(data);
M = sz(1);
t = 1 / Fs : 1 / Fs : M / Fs;
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
deta2 = zeros(M, 3);
k = zeros(4, 3, SegNum);

for n = 1:SegNum
    startn = WindLen * (n - 1) + 1;
    endn = WindLen * n;
      if endn > M - 1
            endn = M - 1;
      end
      Bxn = Bx(startn:endn);
      Byn = By(startn:endn);
      Bzn = Bz(startn:endn);
      bxn = bx(startn:endn);
      byn = by(startn:endn);
      bzn = bz(startn:endn);

      Bxn2 = Bx2(startn:endn);
      Byn2 = By2(startn:endn);
      Bzn2 = Bz2(startn:endn);
      bxn2 = bx2(startn:endn);
      byn2 = by2(startn:endn);
      bzn2 = bz2(startn:endn);
    
      Y = [Bxn, Byn, Bzn];
      Y2 = [Bxn2, Byn2, Bzn2];

      R=[ones(length(bxn),1) bxn byn bzn];
      R2 = [ones(length(bxn),1), bxn2, byn2, bzn2];
      InvertR = pinv(R);
      KMat = InvertR * Y;
      k(:,:,n) = KMat;

      deta2(startn:endn, :) = Y2 - R2 * KMat;
end

for i = size(deta2, 1):-1:1
    if deta2(i,1) ~= 0
        break;
    end
end
deta2 = deta2(1:i,:);

%Bx
figure
plot(t,Bx)
hold on
plot(t(1:length(deta2)),deta2(:,1))
xlabel('time(s)');
ylabel('nT')
legend('补偿前','补偿后')
%By
figure
plot(t,By)
hold on
plot(t(1:length(deta2)),deta2(:,2))
xlabel('time(s)');
ylabel('nT')
legend('补偿前','补偿后')
%Bz
figure
plot(t,Bz)
hold on
plot(t(1:length(deta2)),deta2(:,3))
xlabel('time(s)');
ylabel('nT')
legend('补偿前','补偿后')



ResultData=deta2;

save kcompResult.mat deta2

end