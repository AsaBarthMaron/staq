function [num2name, name2num] = get_channel_identities

% Amplifier inputs for RIGHT amplifier (green)
ai{1} = 'Current';         % Current output filtered at 10kHz ?mV/pA
ai{2} = '10xVm';           % 10x fixed gain voltage output, no filter
ai{3} = 'Scaled output';   
ai{4} = 'Gain';            % Gain setting
ai{5} = 'Frequency';       % Filter setting
ai{6} = 'Mode';            % Amplifier mode
ai{7} = 'Stimulus output';

% Values for name2num container
numVal = {[1, 9];
          [2, 10]
          [3, 11]
          [4, 12]
          [5, 13]
          [6, 14]
          [7, 15]};

% ai{8} = '';
% % Amplifier inputs for LEFT amplifier (blue)
% ai{9} = 'Current';         % Current output filtered at 10kHz ?mV/pA
% ai{10} = '10xVm';           % 10x fixed gain voltage output, no filter
% ai{11} = 'Scaled output';   
% ai{12} = 'Gain';            % Gain setting
% ai{13} = 'Frequency';       % Filter setting
% ai{14} = 'Mode';            % Amplifier mode
% ai{15} = 'Stimulus output';

do{1} = '590-605nm light';
do{2} = 'blank';
do{3} = 'paraffin oil 1';
do{4} = '2-heptanone, 10^-^8';
do{5} = '2-heptanone, 10^-^6';
do{6} = '2-heptanone, 10^-^4';
do{7} = '2-heptanone, 10^-^2';
do{8} = 'paraffin oil 2';

num2name.ai = containers.Map(1:length(ai), ai);
num2name.do = containers.Map(1:length(do), do);

name2num.ai = containers.Map(ai, numVal);
% name2num.ai = containers.Map(ai, 1:length(ai));
name2num.do = containers.Map(do, 1:length(do));
