% Data-Hiding Decoder
% By Theo Rickman
% University of Sheffield 2021

% clear;
waveletType = 'haar';

% % Load watermarked image
% [filename,path] = uigetfile('*.jpg');
% imgO = imread([path,filename]);
imgO = imgReO;

imgDb = im2double(imgO); % convert to double
img = rgb2ycbcr(imgDb);  % convert to YCbCr
imgY = squeeze(img(:,:,1)); % extract luma part

% % decompose Y part of watermarked image using dwt
[LL,HL,LH,HH]     = dwt2(imgY,waveletType);
[LL2,HL2,LH2,HH2] = dwt2(LL,waveletType);

% extract watermark from watermarked matrices

HL2ex = dataExtract(HL2);
LH2ex = dataExtract(LH2);
HH2ex = dataExtract(HH2);
watermarkEx = mode(cat(3,HL2ex,LH2ex,HH2ex),3);

% % measurements/validation
% compare extracted and original watermark- 1 is ideal

load('watermark.mat');
disp(['HL2ex Correctness == ',num2str(hammingf(HL2ex,watermark))])   % compare HL2
disp(['LH2ex Correctness == ',num2str(hammingf(LH2ex,watermark))])   % compare LH2
disp(['HH2ex Correctness == ',num2str(hammingf(HH2ex,watermark))])   % compare HH2
