import easytrader # 基于Windows平台

#  国金客户端
user = easytrader.use('gj_client')
user.prepare(user='', password='')

# 自己状况
balance = user.balance

# 持仓状况
position = user.position

# 交易
trade_buy = user.buy('162411', price=0.5, amount=100)

trade_sell = user.sell('162411', price=0.2, amount=100)

user.auto_ipo()

user.cancel_entrust(trade_buy['entrust_no'])

user.adjust_weight('162411', 0)