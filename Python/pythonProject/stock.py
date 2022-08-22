import pandas as pd
import matplotlib.pyplot as plt
pd.set_option('expand_frame_repr', false)

# import data
# pd.DataFrame(test)
stock_data = pd.read_csv('xx.csv')
stock_data.columns = [i.encode('utf8)]
