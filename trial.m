function [in, daqInfo] = trial(odorSignal, ledSignal, extCmd, sampRate)
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

% Set analog & digital outputs
aO(1) = niIO.addAnalogOutputChannel('Dev2','ao0', 'Voltage'); % Signal for valve1 (odor carrier)
aO(1).Name = 'LED Signal';
aO(2) = niIO.addAnalogOutputChannel('Dev1','ao0', 'Voltage'); % Signal for external command
aO(2).Name = 'External command';
dO = niIO.addDigitalChannel(devID, {['Port0/Line0']}, 'OutputOnly'); % Signal for valve 3 (odor stream)
dO.Name = 'Odor valve cmd';


niIO.queueOutputData([ledSignal*5 extCmd odorSignal]);
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

extCmd = extCmd * 100;

clf
plot((1/niIO.Rate):(1/niIO.Rate):trialLength, ((patchTrace(:,1)/100) * 1e3))
hold on
plot((1/niIO.Rate):(1/niIO.Rate):trialLength, odorBlock, 'k', 'linewidth', 5);
plot((1/niIO.Rate):(1/niIO.Rate):trialLength, ledBlock + 1, 'b', 'linewidth', 5);
plot((1/niIO.Rate):(1/niIO.Rate):trialLength, extCmd -5, 'r', 'linewidth', 5);
% plot((1/niIO.Rate):(1/niIO.Rate):trialLength, odorSignal -10, 'r', 'linewidth', 5);
% plot((1/niIO.Rate):(1/niIO.Rate):trialLength, ledSignal -15, 'r', 'linewidth', 5);


axis tight
% axis([0 11 -60 0 ])
xlabel('Seconds')
% ylabel('Membrane voltage (Vm)')
ylabel('pA')
ylim([-140 80])
% ylim([-65 5])

daqInfo.daqRate     = niIO.Rate;
daqInfo.daqChIDs    = {niIO.Channels(:).ID};
daqInfo.daqChNames  = {niIO.Channels(:).Name};
