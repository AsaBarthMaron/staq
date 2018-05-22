function [in, daqInfo] = nidaq_trial(varargin)
odorSignal, odorChannel, sampRate)
% Quick and dirty code to acquire patch clamp data while presenting odor
% stimulations
function [scaledData, units, sciUnits] = scale_200B_data(varargin)
% Takes data from the 200B amplifer and scales it to common units (mV, pA)
% Data can be in two formats. First is passed in as an M x N x P array, with M 
% being trial length (in samples), N being various DAC inputs, and P being 
% trials. In this case scaled input is #3, gain is input #4 and mode is input #6. 
% The other format is M x P, where the data is just scaled output, while
% gain and mode arrays are passed in separately.

p = inputParser;
p.KeepUnmatched = false;
p.StructExpand = false;
p.CaseSensitive = false;

p.addRequired('trialLength');
p.addRequired('sampRate');
p.addRequired('nChannels')
p.addRequired('trialType')
p.addOptional('odorSignal',0);
p.addOptional('odorChannel',0);

p.parse(varargin{:});
data = p.Results.data;
gain = p.Results.gain;
mode = p.Results.mode;
trialLength = (length(odorSignal)/sampRate);
%--------------------------------------------------------------------------
%-Base daq devices and channels--------------------------------------------
%--------------------------------------------------------------------------
daqreset

niIO = daq.createSession('ni');
devID = 'Dev1';
niIO.Rate = sampRate;           % Sampling rate in Hz
niIO.DurationInSeconds = trialLength;
aI = niIO.addAnalogInputChannel(devID,[1:7 9:15],'Voltage');
[chNames, ~] = get_channel_identities;
for iAI = 1:length(chNames.ai)
    aI(iAI).Name = chNames.ai(iAI);
    aI(iAI).TerminalConfig = 'Sin gleEnded';
end

dO = niIO.addDigitalChannel(devID, {['Port0/Line0']}, 'OutputOnly'); % Signal for valve 3 (odor stream)
dO.Name = 'Odor valve cmd';

niIO.queueOutputData(odorSignal);
% niIO.queueOutputData([odorSignal*5]); 
in = niIO.startForeground; 
%--------------------------------------------------------------------------
%-Plot data--------------------------------------------
%--------------------------------------------------------------------------

patchTrace = in(:, 3);
odorBlock = odorSignal;
odorBlock(odorSignal == 0) = NaN;
odorBlock = ((odorBlock/5) * max(patchTrace)) + (0.05 * max(patchTrace));

clf
plot((1/niIO.Rate):(1/niIO.Rate):trialLength, ((patchTrace/100) * 1e3))
% a = ((patchTrace/100)/510e6);

% plot((1/niIO.Rate):(1/niIO.Rate):trialLength, a)
% plot((1/niIO.Rate):(1/niIO.Rate):trialLength, patchTrace/0.002)
hold on
% plot((1/niIO.Rate):(1/niIO.Rate):trialLength, medfilt1(patchTrace/0.002, 500))
% plot((1/niIO.Rate):(1/niIO.Rate):trialLength, medfilt1(a, 500))
plot((1/niIO.Rate):(1/niIO.Rate):trialLength, odorBlock, 'k', 'linewidth', 5);
% clf
% plot(downsample((patchTrace*10), 10))
% hold on
% plot(downsample(odorBlock, 10), 'k', 'linewidth', 5);
axis tight
xlabel('Seconds')
ylabel('Membrane voltage (Vm)')
% ylabel('pA')
title(chNames.do(odorChannel + 1))

daqInfo.daqRate     = niIO.Rate;
daqInfo.daqChIDs    = {niIO.Channels(:).ID};
daqInfo.daqChNames  = {niIO.Channels(:).Name};
