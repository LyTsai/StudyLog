# 导入函数库
from jqdata import *

# 初始化函数，设定基准等等
def initialize(context):
    # 设定沪深300作为基准
    set_benchmark('000300.XSHG')
    set_option('use_real_price', True)
    set_order_cost(OrderCost(close_tax=0.001, open_commission=0.0003, close_commission=0.0003, min_commission=5), type='stock')

    ## 运行函数（reference_security为运行时间的参考标的；传入的标的只做种类区分，因此传入'000300.XSHG'或'510300.XSHG'是一样的）
      # 开盘前运行
    run_daily(before_market_open, time='before_open', reference_security='000300.XSHG')
      # 开盘时运行
    run_daily(market_open, time='open', reference_security='000300.XSHG')
      # 收盘后运行
    run_daily(after_market_close, time='after_close', reference_security='000300.XSHG')

## 开盘前运行函数
def before_market_open(context):
    # 输出运行时间
    # log.info('函数运行时间(before_market_open)：'+str(context.current_dt.time()))
    # 给微信发送消息（添加模拟交易，并绑定微信生效）
    send_message('美好的一天~')

    # 要操作的股票：平安银行（g.为全局变量）
    g.security = '600809.XSHG'

## 开盘时运行函数
def market_open(context):
    '''
        粗略的收益测试：
        20日均线和5比较 > 10日均线和5比较 > 价格高出五天平均价1%
        卖出加上current_price < MA5收益更高
        
        还需要考虑到其他因素，有时候10日》 
        
    '''
    # log.info('函数运行时间(market_open):'+str(context.current_dt.time()))
    security = g.security
    # close_data = attribute_history(security, 20)
    close_data = get_bars(security, count=20, unit='1d', fields=['close'])
    MA5 = close_data['close'][-5:].mean()
    MA10 = close_data['close'][-10:].mean()
    # MA20 = close_data['close'][-20:].mean()
    cash = context.portfolio.available_cash
    
    current_price = close_data['close'][-1]
    # MA5 上穿MA10，金叉，买入
    # 如果上一时间点价格高出五天平均价1%, 则全仓买入
    if (MA10 > MA5) and (cash > 0):
        # 记录这次买入
        log.info("MA5上穿MA10，金叉, 买入 %s" % (security))
        # 用所有 cash 买入股票
        order_value(security, cash)
    # 如果上一时间点价格低于五天平均价, 则空仓卖出
    elif MA10 < MA5 and context.portfolio.positions[security].closeable_amount > 0:
        # 记录这次卖出
        log.info("死叉, 卖出 %s" % (security))
        # 卖出所有股票,使这只股票的最终持有量为0
        order_target(security, 0)
    # 取得上一时间点价格
    # 
    #     # 如果上一时间点价格高出五天平均价1%, 则全仓买入
    # if (current_price > MA5 * 1.01) and (cash > 0):
    #     # 记录这次买入
    #     log.info("价格高于均价 1%%, 买入 %s" % (security))
    #     # 用所有 cash 买入股票
    #     order_value(security, cash)
    # # 如果上一时间点价格低于五天平均价, 则空仓卖出
    # elif current_price < MA5 and context.portfolio.positions[security].closeable_amount > 0:
    #     # 记录这次卖出
    #     log.info("价格低于均价, 卖出 %s" % (security))
    #     # 卖出所有股票,使这只股票的最终持有量为0
    #     order_target(security, 0)

## 收盘后运行函数
def after_market_close(context):
    log.info(str('函数运行时间(after_market_close):'+str(context.current_dt.time())))
    #得到当天所有成交记录
    trades = get_trades()
    for _trade in trades.values():
        log.info('成交记录：'+str(_trade))
    log.info('一天结束')
    log.info('##############################################################')
