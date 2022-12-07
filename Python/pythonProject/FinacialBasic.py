#!/usr/bin/env python
# coding: utf-8

# In[ ]:


# 输出多条内容
from IPython.core.interactiveshell import InteractiveShell
InteractiveShell.ast_node_interactivity = 'all'


# In[3]:


def npv_f(cashflows, r):
    total = 0
    for i, cashflow in enumerate(cashflows):
        total += cashflow / (1 + r) ** i
    return total


# In[7]:


cashflows_a = [0, -100, 30, 70, 110, 50]
cashflows_b = [0, -100, 110, 70, 30, 50]

npv_f(cashflows_a, 0.4584)
npv_f(cashflows_b, 0.4584)


# In[8]:


# 二分法逼近
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


# In[9]:


irr_f(cashflows_a)
irr_f(cashflows_b)

