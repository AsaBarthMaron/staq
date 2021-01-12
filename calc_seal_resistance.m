function Rseal = calc_seal_resistance(data, sampRate)
% calc_seal_resistance calculates seal resistance from a seal test
% Inputs:
%   data - 200B amplifer data
%   sampRate    - INCORRECT
% Outputs:
%   Rseal - Resistance in units of MOhms

VStepMag = 5e-3;    % 200B seal test is 5mV

% Get *all* the rising edges of the amplifier seal test voltage step
rising = find_rising(data);
rising = round(rising);

% Scale data & remove second amplifier channel
[data, ~, IUnits, ~] = scale_200B_data(data);
IUnits = IUnits(:,1);
data = data(:,1);

% Set baseline and step data window parameters
% period = round((sampRate) / (60)); 
period = median(diff(rising));  % Wow I just realized there's a mismatch 
                                % between actual sampling rate and the
                                % sampRate variable. I knew this (DAC
                                % limitation causes it to sample at ~66.6K
                                % instead of 100K) but didn't realize that
                                % sampRate was then incorrect in all the
                                % data acquired with that rate.

% Due to the incorrect sampRate problem I will check the actual period
% against the period predicted by sampRate. Then correct sampRate
pRatio = period / round((sampRate) / (60));
if (pRatio < 0.95) || (pRatio > 1.05)
%     sampRate = round(sampRate * pRatio);  % This is what you would do if 
                                            % real sampling rate is unkown
    sampRate = round(sampRate * (2/3));     % I happen to know the real 
                                            % sampling rate. But this
                                            % should be changed back if the
                                            % real sampling rate changes or
                                            % becomes uncertain.
end

buff = round(0.001 * sampRate); % Short buffer to ignore noisiness and capacitance
windowLength = floor(period/4); % Get half of the step 
iBaselineStart = rising - windowLength;
iStepStart = rising + windowLength;
iStepStop = rising + floor(period/2) - buff; 

% Find baseline and step data
for iCycle = 1:length(rising)
    baseline(:, iCycle) = data(iBaselineStart(iCycle):...
                               (rising(iCycle) - buff));
    step(:, iCycle) = data(iStepStart(iCycle):iStepStop(iCycle));
end

baseline = mean(baseline, 1)';
step = mean(step, 1)';

% Calculate seal current 
sealCurrent = step - baseline;
sealCurrent = mean(sealCurrent);

% Calculate seal resistance
Rseal = VStepMag / (sealCurrent * IUnits);
Rseal = Rseal / 1e6;  % Output in units of MOhm
end