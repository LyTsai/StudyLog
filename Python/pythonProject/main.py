import requests  # pip install requests
import pprint  # 内置模块，不需要安装
url = 'https://yys.res.netease.com/pc/zt/20170731172708/data/picture/20220520/5/2732x2048.jpg'
response = requests.get(url=url)
print(response)
# json_data = response.json()
# pprint.pprint(json_data)
video_data = requests.get(url=playurl).content  # 二进制数据