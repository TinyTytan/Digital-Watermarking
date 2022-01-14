function watermarkEx = keyComp(matrix,key)
    if size(matrix,1) ~= size(watermark,1) || size(matrix,2) ~= size(watermark,2)
        disp("Error- watermark incorrect size");
    else
        watermarkEx = xor(imbinarize(matrix), key);
    end
end
