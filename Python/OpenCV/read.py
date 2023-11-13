import cv2 as cv
import numpy as np
import matplotlib.pyplot as plt

def rescaleFrame(frame, scale=0.75):
    width = int(frame.shape[1] * scale)
    height = int(frame.shape[0] * scale)
    dimensions = (width, height)

    return cv.resize(frame, dimensions, interpolation=cv.INTER_AREA)

def translate(img, x, y):
    transMat = np.float32([[1, 0, x], [0, 1, y]])
    dimensions = (img.shape[1] + x, img.shape[0] + y)

    return cv.warpAffine(img, transMat, dimensions)

def rotate(img, angle, center=None):
    (height, width) = img.shape[:2]
    if center is None:
        center = (width // 2, height // 2)
    rotateMat = cv.getRotationMatrix2D(center, angle, 1.0) # not scale
    dimensions = (width, height)

    return cv.warpAffine(img, rotateMat, dimensions)

# def changeRes(width, height):
#     capture.set(3, width)
#     capture.set(4, height)

# read image by file path
img = cv.imread('Photos/三贵子.jpg')
# # show on monitor, if the image's size is large than minotor, some part will be off the screen
# cv.imshow('Img', img)
# cv.imshow('resized', rescaleFrame(img))
# # or xxms
# cv.waitKey(0)

# read video
# numbers or file path
# for 0, your camera, identify other cameras by number
# capture = cv.VideoCapture('xxx/xx.mp4')
# capture = cv.VideoCapture(0)

# while True:
#     isTrue, frame = capture.read()
#     cv.imshow('Video', frame)
#     cv.imshow('resized', rescaleFrame(frame))

#     if cv.waitKey(20) & 0xFF==ord('d'):
#         break
# capture.release()
# cv.destroyAllWindows()

# height, width, image type
# blank = np.zeros((500, 500), dtype='uint8')
# img = cv.imshow('Blank', blank)
# cv.waitKey(0)

# blank = np.zeros((501, 500, 3), dtype='uint8')
# blank[200:300, 300:600] = 0, 0, 255
# cv.rectangle(blank, (0, 0), (blank.shape[1] // 2, blank.shape[0] //2), (0, 255, 0), thickness=2)
# cv.imshow('Rectangle', blank)

# cv.line(blank, (250, 250), (400, 600), (0, 0, 255), thickness=-1)
# cv.imshow('Circle', blank)

# cv.putText(blank, 'Hello Worldg', (0, 20), cv.FONT_HERSHEY_TRIPLEX, 1.0, (0, 255, 0), 1)
# cv.imshow('Text', blank)
# cv.waitKey(0)

gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
cv.imshow('Gray', gray)

# blur = cv.GaussianBlur(img, (5, 5), cv.BORDER_DEFAULT)
# cv.imshow('Blur', blur)

# threshold1, threshold2
# canny = cv.Canny(img, 125, 175)
# cv.imshow('Canny Edge', canny)

# dilated = cv.dilate(canny, (3, 3), iterations=2)
# cv.imshow('Dilate', dilated)

# eroded = cv.erode(dilated, (3, 3), iterations=2)
# cv.imshow('Eroded', eroded)

# ignoring the aspect ratio

# resize = cv.resize(img, (3500, 3500))
# cv.imshow('Resize', resize)

# resize = cv.resize(img, (3500, 3500), interpolation=cv.INTER_AREA)
# cv.imshow('area', resize)

# resize = cv.resize(img, (3500, 3500), interpolation=cv.INTER_LINEAR)
# cv.imshow('linear', resize)

# slowest, but high quality
# resize = cv.resize(img, (3500, 3500), interpolation=cv.INTER_CUBIC)
# cv.imshow('cubic', resize)

# height, width
# cropped = img[0:600, 1700:2700]
# cv.imshow('Cropped', cropped)

translated = translate(img, 100, 100)
# cv.imshow('Img', img)
# cv.imshow('Translated', translated)

# anticlockwise, use degree
# rotated = rotate(img, 45)
# cv.imshow('Roated', rotated)
# rotated_roated = rotate(rotated, 45)
# cv.imshow('Roated1', rotated_roated)

# flipCode, 0: vertical, 1: horizontal, -1: both
# flip = cv.flip(img, 0)
# cv.imshow('Flip', flip)

grayscale = cv.cvtColor(img, cv.COLOR_RGB2GRAY)

# blur = cv.GaussianBlur(grayscale, (3, 3), cv.BORDER_DEFAULT)
# canny = cv.Canny(blur, 125, 175)

# 二值化threshold, 单通道灰色图像, thresh, maxval > 125, set to 255
# ret, thresh = cv.threshold(grayscale, 125, 255, cv.THRESH_BINARY)
# cv.imshow('img', img)
# cv.imshow('image',thresh)
# img, RETR_EXTERNAL 只检测最外围的轮廓。 RETR_LIST 检测所有轮廓,不建立等级关系,彼此独立。RETR_CCOMP， 图片可为32位，检测所有轮廓,但所有轮廓都只建立两个等级关系。RETR_TREE 检测所有轮廓，并且所有轮廓建立一个树结构,层次完整。RETR_FLOODFILL 图片可为32位，洪水填充法。
# contours, hierarchies = cv.findContours(thresh, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_NONE)
# print(f'{ len(contours) } contour(s) found!')

# blank = np.zeros(img.shape, dtype="uint8")
# cv.drawContours(blank, contours, -1, (0, 0, 255), 2)
# cv.imshow('Blank', blank)

# rgbImage = cv.cvtColor(img, cv.COLOR_BGR2RGB)
# plt.imshow(rgbImage)
# plt.show()

b,g,r = cv.split(img)

merged = cv.merge([b, g, r])
cv.imshow('Merged', merged)

blank = np.zeros(img.shape[:2], dtype="uint8")
blue = cv.merge([b, blank, blank])
cv.imshow('Blue', blue)

cv.waitKey(0)