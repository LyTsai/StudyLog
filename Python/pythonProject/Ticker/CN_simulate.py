import numpy as np
import pandas as pd

# a = [random.uniform(100.0, 200) for i in range(50)]
a = np.arange(-8, 8).reshape((4, 4))
print(a)
a = pd.Series([1, 2, 3], index=['a', 'b', 'c'])
print(a[0])
