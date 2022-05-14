% Data-Hiding/Zero-Bit Watermarker/Decoder runner
% By Theo Rickman
% University of Sheffield 2022

clear;

waveletType = 'haar';
watermarkingType = questdlg("Zero-Bit or Data-Hiding?","Watermarking Type","Zero-Bit","Data-Hiding","Zero-Bit");
operation = questdlg("Embed or extract watermark?","Operation","Embed","Extract","Embed");

% % Load image
[filename,path] = uigetfile('*.jpg');
[path,filename,ext] = fileparts([path,filename]);
img_in = imread(strcat(path,"\",filename,ext));

if strcmp(watermarkingType,'Zero-Bit') && strcmp(operation,'Extract')
    load("key.mat");
    watermark_or_key_in = key;
else
    load("watermark.mat");
    watermark_or_key_in = watermark;
end

watermark_or_key_out = DWTmark3_fnc(img_in, ...
                                    watermark_or_key_in, ...
                                    watermarkingType, ...
                                    operation, ...
                                    waveletType);
