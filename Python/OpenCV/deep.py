import os
import caer
import canaro
import cv2 as cv
import gc
import matplotlib.pyplot as plt
from tensorflow.python.keras.utils import to_categorical

IMG_SIZE = [80, 80]
channels = 1
char_path = r'/kaggle/input/the-simpsons-characters-dataset'

char_dict = {}
for char in os.listdir(char_path):
    char_dict[char] = len(os.listdir(os.path.join(char_path, char)))
# sort to list in descending order
# [(filename, numberOfPhotos)]
char_dict = caer.sort_dict(char_dict, descending=True)

characters = []
count = 0
for i in char_dict:
    characters.append(i[0])
    count += 1
    if count >= 10:
        break

# train, get index - name
train = caer.preprocess_from_dir(char_path, characters, channels=channels, IMG_SIZE=IMG_SIZE, isShuffle=True)
len(train)
# opencv不会在jupyter里display
plt.figure(figsize=(80, 80))
plt.imshow(train[0][0], cmap='gray')
plt.show()

featureSet, labels = caer.sep_train(train, IMG_SIZE=IMG_SIZE)
# 0-1, faster
featureSet = caer.normalize(featureSet)
labels = to_categorical(labels, len(characters))

x_train, x_val, y_train, y_val = caer.train_val_split(featureSet, labels, val_ratio=.2)

del train
del featureSet
del labels
gc.collect()

BATCH_SIZE = 32
EPOCHS = 10

# image data generator
datagen = canaro.generators.imageDataGenerator()
train_gen = datagen
# flow(x_train, y_train, batch_size)