%--------------------------------------------------------------------------
% Edit for each animal/experiment change
%--------------------------------------------------------------------------
exp.lineName  = 'wild_type';
exp.name = 'test';
exp.number = 1; % Number per day
%--------------------------------------------------------------------------
%-Set up filepaths for logging---------------------------------------------
%--------------------------------------------------------------------------
exp.folderName    = 'Z:\Data\recordings\antennal_LFP';
fullDateTime        = datestr(now,30);
exp.date             = [fullDateTime(1:4), '-', fullDateTime(5:6), '-',...
                        fullDateTime(7:8)];
exp.saveDir = fullfile(exp.folderName, exp.lineName, exp.date);
matSaveFile = [exp.date '_' exp.name '_' num2str(exp.number) '.mat'];
if ~exist(exp.saveDir,'dir')
    mkdir(exp.saveDir);
end
if exist(fullfile(exp.saveDir, matSaveFile))
    exp.number = exp.number + 1;
    matSaveFile = [exp.date '_' exp.name '_' num2str(exp.number) '.mat'];
end
%%
sampRate = 1e4; 
odorTrainDuration = 8; % Duration of odor pulse train in s
trialDuration = 15;
olfCh = 0;           % Indexing for digital outputs starts at 0. NOTE: MUST EDIT get_channel_names.m
nOlfCh = length(olfCh);
nReps = 1;

impulse{1} = [ones((0.02 * sampRate),1)*1; zeros((0.08 * sampRate),1)];
impulse{2} = [ones((0.2 * sampRate),1)*1; zeros((0.38 * sampRate),1)];
impulse{3} = [ones((2 * sampRate),1)*1; zeros((1.58 * sampRate),1)];
% 
% impulse{1} = [zeros((0.02 * sampRate),1)*1; zeros((0.08 * sampRate),1)];
% impulse{2} = [zeros((0.2 * sampRate),1)*1; zeros((0.38 * sampRate),1)];
% impulse{3} = [zeros((2 * sampRate),1)*1; zeros((1.58 * sampRate),1)];

odorSignal(:,1) = [zeros(2 * sampRate, 1); repmat(impulse{1}, 100, 1); zeros(3 * sampRate, 1)];
odorSignal(:,2) = [zeros(2 * sampRate, 1);  repmat(impulse{2}, 18,1); zeros(2.56 * sampRate, 1)];
odorSignal(:,3) = [zeros(2 * sampRate, 1);   repmat(impulse{3}, 3, 1); zeros(ceil(2.26 * sampRate), 1)];

conditions = 1:(nOlfCh * size(odorSignal, 2)); % Gives each condition type a unique ID
conditions = repmat(conditions',nReps,1); % Repeats those IDs by the numebr of trials

randTrials = randsample(conditions, length(conditions)); % Randomizes conditions
% daqInfo = struct;

for iTrial = 1:length(randTrials)
    
    % This performs a remapping from linear space (of unique trial IDs) to 
    % N x 3 space, where N is the number of olfactometer channels, and 3 is
    % the (hard coded) number of odor pulse types.
    [iOdor, pulseType] = ind2sub([length(olfCh), 3], randTrials(iTrial));
    
    [spacer_data(:,:,iTrial), spacer_daqInfo(iTrial)] = spacer_trial(5, olfCh(iOdor),sampRate);
        
        
%     [data(:,:,iTrial), daqInfo(iTrial)] = odor_trial(odorSignal(:, pulseType), olfCh(iOdor), sampRate);
    [data(:,:,iTrial), daqInfo(iTrial)] = odor_trial(odorSignal(:, 3), olfCh(iOdor), sampRate);
    disp(['Trial ' num2str(iTrial) ' of ' num2str(length(randTrials))])
    

    if mod(iTrial,5) == 0
        save(fullfile(exp.saveDir, matSaveFile))
    end
end
