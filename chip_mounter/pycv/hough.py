import cv2, matplotlib
import numpy as np
import matplotlib.pyplot as plt

img = cv2.imread('chip.png')
preprocessed  = cv2.cvtColor(cv2.GaussianBlur(img , (7,7), 0), cv2.COLOR_BGR2GRAY)
cups_edges = cv2.Canny(preprocessed, threshold1=90, threshold2=110)
# plt.imshow(cv2.cvtColor(edges, cv2.COLOR_GRAY2RGB))
# cv2.imwrite('edges.jpg', edges)
# plt.imshow(cv2.cvtColor(cups_edges, cv2.COLOR_GRAY2RGB))
# cv2.imwrite('edges.jpg', cups_edges)


# copy of image to draw lines
cups_lines = np.copy(img)
 
# find hough lines
num_pix_threshold = 110 # minimum number of pixels that must be on a line
lines = cv2.HoughLines(cups_edges, 1, np.pi/180, num_pix_threshold)
 
for rho, theta in lines[0]:
    # convert line equation into start and end points of line
    a = np.cos(theta)
    b = np.sin(theta)
    x0 = a * rho
    y0 = b * rho
 
    x1 = int(x0 + 1000*(-b))
    y1 = int(y0 + 1000*(a))
 
    x2 = int(x0 - 1000*(-b))
    y2 = int(y0 - 1000*(a))
 
    cv2.line(cups_lines, (x1,y1), (x2,y2), (0,0,255), 1)

plt.imshow(cv2.cvtColor(cups_lines, cv2.COLOR_BGR2RGB))
cv2.imwrite('edges_line.jpg', cups_lines)
