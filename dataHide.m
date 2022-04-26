function out = dataHide(matrix,watermark)
watermark = wm_sizer(size(matrix,1),size(matrix,2),watermark,'dh');

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