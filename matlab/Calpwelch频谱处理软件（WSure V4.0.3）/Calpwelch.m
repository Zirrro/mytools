
function varargout = Calpwelch(varargin)

% CALPWELCH MATLAB code for Calpwelch.fig
%      CALPWELCH, by itself, creates a new CALPWELCH or raises the existing
%      singleton*.
%
%      H = CALPWELCH returns the handle to a new CALPWELCH or the handle to
%      the existing singleton*.
%
%      CALPWELCH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALPWELCH.M with the given input arguments.
%
%      CALPWELCH('Property','Value',...) creates a new CALPWELCH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Calpwelch_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Calpwelch_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Calpwelch

% Last Modified by GUIDE v2.5 17-Dec-2021 10:06:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Calpwelch_OpeningFcn, ...
                   'gui_OutputFcn',  @Calpwelch_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);  
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Calpwelch is made visible.
function Calpwelch_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Calpwelch (see VARARGIN)

% Choose default command line output for Calpwelch
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
aa={'1时间长度与谱噪声有关'
    '2窗口长度决定峰值的宽度'
    '3重叠范围决定谱的圆滑度，一般不需要修改'
    '4nfft决定频率分辨率'
    '5本程序支持tmds,txt(m*n数列)格式的文件'};
set(handles.text_illustrate,'string',aa);


