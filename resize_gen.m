%% embed
clear;

[path,filename,ext] = fileparts('C:\Users\Theo\MATLAB\Projects\EEE381\attacked_images\tests\resize\birds.jpg');

img_o = imread([path,'\',filename,ext]);
load('watermark.mat');

DWTmark3_fnc(img_o, ...
             watermark, ...
             'Data-Hiding', ...
             'Embed', ...
             'haar');

filename = [filename, '_DH_']; ext = '.png';
imwrite(imread('C:\Users\Theo\MATLAB\Projects\EEE381\output_DH.jpg'),[path,'\',filename,'0','r',ext])
%% gen files
n = 10;
resize_factor = 0.5;
img_resize = imread([path,'\',filename,'0','r',ext]);

for j = 1:n
    img_resize = imresize(img_resize,resize_factor);
    img_resize = imresize(img_resize,1/resize_factor);
    imwrite(img_resize,[path,'\',filename,num2str(j),'r',ext])
end

%% gen data

imageset = dir([path,'\',filename,'*r.png']);

out = struct();
for j = 1:length(imageset)
    img_atk = imread([imageset(j).folder,'\',imageset(j).name]);
    out(j).n = str2double(cell2mat(regexp(imageset(j).name,'\d*','Match')));
    out(j).SSIM = ssim(img_atk,img_o);
    wm_o = DWTmark3_fnc(img_atk, ...
                        watermark, ...
                        'Data-Hiding', ...
                        'Extract', ...
                        'haar');
    out(j).BER = BER(wm_o, wm_sizer(size(wm_o,1),size(wm_o,2)*3,watermark,'dh'));
end

writematrix(["n" , "SSIM" ,   "BER"; ...
             [out.n]', [out.SSIM]', [out.BER]'], ...
             [path,'\results2.csv']);