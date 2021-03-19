% Load the image
img = uint8(imread('cameraman.tif'));

% Gaussian noise
gaussian_noise_img = imnoise(img, 'gaussian', 0.05);

% salt & pepper
sp_noise_img = imnoise(img, 'salt & pepper', 0.075);

% speckle image noise 
speckle_noise_img = imnoise(img, 'speckle');

% Display the original image and the noisy images
figure(1)
sgtitle("Original and noisy images");
subplot(2,2,1)
imshow(img); title({"Original gray scale image"});

subplot(2,2,2)
imshow(gaussian_noise_img); title({"Gaussian noise image"});

subplot(2,2,3)
imshow(sp_noise_img);title({"Salt&Pepper noise image"});

subplot(2,2,4)
imshow(speckle_noise_img); title({"Speckle noise image"});
pause(0.5);

% Get the image size (both noisy images have the same size)
img_size = size(sp_noise_img);

% Set the filter size
filter_size = [5 5];
half = (filter_size-1)/2;

% Create new images (same size as original): one for each filter
sp_mean_filtered_img = uint8(zeros(img_size(1), img_size(2)));
sp_min_filtered_img = uint8(zeros(img_size(1), img_size(2)));
sp_max_filtered_img = uint8(zeros(img_size(1), img_size(2)));
sp_median_filtered_img = uint8(zeros(img_size(1), img_size(2)));

gaussian_mean_filtered_img = uint8(zeros(img_size(1), img_size(2)));
gaussian_min_filtered_img = uint8(zeros(img_size(1), img_size(2)));
gaussian_max_filtered_img = uint8(zeros(img_size(1), img_size(2)));
gaussian_median_filtered_img = uint8(zeros(img_size(1), img_size(2)));

% Apply filters and save the result to the corresponding cells
for row = (half(1)+1):(img_size(1)-half(1))
    for col = (half(2)+1):(img_size(2)-half(2))
        % Define the 5x5 window in the images the filter will be applied to
        window_gaussian_img = gaussian_noise_img(row-half(1):row+half(1), col-half(2):col+half(2));
        window_sp_img = sp_noise_img(row-half(1):row+half(1), col-half(2):col+half(2));
        
        % Assign the mean value to the corresponding cell in the filtered image
        gaussian_mean_filtered_img(row, col) = ((sum(window_gaussian_img, 'all'))/(filter_size(1)*filter_size(2)));
        sp_mean_filtered_img(row, col) = ((sum(window_sp_img, 'all'))/(filter_size(1)*filter_size(2)));
        
        % Assign the min value in the window to the corresponding cell in the filtered image
        gaussian_min_filtered_img(row, col) = min(window_gaussian_img,[],'all');
        sp_min_filtered_img(row, col) = min(window_sp_img, [],'all');
        
        % Assign the max value in the window to the corresponding cell in the filtered image
        gaussian_max_filtered_img(row, col) = max(window_gaussian_img,[],'all');
        sp_max_filtered_img(row, col) = max(window_sp_img, [],'all');
        
        % Median filter
        gaussian_median_filtered_img(row, col) = median(window_gaussian_img, 'all');
        sp_median_filtered_img(row, col) = median(window_sp_img, 'all');
        
    end
end

% Copy edge approach: Replace the missing pixels around the image with the same value as the new edge
% Horisontal
for row = 1:2
        gaussian_mean_filtered_img(row, :) = gaussian_mean_filtered_img(3, :);
        gaussian_min_filtered_img(row, :) = gaussian_min_filtered_img(3, :);
        gaussian_max_filtered_img(row, :) = gaussian_max_filtered_img(3, :);
        gaussian_median_filtered_img(row, :) = gaussian_median_filtered_img(3, :);
        
        sp_mean_filtered_img(row, :) = sp_mean_filtered_img(3, :);
        sp_min_filtered_img(row, :) = sp_min_filtered_img(3, :);
        sp_max_filtered_img(row, :) = sp_max_filtered_img(3, :);
        sp_median_filtered_img(row, :) = sp_median_filtered_img(3, :);
