function [in, daqInfo] = spacer_trial(trialLength,sampRate)
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

aI = niIO.addAnalogInputChannel(devID,[1 2 3 4 5 6],'Voltage');
chNames = get_channel_names;
for iAI = 1:length(chNames.ai)
    aI(iAI).Name = chNames.ai{iAI};
end

in = niIO.startForeground; 

%--------------------------------------------------------------------------
%-Plot data--------------------------------------------
%--------------------------------------------------------------------------

daqInfo.daqRate     = niIO.Rate;
daqInfo.daqChIDs    = {niIO.Channels(:).ID};
daqInfo.daqChNames  = {niIO.Channels(:).Name};
