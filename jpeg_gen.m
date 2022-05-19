%% embed
clear;

[path,filename,ext] = fileparts('C:\Users\Theo\MATLAB\Projects\EEE381\attacked_images\tests\JPEG\birds.jpg');

img_o = imread([path,'\',filename,ext]);
load('watermark.mat');

DWTmark3_fnc(img_o, ...
             watermark, ...
             'Data-Hiding', ...
             'Embed', ...
             'haar');

filename = [filename, '_DH_'];
copyfile('C:\Users\Theo\MATLAB\Projects\EEE381\output_DH.jpg',[path,'\',filename,'0','p',ext]);
%% gen files

n = 10;

for j = 1:n
    copyfile([path,'\',filename,num2str(j-1),'p',ext], [path,'\',filename,num2str(j),'p',ext]);
    for i = 1:j
        attack_JPEG(path,['\',filename,num2str(j),'p'],ext);
    end
end

%% gen data

imageset = dir([path,'\',filename,'*p.jpg']);

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
             [path,'\results.csv']);