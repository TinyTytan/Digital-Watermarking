function out = dataHide(matrix,watermark)
cRows = size(matrix,1);
cCols = size(matrix,2)/3;

constrSqare = min(cRows,cCols);
watermark = imresize(watermark,[constrSqare constrSqare]);

if cRows < cCols % if matrix is wide
    watermark = repmat(watermark, 1, 30);
    watermark = imcrop(watermark, [0 0 cCols constrSqare]);

elseif cCols < cRows % if matrix is tall
    watermark = repmat(watermark, 30, 1);
    watermark = imcrop(watermark, [0 0 constrSqare cRows]);

end

save('DHlastusedwatermark.mat','watermark');

for workingRow = 1:cRows

    for workingColumn = 1:cCols

        columnLoc = 3*workingColumn-2;
        activeSection = matrix(workingRow,columnLoc:columnLoc+2);
        oddOneOut = abs(activeSection-median(activeSection));
        [~, index] = min(oddOneOut);

        if max(oddOneOut)-min(oddOneOut) <= abs(mean(activeSection))*0.01
            if watermark(workingRow,workingColumn) == 1
                matrix(workingRow,columnLoc+1) = activeSection(index)-1e-18-abs(activeSection(1)*0.1);
            elseif watermark(workingRow,workingColumn) == 0
                matrix(workingRow,columnLoc+1) = activeSection(index)+1e-18+abs(activeSection(1)*0.1);
            end
        elseif watermark(workingRow,workingColumn) == 1
            matrix(workingRow,columnLoc+index-1) = max(activeSection);
        elseif watermark(workingRow,workingColumn) == 0
            matrix(workingRow,columnLoc+index-1) = min(activeSection);
        else
            disp("Uh-oh");
        end
    end
end
out = matrix;

end