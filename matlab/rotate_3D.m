function [dataR] = rotate_3D(inputdata, a, b, c)
%ROTATE_3D 三维旋转输入数据
%   输入应为列向量
data = inputdata(:,1:3);
angz = deg2rad(a);
angy = deg2rad(b);
angx = deg2rad(c);
Ra = [cos(angz), sin(angz),0;
    -sin(angz),cos(angz),0;
    0,0,1];
Rb = [cos(angy), 0, -sin(angy);
    0,1,0;
    sin(angy), 0, cos(angy)];
Rc = [1, 0, 0;
    0, cos(angx), sin(angx);
    0, -sin(angx), cos(angx)];
R = Rc*Rb*Ra;
dataR = [(R * data')',inputdata(:,4:6)];
end

