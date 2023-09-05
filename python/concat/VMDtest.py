# -*- coding: utf-8 -*-
# @Time    : 2023/6/16 10:26
# @Author  : Salieri
# @FileName: VMDtest.py
# @Software: PyCharm
# @Comment :

import matplotlib.pyplot as plt
from vmdpy import VMD
import transfer


fpath = 'D:\\OneDrive\\matlab functions\\selectData06210300.mat'
t = transfer.get_mat_variable_name(fpath)
np_data = transfer.mat_to_nparray(fpath)

# some sample parameters for VMD
alpha = 2000       # moderate bandwidth constraint
tau = 0.           # noise-tolerance (no strict fidelity enforcement)
K = 3              # 3 modes
DC = 0             # no DC part imposed
init = 1           # initialize omegas uniformly
tol = 1e-7

testData = np_data[0:120000,0]

u, u_hat, omega = VMD(testData, alpha, tau, K, DC, init, tol)

plt.figure()
plt.subplot(2,1,1)
plt.plot(testData)
plt.title('Original signal')
plt.xlabel('time (s)')
plt.subplot(2,1,2)
plt.plot(u.T)
plt.title('Decomposed modes')
plt.xlabel('time (s)')
plt.legend(['Mode %d'%m_i for m_i in range(u.shape[0])])
plt.tight_layout()