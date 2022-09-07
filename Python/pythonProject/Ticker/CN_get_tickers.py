import akshare as ak
import mplfinance as mpf  # Please install mplfinance as follows: pip install mplfinance
import pandas
import datetime

# 1. get tickers online
stock_sse_summary = ak.stock_sse_summary()
print(stock_sse_summary)
print(type(stock_sse_summary))
# 2. save the ticker list to a local file


stock_us_daily_df = ak.stock_us_daily(symbol="AAPL", adjust="qfq")
stock_us_daily_df = stock_us_daily_df[["open", "high", "low", "close", "volume"]]
stock_us_daily_df.columns = ["Open", "High", "Low", "Close", "Volume"]
stock_us_daily_df.index.name = "Date"
stock_us_daily_df = stock_us_daily_df["2020-04-01": "2020-04-29"]
mpf.plot(stock_us_daily_df, type='candle', mav=(3, 6, 9), volume=True, show_nontrading=False)