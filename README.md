# im2circles

Takes an image, finds the edges of the grayscale RGB images, then fills in the edge map with circles to recreate the image.

TODO:
 - Add the ability to choose custom colors (CMYK, pop art, etc.)
 - Add comments for readability
 - Optimize circle generation (would like to vectorize if possible)
 - Turn script into MATLAB Live code (sliders for image smoothing, edge detection sensitivity, final circle size, etc.)
 - Make it so final circle size for each color is the same size (currently just creates the same number of circles for each color)
