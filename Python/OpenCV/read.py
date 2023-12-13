import cv2 as cv
import numpy as np
import matplotlib.pyplot as plt
import os

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
# cv.imshow('Gray', gray)

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

# translated = translate(img, 100, 100)
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

# grayscale = cv.cvtColor(img, cv.COLOR_RGB2GRAY)

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

# b,g,r = cv.split(img)

# merged = cv.merge([b, g, r])
# cv.imshow('Merged', merged)

# blank = np.zeros(img.shape[:2], dtype="uint8")
# blue = cv.merge([b, blank, blank])
# cv.imshow('Blue', blue)

# average = cv.blur(img, (7, 7))
# cv.imshow('Average Blur', average)

# guassian = cv.GaussianBlur(img, (7, 7), cv.BORDER_DEFAULT)
# cv.imshow('Guassian', guassian)

# meidan = cv.medianBlur(img, 7)
# cv.imshow('Median', meidan)

# def bilateralFilter(src: cv2.typing.MatLike, d: int, sigmaColor: float, sigmaSpace: float, dst: cv2.typing.MatLike | None = ..., borderType: int = ...) -> cv2.typing.MatLike: ...
# bilateral = cv.bilateralFilter(img, 5, 5, 2)
# cv.imshow('Bilateral', bilateral)

blank = np.zeros(img.shape, dtype='uint8')
# rectangle = cv.rectangle(blank.copy(), (20, 20), (380, 380), 255, thickness=-1)
circle = cv.circle(blank.copy(), (1800, 200), 200, (255, 255, 255), -1)

# 交集intersection
# bitwise_and = cv.bitwise_and(rectangle, circle)
# # 并集 union
# bitwise_or = cv.bitwise_or(rectangle, circle)
# # exclusive OR, non-intersection region
# bitwise_xor = cv.bitwise_xor(rectangle, circle)
# bitwise_not = cv.bitwise_not(rectangle)

# cv.imshow('and', bitwise_and)
# cv.imshow('or', bitwise_or)
# cv.imshow('xor', bitwise_xor)
# cv.imshow('not', bitwise_not)

# images, channels, mask, histSize, ranges, hist, accumulate,

mask = np.zeros(img.shape[:2], dtype='uint8')
cv.circle(mask, (1800, 200), 200, 255, -1)
# gray_hist = cv.calcHist([gray], [0],mask, [256], [0, 256])
# plt.figure()
# plt.title('Gray scale Histogram')
# plt.xlabel('Bins')
# plt.ylabel('# of pixels')
# plt.plot(gray_hist)
# plt.xlim([0, 256])

# plt.show()

# masked = cv.bitwise_and(img, img, mask=mask)
# cv.imshow('ma', masked)
# colors = ('b', 'g', 'r')
# for i,col in enumerate(colors):
#     hist = cv.calcHist([img], [i], mask, [256], [0, 256])
#     plt.plot(hist, color=col)
# plt.show()

# ret, thres = cv.threshold(gray, 160, 255, cv.THRESH_BINARY)
# adaptive_threshold = cv.adaptiveThreshold(gray, 255, cv.ADAPTIVE_THRESH_MEAN_C, cv.THRESH_BINARY, 11, 3)

# adaptive_threshold1 = cv.adaptiveThreshold(gray, 255, cv.ADAPTIVE_THRESH_MEAN_C, cv.THRESH_BINARY, 11, 1)

# print(ret)

# cv.imshow('Threshold', adaptive_threshold1)
# cv.imshow('ada', adaptive_threshold)

# lap = cv.Laplacian(gray, cv.CV_64F)
# lap = np.uint8(np.absolute(lap))
# cv.imshow('Laplacian', lap)

# sobelx = cv.Sobel(gray, cv.CV_64F, 1, 0)
# sobely = cv.Sobel(gray, cv.CV_64F, 0, 1)
# combined = cv.bitwise_or(sobelx, sobely)

# cv.imshow('X', sobelx)
# cv.imshow('Y', sobely)
# cv.imshow('Combined', combined)

# haarcascade & local binary patterns (more advanced)
# haar_cascade = cv.CascadeClassifier('haar_face.xml')
# faces_rect = haar_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=4)
# for (x, y, w, h) in faces_rect:
#     cv.rectangle(img, (x, y), (x + w, y + h), (0, 255, 0), 2)
# cv.imshow('Image', img)

# trainFoloderPath/name1/xxx.jpg
# /Users/lydiretsai/Pictures/yys/
people = ['Satomi', 'Jennifer']
DIR = r'/Users/lydiretsai/Pictures/people'

features = []
labels = []

def is_valid_iamge(filepath):
    try:
        image = cv.imread(filepath)
        if image is not None and len(image.shape) == 3:
            return True
        else:
            return False
    except Exception as e:
        print(f'Error occured while reading the file: {filepath}, {str(e)}')
        return False

def create_train():
    for person in people:
        path = os.path.join(DIR, person)
        label = people.index(person)

        for filename in os.listdir(path):
            # some maybe not img (.DS_Store), check first
            img_path = os.path.join(path, filename)

            if is_valid_iamge(img_path):
                img = cv.imread(img_path)
                gray = cv.cvtColor(img, cv.COLOR_RGB2GRAY)

                haar_cascade = cv.CascadeClassifier('haar_face.xml')
                faces_rect = haar_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5)

                for (x, y, w, h) in faces_rect:
                    faces_roi = gray[y: y+h, x:x+w]
                    # cv.rectangle(img, (x, y), (x + w, y + h), (0, 255, 0), 2)

                    features.append(faces_roi)
                    labels.append(label)
create_train()

print(f'length of the features = { len(features)}')

features = np.array(features, dtype='object')
labels = np.array(labels)

face_recognizer = cv.face.LBPHFaceRecognizer_create()
# train the recognizer
face_recognizer.train(features, labels)

face_recognizer.save('face_trained.yml')
np.save('features.npy', features)
np.save('labels.npy', labels)