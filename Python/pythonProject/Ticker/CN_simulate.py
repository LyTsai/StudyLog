import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import openpyxl

pd.set_option('display.max_columns', 1000)
pd.set_option('display.max_rows', 30)
pd.set_option('display.float_format', lambda x: '%.5f' %x)

# %matplotlib inline
get_ipython().run_line_magic('matplotlib', 'inline')
plt.rcParams['font.sans-serif'] = 'SimHei'
plt.rcParams['axes.unicode_minus'] = False
# %config InlineBackend.figure_format = 'svg'
get_ipython().run_line_magic('config', "InlineBackend.figure_format = 'svg'")

# 输出多条内容
from IPython.core.interactiveshell import InteractiveShell
InteractiveShell.ast_node_interactivity = 'all'

def npv_f(cashflows, r):
    total = 0
    for i, cashflow in enumerate(cashflows):
        total += cashflow / (1 + r) ** i
    return total

def irr_f(cashflows, iterations=10000):
    rate_d = 0
    rate_u = 1
    rate = (rate_d + rate_u) / 2
    npv = npv_f(cashflows, rate)
    while abs(npv) > 0.0001:
        if npv > 0:
            rate_d = rate
        else:
            rate_u = rate
        rate = (rate_u + rate_d) / 2
        npv = npv_f(cashflows, rate)
    return rate

class Dog():
    def __init__(self, name, age):
        self.name = name
        self.age = age
    def sit(self):
        print(self.name.title() + 'is sitting')