% Data-Hiding/Zero-Bit Watermarker
% By Theo Rickman
% University of Sheffield 2021

clear;
waveletType = 'haar';
watermarkingType = 'dataHiding';
% watermarkingType = 'zeroBit';


% % Load image
[filename,path] = uigetfile('*.jpg');
imgO = imread([path,filename]);

% Conv to double and extract Y part
img = rgb2ycbcr(im2double(imgO));  % convert to double then YCbCr
imgY = squeeze(img(:,:,1)); % extract luma part of image (greyscale)

% % decompose Y part of image using dwt
[LL,HL,LH,HH] = dwt2(imgY,waveletType);
[LL2,HL2,LH2,HH2] = dwt2(LL,waveletType);

% % load watermark and execute relevant watermarking function
if strcmp(watermarkingType,'dataHiding')
    load('watermarkDH.mat');
    f = waitbar(0,"Inserting Watermarks");

    HL2dh = dataHide(HL2,watermark); waitbar(1/3);
    LH2dh = dataHide(LH2,watermark); waitbar(2/3);
    HH2dh = dataHide(HH2,watermark); close(f)
    
    % recompose image using idwt
    rLL = idwt2(LL2,HL2dh,LH2dh,HH2dh,waveletType);
    imgReY = idwt2(rLL,HL,LH,HH,waveletType);

    imgRe = cat(3,imgReY,img(:,:,2:3)); % reinsert Cb & Cr from original image
    imgReO = im2uint8(ycbcr2rgb(imgRe)); % convert reconstituted YCbCr image to RGB, then to uint8

elseif strcmp(watermarkingType,'zeroBit')
    load('watermarkZB.mat');
    f = waitbar(0,"Inserting Watermarks");

    HLkey = keyGen(HL2,watermark); waitbar(1/3);
    LHkey = keyGen(LH2,watermark); waitbar(2/3);
    HHkey = keyGen(HH2,watermark); close(f)
    
    key = cat(3,HHkey,HLkey,LHkey);
    save('key.mat','key');

    % no need to recompose image as it has not been modified

else
    disp("Invalid watermarking type selected")
    return
end