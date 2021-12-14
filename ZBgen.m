% Zero-Bit Watermarker
% By Theo Rickman
% University of Sheffield 2021

clear;

% % Load image
[filename,path] = uigetfile('*.jpg');
imgO = imread([path,filename]);

if strcmp(filename,'sun.jpg') || strcmp(filename,'birds.jpg')
   imgO = rot90(imgO,-1); % otherwise images will be landscape
end

imgDb = im2double(imgO); % convert to double
img = rgb2ycbcr(imgDb);  % convert to YCbCr

aspectRatio = [size(img,2),size(img,1),size(img,3)];

% image(img)
% pbaspect(aspectRatio)

imgY = squeeze(img(:,:,1)); % extract luma part of image (greyscale)

% decompose Y part of image using dwt
[LL,HL,LH,HH] = dwt2(imgY,'haar');
[LL2,HL2,LH2,HH2] = dwt2(LL,'haar');
[LL3,HL3,LH3,HH3] = dwt2(LL2,'haar');

load('watermarkZB.mat');
HLkey = keyGen(HL2,watermark);
LHkey = keyGen(LH2,watermark);
HHkey = keyGen(HH2,watermark);

% recompose image using idwt
rLL2 = idwt2(LL3,HL3,LH3,HH3,'haar');
rLL = idwt2(rLL2,HL2,LH2,HH2,'haar');
imgYRe = idwt2(rLL,HL,LH,HH,'haar');

imgRe = cat(3,imgYRe,img(:,:,2:3)); % reinsert Cb & Cr from original image

imgReRGB = ycbcr2rgb(imgRe); % convert reconstituted image back to RGB

% measurements/validation
ssim(rLL2,LL2)
ssim(rLL,LL)
ssim(imgYRe,imgY)
ssim(imgRe,img)

imgRGB = rot90(im2double(imread([path,filename])),-1);
ssim(imgReRGB,imgRGB)

% % create tiled image with all orders
% thirdOrderImg = imtile([LL3,HL3;LH3,HH3]);
% secondOrderImg = imtile([thirdOrderImg,HL2;LH2,HH2]);
% firstOrderImg = imtile([secondOrderImg,HL;LH,HH]);

% create tiled image with all orders normalised 
thirdOrderImg = imtile([mat2gray(LL3),mat2gray(HL3);mat2gray(LH3),mat2gray(HH3)]);
secondOrderImg = imtile([thirdOrderImg,mat2gray(HL2);mat2gray(LH2),mat2gray(HH2)]);
firstOrderImg = imtile([secondOrderImg,mat2gray(HL);mat2gray(LH),mat2gray(HH)]);

% display first-order components in plot
t = tiledlayout(2,2);
colormap gray

nexttile;
imagesc(LL)
title('Approximation (LL)')
pbaspect(aspectRatio)

nexttile;
imagesc(HL)
title('Horizontal (HL)')
pbaspect(aspectRatio)

nexttile;
imagesc(LH)
title('Vertical (LH)')
pbaspect(aspectRatio)

nexttile;
imagesc(HH)
title('Diagonal (HH)')
pbaspect(aspectRatio)