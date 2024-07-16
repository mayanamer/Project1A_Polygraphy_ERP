T = cell2table(table);  % Adjust 'VariableNames' for more columns.
disp(T);
% Write the table to an Excel file
filename = 'feat_table_final_w_irr_tar_only_lying_probe.xlsx';
writetable(T, filename);