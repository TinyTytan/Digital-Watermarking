function out = dataHide(matrix,watermark)
    if size(matrix,1) ~= size(watermark,1) || size(matrix,2)/3 ~= size(watermark,2)
        disp("Error- watermark incorrect size, or matrix dimensions not divisible by 3");
    else
        for workingRow = 1:size(matrix,1) % add redundancy
            for workingColumn = 1:size(matrix,2)/3
                columnLoc = 3*workingColumn-2;
                activeSection = matrix(workingRow,columnLoc:columnLoc+2);
                norm = abs(activeSection-median(activeSection));
                [~, index] = min(norm);

                if norm == 0
                    if watermark(workingRow,workingColumn) == 1
                        matrix(workingRow,columnLoc) = activeSection(1)-1e18-abs(activeSection(1)*0.1);
                    elseif watermark(workingRow,workingColumn) == 0
                        matrix(workingRow,columnLoc) = activeSection(1)+1e18+abs(activeSection(1)*0.1);
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
end