end
for row = (img_size(1)-1):(img_size(1))
    gaussian_mean_filtered_img(row, :) = gaussian_mean_filtered_img(img_size(1)-2, :);
    gaussian_min_filtered_img(row, :) = gaussian_min_filtered_img(img_size(1)-2, :);
    gaussian_max_filtered_img(row, :) = gaussian_max_filtered_img(img_size(1)-2, :);
    gaussian_median_filtered_img(row, :) = gaussian_median_filtered_img(img_size(1)-2, :);
    
    sp_mean_filtered_img(row, :) = sp_mean_filtered_img(img_size(1)-2, :);
    sp_min_filtered_img(row, :) = sp_min_filtered_img(img_size(1)-2, :);
    sp_max_filtered_img(row, :) = sp_max_filtered_img(img_size(1)-2, :);
    sp_median_filtered_img(row, :) = sp_median_filtered_img(img_size(1)-2, :);
end

% Vertical 
for col = 1:2
    gaussian_mean_filtered_img(:, col)  = gaussian_mean_filtered_img(:, 3);
    gaussian_min_filtered_img(:, col)   = gaussian_min_filtered_img(:, 3);
    gaussian_max_filtered_img(:, col)   = gaussian_max_filtered_img(:, 3);
    gaussian_median_filtered_img(:, col)= gaussian_median_filtered_img(:, 3);
    
    sp_mean_filtered_img(:, col)    = sp_mean_filtered_img(:, 3);
    sp_min_filtered_img(:, col)     = sp_min_filtered_img(:, 3);
    sp_max_filtered_img(:, col)     = sp_max_filtered_img(:, 3);
    sp_median_filtered_img(:, col)  = sp_median_filtered_img(:, 3);
end
for col = (img_size(2)-1):(img_size(2))
    gaussian_mean_filtered_img(:, col)  = gaussian_mean_filtered_img(:, (img_size(2)-2));
    gaussian_min_filtered_img(:, col)   = gaussian_min_filtered_img(:, (img_size(2)-2));
    gaussian_max_filtered_img(:, col)   = gaussian_max_filtered_img(:, (img_size(2)-2));
    gaussian_median_filtered_img(:, col)= gaussian_median_filtered_img(:, (img_size(2)-2)); 
    
    sp_mean_filtered_img(:, col)    = sp_mean_filtered_img(:, (img_size(2)-2));
    sp_min_filtered_img(:, col)     = sp_min_filtered_img(:, (img_size(2)-2));
    sp_max_filtered_img(:, col)     = sp_max_filtered_img(:, (img_size(2)-2));
    sp_median_filtered_img(:, col)  = sp_median_filtered_img(:, (img_size(2)-2));
end


% Display results
figure(2)
sgtitle("Denoised images");
set(gcf,'pos',[50 300 1400 400]);

% Gaussian noise
subplot(2,5,1)
imshow(gaussian_noise_img); title({"Gaussian noise: Original image"});

subplot(2,5,2)
imshow(gaussian_min_filtered_img); title({"Gaussian noise: Min filtered"});

subplot(2,5,3)
imshow(gaussian_max_filtered_img); title({"Gaussian noise: Max filtered"});

subplot(2,5,4)
imshow(gaussian_mean_filtered_img); title({"Gaussian noise: Mean filtered"});

subplot(2,5,5)
imshow(gaussian_median_filtered_img); title({"Gaussian noise: Median filtered"});


% Salt and pepper noise
subplot(2,5,6)
imshow(sp_noise_img); title({"Salt & Pepper noise: Original image"});

subplot(2,5,7)
imshow(sp_min_filtered_img); title({"Salt & Pepper noise: Min filtered"});

subplot(2,5,8)
imshow(sp_max_filtered_img); title({"Salt & Pepper noise: Max filtered"});

subplot(2,5,9)
imshow(sp_mean_filtered_img); title({"Salt & Pepper noise: Mean filtered"});

subplot(2,5,10)
imshow(sp_median_filtered_img); title({"Salt & Pepper noise: Median filtered"});
pause(1);
