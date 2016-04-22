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

aI = niIO.addAnalogInputChannel(devID,[1 2 3 4 5 6],'Voltage');
chNames = get_channel_names;
for iAI = 1:length(chNames.ai)
    aI(iAI).Name = chNames.ai{iAI};
end

dO = niIO.addDigitalChannel(devID, {['Port0/Line' num2str(odorChannel)]}, 'OutputOnly'); % Signal for valve 3 (odor stream)
dO.Name = chNames.do{odorChannel + 1};
odorValveOut = [ones(trialLength * niIO.Rate, 1)];
niIO.queueOutputData([odorValveOut]); 

in = niIO.startForeground; 

%--------------------------------------------------------------------------
%-Plot data--------------------------------------------
%--------------------------------------------------------------------------

daqInfo.daqRate     = niIO.Rate;
daqInfo.daqChIDs    = {niIO.Channels(:).ID};
daqInfo.daqChNames  = {niIO.Channels(:).Name};
