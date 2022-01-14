function key = keyGen(matrix,watermark)
    if size(matrix,1) ~= size(watermark,1) || size(matrix,2) ~= size(watermark,2)
        disp("Error- watermark incorrect size");
    else
        key = xor(imbinarize(matrix), watermark);
    end
end