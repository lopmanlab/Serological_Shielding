function textHeader = write_csv_header(CellArray_Headers, FileName)
    % helper function
    % takes cell array of headers and writes them to a csv
    % I stole this from the internet. My primary language is R. I don't
    % know how to do simple things in MatLab.
    commaHeader = [CellArray_Headers;repmat({','},1,numel(CellArray_Headers))]; %insert commaas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    %write header to file
    fid_out = fopen(FileName, 'w'); 
    fprintf(fid_out,'%s\n',textHeader);
    fclose(fid_out);
end