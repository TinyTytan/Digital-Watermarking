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

imgDb = im2double(imgO); % convert to double
img = rgb2ycbcr(imgDb);  % convert to YCbCr
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
    HH2dh = dataHide(HH2,watermark);
    
    close(f)

    % recompose image using idwt
    rLL = idwt2(LL2,HL2dh,LH2dh,HH2dh,waveletType);
    imgReY = idwt2(rLL,HL,LH,HH,waveletType);

    imgRe = cat(3,imgReY,img(:,:,2:3)); % reinsert Cb & Cr from original image
    imgReDb = ycbcr2rgb(imgRe); % convert reconstituted YCbCr image to RGB
    imgReO = im2uint8(imgReDb); % convert reconstituted RGB double image to uint8
    
    % measurements/validation
    
    % compare reconstructed and original images- ssim should = 1 and immse = 0
    if strcmp(questdlg("Show SSIM & IMMSE?"),"Yes")
        disp(['ssim(rLL,LL)         == ',num2str(ssim(rLL,LL))])         % compare LL
        disp(['ssim(imgReY,imgY)    == ',num2str(ssim(imgReY,imgY))])    % compare greyscale image
        disp(['ssim(imgRe,img)      == ',num2str(ssim(imgRe,img))])      % compare YCbCr image
        disp(['ssim(imgReDb,imgDb)  == ',num2str(ssim(imgReDb,imgDb))])  % compare RGB image
        disp(['ssim(imgReO,imgO)    == ',num2str(ssim(imgReO,imgO))])    % compare uint8 image
        disp(newline) 
        disp(['immse(rLL,LL)        == ',num2str(immse(rLL,LL))])        % compare LL
        disp(['immse(imgReY,imgY)   == ',num2str(immse(imgReY,imgY))])   % compare greyscale image
        disp(['immse(imgRe,img)     == ',num2str(immse(imgRe,img))])     % compare YCbCr image
        disp(['immse(imgReDb,imgDb) == ',num2str(immse(imgReDb,imgDb))]) % compare RGB image
        % cannot compare uint8 files with immse
    end

elseif strcmp(watermarkingType,'zeroBit')
    load('watermarkZB.mat');
    HLkey = keyGen(HL2,watermark);
    LHkey = keyGen(LH2,watermark);
    HHkey = keyGen(HH2,watermark);
    key = cat(3,HHkey,HLkey,LHkey);
    save('key.mat','key');

    % no need to recompose image as it has not been modified
    % no need to compare recomposed and original images either

else
    disp("Invalid watermarking type selected")
    return
end

% % % visualisations
% % create tiled image with all orders
% secondOrderImg = imtile([LL2,HL2;LH2,HH2]);
% firstOrderImg = imtile([secondOrderImg,HL;LH,HH]);

% % create tiled image with all orders normalised 
% secondOrderImg = imtile([mat2gray(LL2),mat2gray(HL2);mat2gray(LH2),mat2gray(HH2)]);
% firstOrderImg = imtile([secondOrderImg,mat2gray(HL);mat2gray(LH),mat2gray(HH)]);

% % display first-order components in plot
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