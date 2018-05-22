function [in, daqInfo] = spacer_trial(extCommand, sampRate)
% Quick and dirty code to acquire patch clamp data while presenting odor
% stimulations

%--------------------------------------------------------------------------
%-Base daq devices and channels--------------------------------------------
%--------------------------------------------------------------------------
daqreset

niIO = daq.createSession('ni');
devID = 'Dev1';

niIO.Rate = sampRate;           % Sampling rate in Hz
trialLength = (length(extCommand)/sampRate);
niIO.DurationInSeconds = trialLength;

aI = niIO.addAnalogInputChannel(devID,[1:15],'Voltage');
[chNames, ~] = get_channel_identities;
for iAI = 1:length(chNames.ai)
    aI(iAI).Name = chNames.ai(iAI);
    aI(iAI).TerminalConfig = 'SingleEnded';
end

aO = niIO.addAnalogOutputChannel('Dev1','ao0', 'Voltage'); % Signal for external command
aO.Name = 'External command';
aO = niIO.addAnalogOutputChannel('Dev1','ao1', 'Voltage'); % Signal for external command
aO.Name = 'External command';

niIO.queueOutputData([extCommand extCommand]); 
in = niIO.startForeground; 

%% Calculate input resistance
%--------------------------------------------------------------------------
%-Plot data--------------------------------------------
%--------------------------------------------------------------------------
daqInfo.daqRate     = niIO.Rate;
daqInfo.daqChIDs    = {niIO.Channels(:).ID};
daqInfo.daqChNames  = {niIO.Channels(:).Name};
