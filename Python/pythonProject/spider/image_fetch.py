import requests  # pip install requests
import re
import pprint  # 内置模块，不需要安装
url = 'https://yys.163.com/media/picture.html'

# 把Python代码进行伪装，伪装成浏览器对服务器发送请求。User-Agent
headers = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.2 Safari/605.1.15'
}
response = requests.get(url=url, headers=headers)   # <Response [200]>
html_data = re.findall('<a href="(.*?)"', response.text)
images = []
for pic in html_data:
    if 'jpg' in pic:
        images.append(pic)
images = str(images)
with open('yys.text', mode='w') as yys_image:
    yys_image.write(images)