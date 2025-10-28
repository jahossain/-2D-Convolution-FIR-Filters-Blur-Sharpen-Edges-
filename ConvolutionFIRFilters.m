%% Lab 2: 2D Convolution & FIR Filters (Blur, Sharpen, Edges)
% Course: Mathematical Algorithms (DSP) — Image Processing Labs
% Author: [Your Name]
% Date: [Insert Date]
% -------------------------------------------------------------
% Topics:
%   - FIR filter = convolution with kernel h(m,n)
%   - Low-pass filters (Box, Gaussian)
%   - Sharpening with unsharp masking
%   - Edge detection (Sobel, Laplacian)
%   - Boundary effects and correlation vs convolution
% -------------------------------------------------------------

clear; close all; clc;

%% 0) Load and prepare image
if exist('peppers.png','file')
    I = im2double(rgb2gray(imread('peppers.png')));
else
    I = im2double(imread('cameraman.tif'));
end
figure, imshow(I), title('Original grayscale image');

%% 1) Delta image & impulse response visualization
delta = zeros(101,101);
delta(51,51) = 1;  % single white pixel in the center
h_avg = ones(3,3)/9; % 3x3 average kernel

H = conv2(delta, h_avg, 'same');
figure, imagesc(H), axis image off, colormap gray;
title('Impulse response of 3x3 average filter');

%% 2) Low-pass filters: Box vs Gaussian, separability
h_box3 = ones(3,3)/9;
h_box7 = ones(7,7)/49;
sigma = 1.2;
h_gauss = fspecial('gaussian',[7 7],sigma);

I_box3 = imfilter(I, h_box3, 'replicate');
I_box7 = imfilter(I, h_box7, 'replicate');
I_gauss = imfilter(I, h_gauss, 'replicate');

figure, montage({I, I_box3, I_box7, I_gauss}, 'Size', [1 4]);
title('Low-pass filters: Original | Box 3x3 | Box 7x7 | Gaussian');

%% 3) Unsharp masking (Sharpening)
I_blur = imfilter(I, h_gauss, 'replicate');
mask = I - I_blur;               % high-frequency details
gain = 1.0;
I_sharp = max(min(I + gain*mask, 1.0), 0); % sharpened image

figure, montage({I, I_blur, mask, I_sharp}, 'Size', [1 4]);
title('Unsharp Masking: Original | Blurred | High-frequency Mask | Sharpened');

%% 4) Edge detection: Sobel & Laplacian
h_sobel_x = fspecial('sobel');
h_sobel_y = h_sobel_x';  % transpose for Y direction

Gx = imfilter(I, h_sobel_x, 'replicate');
Gy = imfilter(I, h_sobel_y, 'replicate');
Gmag = hypot(Gx, Gy);  % gradient magnitude

h_lap = fspecial('laplacian', 0.2);
I_lap = imfilter(I, h_lap, 'replicate');

figure, montage({mat2gray(Gx), mat2gray(Gy), mat2gray(Gmag), mat2gray(I_lap)}, 'Size', [1 4]);
title('Edge Detection: Sobel X | Sobel Y | Gradient Magnitude | Laplacian');

%% 5) Correlation vs Convolution (kernel flipping)
C1 = conv2(I, h_box3, 'same');
C2 = imfilter(I, h_box3, 'same');  % imfilter does correlation
diff_val = max(abs(C1(:) - C2(:)));
fprintf('Max difference between conv2 and imfilter: %.6f\n', diff_val);

%% 6) Boundary handling: replicate | symmetric | circular
I_rep = imfilter(I, h_box7, 'replicate');
I_sym = imfilter(I, h_box7, 'symmetric');
I_cir = imfilter(I, h_box7, 'circular');

figure, montage({I_rep, I_sym, I_cir}, 'Size', [1 3]);
title('Boundary modes: replicate | symmetric | circular');

%% 7) Reflection questions (write in report)
% Q1: Why is Gaussian preferred over large box LP?
% Q2: What does separability do for computational cost?
% Q3: How do boundary modes change corners/edges?

disp('--- End of Lab 2 ---');
