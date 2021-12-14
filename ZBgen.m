% Zero-Bit Watermarker
% By Theo Rickman
% University of Sheffield 2021

clear;
waveletType = 'haar';

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
[LL,HL,LH,HH] = dwt2(imgY,waveletType);
[LL2,HL2,LH2,HH2] = dwt2(LL,waveletType);
[LL3,HL3,LH3,HH3] = dwt2(LL2,waveletType);

% load watermark and produce keys
load('watermarkZB.mat');

HLkey = keyGen(HL2,watermarkZB);
LHkey = keyGen(LH2,watermarkZB);
HHkey = keyGen(HH2,watermarkZB);

% % recompose image using idwt
rLL2 = idwt2(LL3,HL3,LH3,HH3,waveletType);
rLL = idwt2(rLL2,HL2,LH2,HH2,waveletType);
imgReY = idwt2(rLL,HL,LH,HH,waveletType);

imgRe = cat(3,imgReY,img(:,:,2:3)); % reinsert Cb & Cr from original image
imgReDb = ycbcr2rgb(imgRe); % convert reconstituted YCbCr image to RGB
imgReO = im2uint8(imgReDb); % convert reconstituted RGB double image to uint8

% % measurements/validation

% compare reconstructed and original images- should all == 1
disp(['ssim(rLL2,LL2) == ',num2str(ssim(rLL2,LL2))])            % compare LL2
disp(['ssim(rLL,LL) == ',num2str(ssim(rLL,LL))])                % compare LL
disp(['ssim(imgReY,imgY) == ',num2str(ssim(imgReY,imgY))])      % compare greyscale image
disp(['ssim(imgRe,img) == ',num2str(ssim(imgRe,img))])          % compare YCbCr image
disp(['ssim(imgReDb,imgDb) == ',num2str(ssim(imgReDb,imgDb))])  % compare RGB image
disp(['ssim(imgReO,imgO) == ',num2str(ssim(imgReO,imgO))])      % compare uint8 image

disp(['immse(rLL2,LL2) == ',num2str(immse(rLL2,LL2))])            % compare LL2
disp(['immse(rLL,LL) == ',num2str(immse(rLL,LL))])                % compare LL
disp(['immse(imgReY,imgY) == ',num2str(immse(imgReY,imgY))])      % compare greyscale image
disp(['immse(imgRe,img) == ',num2str(immse(imgRe,img))])          % compare YCbCr image
disp(['immse(imgReDb,imgDb) == ',num2str(immse(imgReDb,imgDb))])  % compare RGB image
disp(['immse(imgReO,imgO) == ',num2str(immse(imgReO,imgO))])      % compare uint8 image

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