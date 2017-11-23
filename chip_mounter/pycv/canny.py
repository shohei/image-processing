import cv2, matplotlib
import numpy as np
import matplotlib.pyplot as plt

img = cv2.imread('chip.png')
preprocessed  = cv2.cvtColor(cv2.GaussianBlur(img , (7,7), 0), cv2.COLOR_BGR2GRAY)
edges = cv2.Canny(preprocessed, threshold1=90, threshold2=110)
plt.imshow(cv2.cvtColor(edges, cv2.COLOR_GRAY2RGB))
cv2.imwrite('edges.jpg', edges)







