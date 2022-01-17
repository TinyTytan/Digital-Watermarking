function watermarkEx = keyComp(matrix,key)
    if size(matrix,1) ~= size(key,1) || size(matrix,2) ~= size(key,2)
        disp("Error- key incorrect size");
    else
        watermarkEx = xor(imbinarize(matrix), key);
    end
end
