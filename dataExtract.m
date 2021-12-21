function watermarkEx = dataExtract(matrix)
    watermarkEx = NaN(size(matrix,1),size(matrix,2)/3);
    f = waitbar(0,"Extracting Watermark");
    for workingRow = 1:size(matrix,1)
        waitbar(workingRow/size(matrix,1));
        for workingColumn = 1:size(matrix,2)/3
            columnLoc = 3*workingColumn-2;
            activeSection = matrix(workingRow,columnLoc:columnLoc+2);
            [~, index] = max(abs(activeSection - mode(activeSection)));
            if activeSection(index) < mode(activeSection)
                watermarkEx(workingRow,workingColumn) = 1;
            elseif activeSection(index) > mode(activeSection)
                watermarkEx(workingRow,workingColumn) = 0; 
            end
        end
    end
    close(f)
end