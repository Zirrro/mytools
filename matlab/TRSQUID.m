
% Designed and Programmed by WSURE.
% Version 2.0. April 5th, 2022.
% Transition Rejection for SQUID Data.

% 阈值参数说明：

% 异常检测阈值：根据异常处跳动幅度和数据波动幅度确定。
% 阈值应小于异常跳动幅度从而保证正常检出。阈值应大于数据正常波动
% 幅度，否则会出现大面积误伤。
% 可以通过Stage1Diff矩阵确定阈值。

% 聚类阈值和范围扩展阈值：与数据质量密切相关。
% 当跳变较多但非跳变处数据平稳时，需要适当降低聚类阈值以保证数据
% 处理的精细程度。以避免将多个临近跳动归为一类进行处理，造成良好
% 数据的损失。
% 当跳变较多且中间的数据质量较差时，则可以放大聚类阈值和范围扩展
% 阈值。
% 当跳变较少且数据质量良好时，较大的聚类阈值和范围扩展阈值会比较
% 方便。


% 数据
% [PureDataMat, Fs, oriname]=readsquidfiles();

function [TRResultData] = TRSQUID(PureDataMat)

sz = size(PureDataMat);

if sz(1) > sz(2)
    PureDataMat = PureDataMat';
end

% 开始数据处理
[m,n]=size(PureDataMat);
for r=1:m
    figure(r); plot(PureDataMat(r,:));
end
DataWidthMat=1:m;
DataLengthStr=num2str(n);
DataWidthStr=mat2str(DataWidthMat);

prompt = {'输入需要处理的通道序号：', '输入起始点坐标：','输入终止点坐标：'};
dlgtitle = '截取数据';
dims = [1 35];
definput = {DataWidthStr, '1',DataLengthStr};
opts.WindowStyle = 'normal';
answer = inputdlg(prompt,dlgtitle,dims,definput,opts);
SelectChannel=str2double(answer{1,1});
StartPoint=str2double(answer{2,1});
EndPoint=str2double(answer{3,1});

NewM=length(SelectChannel);
NewN=EndPoint-StartPoint+1;
TRResultData=zeros(m,NewN);
Stage1DiffMat=zeros(NewM,NewN-1);
% 参数设定
for s=1:m

    SelectData=PureDataMat(s,StartPoint:EndPoint)';

    if ismember(s,SelectChannel)
    else
        TRResultData(s,:)=SelectData';
        continue;
    end

    % 查找异常值
    Stage1Diff=diff(SelectData);
    figure(s+2*m); plot(Stage1Diff);

    cc=1;
    if ismember(s,SelectChannel)
        Stage1DiffMat(cc,:)=Stage1Diff;
        cc=cc+1;
    else
    end

    SuggestValue=0.8*max(Stage1Diff);
    SuggestValueStr=num2str(SuggestValue);


    prompt = { '输入异常检测阈值：','输入聚类阈值：','输入范围扩展阈值：'};
    dlgtitle = '设置检测参数';
    dims = [1 35];
    definput = {SuggestValueStr, '1000', '100'};
    opts.WindowStyle = 'normal';
    answer = inputdlg(prompt,dlgtitle,dims,definput,opts);
    RejectionThreshold=str2double(answer{1,1});
    ClusterThreshold=str2double(answer{2,1});
    IncludeThreshold=str2double(answer{3,1});

    AnomalyIndex=find((Stage1Diff>RejectionThreshold) | (Stage1Diff<-RejectionThreshold));
    AnomalyAmount=length(AnomalyIndex);
    AnomalySpacing=diff(AnomalyIndex);

    % 异常值聚类

    NewAnomalyIndex=zeros(AnomalyAmount,2);
    NewAnomalyIndex(:,1)=AnomalyIndex;
    NewAnomalyIndex(1,2)=1;
    ClusterAmount=1;

    for i=1:AnomalyAmount-1
        if AnomalySpacing(i,1)<ClusterThreshold
            NewAnomalyIndex(i+1,2)=ClusterAmount;
        else
            ClusterAmount=ClusterAmount+1;
            NewAnomalyIndex(i+1,2)=ClusterAmount;
        end
    end

    % 聚类属性矩阵：每行对应一个类。3列分别是每类的起止点与点数量

    ClusterFeature=zeros(ClusterAmount,3);

    for j=1:ClusterAmount

        Temp=find(NewAnomalyIndex(:,2)==j);
        TempLength=length(Temp);

        if TempLength==1
            ClusterFeature(j,1)=NewAnomalyIndex(Temp,1);
            ClusterFeature(j,3)=TempLength;
        else
            ClusterFeature(j,1)=NewAnomalyIndex(Temp(1,1),1)-IncludeThreshold;
            ClusterFeature(j,2)=NewAnomalyIndex(Temp(TempLength,1),1)+IncludeThreshold;
            ClusterFeature(j,3)=ClusterFeature(j,2)-ClusterFeature(j,1)+1;
        end
    end


    % 开始按类从后往前处理
    for w=ClusterAmount:-1:1

        if ClusterFeature(1,1)==0
            continue;
        end

        % 判断是单独的异常值还是成段的异常值
        if ClusterFeature(w,3)==1
            % 单独异常值，异常值处修正为5点后的数据值，之后两段数据拉平
            if ClusterFeature(w,1)<=3
                break;
            end
            UpPoint=SelectData(ClusterFeature(w,1)-3,1);
            DownPoint=SelectData(ClusterFeature(w,1)+3,1);
            PointValueDiff=UpPoint-DownPoint;
            SelectData(ClusterFeature(w,1),1)=SelectData(ClusterFeature(w,1)+5,1);
            SelectData(ClusterFeature(w,1):end,1)=SelectData(ClusterFeature(w,1):end,1)+PointValueDiff;

        else
            % 非单独异常值，异常值段数据修正为粉红噪声
            DownPoint=SelectData(ClusterFeature(w,2)+3,1);
            %  Temp=pinknoise(ClusterFeature(w,3));
            %  NoiseMax=max(Temp);
            %  RegionalMean=mean(SelectData(ClusterFeature(w,2):ClusterFeature(w,2)+IncludeThreshold,1));
            Temp2=SelectData(ClusterFeature(w,2):ClusterFeature(w,2)+ClusterFeature(w,3)-1,1);
            SelectData(ClusterFeature(w,1):ClusterFeature(w,2),1)=Temp2;
            UpPoint=SelectData(ClusterFeature(w,2)-3,1);
            PointValueDiff=UpPoint-DownPoint;
            SelectData(ClusterFeature(w,2)+1:end,1)=SelectData(ClusterFeature(w,2)+1:end,1)+PointValueDiff;
            UpPoint2=SelectData(ClusterFeature(w,1)-3,1);
            DownPoint2=SelectData(ClusterFeature(w,1),1);
            PointValueDiff2=UpPoint2-DownPoint2;
            SelectData(ClusterFeature(w,1):end,1)=SelectData(ClusterFeature(w,1):end,1)+PointValueDiff2;
        end
    end

    figure(s+m); plot(SelectData);
    TRResultData(s,:)=SelectData';
end

end
% SaveFileName=[char(oriname(2)),'TR.mat'];
% 
% save(SaveFileName,'TRResultData');
