# histogram normalization
# From Feature Extraction and Image Processing, Aguado, Nixon, pg 74
# Translated from MATLAB
import cv2 as cv
import numpy as np

img = cv.imread("image.jpg",cv.CV_LOAD_IMAGE_GRAYSCALE)
# display image
cv.imshow('image',img);
# get sizes
[rows, cols] = np.shape(img)

normalized = [[0 for x in range(rows)] for x in range(cols)]

# print image sizes
print np.shape(normalized), np.shape(img)
# set minimum
minim = np.min(np.min(img))
# work out range of input levels
rangeIM =  np.max(np.max(img))-minim 
print minim, rangeIM

# normalize the image
for x in range(1,cols):
    for y in range(1,rows):
        normalized[x][y] = np.floor((img[x ][y] - minim)*255/rangeIM)


h = np.flipud(normalized)
cv.imshow('normalized',h)
cv.waitKey(0)
