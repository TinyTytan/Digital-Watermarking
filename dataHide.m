function out = dataHide(matrix,watermark)
    if size(matrix,1) ~= size(watermark,1) || size(matrix,2)/3 ~= size(watermark,2)
        disp("Error- watermark incorrect size, or matrix dimensions not divisible by 3");
    else
        f = waitbar(0,"Inserting Watermark");
        for workingRow = 1:size(matrix,1) % add redundancy
            waitbar(workingRow/size(matrix,1));
            for workingColumn = 1:size(matrix,2)/3
                columnLoc = 3*workingColumn-2;
                activeSection = matrix(workingRow,columnLoc:columnLoc+2);
                oddOneOut = abs(activeSection-median(activeSection));
                [~, index] = min(oddOneOut);

                if oddOneOut == 0
                    disp(["all values same, activeSection ==",num2str(activeSection,3)])
                    if watermark(workingRow,workingColumn) == 1
                        matrix(workingRow,columnLoc+1) = activeSection(2)-1e-18-abs(activeSection(1)*0.1);
                        disp(["1 embedded, activeSection ==",num2str(matrix(workingRow,columnLoc:columnLoc+2),3)])
                    elseif watermark(workingRow,workingColumn) == 0
                        matrix(workingRow,columnLoc+1) = activeSection(2)+1e-18+abs(activeSection(1)*0.1);
                        disp(["0 embedded, activeSection ==",num2str(matrix(workingRow,columnLoc:columnLoc+2),3)])
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
    close(f)
end