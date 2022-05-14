% % Load image
path = 'C:\Users\Theo\MATLAB\Projects\EEE381\images'; filename = 'birds'; ext = '.jpg';
img_in = imread(strcat(path,"\",filename,ext));

load("watermark.mat");
watermark_or_key_in = watermark;

DWTmark3_fnc(img_in, ...
            watermark_or_key_in, ...
            "Data-Hiding", ...
            "Embed", ...
            "haar");

attack_Android('C:\Users\Theo\MATLAB\Projects\EEE381','output_DH','.jpg');

atk_img = imresize(imread('output_DHa.jpg'),[4032 3024]);

wm_out = DWTmark3_fnc(atk_img, ...
                     watermark_or_key_in, ...
                     "Data-Hiding", ...
                     "Extract", ...
                     "haar");






