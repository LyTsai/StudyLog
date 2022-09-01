import requests
import pprint

url = 'https://www.huya.com/cache.php?m=LiveList&do=getLiveListByPage&gameId=2168&tagAll=0&page=2'
headers = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.5112.101 Safari/537.36'
}
response = requests.get(url=url, headers=headers).json()
data_list = response['data']['datas']
for item in data_list:
    name = item['nick']
    image_url = item['screenshot']
    image_content = requests.get(url=image_url, headers=headers).content
    print(item)