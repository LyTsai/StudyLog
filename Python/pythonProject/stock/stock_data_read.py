import pandas as pd
from pyecharts.charts import Bar
from pyecharts import options as opts

data_fetch = pd.read_csv('snowball.csv')
x = list(data_fetch['股票名称'].values)
y = list(data_fetch['涨跌幅'].values)
c = (
    Bar()
    .add_xaxis(x[:10])
    .add_yaxis('涨跌幅', y[:10])
    .set_global_opts(
        title_opts = opts.TitleOpts(title="涨跌幅"),
        datazoom_opts = opts.DataZoomOpts()
    )
)

c.render('current.html')
