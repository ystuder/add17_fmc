% This script can be used to convert data for one MIDI channel perpared in csv
% format into a .mif file for ROM initialization.
% NOTE: The CR at the end of the last line in the generated .mif file
%       must be removed manually!!
%
% .csv format: col_1        col_2
%              tone_number  absolute time         
% .mif format: 
%         Bit: 19   ...    6 5   ...   0
%              tone_duration tone_number
%                   [ms]     [MIDI key #]

% for each of the 8 channels do
for f=0:7
    %% read in csv file for Channel i
    f_csv = ['Pirate_ch'  num2str(f) '.csv'];
    csv = dlmread(f_csv);
    % format csv data for .mif file generation
    mif = zeros(size(csv,1),1);
    for i=1:size(csv,1)-1
        mif(i)= (csv(i+1,2)-csv(i,2))*(2^6) + csv(i,1);
    end
    % add EOF in last row of mif.file
    mif(size(csv,1)) = 2^20-1;
    % write .mif file in binary format
    f_mif = ['fmc_rom_' num2str(f) '.mif'];
    write(table(dec2bin(mif,20)), f_mif, 'FileType', 'text', 'WriteVariableNames', false);    
end
