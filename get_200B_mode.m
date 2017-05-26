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

modeVal = round(median(mode(:)));
if modeVal == modeCh
    mode = 'V-clamp';
    units = 'pA';
    sciUnits = 1e-12;
elseif modeVal <= 3
    mode = 'I-clamp';
    units = 'mV';
    sciUnits = 1e-3;
end