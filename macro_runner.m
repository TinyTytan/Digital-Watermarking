clear global; clear;

imageset = dir('C:\Users\Theo\MATLAB\Projects\EEE381\images\*.jpg');

macro_wait = waitbar(0,"Attacking dataset");

for i = 1:length(imageset)

    macroZB([imageset(i).folder '\'],imageset(i).name);
    waitbar(0.5*i/length(imageset),macro_wait);

    macroDH([imageset(i).folder '\'],imageset(i).name);
    waitbar(i/length(imageset),macro_wait);

end

close(macro_wait);