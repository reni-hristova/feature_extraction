% Load image
img = imread("office_4.jpg");
grey_img = rgb2gray(img);
% Create another version of the image to compare derived features
noisy_img = imnoise(grey_img, 'gaussian', 0.3);

% Step 1. Detection: Find corner points using the Harris Corner Detector
cp_grey_img = detectBRISKFeatures(grey_img);
cp_noisy_img = detectBRISKFeatures(noisy_img);

% Step 2. Descrition: Extract the descriptors of each feature
[features_original,points_original] = extractFeatures(noisy_img,cp_noisy_img, 'Method', 'BRISK');
[features_noisy,points_noisy] = extractFeatures(grey_img,cp_grey_img, 'Method', 'BRISK');

% Step 3. Matching: Match the extracted features
matched_indexes = matchFeatures(features_original, features_noisy);

% Visualize the matched points: Mean
matched1 = points_original(matched_indexes(:,1),:);
matched2 = points_noisy(matched_indexes(:,2),:);

figure(2)
ax = axes; 
showMatchedFeatures(grey_img,noisy_img, matched1, matched2,'montage','Parent', ax);
title(ax, 'Feature matching results');
legend(ax, 'Matched points in the original image','Matched points in noisy image');
pause(1);