function [in, daqInfo] = odor_trial(odorSignal, odorChannel,sampRate)
% Quick and dirty code to acquire patch clamp data while presenting odor
% stimulations

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
    aI(iAI).TerminalConfig = 'SingleEnded';
end
% aO = niIO.addAnalogOutputChannel('Dev1','ao1', 'Voltage'); % Signal for valve1 (odor carrier)
% aO.Name = 'Shutter Signal';
dO = niIO.addDigitalChannel(devID, {['Port0/Line0']}, 'OutputOnly'); % Signal for valve 3 (odor stream)
dO.Name = 'Odor valve cmd';

% shutterSignal = [zeros((2 * sampRate),1); ones((0.5 * sampRate),1)*5; zeros((4.5 * sampRate),1)];
% shutterSignal = [zeros((3 * sampRate),1); ones((4 * sampRate),1)*5; zeros((3 * sampRate),1)];
% shutterSignal = [zeros((3 * sampRate),1); zeros((4 * sampRate),1)*5; zeros((3 * sampRate),1)];



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
