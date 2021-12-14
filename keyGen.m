function key = keyGen(matrix,watermark)
    if size(matrix,1) ~= size(watermark,1) || size(matrix,2) ~= size(watermark,2)
        disp("Error- watermark incorrect size");
    else
        mid = median(matrix,'all');
        feat = matrix;
        for workingRow = 1:size(matrix,1)
            for workingColumn = 1:size(matrix,2)
                if matrix(workingRow,workingColumn) >= mid
                    feat(workingRow,workingColumn) = 1;
                elseif matrix(workingRow,workingColumn) < mid
                    feat(workingRow,workingColumn) = 0;
                else
                    disp("Uh-oh");
                end
            end
        end
    end
    key = xor(feat, watermark);
end