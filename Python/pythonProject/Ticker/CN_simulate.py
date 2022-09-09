import random

import numpy as np

a = [random.uniform(100.0, 200) for i in range(50)]
a = np.array(a)
x = 6
a = a * 6.5

print(a.dtype)