function img_out = attack_IOS(img_in)
%ATTACK_IOS Emulates iOS screenshot attack
%   Resize image, then JPG compress it

    % dimensions for resizing
% res = [2778 1284]; % iPhone 12/13 Pro Max
res = [2532 1170]; % iPhone 12/13 (and Pro)
% res = [1334 750];  % iPhone 6s/7/8/SE2/SE3

phone_asp = res(2)/res(1);

image_res = size(img_in);
image_asp = image_res(2)/image_res(1);

if image_asp < phone_asp % if the image's aspect ratio  is less than the phone's
    % then the image is bound by height
    res(2) = size(img_in,2)*res(1)/size(img_in,1); % set image width
else % the image is bound by width
    res(1) = size(img_in,1)*res(2)/size(img_in,2); % set image height
end

img_out = imresize(img_in,res);

end