# Stem-Cell-Image-Classification
An unsupervised algorithm for classifying stem cells into 2 classes: Non-Mitotic(single cells) and Mitotic(cells that are in the process of division).
Dataset contains 24 images: 12 of Non-mitotic and 12 of Mitotic.
Steps: Compress each image using 2D wavelets. Calculate the normalized compression distance between each image pair. Convert this affinity matrix into spectral representation using symmetric divisive normalization. Find the 2 largest eigenvectors of the resulting matrix and use K-means clustering to classify into 2 groups.
Used Matlab. 
