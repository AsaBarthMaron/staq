function run_current_stim_trial(nReps)
%--------------------------------------------------------------------------
% Edit for each animal/experiment change
%--------------------------------------------------------------------------
exp.lineName  = 'GMR59C05-gal4';
exp.name = 'current_steps_right_only_hyp_2';
exp.number = 1; % Number per day
%--------------------------------------------------------------------------
%-Set up filepaths for logging---------------------------------------------
%--------------------------------------------------------------------------
exp.folderName    = 'Z:\Data\recordings\LN_dynamics\';
fullDateTime        = datestr(now,30);
exp.date             = [fullDateTime(1:4), '-', fullDateTime(5:6), '-',...
                        fullDateTime(7:8)];
exp.saveDir = fullfile(exp.folderName, exp.lineName, exp.date);
matSaveFile = [exp.date '_' exp.name '_' num2str(exp.number) '.mat'];
if ~exist(exp.saveDir,'dir')
    mkdir(exp.saveDir);
end
while exist(fullfile(exp.saveDir, matSaveFile))
    exp.number = exp.number + 1;
    matSaveFile = [exp.date '_' exp.name '_' num2str(exp.number) '.mat'];
end
%%
pA = 7;
sampRate = 1e4; 
stimTrainDuration = 3; % Duration of odor pulse train in s
trialDuration = 15;

% commandMag = 1; % Volts/pA (given 100x gain) * pA
commandMag = 0.5e-3 * pA; % Volts/pA (given 100x gain) * pA
extCommand(:,1) = [zeros(1*sampRate,1); ones(3*sampRate, 1) * -1; zeros(4 *sampRate,1)];
% extCommand(:,2) = [zeros(1*sampRate,1); ones(3*sampRate, 1) * -1; zeros(4 *sampRate,1)];
% extCommand(:,3) = [zeros(1*sampRate,1); ones(3*sampRate, 1) * 0.5; zeros(4 *sampRate,1)];
% extCommand(:,4) = [zeros(1*sampRate,1); ones(3*sampRate, 1) * -0.5; zeros(4 *sampRate,1)];

extCommand = extCommand * commandMag;

% trialOrder = repmat([1 2 3 4], 1, nReps);
trialOrder = repmat([1], 1, nReps);


for iTrial = 1:length(trialOrder)
    
        
    [data(:,:,iTrial), daqInfo(iTrial)] = current_step_trial(extCommand(:, trialOrder(iTrial)), sampRate);
    disp(['Trial ' num2str(iTrial) ' of ' num2str(length(trialOrder))])
    clf
    plot((data(:,3,iTrial) /100 * 1e3))
    hold on
    plot((data(:,11,iTrial) /100 * 1e3))
    
%     save(fullfile(exp.saveDir, matSaveFile))
    if mod(iTrial,5) == 0
%         save(fullfile(exp.saveDir, matSaveFile))
    end
end
save(fullfile(exp.saveDir, matSaveFile), '-v7.3')