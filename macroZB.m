function macroZB(original_path,original_filename)
    clear global;

    % Set directory for attacked images
    working_dir = 'C:\Users\Theo\MATLAB\Projects\EEE381\attacked_images';
    
    % Divide up the filename
    [original_path,original_filename,ext] = fileparts([original_path,original_filename]);
    
    % Create new folder in working directory for this image
    new_path = strcat(working_dir,'\',original_filename,'_ZB'); 
    warning('off', 'MATLAB:MKDIR:DirectoryExists');
    mkdir(new_path);
    
    % Copy image to be attacked to the new folder, append "_"
    copyfile(strcat(original_path,'\',original_filename,ext),strcat(new_path,'\',original_filename,'_',ext));
    new_filename = strcat(original_filename,'_');
    
    % Load/define a few variables
    load("watermark.mat");
    global n wm_ssim_array wm_ex_array wm_ber_array imgO wmcomp key; %#ok<NUSED> 
    imgO = imread(strcat(new_path,'\',original_filename,'_',ext));
    wmcomp = wm_sizer(size(imgO,1)/8,size(imgO,2)/8,watermark,'zb');
    
    % Generate key 
    key = DWTmark3_fnc(imgO, ...
                       watermark, ...
                       "Zero-Bit", ...
                       "Embed", ...
                       "haar"); 
    
    % Init waitbar
    numAttacks = 25; 
    numAttacksComplete = 0;
    wb = waitbar(0,strcat("Zero-Bit macro: Attacking ",original_filename,ext)); wb.Children.Title.Interpreter = 'none';
    
    %% generate attacked images
    gen_data(imgO);
    
    gen_data(attack_Android(new_path,new_filename,ext));                    % generate _a
    gen_data(attack_Android(new_path,strcat(new_filename,"a"),ext));        % generate _aa
    gen_data(attack_Android(new_path,strcat(new_filename,"aa"),ext));       % generate _aaa
        
    
        numAttacksComplete = numAttacksComplete + 3;
        waitbar(numAttacksComplete/numAttacks,wb);
    
    gen_data(attack_IOS(new_path,new_filename,ext));                        % generate _i
    gen_data(attack_IOS(new_path,strcat(new_filename,"i"),'.png'));         % generate _ii
    gen_data(attack_IOS(new_path,strcat(new_filename,"ii"),'.png'));        % generate _iii
    
        numAttacksComplete = numAttacksComplete + 3;
        waitbar(numAttacksComplete/numAttacks,wb);
    
    gen_data(attack_JPEG(new_path,new_filename,ext));                       % generate _p
    gen_data(attack_JPEG(new_path,strcat(new_filename,"p"),ext));           % generate _pp
    gen_data(attack_JPEG(new_path,strcat(new_filename,"pp"),ext));          % generate _ppp
    
        numAttacksComplete = numAttacksComplete + 3;
        waitbar(numAttacksComplete/numAttacks,wb);
    
    gen_data(attack_Android(new_path,strcat(new_filename,"p"),ext));        % generate _pa
    gen_data(attack_IOS(new_path,strcat(new_filename,"p"),ext));            % generate _pi
    
        numAttacksComplete = numAttacksComplete + 2;
        waitbar(numAttacksComplete/numAttacks,wb);
    
    gen_data(attack_Android(new_path,strcat(new_filename,"pp"),ext));       % generate _ppa
    gen_data(attack_IOS(new_path,strcat(new_filename,"pp"),ext));           % generate _ppi
    
        numAttacksComplete = numAttacksComplete + 2;
        waitbar(numAttacksComplete/numAttacks,wb);
    
    gen_data(attack_JPEG(new_path,strcat(new_filename,"a"),ext));           % generate _ap
    gen_data(attack_JPEG(new_path,strcat(new_filename,"ap"),ext));          % generate _app
    gen_data(attack_JPEG(new_path,strcat(new_filename,"i"),'.png'));        % generate _ip
    gen_data(attack_JPEG(new_path,strcat(new_filename,"ip"),ext));          % generate _ipp
    
        numAttacksComplete = numAttacksComplete + 4;
        waitbar(numAttacksComplete/numAttacks,wb);
    
    gen_data(attack_IOS(new_path,strcat(new_filename,"a"),ext));            % generate _ai
    gen_data(attack_Android(new_path,strcat(new_filename,"i"),'.png'));     % generate _ia
    
        numAttacksComplete = numAttacksComplete + 2;
        waitbar(numAttacksComplete/numAttacks,wb);
    
    gen_data(attack_IOS(new_path,strcat(new_filename,"aaa"),ext));          % generate _aaai
    gen_data(attack_IOS(new_path,strcat(new_filename,"aaai"),'.png'));      % generate _aaaii
    gen_data(attack_IOS(new_path,strcat(new_filename,"aaaii"),'.png'));     % generate _aaaiii
    gen_data(attack_JPEG(new_path,strcat(new_filename,"aaaiii"),'.png'));   % generate _aaaiiip
    gen_data(attack_JPEG(new_path,strcat(new_filename,"aaaiiip"),ext));     % generate _aaaiiipp
    gen_data(attack_JPEG(new_path,strcat(new_filename,"aaaiiipp"),ext));    % generate _aaaiiippp

    numAttacksComplete = numAttacksComplete + 6;
    waitbar(numAttacksComplete/numAttacks,wb); close(wb)
    
    %% write data to file
    name_array = ["orig", ...
                  "a" "aa" "aaa" , ...
                  "i" "ii" "iii", ...
                  "p" "pp" "ppp", ...
                  "pa" "pi", ...
                  "ppa" "ppi", ...
                  "ap" "app" "ip" "ipp", ...
                  "ai" "ia", ...
                  "aaai" "aaaii" "aaaiii" "aaaiiip" "aaaiiipp" "aaaiiippp"...
                  ];
    writematrix(["IMAGE" name_array; ...
                 "SSIM"  wm_ssim_array; ...
                 "BER"   wm_ber_array], ...
                strcat('C:\Users\Theo\MATLAB\Projects\EEE381\attacked_images\all_csv\',original_filename,'_ZB_results.csv'));

    save(strcat(new_path,'\',original_filename,'_ZB_extracted_watermarks.mat'),'wm_ex_array');
end

%% generate data fnc
    
function gen_data(img_in)
global n wm_ssim_array wm_ex_array wm_ber_array imgO wmcomp key; %#ok<*GVMIS> 

    if isempty(n); n = 1; end

    img_in = imresize(img_in, size(imgO,[1 2]));
    wm_ssim_array(n) = ssim(img_in,imgO);
    wm_ex_array{n} = DWTmark3_fnc(img_in, ...
                               key, ...
                               "Zero-Bit", ...
                               "Extract", ...
                               "haar"); 
    wm_ber_array(n) = BER(wm_ex_array{n},wmcomp); n=n+1;
end