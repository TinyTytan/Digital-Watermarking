function attack_JPEG(path,filename,ext)
%ATTACK_JPEG Simple JPEG compression
%   JPG compress image

qFactor = 80;

img_in = imread(strcat(path,"\",filename,ext));

imwrite(img_in,strcat(path,"\",filename,"p.jpg"),"Quality", qFactor);

end