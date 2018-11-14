function [mode,  units, sciUnits] = get_200B_mode(varargin)

p = inputParser;
p.KeepUnmatched = false;
p.StructExpand = false;
p.CaseSensitive = false;

p.addOptional('mode',0);
p.addOptional('data',0);

p.parse(varargin{:});
data = p.Results.data;
mode = p.Results.mode; 

[~, name2num] = get_channel_identities;
modeCh = name2num.ai('Mode');

if (mode == 0) 
    mode = squeeze(data(:,modeCh,:));
% elseif (mode == 0) && (data == 0)
%     error('Provide an input')
end

if modeCh > 1
    mode = permute(mode, [1 3 2]);
    mode = reshape(mode, size(mode, 1) * size(mode, 2), size(mode, 3));
    modeVal = round(median(mode));
else
    modeVal = round(median(mode(:)));
end
clear mode

for iMode = 1:length(modeVal)
    if modeVal(iMode) == 6
        mode(iMode,:) = 'V-clamp';
        units(iMode,:) = 'pA';
        sciUnits(iMode) = 1e-12;
    elseif modeVal(iMode) <= 3
        mode(iMode,:) = 'I-clamp';
        units(iMode,:) = 'mV';
        sciUnits(iMode) = 1e-3;
    end
end