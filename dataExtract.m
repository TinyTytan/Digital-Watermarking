function watermarkEx = dataExtract(matrix)
    watermarkEx = NaN(size(matrix,1),size(matrix,2)/3);

    f = waitbar(0,"Extracting Watermark"); % create progress bar

    failex_0 = 0;   % failed to extract 0
    failex_1 = 0;   % failed to extract 1
    tfailex = 0;    % failed to extract anything
    numsucc = 0;    % extracted correct value

    load('watermark.mat');

    for workingRow = 1:size(matrix,1)
        waitbar(workingRow/size(matrix,1)); % update waitbar, progress = current row/total rows

        for workingColumn = 1:size(matrix,2)/3 % for each set of 3 columns

            columnLoc = 3*workingColumn-2; % first element in each set of 3
            activeSection = matrix(workingRow,columnLoc:columnLoc+2); % pull out array of the working elements

            asMedian = median(activeSection);
            [~, index] = max(abs(activeSection - asMedian)); % find index of value furthest from median

            if activeSection(index) < asMedian % if the exceptional value is less than the median, extract 1
                watermarkEx(workingRow,workingColumn) = 1;
                if watermark(workingRow,workingColumn) == 0 % if this was the incorrect value, flag error
                    failex_0 = failex_0 + 1;
                else
                    numsucc = numsucc + 1;
                end
            elseif activeSection(index) > asMedian % if the exceptional value is greater than the median, extract 0
                watermarkEx(workingRow,workingColumn) = 0; 
                if watermark(workingRow,workingColumn) == 1 % if this was the incorrect value, flag error
                    failex_1 = failex_1 + 1;
                else
                    numsucc = numsucc + 1;
                end
            else % if all values are the same, extract 0 and flag error
                watermarkEx(workingRow,workingColumn) = 0;
                tfailex = tfailex + 1;
            end
        end
    end

    close(f) % close progress bar

    % display success rate
    disp(["times failed to extract 1:  " + num2str(failex_1) + "    (" + num2str(100*(failex_1/numel(watermarkEx)),3) + "%)"])
    disp(["times failed to extract 0:  " + num2str(failex_0) + "    (" + num2str(100*(failex_0/numel(watermarkEx)),3) + "%)"])
    disp(["times extraction failed:    " + num2str(tfailex) + "     (" + num2str(100*(tfailex/numel(watermarkEx)),3) + "%)"])
    disp(["times extraction succeeded: " + num2str(numsucc) + "     (" + num2str(100*(numsucc/numel(watermarkEx)),3) + "%)"])
    disp(newline)
end