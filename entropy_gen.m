clear;

root = 'C:\Users\Theo\MATLAB\Projects\EEE381\images\';
imageset = dir([root, '*.jpg']);

img_entropy = struct();

for i = 1:length(imageset)

    img_entropy(i).name = imageset(i).name;
    img_entropy(i).value = entropy(imread(strcat(imageset(i).folder,'\',imageset(i).name)));

end

writecell({'name',img_entropy.name; ...
           'value',img_entropy.value},[root, 'img_entropy.csv']);