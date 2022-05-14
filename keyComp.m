function watermarkEx = keyComp(matrix,key)
    if size(matrix,1) ~= size(key,1) || size(matrix,2) ~= size(key,2)
        error('Key incorrect size');
    else
        watermarkEx = xor(imbinarize(matrix,median(matrix,'all')), key);
    end
end
