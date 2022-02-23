% Data-Hiding/Zero-Bit Watermarker/Decoder
% By Theo Rickman
% University of Sheffield 2022

clear;
waveletType = 'haar';


watermarkingType = questdlg("Zero-Bit or Data-Hiding?","Watermarking Type","Zero-Bit","Data-Hiding","Zero-Bit");
operation = questdlg("Embed or extract watermark?","Operation","Embed","Extract","Embed");

% % Load image
[filename,path] = uigetfile('*.jpg');
[path,filename,ext] = fileparts([path,filename]);
img = imread(strcat(path,"\",filename,ext));

% Conv to double and extract Y part
img = rgb2ycbcr(im2double(img));  % convert to double then YCbCr
imgY = squeeze(img(:,:,1)); % extract luma part of image (greyscale)

% % decompose Y part of image using dwt
[LL,HL,LH,HH] = dwt2(imgY,waveletType);
[LL2,HL2,LH2,HH2] = dwt2(LL,waveletType);

if strcmp(operation,'Embed')
    % % load watermark and execute relevant watermarking function
    if strcmp(watermarkingType,'Data-Hiding')
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
        imwrite(imgReO,strcat(filename,"_DH",ext),"Quality",100);
    
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
    
        HL2ex = dataExtract(HL2); waitbar(1/3);
        LH2ex = dataExtract(LH2); waitbar(2/3);
        HH2ex = dataExtract(HH2); close(f)
    
        load('watermarkDH.mat'); % for comparison later
    
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
    watermarkEx = mode(cat(3,HL2ex,LH2ex,HH2ex),3);
    
    % % measurements/validation
    % compare extracted and original watermark- 1 is ideal
    
    disp(['HH2ex Bit Error Ratio == ',num2str(BER(HH2ex,watermark))])   % compare HH2
    disp(['HL2ex Bit Error Ratio == ',num2str(BER(HL2ex,watermark))])   % compare HL2
    disp(['LH2ex Bit Error Ratio == ',num2str(BER(LH2ex,watermark))])   % compare LH2
    disp(['Extracted Watermark Bit Error Ratio == ',num2str(BER(watermarkEx,watermark))])   % compare extracted watermark
end