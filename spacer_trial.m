function [in, daqInfo] = spacer_trial(trialLength, pA, sampRate)
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

aI = niIO.addAnalogInputChannel(devID, [1:15],'Voltage');
[chNames, ~] = get_channel_identities;
for iAI = 1:length(chNames.ai)
    aI(iAI).Name = chNames.ai(iAI);
    aI(iAI).TerminalConfig = 'SingleEnded';
end

aO = niIO.addAnalogOutputChannel('Dev1','ao0', 'Voltage'); % Signal for external command
aO.Name = 'External command';
aO = niIO.addAnalogOutputChannel('Dev1','ao1', 'Voltage'); % Signal for external command
aO.Name = 'External command';

pA = -35;
% commandMag = 0; 
commandMag = 0.5e-3 * pA; % Volts/pA (given 100x gain) * pA
% commandMag = -1; 
extCommand = [zeros(0.5*sampRate,1); ones(0.5*sampRate, 1); zeros((trialLength-1) *sampRate,1)];
extCommand = extCommand * commandMag;
% dO = niIO.addDigitalChannel(devID, {['Port0/Line' num2str(odorChannel)]}, 'OutputOnly'); % Signal for valve 3 (odor stream)
% dO.Name = chNames.do{odorChannel + 1};
% odorValveOut = [ones(trialLength * niIO.Rate, 1)];
niIO.queueOutputData([extCommand extCommand]); 

in = niIO.startForeground; 

%% Calculate input resistance
Rinput(1) = ((median(in(:,3)) - mean(in(0.75*sampRate:(1*sampRate)-1,3))) /100)/(abs(pA) * 1e-12);
Rinput(2) = ((median(in(:,11)) - mean(in(0.75*sampRate:(1*sampRate)-1,11))) /100)/(abs(pA) * 1e-12);

% Rinput = (20e-3)/((median(in(:,3)) - mean(in(0.75*sampRate:(1*sampRate)-1,3))) /20);
%--------------------------------------------------------------------------
%-Plot data--------------------------------------------
%--------------------------------------------------------------------------
disp(['Rinput: ' num2str(Rinput / 1e6) ' MOhms'])
daqInfo.daqRate     = niIO.Rate;
daqInfo.daqChIDs    = {niIO.Channels(:).ID};
daqInfo.daqChNames  = {niIO.Channels(:).Name};
