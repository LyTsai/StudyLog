import requests
import pprint
import os

url = 'https://img-qn.51miz.com/preview/sound/00/25/75/51miz-S257551-BE28A5AD-thumb.mp3'   #https://www.huya.com/cache.php?m=LiveList&do=getLiveListByPage&gameId=2168&tagAll=0&page=2'
headers = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.5112.101 Safari/537.36'
}
response = requests.get(url=url, headers=headers).content
with open('rain.mp3', mode='wb') as file:
    file.write(response)
# data_list = response['data']['datas']
# for item in data_list:
#     name = item['nick']
#     image_url = item['screenshot']
#     image_content = requests.get(url=image_url, headers=headers).content
#
#     filename = 'img/'
#     if not os.path.exists(filename):
#         os.mkdir(filename)
#     with open(filename + name + '.jpg', mode='wb') as file:
#         file.write(image_content)
