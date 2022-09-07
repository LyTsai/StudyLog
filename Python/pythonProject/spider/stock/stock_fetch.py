from ast import If
import requests

import os
import csv

filepath = 'snowball.csv'
# if not os.path.isfile(filepath):
with open(filepath, mode='w', encoding='utf-8', newline='') as file:
    csv_writer = csv.writer(file)
    csv_writer.writerow(['股票代码', '股票名称', '当前价', '涨跌额', '涨跌幅', '年初至今', '成交量', '成交额', '换手率', '市盈率(TTM)', '股息率', '市值'])

url = 'https://xueqiu.com/service/v5/stock/screener/quote/list?page=1&size=90&order=desc&orderby=current_year_percent&order_by=current_year_percent&market=CN&type=sh_sz&_=1662365361258'
headers = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.2 Safari/605.1.15'
}

data = requests.get(url=url, headers=headers).json()['data']
count = data['count']

page = 1
while page * 90 < count:
    url = f'https://xueqiu.com/service/v5/stock/screener/quote/list?page={page}&size=90&order=desc&orderby=current_year_percent&order_by=current_year_percent&market=CN&type=sh_sz&_=1662365361258'
    data = requests.get(url=url, headers=headers).json()['data']
    list = data['list']
    for item in list:
        market_capital = item['market_capital']
        if market_capital < 5000000000 or market_capital > 20000000000:
            continue
        symbol = item['symbol']
        name = item['name']
        current = item['current']
        chg = item['chg']
        percent = item['percent']
        current_year_percent = item['current_year_percent']
        volume = item['volume']
        amount = item['amount']
        turnover_rate = item['turnover_rate']
        pe_ttm = item['pe_ttm']
        dividend_yield = item['dividend_yield']

        # '股票代码', '股票名称', '当前价', '涨跌额', '涨跌幅', '年初至今', '成交量', '成交额', '换手率', '市盈率(TTM)', '股息率', '市值'
        with open(filepath, mode='a', encoding='utf-8', newline='') as file:
            csv_writer = csv.writer(file)
            csv_writer.writerow(
                [symbol, name, current, chg, percent, current_year_percent, volume, amount, turnover_rate, pe_ttm,
                 dividend_yield, market_capital])

    page += 1


