# render_template: 渲染之前显示的html文件
from flask import Flask, render_template, Response, request
import cv2
import datetime, time
import os, sys
import numpy as np

# 开启新线程
from threading import Thread

global capture, rec_frame, grey, switch, neg, face, rec, out
capture = 0
grey = 0
neg = 0
face = 0
switch = 1
rec = 0

# save picture
try:
    os.mkdir('./shots')
except OSError as error:
    pass

#Load pretrained face detection model    
net = cv2.dnn.readNetFromCaffe('./saved_model/deploy.prototxt.txt', './saved_model/res10_300x300_ssd_iter_140000.caffemodel')

#instatiate flask app  
app = Flask(__name__, template_folder='./templates')

camera = cv2.VideoCapture(0)

# .avi
def record(out):
    global rec_frame
    while(rec):
        time.sleep(0.05)
        out.wirte(rec_frame)