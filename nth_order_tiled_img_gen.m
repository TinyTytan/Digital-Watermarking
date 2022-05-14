% % Load image
[filename,path] = uigetfile('*.jpg');
imgO = imread([path,filename]);

imgDb = im2double(imgO); % convert to double
img = rgb2ycbcr(imgDb);  % convert to YCbCr

aspectRatio = [size(img,2),size(img,1),size(img,3)];

% image(img)
% pbaspect(aspectRatio)

imgY = squeeze(img(:,:,1)); % extract luma part of image (greyscale)

% % decompose Y part of image using dwt
[LL,HL,LH,HH] = dwt2(imgY,'haar');
[LL2,HL2,LH2,HH2] = dwt2(LL,'haar');
[LL3,HL3,LH3,HH3] = dwt2(LL2,'haar');

% % create tiled image with all orders
% thirdOrderImg = imtile([LL3,HL3;LH3,HH3]);
% secondOrderImg = imtile([thirdOrderImg,HL2;LH2,HH2]);
% firstOrderImg = imtile([secondOrderImg,HL;LH,HH]);

b = 2; % black border px
b2 = 4;
b4 = 8;

% create tiled image with all orders normalised 
thirdOrderImg  = imtile([padarray(mat2gray(LL3),[b b],0,'both'),  padarray(mat2gray(HL3),[b b],0,'both'); ...
                         padarray(mat2gray(LH3),[b b],0,'both'),  padarray(mat2gray(HH3),[b b],0,'both')]);

secondOrderImg = imtile([padarray(thirdOrderImg,[0 0],0,'both'),  padarray(mat2gray(HL2),[b2 b2],0,'both'); ...
                         padarray(mat2gray(LH2),[b2 b2],0,'both'),padarray(mat2gray(HH2),[b2 b2],0,'both')]);

firstOrderImg  = imtile([padarray(secondOrderImg,[0 0],0,'both'), padarray(mat2gray(HL),[b4 b4],0,'both'); ...
                         padarray(mat2gray(LH),[b4 b4],0,'both'), padarray(mat2gray(HH),[b4 b4],0,'both')]);