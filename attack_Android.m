function attack_Android(path,filename,ext)
%ATTACK_ANDROID Emulates Android screenshot attack
%   Resize image, then JPG compress it

    % dimensions for resizing
% res = [1440 2960]; % 1:2.05 QHD
res = [1080 2400]; % 9:20 FHD+
% res = [1080 1920]; % 9:16 FHD
% res = [720 1280]; % 9:16 HD

img_in = imread(strcat(path,"\",filename,ext));

phone_asp = res(2)/res(1);

image_res = size(img_in);
image_asp = image_res(2)/image_res(1);

if image_asp < phone_asp % if the image's aspect ratio is less than the phone's
    % then the image is bound by height
    res(2) = res(1)*image_asp; % set image width
else % the image is bound by width
    res(1) = res(2)*1/image_asp; % set image height
end

imwrite(imresize(img_in,res),strcat(path,"\",filename,"a.jpg"),"Quality",100);

end