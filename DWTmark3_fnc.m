% Data-Hiding/Zero-Bit Watermarker/Decoder
% By Theo Rickman
% University of Sheffield 2022

function [watermark_or_key_out] = DWTmark3_fnc(img_in, ...
                                              watermark_or_key_in, ...
                                              watermarkingType, ...
                                              operation, ...
                                              waveletType)

watermark_or_key_out = 0;

    % Conv to double and extract Y part
    img = rgb2ycbcr(im2double(img_in));  % convert to double then YCbCr
    imgY = squeeze(img(:,:,1)); % extract luma part of image (greyscale)
    
    % % decompose Y part of image using dwt
    [LL,HL,LH,HH] = dwt2(imgY,waveletType);
    [LL2,HL2,LH2,HH2] = dwt2(LL,waveletType);
    [LL3,HL3,LH3,HH3] = dwt2(LL2,waveletType);
    
    if strcmp(operation,'Embed')
%         f = waitbar(0,"Inserting Watermarks");
        % % load watermark and execute relevant watermarking function
        if strcmp(watermarkingType,'Data-Hiding')
        
            HH3dh = dataHide(HH3,watermark_or_key_in); %waitbar(1/3,f);
            HL3dh = dataHide(HL3,watermark_or_key_in); %waitbar(2/3,f);
            LH3dh = dataHide(LH3,watermark_or_key_in); %close(f)
            
            % recompose image using idwt
            rLL2 = idwt2(LL3,HL3dh,LH3dh,HH3dh,waveletType);
            rLL = idwt2(rLL2,HL2,LH2,HH2,waveletType);
            imgReY = idwt2(rLL,HL,LH,HH,waveletType);
        
            imgRe = cat(3,imgReY,img(:,:,2:3)); % reinsert Cb & Cr from original image
            imgReO = im2uint8(ycbcr2rgb(imgRe)); % convert reconstituted YCbCr image to RGB, then to uint8
            imwrite(imgReO,strcat("output","_DH",".jpg"),"Quality",100);
        
        elseif strcmp(watermarkingType,'Zero-Bit')
        
            HHkey = keyGen(HH3,watermark_or_key_in); %waitbar(1/3,f);
            HLkey = keyGen(HL3,watermark_or_key_in); %waitbar(2/3,f);
            LHkey = keyGen(LH3,watermark_or_key_in); %close(f)
            
            watermark_or_key_out = cat(3,HHkey,HLkey,LHkey);
        
            % no need to recompose image as it has not been modified
        end
    elseif strcmp(operation,'Extract')
        load('watermark.mat','watermark');
%         f = waitbar(0,"Extracting Watermark");
        % % extract watermark
        if strcmp(watermarkingType,'Data-Hiding')

            HH3ex = dataExtract(HH3); %waitbar(1/3,f);
            HL3ex = dataExtract(HL3); %waitbar(2/3,f);
            LH3ex = dataExtract(LH3); %close(f)

%             wmcomp = wm_sizer(size(HL3,1),size(HL3,2),watermark,'dh');
        
        elseif strcmp(watermarkingType,'Zero-Bit')
        
            HH3ex = keyComp(HH3,watermark_or_key_in(:,:,1)); %waitbar(1/3,f);
            HL3ex = keyComp(HL3,watermark_or_key_in(:,:,2)); %waitbar(2/3,f);
            LH3ex = keyComp(LH3,watermark_or_key_in(:,:,3)); %close(f)

%             wmcomp = wm_sizer(size(HL3,1),size(HL3,2),watermark,'zb');

        else
            disp("Invalid watermarking type selected")
            return
        end
        
        % combine extracted watermarks
        watermark_or_key_out = mode(cat(3,HL3ex,LH3ex,HH3ex),3);
        
        % % measurements/validation
        % compare extracted and original watermark- 1 is ideal
        
%         disp(['HH3ex Bit Error Ratio == ',num2str(BER(HH3ex,wmcomp))])   % compare HH3
%         disp(['HL3ex Bit Error Ratio == ',num2str(BER(HL3ex,wmcomp))])   % compare HL3
%         disp(['LH3ex Bit Error Ratio == ',num2str(BER(LH3ex,wmcomp))])   % compare LH3
%         disp(['Extracted Watermark Bit Error Ratio == ',num2str(BER(watermark_or_key_out,wmcomp))])   % compare extracted watermark
    end
end