import numpy as np
import cv2 as cv

haar_cascade = cv.CascadeClassifier('haar_face.xml')

people = ['Satomi', 'Jennifer']
features = np.load('features.npy', allow_pickle=True)
labels = np.load('labels.npy')

face_recognizer = cv.face.LBPHFaceRecognizer_create()
face_recognizer.read('face_trained.yml')

img = cv.imread(r'/Users/lydiretsai/Pictures/people/Satomi/2fdda3cc7cd98d10f6e5b92f223fb80e7bec90ff.jpeg')
gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
cv.imshow('Gray', gray)

faces_rect = haar_cascade.detectMultiScale(gray, 1.1, 5)
for (x, y, w, h) in faces_rect:
    faces_roi = gray[y: y+h, x: x+w]

    # confidence can be > 100
    label, confidence = face_recognizer.predict(faces_roi)
    print(f'label = { people[label] } with a confidence of {confidence}')
    cv.putText(img, str(people[label]), (20, 20), cv.FONT_HERSHEY_COMPLEX, 1.0, (0, 255, 0), thickness=2)
    cv.rectangle(img, (x, y), (x+w, y+h), (0, 255, 0), thickness=2)

cv.imshow('Detected', img)

cv.waitKey(0)