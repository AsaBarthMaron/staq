function [in, daqInfo] = odor_trial(odorSignal, odorChannel,sampRate, ledSignal)
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
% aI = niIO.addAnalogInputChannel(devID,[1:15],'Voltage');
aI = niIO.addAnalogInputChannel(devID,[1:7],'Voltage');
[chNames, ~] = get_channel_identities;
for iAI = 1:length(chNames.ai)
    aI(iAI).Name = chNames.ai(iAI);
    aI(iAI).TerminalConfig = 'SingleEnded';
end
aO = niIO.addAnalogOutputChannel('Dev2','ao0', 'Voltage'); % Signal for valve1 (odor carrier)
aO.Name = 'LED Signal';
dO = niIO.addDigitalChannel(devID, {['Port0/Line0']}, 'OutputOnly'); % Signal for valve 3 (odor stream)
dO.Name = 'Odor valve cmd';

% aO_ext = niIO.addAnalogOutputChannel('Dev1','ao0', 'Voltage'); % Signal for external command
% aO.Name = 'External command';

% pA = -40;
% commandMag = 0.5e-3 * pA; % Volts/pA (given 100x gain) * pA
% extCommand = [zeros(2.25*sampRate,1); ones(0.75*sampRate, 1); zeros(3.5 *sampRate,1)];
% extCommand = extCommand * commandMag;
% 
% niIO.queueOutputData([ledSignal*5 odorSignal extCommand]);
niIO.queueOutputData([ledSignal*5 odorSignal]); 
in = niIO.startForeground; 
%--------------------------------------------------------------------------
%-Plot data--------------------------------------------
%--------------------------------------------------------------------------

patchCh = 3;
patchTrace(:,1) = in(:, patchCh);
% patchTrace(:,2) = in(:, 11);
odorBlock = odorSignal;
odorBlock(odorSignal == 0) = NaN;
odorBlock = ((odorBlock/5) * max(patchTrace(:,1))) + (0.05 * max(patchTrace(:,1)));

ledBlock = ledSignal;
ledBlock(ledSignal == 0) = NaN;
ledBlock = ((ledBlock/5) * max(patchTrace(:,1))) + (0.05 * max(patchTrace(:,1)));


clf
plot((1/niIO.Rate):(1/niIO.Rate):trialLength, ((patchTrace(:,1)/100) * 1e3))
hold on
% plot((1/niIO.Rate):(1/niIO.Rate):trialLength, ((patchTrace(:,2)/100) * 1e3))

% a = ((patchTrace/100)/510e6);

% plot((1/niIO.Rate):(1/niIO.Rate):trialLength, a)
% plot((1/niIO.Rate):(1/niIO.Rate):trialLength, patchTrace/0.002)
hold on
% plot((1/niIO.Rate):(1/niIO.Rate):trialLength, medfilt1(patchTrace/0.002, 500))
% plot((1/niIO.Rate):(1/niIO.Rate):trialLength, medfilt1(a, 500))
plot((1/niIO.Rate):(1/niIO.Rate):trialLength, odorBlock, 'k', 'linewidth', 5);
plot((1/niIO.Rate):(1/niIO.Rate):trialLength, ledBlock + 1, 'b', 'linewidth', 5);
% clf
% plot(downsample((patchTrace*10), 10))
% hold on
% plot(downsample(odorBlock, 10), 'k', 'linewidth', 5);
axis tight
% axis([0 11 -60 0 ])
xlabel('Seconds')
ylabel('Membrane voltage (Vm)')
% ylabel('pA')
title(chNames.do(odorChannel + 1))
% ylim([0 80])
ylim([-65 5])

daqInfo.daqRate     = niIO.Rate;
daqInfo.daqChIDs    = {niIO.Channels(:).ID};
daqInfo.daqChNames  = {niIO.Channels(:).Name};
