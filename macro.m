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

attack_Android(new_path,filename,ext);                      % generate _a
attack_Android(new_path,strcat(filename,"a"),ext);          % generate _aa
attack_Android(new_path,strcat(filename,"aa"),ext);         % generate _aaa
    
attack_IOS(new_path,filename,ext);                          % generate _i
attack_IOS(new_path,strcat(filename,"i"),'.png');           % generate _ii
attack_IOS(new_path,strcat(filename,"ii"),'.png');          % generate _iii
    
attack_JPEG(new_path,filename,ext);                         % generate _p
attack_JPEG(new_path,strcat(filename,"p"),ext);             % generate _pp
attack_JPEG(new_path,strcat(filename,"pp"),ext);            % generate _ppp
    
attack_Android(new_path,strcat(filename,"p"),ext);          % generate _pa
attack_IOS(new_path,strcat(filename,"p"),ext);              % generate _pi
    
attack_Android(new_path,strcat(filename,"pp"),ext);         % generate _ppa
attack_IOS(new_path,strcat(filename,"pp"),ext);             % generate _ppi
    
attack_JPEG(new_path,strcat(filename,"a"),ext);             % generate _ap
attack_JPEG(new_path,strcat(filename,"ap"),ext);            % generate _app
attack_JPEG(new_path,strcat(filename,"i"),'.png');          % generate _ip
attack_JPEG(new_path,strcat(filename,"ip"),ext);            % generate _ipp

attack_IOS(new_path,strcat(filename,"a"),ext);              % generate _ai
attack_Android(new_path,strcat(filename,"i"),'.png');       % generate _ia

attack_IOS(new_path,strcat(filename,"aaa"),ext);            % generate _aaai
attack_IOS(new_path,strcat(filename,"aaai"),'.png');        % generate _aaaii
attack_IOS(new_path,strcat(filename,"aaaii"),'.png');       % generate _aaaiii
attack_JPEG(new_path,strcat(filename,"aaaiii"),'.png');     % generate _aaaiiip
attack_JPEG(new_path,strcat(filename,"aaaiiip"),ext);       % generate _aaaiiipp
attack_JPEG(new_path,strcat(filename,"aaaiiipp"),ext);      % generate _aaaiiippp