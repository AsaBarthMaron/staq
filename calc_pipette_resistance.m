function Rpipette = calc_pipette_resistance(data, sampRate)
% calc_pipette_resistance calculates pipette resistance from a seal test
% Inputs:
%   data - 200B amplifer data
%   sampRate
% Outputs:
%   Rpipette - Resistance in units of MOhms

VStepMag = 5e-3;    % 200B seal test is 5mV

% Get *all* the rising edges of the amplifier seal test voltage step
rising = find_rising(data);
rising = round(rising);

% Scale data & remove second amplifier channel
[data, ~, IUnits, ~] = scale_200B_data(data);
IUnits = IUnits(:,1);
data = data(:,1);

% Set baseline and step data window parameters
% period = round((sampRate * trialLength) / (60 * trialLength));
period = median(diff(rising));
windowLength = floor(period/3); % Just a trick to get most, but not all, of the step 
iStart = rising - windowLength;
iStop = rising + windowLength;
buff = 0.001 * sampRate; % Short buffer to ignore noisiness and capacitance

% Find baseline and step data
for iCycle = 1:length(rising)
    baseline(iCycle) = mean(data(iStart(iCycle):(rising(iCycle) - buff)));
    step(iCycle) = mean(data((rising(iCycle) + buff):iStop(iCycle)));
end

% Calculate pipette current 
pipetteCurrent = step - baseline;
pipetteCurrent = mean(pipetteCurrent);

Rpipette = VStepMag / (pipetteCurrent * IUnits);
Rpipette = Rpipette / 1e6;  % Output in units of MOhm
end