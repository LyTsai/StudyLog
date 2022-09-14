import numpy as np
import pandas as pd

# a = [random.uniform(100.0, 200) for i in range(50)]
a = np.arange(-8, 8).reshape((4, 4))
print(a)
sr = pd.Series([1, 2, 3], index=['a', 'd', 'c'])
sr1 = pd.Series([1, 2, 3], index=['a', '1', 'c'])
df = pd.DataFrame({'one': sr, 'two': sr1})
df.sort_index
print(df)