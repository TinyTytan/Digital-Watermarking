function watermarkEx = dataExtract(matrix)
    watermarkEx = NaN(size(matrix,1),size(matrix,2)/3);

    for workingRow = 1:size(matrix,1)
        for workingColumn = 1:size(matrix,2)/3 % for each set of 3 columns

            columnLoc = 3*workingColumn-2; % first element in each set of 3
            activeSection = matrix(workingRow,columnLoc:columnLoc+2); % pull out array of the working elements

            asMedian = median(activeSection);
            [~, index] = max(abs(activeSection - asMedian)); % find index of value furthest from median

            if activeSection(index) < asMedian % if the exceptional value is less than the median, extract 1
                watermarkEx(workingRow,workingColumn) = 1;
            elseif activeSection(index) > asMedian % if the exceptional value is greater than the median, extract 0
                watermarkEx(workingRow,workingColumn) = 0; 
            else % if all values are the same, extract 0 and flag error
                watermarkEx(workingRow,workingColumn) = 0;
            end
        end
    end
end