daqreset

niIO = daq.createSession('ni');
devID = 'Dev1';

niIO.Rate = 1e3;           % Sampling rate in Hz
niIO.DurationInSeconds = 1;

aI = niIO.addAnalogInputChannel(devID,[1 2 3 4 5 6],'Voltage');
chNames = get_channel_names;
for iAI = 1:length(chNames.ai)
    aI(iAI).Name = chNames.ai{iAI};
end

aO(1) = niIO.addAnalogOutputChannel('Dev1','ao0', 'Voltage'); % Signal for valve1 (odor carrier)
aO(2) = niIO.addAnalogOutputChannel('Dev1','ao1', 'Voltage'); % Signal for valve2 (clean carrier)
dO = niIO.addDigitalChannel(devID, {'Port0/Line0:7'}, 'OutputOnly'); % Signal for valve 3 (odor stream)
odorValveOut = zeros(niIO.Rate, 1);
niIO.queueOutputData(repmat(odorValveOut, 1, 10)); 

in = niIO.startForeground; 