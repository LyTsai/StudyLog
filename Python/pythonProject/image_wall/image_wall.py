import pygame
from PIL import Image  # 图像处理模块 pip install pillow

import os
import random

pygame.init()  # 模块初始化

text = '520'
font_size = 30

# <pygame.font.Font object at 0x1055d8bd0>
font = pygame.font.Font('SF-UI-Text-Bold.otf', font_size)  # SF-UI-Text-Bold.otf
# True：锯齿化, color, background
font_text = font.render(text, True, (0, 0, 0), (255, 255, 255))

# get_size()
width = font_text.get_width()
height = font_text.get_height()

# 获得指定像素点的颜色
scale_size = 100
image_wall = Image.new('RGB', (width * scale_size, height * scale_size), (255, 255, 255))  # mode, size, color=0

for y in range(0, height):
    for x in range(0, width):
        if font_text.get_at((x, y))[0] != 255:
            source_image = Image.open('images/' + random.choice(os.listdir(r'images')))
            source_image = source_image.resize((scale_size, scale_size), Image.Resampling.LANCZOS)
            image_wall.paste(source_image, (x * scale_size, y * scale_size))

print('adding....')
image_wall.save(text + '.jpg')
print('Add finished.')