function f_excelwrite

Analysisfolder  = [pwd '\Analysis'];    %Analysis Folder
Scatfolder      = [pwd '\scat_data'];   %Scatter Folder

ExcelApp = acxserver('Excel.Application');
%Show window (optional)
ExcelApp.Visible = 1;
%Open file located in the current folder
ExcelApp.Workbooks.Open(fullfile(Analysisfolder, '\myFile.xlsx'));

% Run Macro1, defined in "ThisWorkBook" with one parameter. A return value cannot be retrieved.
ExcelApp.Run('ThisWorkBook.Macro1', parameter1);
% Run Macro2, defined in "Sheet1" with two parameters. A return value cannot be retrieved.
ExcelApp.Run('Sheet1.Macro2', parameter1, parameter2);
% Run Macro3, defined in the module "Module1" with no parameters and a return value.
retVal = ExcelApp.Run('Macro3');
% Quit application and release object.
ExcelApp.Quit;
ExcelApp.release;

end
