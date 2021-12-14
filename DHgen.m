% Data-Hiding Watermarker
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

% % decompose Y part of image using dwt
[LL,HL,LH,HH] = dwt2(imgY,'haar');
[LL2,HL2,LH2,HH2] = dwt2(LL,'haar');
[LL3,HL3,LH3,HH3] = dwt2(LL2,'haar');

% load watermark and produce data-hidden images
load('watermark.mat');

HL2dh = dataHide(HL2,watermark);
LH2dh = dataHide(LH2,watermark);
HH2dh = dataHide(HH2,watermark);

% % recompose image using idwt
rLL2 = idwt2(LL3,HL3,LH3,HH3,'haar');
rLL = idwt2(rLL2,HL2dh,LH2dh,HH2dh,'haar');
imgReY = idwt2(rLL,HL,LH,HH,'haar');

imgRe = cat(3,imgReY,img(:,:,2:3)); % reinsert Cb & Cr from original image
imgReDb = ycbcr2rgb(imgRe); % convert reconstituted YCbCr image to RGB
imgReO = im2uint8(imgReDb); % convert reconstituted RGB double image to uint8

% % measurements/validation

% compare reconstructed and original images- should all == 1
disp(ssim(rLL2,LL2))        % compare LL2
disp(ssim(rLL,LL))          % compare LL
disp(ssim(imgReY,imgY))     % compare greyscale image
disp(ssim(imgRe,img))       % compare YCbCr image
disp(ssim(imgReDb,imgDb))   % compare RGB image
disp(ssim(imgReO,imgO))     % compare uint8 image

disp(immse(rLL2,LL2))        % compare LL2
disp(immse(rLL,LL))          % compare LL
disp(immse(imgReY,imgY))     % compare greyscale image
disp(immse(imgRe,img))       % compare YCbCr image
disp(immse(imgReDb,imgDb))   % compare RGB image
disp(immse(imgReO,imgO))     % compare uint8 image

% % create tiled image with all orders
% thirdOrderImg = imtile([LL3,HL3;LH3,HH3]);
% secondOrderImg = imtile([thirdOrderImg,HL2;LH2,HH2]);
% firstOrderImg = imtile([secondOrderImg,HL;LH,HH]);

% create tiled image with all orders normalised 
thirdOrderImg = imtile([mat2gray(LL3),mat2gray(HL3);mat2gray(LH3),mat2gray(HH3)]);
secondOrderImg = imtile([thirdOrderImg,mat2gray(HL2);mat2gray(LH2),mat2gray(HH2)]);
firstOrderImg = imtile([secondOrderImg,mat2gray(HL);mat2gray(LH),mat2gray(HH)]);

% % % display first-order components in plot
% t = tiledlayout(2,2);
% colormap gray
% 
% nexttile;
% imagesc(LL)
% title('Approximation (LL)')
% pbaspect(aspectRatio)
% 
% nexttile;
% imagesc(HL)
% title('Horizontal (HL)')
% pbaspect(aspectRatio)
% 
% nexttile;
% imagesc(LH)
% title('Vertical (LH)')
% pbaspect(aspectRatio)
% 
% nexttile;
% imagesc(HH)
% title('Diagonal (HH)')
% pbaspect(aspectRatio)