function attack_JPEG(path,filename,ext)
%ATTACK_JPEG Simple JPEG compression
%   JPG compress image

%% generate q factor between 70 and 80 that does not equal the previous q factor
persistent qPrev
if isempty(qPrev); qPrev = 0; end
qFactor = 0; qLowerBound = 70; qUpperBound = 80;

while true
    qFactor = round(qLowerBound + (qUpperBound-qLowerBound)*rand);
    if(qFactor ~= qPrev); break; end
end

qPrev = qFactor;

%% load, resize and recompress image specified

img_in = imread(strcat(path,'\',filename,ext));

% to emulate facebook, resize image if width > 2048 [Pippin 2016 Table 4.5]
if size(img_in,2) > 2048
    imresize(img_in,[round(2048*size(img_in,1)/size(img_in,2)) 2048]);
end

imwrite(img_in,strcat(path,'\',filename,".jpg"),"Quality", qFactor);

end