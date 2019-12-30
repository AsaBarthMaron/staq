function Rseal = calc_series_resistance(data, sampRate)
% calc_seal_resistance calculates seal resistance from a seal test
% Inputs:
%   data - 200B amplifer data
%   sampRate    - INCORRECT
% Outputs:
%   Rseal - Resistance in units of MOhms

%% Find rising edges, scale data,  clean data, set parameters
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

%% Find all the tranisents
iStart = rising - floor(period/8);
iStop = rising + floor(period/8);

for iRising = 1:length(rising)
    window = iStart(iRising):iStop(iRising);
    tmpData(:, iRising, 1) = data(window);
    tmpData(:, iRising, 2) = data(window + (period/2)) * -1;
end
tmpData = reshape(tmpData, size(tmpData, 1), size(tmpData, 2) * size(tmpData, 3));
[tmpData, peakLoc] = peak_align(tmpData);
tmpData = tmpData - mean(tmpData(1:100, :));
close all
plot(tmpData)
hold on
plot(mean(tmpData,2), 'k', 'linewidth', 2)

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

% Throw out baseline & step trials where variance is too high, i.e., when
% there may be spiking or other non-stationary behavior.
baselineVar = var(baseline);
stepVar = var(step);
iDiscard = baselineVar > (3 * std(baselineVar));   % This doesn't really 
                                                   % quite make sense since
                                                   % baselineVar is NOT
                                                   % normally distributed
                                                   % at all. But it's a hack
iDiscard(stepVar > (3 * std(stepVar))) = 1;
baseline(:, iDiscard) = [];
baseline = mean(baseline)';
step(:, iDiscard) = [];
step = mean(step)';

% Calculate seal current 
sealCurrent = step - baseline;
sealCurrent = mean(sealCurrent);

% Calculate seal resistance
Rseal = VStepMag / (sealCurrent * IUnits);
Rseal = Rseal / 1e6;  % Output in units of MOhm
end