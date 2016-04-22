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
aI = niIO.addAnalogInputChannel(devID,[1 2 3 4 5 6],'Voltage');
chNames = get_channel_names;
for iAI = 1:length(chNames.ai)
    aI(iAI).Name = chNames.ai{iAI};
end
aO(1) = niIO.addAnalogOutputChannel('Dev1','ao0', 'Voltage'); % Signal for valve1 (odor carrier)
aO(2) = niIO.addAnalogOutputChannel('Dev1','ao1', 'Voltage'); % Signal for valve2 (clean carrier)
dO = niIO.addDigitalChannel(devID, {['Port0/Line' num2str(odorChannel)]}, 'OutputOnly'); % Signal for valve 3 (odor stream)
aO(1).Name = 'Odor carrier';
aO(2).Name = 'Clean carrier';
dO.Name = chNames.do{odorChannel + 1};


% impulse = ones(6 * niIO.Rate,1);
% impulse = [ones((0.5 * niIO.Rate),1)*1; zeros((0.5 * niIO.Rate),1)];
carrier1out = odorSignal * 5;
carrier2out = odorSignal * 5;
odorValveOut = [zeros(0.5*sampRate,1); ones((trialLength-1) * niIO.Rate, 1); zeros(0.5*sampRate,1)];
% odorValveOut = [zeros(0.5*sampRate,1); zeros((trialLength-1) * niIO.Rate, 1); zeros(0.5*sampRate,1)];
niIO.queueOutputData([carrier1out carrier2out odorValveOut]); 
in = niIO.startForeground; 
%--------------------------------------------------------------------------
%-Plot data--------------------------------------------
%--------------------------------------------------------------------------

patchTrace = in(:, 3);
odorBlock = carrier1out;
odorBlock(carrier1out == 0) = NaN;
odorBlock = ((odorBlock/5) * max(patchTrace)) + (0.05 * max(patchTrace));

clf
plot((1/niIO.Rate):(1/niIO.Rate):trialLength, patchTrace)
hold on
plot((1/niIO.Rate):(1/niIO.Rate):trialLength, odorBlock, 'k', 'linewidth', 5);
axis tight
xlabel('Seconds')
ylabel('Membrane voltage (Vm)')
title(chNames.do{odorChannel + 1})

daqInfo.daqRate     = niIO.Rate;
daqInfo.daqChIDs    = {niIO.Channels(:).ID};
daqInfo.daqChNames  = {niIO.Channels(:).Name};