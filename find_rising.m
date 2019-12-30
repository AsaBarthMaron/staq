function rising = find_rising(data)
% find_rising finds the indices of all (except first and last) rising edges
% of the amplifier seal test command (5mV, 60Hz freq).
%   data - 200B amplifer data, channel 2 assumed to be 10xVm

sealTest = data(:,2);  % Note, assuming ch2 is 10x Vm

[D, rising] = dutycycle(sealTest);
exclude  = [find(D < 0.45); find(D > 0.55)];
D([1; exclude; end]) = [];
rising([1; exclude; end]) = [];
end