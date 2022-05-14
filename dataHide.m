function out = dataHide(matrix,watermark)
cRows = size(matrix,1);
cCols = size(matrix,2)/3;

watermark = wm_sizer(cRows,cCols*3,watermark,'dh');

median_Matrix = reshape(median(reshape(matrix', 3, [])),cCols,[])';

for workingRow = 1:cRows

    for workingColumn = 1:cCols

        columnLoc = 3*workingColumn-2;
        activeSection = matrix(workingRow,columnLoc:columnLoc+2);
        oddOneOut = abs(activeSection-median_Matrix(workingRow,workingColumn));
        [~, index] = min(oddOneOut);

        if max(oddOneOut) - min(oddOneOut) <= 1/255
            if watermark(workingRow,workingColumn) == 1
                matrix(workingRow,columnLoc+1) = activeSection(index)-1/255;
            elseif watermark(workingRow,workingColumn) == 0
                matrix(workingRow,columnLoc+1) = activeSection(index)+1/255;
            end
        elseif watermark(workingRow,workingColumn) == 1
            matrix(workingRow,columnLoc+index-1) = max(activeSection);
        else
            matrix(workingRow,columnLoc+index-1) = min(activeSection);
        end

    end

end
out = matrix;
end