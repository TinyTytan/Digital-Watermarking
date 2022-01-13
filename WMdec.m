% Data-Hiding/Zero-Bit Decoder
% By Theo Rickman
% University of Sheffield 2022

clear;
waveletType = 'haar';
watermarkingType = 'dataHiding';
% watermarkingType = 'zeroBit';


% % Load watermarked image
[filename,path] = uigetfile('*.jpg');
imgO = imread([path,filename]);

% Conv to double and extract Y part
imgDb = im2double(imgO); % convert to double
img = rgb2ycbcr(imgDb);  % convert to YCbCr
imgY = squeeze(img(:,:,1)); % extract luma part of image (greyscale)

% % decompose Y part of watermarked image using dwt
[LL,HL,LH,HH] = dwt2(imgY,waveletType);
[LL2,HL2,LH2,HH2] = dwt2(LL,waveletType);

% % extract watermark
if strcmp(watermarkingType,'dataHiding')
    f = waitbar(0,"Extracting Watermark");

    HL2ex = dataExtract(HL2); waitbar(1/3);
    LH2ex = dataExtract(LH2); waitbar(2/3);
    HH2ex = dataExtract(HH2); close(f)

    load('watermarkDH.mat'); % for comparison later

elseif strcmp(watermarkingType,'zeroBit')
    load('key.mat');
    f = waitbar(0,"Extracting Watermark");

    HH2ex = keyComp(HH2,key(:,:,1)); waitbar(1/3);
    HL2ex = keyComp(HL2,key(:,:,2)); waitbar(2/3);
    LH2ex = keyComp(LH2,key(:,:,3)); close(f)

    load('watermarkZB.mat'); % for comparison later

else
    disp("Invalid watermarking type selected")
    return
end

% combine extracted watermarks
watermarkEx = mode(cat(3,HL2ex,LH2ex,HH2ex),3);

% % measurements/validation
% compare extracted and original watermark- 1 is ideal

disp(['HH2ex Correctness == ',num2str(hammingf(HH2ex,watermark))])   % compare HH2
disp(['HL2ex Correctness == ',num2str(hammingf(HL2ex,watermark))])   % compare HL2
disp(['LH2ex Correctness == ',num2str(hammingf(LH2ex,watermark))])   % compare LH2
disp(['Extracted Watermark Correctness == ',num2str(hammingf(watermarkEx,watermark))])   % compare extracted watermark