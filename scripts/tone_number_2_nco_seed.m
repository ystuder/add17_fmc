% This script can be used to convert MIDI Tone numbers into seed
% values for an NCO, which can then be used in a VHDL look-up table.

% MIDI tone numbers 
% 63:50 ==> not used = 0
% 49:1  ==> 440.0:27.5 Hz
% 0     ==> tone off = 0
tn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 ....
      440.000 415.305 391.995 369.994 349.228 329.628 311.127 293.665 277.183...
      261.626 246.942 233.082 220.000 207.652 195.998 184.997 174.614 164.814...
      155.563 146.832 138.591 130.813 123.471 116.541 110.000 103.826 97.9989...
      92.4986 87.3071 82.4069 77.7817 73.4162 69.2957 65.4064 61.7354 58.2705...
      55.0000 51.9131 48.9994 46.2493 43.6535 41.2034 38.8909 36.7081 34.6478...
      32.7032 30.8677 29.1352 27.5000 0];
% clock frequency of NCO [Hz]
f_clk = 1e+06; % 1 MHz
% number of NCO accu bits
N = 24;
% generate LUT values
seed = round(tn*(2^N)/f_clk);
% format and print LUT values for usage in VHDL
str1=sprintf(num2str(seed));
k=1;
new_gap=1;
str2='';
for i=1:length(str1)
    if str1(i)>47
        str2(k) = str1(i);
        k=k+1;
        new_gap = 1;
    elseif new_gap
        str2(k) = ',';
        k=k+1;
        new_gap = 0;
    end
end
sprintf(str2)



