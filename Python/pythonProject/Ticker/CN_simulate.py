import numpy as np
import pandas as pd
import dateutil


# a = [random.uniform(100.0, 200) for i in range(50)]

date = dateutil.parser.parser('2010-01-01')  # string parser time

print(pd.to_datetime(['2010-01-01', '2010/Feb/02']))