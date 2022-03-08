% Data-Hiding/Zero-Bit Watermarker/Decoder
% By Theo Rickman
% University of Sheffield 2022

function [watermark_or_key_out, img_out] = DWTmark_fnc(img_in, ...
                                                watermark_or_key_in, ...
                                                watermarkingType, ...
                                                operation, ...
                                                waveletType)
    
    % % Load image
    img = img_in;
    
    % Conv to double and extract Y part
    img = rgb2ycbcr(im2double(img));  % convert to double then YCbCr
    imgY = squeeze(img(:,:,1)); % extract luma part of image (greyscale)
    
    % % decompose Y part of image using dwt
    [LL,HL,LH,HH] = dwt2(imgY,waveletType);
    [LL2,HL2,LH2,HH2] = dwt2(LL,waveletType);
    
    if strcmp(operation,'Embed')
        % % load watermark and execute relevant watermarking function
        if strcmp(watermarkingType,'Data-Hiding')
            f = waitbar(0,"Inserting Watermarks");
        
            HL2dh = dataHide(HL2,watermark_or_key_in); waitbar(1/3);
            LH2dh = dataHide(LH2,watermark_or_key_in); waitbar(2/3);
            HH2dh = dataHide(HH2,watermark_or_key_in); close(f)
            
            % recompose image using idwt
            rLL = idwt2(LL2,HL2dh,LH2dh,HH2dh,waveletType);
            imgReY = idwt2(rLL,HL,LH,HH,waveletType);
        
            imgRe = cat(3,imgReY,img(:,:,2:3)); % reinsert Cb & Cr from original image
            imgReO = im2uint8(ycbcr2rgb(imgRe)); % convert reconstituted YCbCr image to RGB, then to uint8
            imwrite(imgReO,strcat(filename,"_DH",ext),"Quality",100);
        
        elseif strcmp(watermarkingType,'Zero-Bit')
            f = waitbar(0,"Inserting Watermarks");
        
            HLkey = keyGen(HL2,watermark_or_key_in); waitbar(1/3);
            LHkey = keyGen(LH2,watermark_or_key_in); waitbar(2/3);
            HHkey = keyGen(HH2,watermark_or_key_in); close(f)
            
            watermark_or_key_out = cat(3,HHkey,HLkey,LHkey);
        
            % no need to recompose image as it has not been modified
        end
    elseif strcmp(operation,'Extract')
        % % extract watermark
        if strcmp(watermarkingType,'Data-Hiding')
            f = waitbar(0,"Extracting Watermark");
        
            HL2ex = dataExtract(HL2); waitbar(1/3);
            LH2ex = dataExtract(LH2); waitbar(2/3);
            HH2ex = dataExtract(HH2); close(f)
        
        elseif strcmp(watermarkingType,'Zero-Bit')
            f = waitbar(0,"Extracting Watermark");
        
            HH2ex = keyComp(HH2,watermark_or_key_in(:,:,1)); waitbar(1/3);
            HL2ex = keyComp(HL2,watermark_or_key_in(:,:,2)); waitbar(2/3);
            LH2ex = keyComp(LH2,watermark_or_key_in(:,:,3)); close(f)

        else
            disp("Invalid watermarking type selected")
            return
        end
        
        % combine extracted watermarks
        watermark_or_key_out = mode(cat(3,HL2ex,LH2ex,HH2ex),3);
        
        % % measurements/validation
        % compare extracted and original watermark- 1 is ideal
        
        disp(['HH2ex Bit Error Ratio == ',num2str(BER(HH2ex,watermark_or_key_in))])   % compare HH2
        disp(['HL2ex Bit Error Ratio == ',num2str(BER(HL2ex,watermark_or_key_in))])   % compare HL2
        disp(['LH2ex Bit Error Ratio == ',num2str(BER(LH2ex,watermark_or_key_in))])   % compare LH2
        disp(['Extracted Watermark Bit Error Ratio == ',num2str(BER(watermark_or_key_out,watermark_or_key_in))])   % compare extracted watermark
    end
end