% Zero-Bit Decoder
% By Theo Rickman
% University of Sheffield 2021

clear;
waveletType = 'haar';

% Load watermarked image
[filename,path] = uigetfile('*.jpg');
imgO = imread([path,filename]);

imgDb = im2double(imgO); % convert to double
img = rgb2ycbcr(imgDb);  % convert to YCbCr
imgY = squeeze(img(:,:,1)); % extract luma part

% % decompose Y part of watermarked image using dwt
[LL,HL,LH,HH]     = dwt2(imgY,waveletType);
[LL2,HL2,LH2,HH2] = dwt2(LL,waveletType);

% extract watermark from watermarked matrices
load('key.mat');
HH2ex = keyComp(HH2,key(:,:,1));
HL2ex = keyComp(HL2,key(:,:,2));
LH2ex = keyComp(LH2,key(:,:,3));
watermarkEx = mode(cat(3,HL2ex,LH2ex,HH2ex),3);

% % measurements/validation
% compare extracted and original watermark- 1 is ideal

load('watermarkZB.mat');
disp(['HH2ex Correctness == ',num2str(hammingf(HH2ex,watermarkZB))])   % compare HH2
disp(['HL2ex Correctness == ',num2str(hammingf(HL2ex,watermarkZB))])   % compare HL2
disp(['LH2ex Correctness == ',num2str(hammingf(LH2ex,watermarkZB))])   % compare LH2
disp(['Extracted Watermark Correctness == ',num2str(hammingf(watermarkEx,watermarkZB))])   % compare extracted watermark
