import pygame
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
image_list = []
for y in range(0, height):
    image_row_list = []
    for x in range(0, width):
        if font_text.get_at((x, y))[0] != 255:
            image_row_list.append(1)
        else:
            image_row_list.append(0)
    image_list.append(image_row_list)

for row in image_list:
    for col in row:
        if col:
            print('1', end='')
        else:
            print(' ', end='')
    print()


from PIL import Image  # 图像处理模块 pip install pillow
import os
import random
image_wall = Image.new('RGB', (width * 100, height * 100), (255, 255, 255))  # mode, size, color=0
for row in range(0, height):
    for col in range(0, width):
        if image_list[row][col]:
            source_image = Image.open('images/' + random.choice(os.listdir(r'images')))
            source_image.resize((100, 100), Image.Resampling.LANCZOS)
            image_wall.paste(source_image, (col * 100, row * 100))

image_wall.save(text + '.jpg')