% UIWAIT makes Calpwelch wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Calpwelch_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_read.
function pushbutton_read_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_read (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global t
global rawdata
global Fs
global newpath
global oriname

oldpath=cd;
if isempty(newpath)||~exist('newpath')
    newpath=cd
end
cd(newpath);
[filename, pathname] = uigetfile({'*.tdms;*.txt; *.mat;*.lvm;', ...
           'Data Files (*.tdms *.txt *.lvm)'; '*.*','All Files (*.*)'},'Pick a file');
       fpath=[pathname filename];
                   if filename~=0
                
                newpath=pathname
            end
            cd(oldpath);
         if filename==0
             return
         end
             if filename~=0
               path0=pathname;
               filename0=filename;
             end
%          if(~filename((length(filename)-3):end)== 'tdms')
filelast=filename((length(filename)-3):end);
%浠ヤ笂鏄鍙栨枃浠��
oriname=filename(1:size(filename,2)-4);
  if(filelast== 'tdms')
      
oriname=filename(1:size(filename,2)-5);
[a,b,c,d,e]=convertTDMS(true,fpath);
i=1;
k=1;
[m,n]=size(a.Data.MeasuredData);
for ii=1:1:n
   if length(a.Data.MeasuredData(i).Data)>100
y(:,k)=a.Data.MeasuredData(i).Data;
listname{k}=a.Data.MeasuredData(i).Name;
k=k+1;
   end
i=i+1;
end

x1=y(2,1)-y(1,1);
%%褰撶涓��鍒椾笉鏄椂闂存椂锛屾湁鍙兘宸��兼槸0
if x1~=0
Fs=1/x1;
else
    Fs=0.386;
end


if ~rem(Fs,1)
    t=y(:,1);

else
  % Fs=inputdlg('璇疯緭鍏ラ噰鏍风巼');
   %Fs=str2num(cell2mat(Fs));
  Fx= e.Object3.Property2.value;
  Fs=1/Fx;
 % Fs=50000;
   t=1/Fs:1/Fs:length(y(:,1))/Fs;
end

rawdata=y;
%rawdata(:,4:6)=-rawdata(:,4:6);%%%鐩镐綅鍙栧弽
aa=floor(t(end));
aa=num2str(aa);

set(handles.edit_readfile,'string',fpath);
set(handles.text_Fs,'string',Fs);
set(handles.edit_lentime,'string',aa);
bb=1/Fs;
bb=num2str(bb);
set(handles.edit_begin,'string',bb);
set(handles.edit_end,'string',aa);
set(handles.listbox_data,'string',listname);
  else if (filelast== '.lvm')
       %   channel=2;
          channel=inputdlg('璇疯緭鍏ヨ鏂囦欢鐨勫垪鏁��');
           channel=str2num(cell2mat(channel));
          nfiletitle=23;
                 
             fid=fopen(fpath);  
             for li=1:nfiletitle;    
             line=fgetl(fid);
             end;
             data=fscanf(fid,'%f',[1 inf]);
             data=data';
             fclose('all');  
             Nn=length(data);
           
             Lon=Nn/channel;
             Lon1=ceil(Lon);
         
             data_in=zeros(Lon1,channel);
              m=1;
              n=1;    
            for i=1:Nn
                data_in(m,n)=data(i);
                n=n+1;
                xx=mod(i,channel); 
                  if (xx==0);
                   n=1;
                   m=m+1;
                  end
            end
          format rat             
       y=data_in;      
        Fs=double(1/(y(2,1)-y(1,1)));
  
%if ~rem(Fs,1)
if Fs==fix(Fs)
    t=y(:,1);

else
   Fs=inputdlg('璇疯緭鍏ラ噰鏍风巼');
   Fs=str2num(cell2mat(Fs));
   t=1/Fs:1/Fs:length(y(:,1))/Fs;
end
 [m,n]=size(y);
rawdata=y;
aa=floor(t(end));
aa=num2str(aa);
set(handles.edit_readfile,'string',fpath);
set(handles.text_Fs,'string',Fs);
set(handles.edit_lentime,'string',aa);
bb=1/Fs;
bb=num2str(bb);
set(handles.edit_begin,'string',bb);
set(handles.edit_end,'string',aa);

name=[1,2,3,4,5,6,7,8,9,10,11,12,13];
name=name';
listname=num2str(name(1:n));
set(handles.listbox_data,'string',listname);     

      else
      y=load(fpath);

      if isa(y, 'struct')
          y=cell2mat(struct2cell(y));
      end
      %%%%鍔爊ame
      [m,n]=size(y);

      if n>m
          y=y';
          [m,n]=size(y);
      end
      
      Fs=1/(y(2,1)-y(1,1));

   Fs=inputdlg('请输入文件的采样率：');
   Fs=str2num(cell2mat(Fs));
   t=1/Fs:1/Fs:length(y(:,1))/Fs;


rawdata=y;
% rawdata(:,4:6)=-rawdata(:,4:6);%%%鐩镐綅鍙栧弽
aa=floor(t(end));
aa=num2str(aa);
set(handles.edit_readfile,'string',fpath);
set(handles.text_Fs,'string',Fs);
set(handles.edit_lentime,'string',aa);
bb=1/Fs;
bb=num2str(bb);
set(handles.edit_begin,'string',bb);
set(handles.edit_end,'string',aa);

name=[1,2,3,4,5,6,7,8,9,10,11,12,13];
name=name';
listname=num2str(name(1:n));
set(handles.listbox_data,'string',listname);
  end
  
  set(handles.edit_nwindow,'string',Fs);
set(handles.edit_nfft,'string',Fs);
set(handles.edit_coe,'string','8.8');
  end


function edit_readfile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_readfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_readfile as text
%        str2double(get(hObject,'String')) returns contents of edit_readfile as a double


% --- Executes during object creation, after setting all properties.
function edit_readfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_readfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_pwelch.
function pushbutton_pwelch_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_pwelch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Fs
global rawdata
A= get(handles.listbox_data,'value'); %A鐨勫��间唬琛ㄦ垜浠��夌殑鏄鍑犱釜閫夐」
win=get(handles.popupmenu_window,'value');%%杩欓噷閫夋嫨涓嶅悓鐨勭獥鍙��
nwindow=str2num(get(handles.edit_nwindow,'string'));
overlap=str2num(get(handles.edit_noverlap,'string'));
nfft=str2num(get(handles.edit_nfft,'string'));
nt=str2num(get(handles.edit_lentime,'string'));
coe=str2num(get(handles.edit_coe,'string'));

nbegin=str2num(get(handles.edit_begin,'string'));
nend=str2num(get(handles.edit_end,'string'));

%%%涓嬮潰瀵归��変腑鐨勬暟鎹眰鍔熺巼瀵嗗害璋��
 %   y=rawdata(1:nt*Fs,A)*coe;
    y=rawdata(nbegin*Fs:nend*Fs,A)*coe;
 switch win
case 1  % 褰撴垜浠��夌殑鏄��鏃讹紝缁欏彉閲廈璧嬩釜浠��涔堟牱鐨勫��硷紝渚濇绫绘帹锛屾渶鍚嶣灏嗘槸浣犳兂瑕佺殑缁撴灉

window=hanning(nwindow);


case 2 
  window=boxcar(nwindow);
  
     case 3
           window=triang(nwindow);
     case 4
           window=hamming(nwindow);
     case 5
           window=blackman(nwindow);
     case 6
           window=kaiser(nwindow);
end   

noverlap=overlap*nfft;
[Pxx,f]=pwelch(y,window,noverlap,nfft,Fs);

yy=sqrt(Pxx*2);
figure(2)
loglog(f,yy);
hold on
xlabel('Frequency (Hz)');
ylabel('B (nT/rtHz)');




function edit_nwindow_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nwindow as text
%        str2double(get(hObject,'String')) returns contents of edit_nwindow as a double


% --- Executes during object creation, after setting all properties.
function edit_nwindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_noverlap_Callback(hObject, eventdata, handles)
% hObject    handle to edit_noverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_noverlap as text
%        str2double(get(hObject,'String')) returns contents of edit_noverlap as a double


% --- Executes during object creation, after setting all properties.
function edit_noverlap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_noverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_nfft_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nfft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nfft as text
%        str2double(get(hObject,'String')) returns contents of edit_nfft as a double


% --- Executes during object creation, after setting all properties.
function edit_nfft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nfft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_data.
function listbox_data_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_data contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_data

global t
global rawdata
global Fs

A= get(handles.listbox_data,'value'); %A鐨勫��间唬琛ㄦ垜浠��夌殑鏄鍑犱釜閫夐」
coe=str2num(get(handles.edit_coe,'string'));
  nbegin=str2num(get(handles.edit_begin,'string'));
nend=str2num(get(handles.edit_end,'string'));


  %  y=rawdata(nbegin*Fs:nend*Fs,A)*coe;
lenA=length(A);
if lenA>1
figure(1)
plot(t(nbegin*Fs:nend*Fs),rawdata(nbegin*Fs:nend*Fs,A)*coe);
xlabel('Time (s)');
ylabel('B (nT)');
else
    sel=get(gcf,'selectiontype');%%鑾峰彇榧犳爣妗堜欢绫诲瀷
    if strcmp(sel,'open')%%鏄惁鍙屽嚮宸﹂敭
        figure(1)
plot(t(nbegin*Fs:nend*Fs),rawdata(nbegin*Fs:nend*Fs,A)*coe);
xlabel('Time (s)');
ylabel('B (nT)');
    end
end
        


% --- Executes during object creation, after setting all properties.
function listbox_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over listbox_data.
function listbox_data_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to listbox_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_lentime_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lentime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lentime as text
%        str2double(get(hObject,'String')) returns contents of edit_lentime as a double


% --- Executes during object creation, after setting all properties.
function edit_lentime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lentime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_coe_Callback(hObject, eventdata, handles)
% hObject    handle to edit_coe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_coe as text
%        str2double(get(hObject,'String')) returns contents of edit_coe as a double


% --- Executes during object creation, after setting all properties.
function edit_coe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_coe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%%%涓嬮潰鏄痗onvertTDMS


% --- Executes on selection change in popupmenu_window.
function popupmenu_window_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_window contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_window


% --- Executes during object creation, after setting all properties.
function popupmenu_window_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_filter.
function pushbutton_filter_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Fs
global t
global rawdata
A= get(handles.listbox_data,'value'); %A鐨勫��间唬琛ㄦ垜浠��夌殑鏄鍑犱釜閫夐」
win=get(handles.popupmenu_window,'value');%%杩欓噷閫夋嫨涓嶅悓鐨勭獥鍙��
nwindow=str2num(get(handles.edit_nwindow,'string'));
overlap=str2num(get(handles.edit_noverlap,'string'));
nfft=str2num(get(handles.edit_nfft,'string'));
nt=str2num(get(handles.edit_lentime,'string'));
coe=str2num(get(handles.edit_coe,'string'));
%%%涓嬮潰瀵归��変腑鐨勬暟鎹眰鍔熺巼瀵嗗害璋��
  %  y=rawdata(1:nt*Fs,A)*coe;
  nbegin=str2num(get(handles.edit_begin,'string'));
nend=str2num(get(handles.edit_end,'string'));


    y=rawdata(nbegin*Fs:nend*Fs,A)*coe;
 
%[Pxx,f]=pwelch(y,window,noverlap,nfft,Fs);


Hd=myfilter;
output=filter(Hd,y);


figure(2)

plot(t((nbegin)*Fs:nend*Fs),output((1/Fs)*Fs:end,:));
hold on
xlabel('time(s)');
ylabel('B(nT)');
%xlim([100,400]);
if sum(A)==9
    legend('Bx1','By1','Bz1');
elseif sum(A)==23
    legend('Bx2','By2','Bz2');
end
    



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filterDesigner


% --- Executes on button press in edit_begin.
function edit_begin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of edit_begin


% --- Executes during object creation, after setting all properties.
function edit_begin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_begin as text
%        str2double(get(hObject,'String')) returns contents of edit_begin as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_end_Callback(hObject, eventdata, handles)
% hObject    handle to edit_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_end as text
%        str2double(get(hObject,'String')) returns contents of edit_end as a double


% --- Executes during object creation, after setting all properties.
function edit_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_FFT.
function pushbutton_FFT_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_FFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global u
u = u+1
global Fs
global rawdata
% store_frequency_and_amplitude = [];
global store_frequency_and_amplitude
A= get(handles.listbox_data,'value'); %A鐨勫��间唬琛ㄦ垜浠��夌殑鏄鍑犱釜閫夐」
win=get(handles.popupmenu_window,'value');%%杩欓噷閫夋嫨涓嶅悓鐨勭獥鍙��
nwindow=str2num(get(handles.edit_nwindow,'string'));
overlap=str2num(get(handles.edit_noverlap,'string'));
nfft=str2num(get(handles.edit_nfft,'string'));
nt=str2num(get(handles.edit_lentime,'string'));
coe=str2num(get(handles.edit_coe,'string'));

nbegin=str2num(get(handles.edit_begin,'string'));
nend=str2num(get(handles.edit_end,'string'));
%%%涓嬮潰瀵归��変腑鐨勬暟鎹眰鍔熺巼瀵嗗害璋��
 %   y=rawdata(1:nt*Fs,A)*coe;
    y=rawdata(nbegin*Fs+1:nend*Fs,A)*coe;

 switch win
case 1  % 褰撴垜浠��夌殑鏄��鏃讹紝缁欏彉閲廈璧嬩釜浠��涔堟牱鐨勫��硷紝渚濇绫绘帹锛屾渶鍚嶣灏嗘槸浣犳兂瑕佺殑缁撴灉

window=hanning(nwindow);


case 2 
  window=boxcar(nwindow);
  
     case 3
           window=triang(nwindow);
     case 4
           window=hamming(nwindow);
     case 5
           window=blackman(nwindow);
     case 6
           window=kaiser(nwindow);
end   

%noverlap=overlap*nfft;
%[Pxx,f]=pwelch(y,window,noverlap,nfft,Fs);

[m,n]=size(y);
for i=1:n
yy=y(:,i);

N=m;
   w=window;
   ts=1/Fs;
   T=(N-0)*ts;
   t=0:ts:T-0*ts;
%    save('yy','y');
%    save('m','m');
%    save('T','T');
%    save('N','N');
 %    x=col'.*w;
   x=yy';
   yf=fft(x);
   f=(0:N-1)*Fs/(N-0);
   data_am=2*abs(yf)/N;
   

   px=f(1:fix(N/2));
   py(:,i)=data_am(1:fix(N/2));

end
% store_frequency_and_amplitude = [];


% u = get(handles.pushbutton_FFT,'value')+u
    maximum_amplitude = max(max(py));
    [row column] = find(py == max(max(py)));
    maximum_corresponding_frequency = px(row);
    if px(row)==0
        py(row)=0;
        [row column] = find(py == max(max(py)));
        maximum_corresponding_frequency = px(row);
    end
%     row
%     save('px','px');
%     save('py','py');
%     store_frequency_and_amplitude = [store_frequency_and_amplitude;store_frequency_and_amplitude]
    store_frequency_and_amplitude(u,1) = nbegin;
    store_frequency_and_amplitude(u,2) = nend;
    store_frequency_and_amplitude(u,3) = maximum_corresponding_frequency;
    store_frequency_and_amplitude(u,4) = maximum_amplitude;
%     store_frequency_and_amplitude = [store_frequency_and_amplitude;store_frequency_and_amplitude]


% save('store_frequency_and_amplitude','store_frequency_and_amplitude');
% save('py','py');
% figure
% crosstalk = [];
% crosstalk(:,1) =log10(px);
% crosstalk(:,2) =log10(py);
% 
% save('梯度计输出串扰','crosstalk');

figure;
   loglog(px,py);
      xlabel('棰戠巼(Hz)');
   ylabel('鎸箙锛坢v)');
 



% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%文件读取
% [file,path] = uigetfile('*.txt');
% filepath = strcat(path,file);
% mag=load(filepath);
%input=jcy(1,length(mag),10,mag);%%%降采样
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%自补偿
% input=mag;
global Fs
global rawdata
global k
global oriname
global self_compensation_data

A= get(handles.listbox_data,'value'); %A鐨勫��间唬琛ㄦ垜浠��夌殑鏄鍑犱釜閫夐」
win=get(handles.popupmenu_window,'value');%%杩欓噷閫夋嫨涓嶅悓鐨勭獥鍙��
nwindow=str2num(get(handles.edit_nwindow,'string'));
overlap=str2num(get(handles.edit_noverlap,'string'));
nfft=str2num(get(handles.edit_nfft,'string'));
nt=str2num(get(handles.edit_lentime,'string'));
coe=str2num(get(handles.edit_coe,'string'));

nbegin=str2num(get(handles.edit_begin,'string'));
nend=str2num(get(handles.edit_end,'string'));
%%%涓嬮潰瀵归��変腑鐨勬暟鎹眰鍔熺巼瀵嗗害璋��
%   y=rawdata(1:nt*Fs,A)*coe;
y=rawdata(nbegin*Fs:nend*Fs,A)*coe;
% Hd=myfilter;
% output=filter(Hd,y);
% save('output','output');
% input=output(5*Fs:end,:);
% self_compensation_data = input(1:end,:);
% input=y;

data=y;
self_compensation_data=y;
% data=self_compensation_data(:,:);%%%自补偿数据选取
% t=data(:,1);%第一列所有数据
t = nbegin*Fs:1:nend*Fs;
t = t';
% t = t(5*Fs:end);
t = t/Fs;
% save('t','t');
% save('output','output');
N=length(t);
M=ones(length(t),1);

Bx=data(:,1);
By=data(:,2);
Bz=data(:,3);


bx=data(:,4);
by=data(:,5);
bz=data(:,6);

% windnum=10
windnum = str2num(get(handles.edit11,'string'));
windowlen = floor(N/windnum);

for n=1:windnum-1
    startn = windowlen*n;
    endn= windowlen*(n+1);
    Bxn = Bx(startn:endn);
    Byn = By(startn:endn);
    Bzn = Bz(startn:endn);
    bxn = bx(startn:endn);
    byn = by(startn:endn);
    bzn = bz(startn:endn);

    Y=[Bxn Byn Bzn];
    R=[ones(length(bxn),1) bxn byn bzn];
    k(:,:,n)=pinv(R)*Y;
    deta(startn:endn,:)=Y-R*k(:,:,n);
end
% save('k');


%Bx
figure
plot(t,Bx)
hold on
plot(t(1:length(deta)),deta(:,1))
xlabel('time(s)');
ylabel('nT')
legend('补偿前','补偿后')
title('x');
%By
figure
plot(t,By)
hold on
plot(t(1:length(deta)),deta(:,2))
xlabel('time(s)');
ylabel('nT')
legend('补偿前','补偿后')
title('y');
%Bz
figure
plot(t,Bz)
hold on
plot(t(1:length(deta)),deta(:,3))
xlabel('time(s)');
ylabel('nT')
legend('补偿前','补偿后')
title('z');

% outname=['12101.txt'];
outdata=[t(1:length(deta)),deta(:,1),deta(:,2),deta(:,3)];

% SaveFileNameMat=[oriname,'Compensated.mat'];
SaveFileNameTXT=[oriname, 'Compensated.txt'];
% save(SaveFileNameMat ,'outdata', '-ascii');
save(SaveFileNameTXT, 'outdata', '-ascii');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%外补偿
% data2=input(:,:);%%%自补偿数据选取
% tt=data2(:,1);
% M2=ones(length(tt),1);
% Bx2=data2(:,2);
% By2=data2(:,3);
% Bz2=data2(:,4);


% bx2=data2(:,5);
% by2=data2(:,6);
% bz2=data2(:,7);
% Y2=[Bx2 By2 Bz2];
% %
% R2=[M2 bx2 by2 bz2];
% deta2=Y2-R2*k;
% %
% %Bx
% figure
% plot(tt,Bx2)
% hold on
% plot(tt,deta2(:,1))
% xlabel('time(s)');

% ylabel('nT')
% legend('补偿前','补偿后')
% %By
% figure
% plot(tt,By2)
% hold on
% plot(tt,deta2(:,2))
% xlabel('time(s)');

% ylabel('nT')
% legend('补偿前','补偿后')
% %Bz
% figure
% plot(tt,Bz2)
% hold on
% plot(tt,deta2(:,3))
% xlabel('time(s)');

% ylabel('nT')
% legend('补偿前','补偿后')

%R=[M by];  %第二个模块By补偿Bx
%k1=pinv(R)*bx;
%deta3=bx-R*k1;

%figure
%plot(t,bx)
%hold on
%plot(t,deta3)
%xlabel('time(s)');
%ylabel('nT')
%legend('补偿前','补偿后')

%R=[M by];  %第二个模块By补偿Bz
%k2=pinv(R)*bz;
%deta4=bz-R*k2;

%figure
%plot(t,bz)
%hold on
%plot(t,deta4)
%xlabel('time(s)');
%ylabel('nT')
%legend('补偿前','补偿后')
%A=[deta3 deta4];


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Fs
global rawdata
function main
% clear all;
% clc;
% [filename, pathname] = uigetfile({'*.mat', ...
%            'Data Files (*.mat)'; '*.*','All Files (*.*)'},'MultiSelect','on');
% fpath=[pathname filename];
% a=load(fpath);
% Fs=1000;

A= get(handles.listbox_data,'value'); %A的值代表我们选的是第几个选项
win=get(handles.popupmenu_window,'value');%%这里选择不同的窗口
nwindow=str2num(get(handles.edit_nwindow,'string'));
overlap=str2num(get(handles.edit_noverlap,'string'));
nfft=str2num(get(handles.edit_nfft,'string'));
nt=str2num(get(handles.edit_lentime,'string'));
coe=str2num(get(handles.edit_coe,'string'));

nbegin=str2num(get(handles.edit_begin,'string'));
nend=str2num(get(handles.edit_end,'string'));
aa = rawdata(nbegin*Fs:nend*Fs,A)*coe;
% aa=a.data_input;

%%截一段
% bb=aa(1:200*Fs,:);  %%%这里表示截取一段，300s以内还行，不然数据太长，计算时间很慢
% aa=[];
% aa=bb;
[N M]=size(aa);
%%下面是1.5nT芯片
%旧塞子X，ms33-2:5.437uA/phi0
RF=2;
LMD=1.5;%1.5nT/phi0

%s1 矮 新塞子
% corx=1.5*1000/(5.437*1.993);
% cory=1.5*1000/(5.48*1.998);
% corz=1.5*1000/(5.4*1.996);
% 
% %%%s2 高 旧塞子
% 
% mcorx=1.5*1000/(3.8*1.997);
% mcory=1.5*1000/(4.3*1.997);%%%就这个了
% mcorz=1.5*1000/(5.7*2.001);

% %s1 矮 新塞子
corx=1.5*1000/(5.437*1.993);
cory=1.5*1000/(5.48*1.998);
corz=1.5*1000/(5.4*1.996);

%%%s2 高 旧塞子

mcorx=1.5*1000/(6.59*1.995);
mcory=1.5*1000/(2.757*1.997);
mcorz=1.5*1000/(5.7*2.001);
corx=1;
cory=1;
corz=1;
% 
% %%s2 高 旧塞子
% 
% mcorx=1;
% mcory=1;
% mcorz=1;
aa(:,1)=aa(:,1)*corx;
aa(:,2)=aa(:,2)*cory;
aa(:,3)=aa(:,3)*corz;

aa(:,4)=aa(:,4)*mcorx;
aa(:,5)=aa(:,5)*mcory;
aa(:,6)=aa(:,6)*mcorz;
t=1/Fs:1/Fs:N/Fs;
col=['r' 'b' 'g' 'r--' 'b--' 'g--'];
%%%全放一张图
figure
for i=1:M
plot(t,aa(:,i),col(i));
hold on
end
%%%图2 分类放
NN=2;
NB=1;
%%%下面是为了两套系统曲线放到一张图里，所以去除了一下直流量
figure
subplot(3,1,1)
m15x=aa(:,1)-mean(aa(NB*Fs+1:NB*Fs+Fs*NN,1));
m800x=aa(:,5)-mean(aa(NB*Fs+1:NB*Fs+Fs*NN,5));
plot(t,m15x,'r',t,m800x,'b');
title('X轴');
legend('s2','s1');
subplot(3,1,2)
m15y=aa(:,2)-mean(aa(NB*Fs+1:NB*Fs+Fs*NN,2));
m800y=-aa(:,4)+mean(aa(NB*Fs+1:NB*Fs+Fs*NN,4));
plot(t,m15y,'r',t,m800y,'b');
legend('s2','s1');
title('Y轴');
subplot(3,1,3)
m15z=aa(:,3)-mean(aa(NB*Fs+1:NB*Fs+Fs*NN,3));
m800z=-aa(:,6)+mean(aa(NB*Fs+1:NB*Fs+Fs*NN,6));
plot(t,m15z,'r',t,m800z,'b');
legend('s2','s1');
title('Z轴');
%%%%%下面开始求频谱
nums=floor(N/Fs);

L=1%%%求取频谱长度，这里是选取1s的长度做FFT
allfy1=[];
for i=1:nums
[f1,fy1]=qiupinpu(Fs,m15x((i-1)*Fs*L+1:i*Fs*L));
allfy1(:,i)=fy1;
end
figure
loglog(f1,allfy1(:,1));

%%%下面画图
xx=[];
x=1:1:nums;
ny=length(f1);
    for i=1:ny  %%横轴行变列不变，时间
        xx=[x
            xx];
    end
    yy=[];
    for i=1:nums   %%%%纵轴是频率
        yy=[f1' yy];
    end
   zz=log10(allfy1);%%%对频谱的幅度取对数
  % zz=allfy1;
    figure(3);

     [c,h]=contourf(xx,yy,zz,length(zz));
set(h,'LineStyle','none');
        map=jet;
       colormap(map);
    
     xlabel('time(s)');
     ylabel('frequence(Hz)');


function [f, sf]=FFT_SHIFT(t, st)
%This function is FFT to calculate a signal’s Fourier transform
%Input: t: sampling time , st : signal data. Time length must greater than 2
%output: f : sampling frequency , sf: frequency
%output is the frequency and the signal spectrum
dt=t(2)-t(1);
T=t(end);
df=1/T;
N=length(t);
f=[-N/2:N/2-1]*df;
sf=fft(st);
sf=T/N*fftshift(sf);

% 傅里叶反变换
function [t,st]=IFFT_SHIFT(f,Sf)
df=f(2)-f(1);
fmax=(f(end)-f(1)+df);
dt=1/fmax;
N=length(f);
t=[0:N-1]*dt;
Sf=fftshift(Sf);
st=fmax*ifft(Sf);
st=real(st);

% 低通滤波器
function [t,st]=RECT_LPF(f,Sf,B)
df=f(2)-f(1);
fN=length(f);
RectH=zeros(1,fN);
BN=floor(B/df);
BN_SHIFT=[-BN:BN-1]+floor(fN/2);
RectH(BN_SHIFT)=1;
Yf=RectH.*Sf;
[t,st]=IFFT_SHIFT(f,Yf);

function [ft,fy]=qiupinpu(Fs,yy)
 col=yy;

N=length(col);
   w=hanning(N);
   ts=1/Fs;
   T=N*ts;
   t=0:ts:T-ts;
    x=col.*w;
 %  x=col';
   y=fft(x);
   f=(0:N-1)*Fs/N;
   data_am=4*abs(y)/N;%单峰值  *4是单峰值，*8是峰峰值
%    figure(2);
%    loglog(f(1:fix(N/2)),data_am(1:fix(N/2)),'r');
   ft=f(1:fix(N/2));
   fy=data_am(1:fix(N/2));


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear global u
u = 0;
global u
clear global store_frequency_and_amplitude
store_frequency_and_amplitude = [];



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%外补偿
global Fs
global self_compensation_data
global k
global oriname

nbegin=str2num(get(handles.edit_begin,'string'));
nend=str2num(get(handles.edit_end,'string'));
n_k = str2num(get(handles.edit12,'string'));
b = k(:,:,n_k);
data2=self_compensation_data(:,:);%%%自补偿数据选取
t = nbegin*Fs:1:nend*Fs;
t = t';
% t = t(5*Fs:end);
t = t/Fs;
M2=ones(length(t),1);
Bx2=data2(:,1);
By2=data2(:,2);
Bz2=data2(:,3);


bx2=data2(:,4);
by2=data2(:,5);
bz2=data2(:,6);
Y2=[Bx2 By2 Bz2];
%
R2=[M2 bx2 by2 bz2];
deta2=Y2-R2*b;
%
%Bx
figure
plot(t,Bx2)
hold on
plot(t,deta2(:,1))
xlabel('time(s)');

ylabel('nT')
legend('补偿前','补偿后')
%By
figure
plot(t,By2)
hold on
plot(t,deta2(:,2))
xlabel('time(s)');

ylabel('nT')
legend('补偿前','补偿后')
%Bz
figure
plot(t,Bz2)
hold on
plot(t,deta2(:,3))
xlabel('time(s)');

ylabel('nT')
legend('补偿前','补偿后')

% outname=['12101.txt'];
outdata=[t(1:length(deta2)),deta2(:,1),deta2(:,2),deta2(:,3)];

% SaveFileNameMat=[oriname,'Compensated.mat'];
SaveFileNameTXT=[oriname, 'OutComp.txt'];
% save(SaveFileNameMat ,'outdata', '-ascii');
save(SaveFileNameTXT, 'outdata', '-ascii');



% clear global k
% 
% R=[M by];  %第二个模块By补偿Bx
% k1=pinv(R)*bx;
% deta3=bx-R*k1;
% 
% figure
% plot(t,bx)
% hold on
% plot(t,deta3)
% xlabel('time(s)');
% ylabel('nT')
% legend('补偿前','补偿后')
% 
% R=[M by];  %第二个模块By补偿Bz
% k2=pinv(R)*bz;
% deta4=bz-R*k2;
% 
% figure
% plot(t,bz)
% hold on
% plot(t,deta4)
% xlabel('time(s)');
% ylabel('nT')
% legend('补偿前','补偿后')
% A=[deta3 deta4];



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
