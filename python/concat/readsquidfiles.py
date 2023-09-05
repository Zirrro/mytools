# -*- coding: utf-8 -*-
# @Time    : 2022/10/31 10:23
# @Author  : Salieri
# @FileName: readsquidfiles.py
# @Software: PyCharm
# @Comment :

def readsquiddsfiles(f_path_total):

    import numpy as np
    from nptdms import TdmsFile
    import pandas as pd
    import os
    import scipy.io as sio
    import h5py

    # 获取文件夹路径
    f_path = os.path.dirname(f_path_total)
    f_name = os.path.basename(f_path_total)
    FileName = f_name.split(".")[0]
    suffix = f_name.split(".")[1]

    if suffix == "tdms":
        # %% 读取 TDMS 文件
        tdms_file = TdmsFile.read(f_path_total)

        for group in tdms_file.groups():
            group_name = group.name
            for channel in group.channels():
                channel_name = channel.name
                # Access dictionary of properties:
                properties = channel.properties
        Fs = int(round((1 / properties['wf_increment']) / 100) * 100)
        DataMat = tdms_file.as_dataframe(time_index=False, absolute_time=False)


    elif suffix == "txt":
        # %% 读取txt文件
        DataMat = pd.read_csv(f_path_total, sep='\t')
        Fs = None

    else:
        # %% 读取mat文件
        try:
            rawdata = sio.loadmat(f_path_total)
            DataMat = pd.DataFrame(rawdata[FileName])
            Fs = None

        except NotImplementedError:
            rawdata = h5py.File(f_path_total, 'r')
            arrays = {}
            for k, v in rawdata.items():
                arrays[k] = np.array(v)

            KeysName = list(arrays.keys())[0]
            DataMat = pd.DataFrame(arrays[KeysName])
            Fs = None

        except:
            ValueError('Can not read this mat file.')
            DataMat = None
            Fs = None

    #%% 检查矩阵维度
    # HNum, VNum = DataMat.shape
    # if HNum < VNum:
    #     DataMat = DataMat.T

    return DataMat, Fs, FileName