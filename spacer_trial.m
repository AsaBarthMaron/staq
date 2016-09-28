function [in, daqInfo] = spacer_trial(trialLength, odorChannel, sampRate)
% Quick and dirty code to acquire patch clamp data while presenting odor
% stimulations

%--------------------------------------------------------------------------
%-Base daq devices and channels--------------------------------------------
%--------------------------------------------------------------------------
daqreset

niIO = daq.createSession('ni');
devID = 'Dev1';

niIO.Rate = sampRate;           % Sampling rate in Hz
niIO.DurationInSeconds = trialLength;

aI = niIO.addAnalogInputChannel(devID,[1 2 3 4 5 6 7],'Voltage');
chNames = get_channel_names;
for iAI = 1:length(chNames.ai)
    aI(iAI).Name = chNames.ai{iAI};
end

aO = niIO.addAnalogOutputChannel('Dev1','ao1', 'Voltage'); % Signal for external command
aO.Name = 'External command';

% commandMag = 0;
commandMag = -0.004 * 5; % Volts/pA (given 100x gain) * pA
extCommand = [zeros(0.5*sampRate,1); ones(0.5*sampRate, 1); zeros((trialLength-1) *sampRate,1)];
extCommand = extCommand * commandMag;
% dO = niIO.addDigitalChannel(devID, {['Port0/Line' num2str(odorChannel)]}, 'OutputOnly'); % Signal for valve 3 (odor stream)
% dO.Name = chNames.do{odorChannel + 1};
% odorValveOut = [ones(trialLength * niIO.Rate, 1)];
niIO.queueOutputData(extCommand); 

in = niIO.startForeground; 

%--------------------------------------------------------------------------
%-Plot data--------------------------------------------
%--------------------------------------------------------------------------

daqInfo.daqRate     = niIO.Rate;
daqInfo.daqChIDs    = {niIO.Channels(:).ID};
daqInfo.daqChNames  = {niIO.Channels(:).Name};
