
[fileName,filePath]=uigetfile('*.TS');
oriname=fileName(1:size(fileName,2)-3);

fp=fopen([filePath,fileName]);
samp=fread(fp,'uint8');
fclose(fp);
len=length(samp);
n=48;
m=len/n;
data=reshape(samp,n,m);
data=data';

%%2通道光泵   字节6-15
%%光泵1  nT   
Cx1=data(:,6)*16^2+data(:,7);
Fx1=data(:,8)*16^4+data(:,9)*16^2+data(:,10);
CH1=320000000 * (Cx1+1)./(Fx1+1) / 3.498577;

%%光泵2  nT
Cx2=data(:,11)*16^2+data(:,12);
Fx2=data(:,13)*16^4+data(:,14)*16^2+data(:,15);
CH2=(Cx2+1)*320000000./(Fx2+1) / 3.498577;


%%%%% 3通道磁通门  字节16-24
K= 1;
flux1_x = (data(:,18)*65536 + data(:,17)*256 + data(:,16));
for i=1:length(flux1_x)
    if (flux1_x(i) > 8388607)
        flux1_x(i) = (flux1_x(i) - 16777216) *10/2^24*K;
    else 
       flux1_x(i) = flux1_x(i) *10/2^24*K;
    end
end

flux1_y = (data(:,21)*65536 + data(:,20)*256 + data(:,19));
for i=1:length(flux1_y)
    if (flux1_y(i) > 8388607)
        flux1_y(i) = (flux1_y(i) - 16777216)* 10/2^24*K;
    else 
       flux1_y(i) = flux1_y(i) *10/2^24*K;
    end
end


flux1_z1 = (data(:,24)*65536 + data(:,23)*256 + data(:,22));
for i=1:length(flux1_z1)
    if (flux1_z1(i) > 8388607)
        flux1_z1(i) = (flux1_z1(i) - 16777216)* 10/2^24*K;
    else 
       flux1_z1(i) = flux1_z1(i) *10/2^24*K;
    end
end


%%%%%%%%%%%%%电压V   电流A  字节 25-28
vol= (data(:,25)*256 + data(:,26))*25/16/1000;  
amp= (data(:,27)*256 + data(:,28))*25/16/100000;


%%%经纬高  字节29-41
%%%%%%%%%%%%%南北纬度ddmm.mmmmm;    
lat_1=data(:,29)*16^2+data(:,30);
lat_2=data(:,31)*16^4+data(:,32)*16^2+data(:,33);
lat=lat_1+lat_2/10^7;
%%%%%%%%%%%%%%%%%%%%%东西经度dddmm.mmmmm
lon_1=data(:,34)*16^2+data(:,35);
lon_2=data(:,36)*16^4+data(:,37)*16^2+data(:,38);
lon=lon_1+lon_2/10^7;
%%%%%%%%%%%%%%%%%%%%高程
h=(data(:,39)*16^4+data(:,40)*16^2+data(:,41))/10;

%%%%%%%%%%%%%%%%%%%%采集 同步状态    字节42
%%% matlab不会字节操作了
%%%   最高位为采集状态  从左第4位为同步状态   低4位调试用


%%%%%%%%%%%%%%%  3字节自增
index = data(:,43)*65536 + data(:,44)*256 + data(:,45);


%%%%%%%%%%%%%%%  3字节时间 小时 分钟 秒
status=dec2hex(data(:,46));
hour=status(:,1);
hr=hex2dec(hour);
mm= data(:,47);
ss= data(:,48);

%%%%%%%%%%%%%%% 锁定状态 卫星数
lock_state = status(:,1);   %%% 具体解析见word
status=dec2hex(data(:,28));
star_num = status(:,2);



DATA1=[ hr mm ss CH1 CH2 flux1_x flux1_y flux1_z1 lat lon h];
DATA1 =DATA1(2:end,:);



% 可根据需要更改。现在是截取DATA1的第4到8列
ResultIWant=DATA1(:,4:8);
WriteName=[oriname,'.mat'];
save(WriteName,'ResultIWant');

figure(1);
plot(ResultIWant(:,1));
figure(2);
plot(ResultIWant(:,2));


%%%%%%%%%%%%  小时 分钟 秒 光泵磁场1 光泵磁场2 经度 纬度  高度

 %%clearvars -except DATA1;
 
 %% %%%%%%%%   功率谱
 fs =160; % 采样率
 dfs = 0.1; % 功率谱分辨率
 %%%%%%%%%%%%  截数据   %%%%%%%%%%%%%%%%%%%%%%%%%
 CH1_cut = CH1(40:end);
 CH2_cut = CH2(40:end);
  
%  [pxx_diff,ff] = MyPSD(CH1_cut-CH2_cut,160,0.1,1);  % pxx_diff为估计的谱密度；
%  [pxx_CH1,ff] = MyPSD(CH1_cut,160,0.1,1);
%  [pxx_CH2,ff] = MyPSD(CH2_cut,160,0.1,1);
% 
% 
% 
% %  [pxx_diff,ff] = MyPSD(CH1-CH2,160,0.1,1);  % pxx_diff为估计的谱密度；
% %  [pxx_CH1,ff] = MyPSD(CH1,160,0.1,1);
% %  [pxx_CH2,ff] = MyPSD(CH2,160,0.1,1);
% 
%  loglog(ff,pxx_diff/sqrt(2),'r');grid on; axis tight;hold on;
%  loglog(ff,pxx_CH1,'g');grid on; axis tight;hold on;
%  loglog(ff,pxx_CH2,'b');grid on; axis tight;hold on;
% plot(ff,pxx_diff/sqrt(2),'r');grid on; axis tight;hold on;
% %  plot(ff,pxx_CH1,'g');grid on; axis tight;hold on;
% %  plot(ff,pxx_CH2,'b');grid on; axis tight;hold on;
% xlabel('频率(Hz)','Fontsize',20,'FontName','宋体');
% ylabel('幅度(pT/√Hz)','Fontsize',20,'FontName','宋体')
% title('自相关功率谱')
%  legend('CH1-CH2','CH1','CH2');
 
 