import random

import numpy as np

# a = [random.uniform(100.0, 200) for i in range(50)]
a = np.arange(0, 16).reshape((4, 4))
print(a)
print(a[1, a[1] % 2 == 0])