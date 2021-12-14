% Data-Hiding Decoder
% By Theo Rickman
% University of Sheffield 2021

clear;

% % Load watermarked image
[filename,path] = uigetfile('*.jpg');
imgO = imread([path,filename]);

if strcmp(filename,'sun.jpg') || strcmp(filename,'birds.jpg')
   imgO = rot90(imgO,-1); % otherwise images will be landscape
end

imgDb = im2double(imgO); % convert to double
img = rgb2ycbcr(imgDb);  % convert to YCbCr

aspectRatio = [size(img,2),size(img,1),size(img,3)];

imgY = squeeze(img(:,:,1)); % extract luma part

% % decompose Y part of watermarked image using dwt
[LL,HL,LH,HH] = dwt2(imgY,waveletType);
[LL2,HL2,LH2,HH2] = dwt2(LL,waveletType);
[LL3,HL3,LH3,HH3] = dwt2(LL2,waveletType);

