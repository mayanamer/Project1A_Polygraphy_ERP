% Define the folder containing the Excel files
folder = './probe_excel_per_subject';

% Get a list of all Excel files in the folder
fileList = dir(fullfile(folder, '*.xlsx'));

% Define the sheets and strings for find and replace
sheets = {'Sheet1'}; % List of sheet names
findStr = 'p3-fp1';  % String to find
replaceStr = 'p3_fp1';  % String to replace with

% Loop through each file
for fileIdx = 1:length(fileList)
    % Get the current file name
    filename = fullfile(folder, fileList(fileIdx).name);
    fprintf('Processing file: %s\n', filename);
    
    % Loop through each sheet in the current file
    for sheetIdx = 1:length(sheets)
        % Read the data from the current sheet
        try
            data = readtable(filename, 'Sheet', sheets {sheetIdx});
        catch
            warning('Could not read sheet %s in file %s. Skipping...', sheets{sheetIdx}, filename);
            continue;
        end
        
        % Convert table to cell array for easier manipulation
        dataCell = table2cell(data);
        
        % Perform find and replace in the cell array
        dataCell = cellfun(@(x) strrep(x, findStr, replaceStr), dataCell, 'UniformOutput', false);
        
        % Convert the cell array back to a table
        data = cell2table(dataCell, 'VariableNames', data.Properties.VariableNames);
        
        % Write the modified data back to the same sheet
        writetable(data, filename, 'Sheet', sheets{sheetIdx});
    end
end

disp('Find and replace operation completed for all files.');

