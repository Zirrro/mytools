# -*- coding: utf-8 -*-
# @Time    : 2023/9/1 8:45
# @Author  : Salieri
# @FileName: removeStep.py
# @Software: PyCharm
# @Comment :

import numpy as np
import matplotlib.pyplot as plt

# 生成带有跳变的数据
x = np.linspace(0,10,100)
y = np.sin(x) + np.random.normal(0,0.2,100)
y[40:60] += 2
y1 = y

threshold = 1.5
jump_indices = np.where(np.abs(np.diff(y)) > threshold)[0] + 1

for idx in jump_indices:
    y1[idx] = (y1[idx - 1] + y1[idx + 1])/2

# plt.plot(x,y,color='blue')
# plt.plot(x, y1,color='red')
plt.plot(x, y1 - y,color='orange')
# plt.scatter(x[jump_indices],y1[jump_indices],color="red")
plt.legend()
plt.xlabel('X')
plt.ylabel('Y')
plt.title('带有跳变的数据处理',fontproperties="SimHei")
plt.show()