% Data-Hiding Decoder
% By Theo Rickman
% University of Sheffield 2021

% clear;
waveletType = 'haar';

% % Load watermarked image
% [filename,path] = uigetfile('*.jpg');
% imgO = imread([path,filename]);
imgO = imgReO;

% if strcmp(filename,'sun.jpg') || strcmp(filename,'birds.jpg')
%     imgO = rot90(imgO,-1); % otherwise images will be landscape
% end

imgDb = im2double(imgO); % convert to double
img = rgb2ycbcr(imgDb);  % convert to YCbCr

aspectRatio = [size(img,2),size(img,1),size(img,3)];

imgY = squeeze(img(:,:,1)); % extract luma part

% % decompose Y part of watermarked image using dwt
[LL,HL,LH,HH]     = dwt2(imgY,waveletType);
[LL2,HL2,LH2,HH2] = dwt2(LL,waveletType);

% extract watermark from watermarked matrices
% conv to double for ssim/immse analysis

HL2ex = double(dataExtract(HL2));
LH2ex = double(dataExtract(LH2));
HH2ex = double(dataExtract(HH2));

% % measurements/validation

load('watermark.mat');
watermark = double(watermark);
% compare extracted and original watermark- ssim should = 1 and immse = 0

disp(['ssim(HL2ex,watermark)    == ',num2str(ssim(HL2ex,watermark))])   % compare HL2
disp(['ssim(LH2ex,watermark)    == ',num2str(ssim(LH2ex,watermark))])   % compare LH2
disp(['ssim(HH2ex,watermark)    == ',num2str(ssim(HH2ex,watermark))])   % compare HH2
disp(newline) 
disp(['immse(HL2ex,watermark)   == ',num2str(immse(HL2ex,watermark))])  % compare HL2
disp(['immse(LH2ex,watermark)   == ',num2str(immse(LH2ex,watermark))])  % compare LH2
disp(['immse(HH2ex,watermark)   == ',num2str(immse(HH2ex,watermark))])  % compare HH2
