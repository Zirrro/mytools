# -*- coding: utf-8 -*-
# @Time    : 2022/11/21 17:13
# @Author  : Salieri
# @FileName: concatfiles.py
# @Software: PyCharm
# @Comment :

import os
import tkinter as tk
from tkinter import filedialog
from tkinter import Tcl
import numpy as np
import hdf5storage

from readsquidfiles import readsquiddsfiles

'''删除index后缀的文件'''
suffix = 'tdms_index'
root = tk.Tk()
root.withdraw()

FolderPath = filedialog.askdirectory()
path_list = os.listdir(FolderPath)
FolderName = os.path.basename(FolderPath)

# n = 0
for root, dirs, files in os.walk(FolderPath):
    for name in files:
        if name.endswith(suffix):
            # print(name)
            # n = n + 1
            os.remove(os.path.join(root, name))

# print(n)


def file_filter(f):
    if f[-4:] in ['tdms', '.mat', '.txt']:
        return True
    else:
        return False


clean_files_list = list(filter(file_filter, path_list))
print(clean_files_list)
sorted_path_list = Tcl().call('lsort', '-dict', clean_files_list)
print(sorted_path_list)
FileCount = len(sorted_path_list)

i = 0
ShapeMat = np.zeros((2, FileCount), dtype=int)

for filename in sorted_path_list:
    f_path_total = FolderPath + "/" + filename
    DataMat, Fs, _ = readsquiddsfiles(f_path_total)

    ShapeMat[:, i] = DataMat.shape
    i += 1

ChannelCount = ShapeMat[1, 0]
if len(np.unique(ShapeMat[1, :] / ChannelCount)) != 1:
    raise Exception("ShapeMat 通道数验证未通过")

TotalPointCount = np.sum(ShapeMat[0, :])

TotalMat = np.zeros((TotalPointCount, ChannelCount))

i = 1
for filename in sorted_path_list:
    f_path_total = FolderPath + "/" + filename
    DataMat, Fs, _ = readsquiddsfiles(f_path_total)
    StartPoint = np.sum(ShapeMat[0, 0: i - 1])
    EndPoint = StartPoint + ShapeMat[0, i - 1]
    DataMat = np.array(DataMat)
    TotalMat[StartPoint:EndPoint, :] = DataMat
    i += 1

(base, ext) = os.path.splitext(path_list[0])
hdf5storage.savemat(FolderPath + '/' + base,
                    {'ConcatMat': TotalMat},
                    format='7.3', oned_as='column', store_python_metadata=True)
