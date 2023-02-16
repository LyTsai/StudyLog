from jqdata import *

def initialize(context):
    # 每日运行
    # 基准收益，运行后的红线，和策略进行比较
    set_benchmark('000300.XSHG')
    set_option('use_real_price', True)
    set_order_cost(OrderCost(open_tax=0, close_tax=0.001, open_commission=0.0003, close_commission=0.0003, close_today_commission=0, min_commission=5), type="stock")
    # 股票池
    g.security = get_index_stocks('000300.XSHG')
    # run_daily(方法名, time参数：'before_open'， 'open'， 'after_close')
    run_daily(period, time="every_bar")


def period(context):
    # 先卖后买，假设平均买
    tobuy = []
    for stock in g.security:
        # 默认是开盘价进行交易，也可以自己设置
        p = get_current_data()[stock].day_open
        # portfolio账户信息
        # positions，amount 仓位
        amount = context.portfolio.positions[stock].total_amount
        cost = context.portfolio.positions[stock].avg_cost
        # 股价 <= 10 且不持仓，预计买入
        if p <= 10.0 and amount == 0:
            tobuy.append(stock)
        if amount > 0:
            # 止盈和止损
            if p >= cost * 1.25 or p <= cost * 0.9:
                order_target(stock, 0)
    cash_per_stock = context.portfolio.available_cash / len(tobuy)
    for stock in tobuy:
        order_value(stock, cash_per_stock)
        # 各种买入方式
        # order(stock, 1000)
        # order_value('xx', total_amount)
        # order_target('xx', target_hold)
        # order_target_value('xx', total_amount)
