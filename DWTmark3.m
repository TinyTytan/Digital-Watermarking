% Data-Hiding/Zero-Bit Watermarker/Decoder
% By Theo Rickman
% University of Sheffield 2022

% clear;
waveletType = 'haar';


watermarkingType = questdlg("Zero-Bit or Data-Hiding?","Watermarking Type","Zero-Bit","Data-Hiding","Zero-Bit");
operation = questdlg("Embed or extract watermark?","Operation","Embed","Extract","Embed");

% % Load image
% [filename,path] = uigetfile('*.jpg');
% imgO = imread([path,filename]);

% Conv to double and extract Y part
img = rgb2ycbcr(im2double(imgO));  % convert to double then YCbCr
img = squeeze(img(:,:,1)); % extract luma part of image (greyscale)

% % decompose Y part of image using dwt
[LL,HL,LH,HH] = dwt2(img,waveletType);
[LL2,HL2,LH2,HH2] = dwt2(LL,waveletType);
[LL3,HL3,LH3,HH3] = dwt2(LL2,waveletType);

if strcmp(operation,'Embed')
    % % load watermark and execute relevant watermarking function
    if strcmp(watermarkingType,'Data-Hiding')
%         load('watermarkDH.mat');
        f = waitbar(0,"Inserting Watermarks");
    
        HL3dh = dataHide(HL3,watermark); waitbar(1/3);
        LH3dh = dataHide(LH3,watermark); waitbar(2/3);
        HH3dh = dataHide(HH3,watermark); close(f)
        
        % recompose image using idwt
        rLL2 = idwt2(LL3,HL3dh,LH3dh,HH3dh,waveletType);
        rLL = idwt2(rLL2,HL2,LH2,HH2,waveletType);
        imgReY = idwt2(rLL,HL,LH,HH,waveletType);
    
        imgRe = cat(3,imgReY,imgO(:,:,2:3)); % reinsert Cb & Cr from original image
        imgReO = im2uint8(ycbcr2rgb(imgRe)); % convert reconstituted YCbCr image to RGB, then to uint8
    
    elseif strcmp(watermarkingType,'Zero-Bit')
        load('watermarkZB.mat');
        f = waitbar(0,"Inserting Watermarks");
    
        HLkey = keyGen(HL2,watermark); waitbar(1/3);
        LHkey = keyGen(LH2,watermark); waitbar(2/3);
        HHkey = keyGen(HH2,watermark); close(f)
        
        key = cat(3,HHkey,HLkey,LHkey);
        save('key.mat','key');
    
        % no need to recompose image as it has not been modified
    end
elseif strcmp(operation,'Extract')
    % % extract watermark
    if strcmp(watermarkingType,'Data-Hiding')
        f = waitbar(0,"Extracting Watermark");
    
        HL3ex = dataExtract(HL3); waitbar(1/3);
        LH3ex = dataExtract(LH3); waitbar(2/3);
        HH3ex = dataExtract(HH3); close(f)
    
%         load('watermarkDH.mat'); % for comparison later
    
    elseif strcmp(watermarkingType,'Zero-Bit')
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
    watermarkEx = mode(cat(3,HL3ex,LH3ex,HH3ex),3);
    
    % % measurements/validation
    % compare extracted and original watermark- 1 is ideal
    
    disp(['HH2ex Correctness == ',num2str(hammingf(HH3ex,watermark))])   % compare HH2
    disp(['HL2ex Correctness == ',num2str(hammingf(HL3ex,watermark))])   % compare HL2
    disp(['LH2ex Correctness == ',num2str(hammingf(LH3ex,watermark))])   % compare LH2
    disp(['Extracted Watermark Correctness == ',num2str(hammingf(watermarkEx,watermark))])   % compare extracted watermark
end