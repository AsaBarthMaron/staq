function names = get_channel_names

names.ai{1} = 'Current';         % Current output filtered at 10kHz ?mV/pA
names.ai{2} = '10xVm';           % 10x fixed gain voltage output, no filter
names.ai{3} = 'Scaled output';   
names.ai{4} = 'Gain';            % Gain setting
names.ai{5} = 'Frequency';       % Filter setting
names.ai{6} = 'Mode';            % Amplifier mode

names.do{1} = 'blank';
names.do{2} = 'blank';
names.do{3} = 'blank';
names.do{4} = '2-heptanone, 10^-^8';
names.do{5} = '2-heptanone, 10^-^6';
names.do{6} = '2-heptanone, 10^-^4';
names.do{7} = '2-heptanone, 10^-^2';
names.do{8} = 'blank';
