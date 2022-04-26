% Set directory for attacked images
workingDir = 'C:\Users\Theo\MATLAB\Projects\EEE381\attacked_images';

% Prompt user for file to attack and divide up the filename
[original_filename,original_path] = uigetfile('*.jpg;*.jpeg;*.png');
[original_path,original_filename,ext] = fileparts([original_path,original_filename]);

% Create new folder in working directory for this image
new_path = strcat(workingDir,'\',original_filename); 
warning('off', 'MATLAB:MKDIR:DirectoryExists');
mkdir(new_path);

% Copy image to be attacked to the new folder, append "_"
copyfile(strcat(original_path,'\',original_filename,ext),strcat(new_path,'\',original_filename,'_',ext));
filename = strcat(original_filename,'_');

    numAttacks = 25; 
    numAttacksComplete = 0;
    f = waitbar(0,strcat("Attacking ",original_filename,ext)); f.Children.Title.Interpreter = 'none';

attack_Android(new_path,filename,ext);                      % generate _a
attack_Android(new_path,strcat(filename,"a"),ext);          % generate _aa
attack_Android(new_path,strcat(filename,"aa"),ext);         % generate _aaa
    
    numAttacksComplete = numAttacksComplete + 3;
    waitbar(numAttacksComplete/numAttacks)

attack_IOS(new_path,filename,ext);                          % generate _i
attack_IOS(new_path,strcat(filename,"i"),'.png');           % generate _ii
attack_IOS(new_path,strcat(filename,"ii"),'.png');          % generate _iii

    numAttacksComplete = numAttacksComplete + 3;
    waitbar(numAttacksComplete/numAttacks)

attack_JPEG(new_path,filename,ext);                         % generate _p
attack_JPEG(new_path,strcat(filename,"p"),ext);             % generate _pp
attack_JPEG(new_path,strcat(filename,"pp"),ext);            % generate _ppp

    numAttacksComplete = numAttacksComplete + 3;
    waitbar(numAttacksComplete/numAttacks)

attack_Android(new_path,strcat(filename,"p"),ext);          % generate _pa
attack_IOS(new_path,strcat(filename,"p"),ext);              % generate _pi

    numAttacksComplete = numAttacksComplete + 2;
    waitbar(numAttacksComplete/numAttacks)

attack_Android(new_path,strcat(filename,"pp"),ext);         % generate _ppa
attack_IOS(new_path,strcat(filename,"pp"),ext);             % generate _ppi

    numAttacksComplete = numAttacksComplete + 2;
    waitbar(numAttacksComplete/numAttacks)

attack_JPEG(new_path,strcat(filename,"a"),ext);             % generate _ap
attack_JPEG(new_path,strcat(filename,"ap"),ext);            % generate _app
attack_JPEG(new_path,strcat(filename,"i"),'.png');          % generate _ip
attack_JPEG(new_path,strcat(filename,"ip"),ext);            % generate _ipp

    numAttacksComplete = numAttacksComplete + 4;
    waitbar(numAttacksComplete/numAttacks)

attack_IOS(new_path,strcat(filename,"a"),ext);              % generate _ai
attack_Android(new_path,strcat(filename,"i"),'.png');       % generate _ia

    numAttacksComplete = numAttacksComplete + 2;
    waitbar(numAttacksComplete/numAttacks)

attack_IOS(new_path,strcat(filename,"aaa"),ext);            % generate _aaai
attack_IOS(new_path,strcat(filename,"aaai"),'.png');        % generate _aaaii
attack_IOS(new_path,strcat(filename,"aaaii"),'.png');       % generate _aaaiii
attack_JPEG(new_path,strcat(filename,"aaaiii"),'.png');     % generate _aaaiiip
attack_JPEG(new_path,strcat(filename,"aaaiiip"),ext);       % generate _aaaiiipp
attack_JPEG(new_path,strcat(filename,"aaaiiipp"),ext);      % generate _aaaiiippp

numAttacksComplete = numAttacksComplete + 6;
waitbar(numAttacksComplete/numAttacks); close(f)