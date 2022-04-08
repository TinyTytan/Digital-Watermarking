function key = keyGen(matrix,watermark)
cRows = size(matrix,1);
cCols = size(matrix,2);

constrSquare = min(cRows,cCols);
watermark = imresize(watermark,[constrSquare constrSquare]);

if cRows < cCols % if matrix is wide
    watermark = repmat(watermark, 1, 30);
    watermark = imcrop(watermark, [0 0 cCols constrSquare]);

elseif cCols < cRows % if matrix is tall
    watermark = repmat(watermark, 30, 1);
    watermark = imcrop(watermark, [0 0 constrSquare cRows]);

end

save('ZBlastusedwatermark.mat','watermark');

key = xor(imbinarize(matrix), watermark);

end