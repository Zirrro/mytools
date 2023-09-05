function [dataR] = rotate_2D(inputdata, t)

data = inputdata(:,1:3);
ang = deg2rad(t);
R = [cos(ang), sin(ang),0;
    -sin(ang),cos(ang),0;
    0,0,1];
dataR = (R * data')';
dataR = [dataR, inputdata(:,4:6)];
end