% Set directory for attacked images
workingDir = 'C:\Users\Theo\MATLAB\Projects\EEE381\attacked_images';

% Prompt user for file to attack and divide up the filename
[filename,origin_path] = uigetfile('*.jpg;*.jpeg;*.png');
[origin_path,filename,ext] = fileparts([origin_path,filename]);

% Create new folder in working directory for this image
new_path = strcat(workingDir,'\',filename);
mkdir(new_path);

% Copy image to be attacked to the new folder, append "_"
copyfile(strcat(origin_path,'\',filename,ext),strcat(new_path,'\',filename,'_',ext));
filename = strcat(filename,'_');

attack_Android(new_path,filename,ext);                  % generate _a
attack_Android(new_path,strcat(filename,"a"),ext);      % generate _aa
attack_Android(new_path,strcat(filename,"aa"),ext);     % generate _aaa

attack_IOS(new_path,filename,ext);                      % generate _i
attack_IOS(new_path,strcat(filename,"i"),'.png');       % generate _ii
attack_IOS(new_path,strcat(filename,"ii"),'.png');      % generate _iii

attack_JPEG(new_path,filename,ext);                     % generate _p
attack_JPEG(new_path,strcat(filename,"p"),ext);         % generate _pp
attack_JPEG(new_path,strcat(filename,"pp"),ext);        % generate _ppp