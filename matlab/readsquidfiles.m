function [DataMat, Fs, LocName]=readsquidfiles()

[fileName,filePath]=uigetfile({'*.tdms; *.mat; *.txt; *.csv;*.TS;', 'Data Files (*.TS *.mat)'; '*.*','All Files (*.*)'},'Pick a file');

newStr=split(fileName, '.');
base=newStr{1,1};
suffix=newStr{2,1};
fpath=[filePath fileName];
LocName={filePath; fileName};

if(strcmp(suffix, 'tdms'))
    % Unpack data.
    [ConvertedData,ConvertVer,ChanNames, GroupNames, ChannelIndex]=convertTDMS(false,fpath);
    base=fileName(1:size(fileName,2)-5);
    ChannelCount=size(ChanNames{1,1},1);

    MainStruct=ConvertedData.Data.MeasuredData(1,3);
    DataLength=MainStruct.Total_Samples;
    DataMat=zeros(ChannelCount, DataLength);

    for i=3:1:(3+ChannelCount-1)
        MainStruct=ConvertedData.Data.MeasuredData(1,i);
        PureDataStruct{i-2}=MainStruct.Data;
        DataMat(i-2,:)=MainStruct.Data;
    end

    % Fs readout.
    MainStruct=ConvertedData.Data.MeasuredData(1,3);
    m=MainStruct.Total_Samples;
    PureDataMat=zeros(ChannelCount, m);
    i=1;
    k=1;
    [m,n]=size(ConvertedData.Data.MeasuredData);

    % 将MeasuredData.Data�?长度超过100的项记录，矩阵y记录其中的数�?序列，listname记录
    for j=1:1:n
        if length(ConvertedData.Data.MeasuredData(i).Data)>100
            y(:,k)=ConvertedData.Data.MeasuredData(i).Data;
            % listname{k}=ConvertedData.Data.MeasuredData(i).Name;
            k=k+1;
        end
        i=i+1;
    end

    x1=y(2,1)-y(1,1);
    %%当�??一列不�?时间时，有可能差值是0
    if x1~=0
        Fs=1/x1;
    else
        Fs=0.386;
    end

    if ~rem(Fs,1)
        t=y(:,1);

    else
        Fx= ChannelIndex.Object3.Property2.value;
        Fs=1/Fx;
        t=1/Fs:1/Fs:length(y(:,1))/Fs;
    end

    if Fs==Inf
        Fs=ConvertedData.Data.MeasuredData(3).Property(4).Value;
    end

elseif(strcmp(suffix, 'TS'))

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
    %%%经纬�?  字节29-41
    %%%%%%%%%%%%%南北�?�?ddmm.mmmmm;
    lat_1=data(:,29)*16^2+data(:,30);
    lat_2=data(:,31)*16^4+data(:,32)*16^2+data(:,33);
    lat=lat_1+lat_2/10^7;
    %%%%%%%%%%%%%%%%%%%%%东西经度dddmm.mmmmm
    lon_1=data(:,34)*16^2+data(:,35);
    lon_2=data(:,36)*16^4+data(:,37)*16^2+data(:,38);
    lon=lon_1+lon_2/10^7;
    %%%%%%%%%%%%%%%%%%%%高程
    h=(data(:,39)*16^4+data(:,40)*16^2+data(:,41))/10;
    %%%%%%%%%%%%%%%%%%%%采集 同�?�状�?    字节42
    %%% matlab不会字节操作�?
    %%%   最高位为采集状�?  从左�?4位为同�?�状�?   �?4位调试用
    %%%%%%%%%%%%%%%  3字节�?�?
    index = data(:,43)*65536 + data(:,44)*256 + data(:,45);
    %%%%%%%%%%%%%%%  3字节时间 小时 分钟 �?
    status=dec2hex(data(:,46));
    hour=status(:,1);
    hr=hex2dec(hour);
    mm= data(:,47);
    ss= data(:,48);

    %%%%%%%%%%%%%%% 锁定状�? �?星数
    lock_state = status(:,1);   %%% 具体解析见word
    status=dec2hex(data(:,28));
    star_num = status(:,2);
    DATA1=[ hr mm ss CH1 CH2 flux1_x flux1_y flux1_z1 lat lon h];
    DATA1 =DATA1(2:end,:);
    % �?根据需要更改。现在是�?取DATA1的�??4�?8�?
    ResultIWant=DATA1(:,4:8);
    DataMat=ResultIWant;
    Fs=Inf;

% mat and txt readout
else
    DataMat=load(fpath);
    if isa(DataMat, 'struct')
        DataMat=cell2mat(struct2cell(DataMat));
    end
    Fs=Inf;
end

% �?�?判断
[m,n]=size(DataMat);
if m < n
    DataMat=DataMat';
end

end


