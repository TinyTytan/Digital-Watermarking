function watermarkEx = keyComp(matrix,key)
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
    watermarkEx = xor(feat,key);
end

