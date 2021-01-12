function stim_from_hyperpolarized(nReps)
%--------------------------------------------------------------------------
% Edit for each animal/experiment change
%--------------------------------------------------------------------------
exp.lineName  = 'R78F09-Gal4_GFP R60F02-LexA_Chrimson_LN';
exp.number = 1; % Number per day
exp.name = 'hyp_odor';
%--------------------------------------------------------------------------
%-Set up filepaths for logging---------------------------------------------
%--------------------------------------------------------------------------
exp.folderName    = 'Z:\Data\recordings\optogenetic_LN_stim\';
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
sampRate = 2e4; 
blockType = 'hyp_odor';

hypStep = [zeros(1 * sampRate, 1);...
           ones(0.5 * sampRate, 1)];
switch blockType
    case 'hyp_dep'
        depStep = [ones(0.2 * sampRate, 1);...
                   zeros(2.3 * sampRate, 1)];
        trialLength = length(hypStep) + length(depStep);
        odorSignal = zeros(trialLength, 1);
        
        ledSignal = [zeros(0.5 * sampRate, 1);...
        ones(2 * sampRate, 1);...
        zeros(1.5 * sampRate, 1)];
    case 'hyp_odor'
        odorSignal = [zeros(length(hypStep), 1);...
                      ones(0.5 * sampRate, 1);...
                      zeros(2 * sampRate, 1)];
        depStep = zeros(2.5 * sampRate, 1);
        ledSignal = [zeros(0.5 * sampRate, 1);...
        ones(2 * sampRate, 1);...
        zeros(1.5 * sampRate, 1)];
end

% pASteps = [0:25:75] * -1;      % Magnitude of hyperpolarizing steps
pASteps = [0, 80] * -1;      % Magnitude of hyperpolarizing steps
% pASteps = [0:30:90] * -1;      % Magnitude of hyperpolarizing steps
depMag = 150;           % Magnitude of depolarizing step, ignored if odor
nSteps = length(pASteps);

trialOrder(1:2:(2 * nSteps * nReps)) = repmat(1:nSteps, 1, nReps);
trialOrder(2:2:(2 * nSteps * nReps)) = repmat(1:nSteps, 1, nReps);
trialOrder = [1, trialOrder];

storedLEDSig = ledSignal;
for iTrial = 1:length(trialOrder)
        
    extCommand = [hypStep * pASteps(trialOrder(iTrial));...
                  depStep * depMag];
    extCommand = extCommand * 0.5e-3;   % Hard coded scaling factor for 100x gain
    
    ledSignal = zeros(length(ledSignal),1);
    if ((iTrial > 1) && (mod(iTrial,2)))
        ledSignal = storedLEDSig;
    end
    disp(['Trial ' num2str(iTrial) ' of ' num2str(length(trialOrder))])

    [data(:,:,iTrial), daqInfo(iTrial)] = trial(odorSignal, ledSignal, extCommand, sampRate);
 
%     save(fullfile(exp.saveDir, matSaveFile))
    if mod(iTrial,5) == 0
%         save(fullfile(exp.saveDir, matSaveFile))
    end
    title(num2str(iTrial))
end
save(fullfile(exp.saveDir, matSaveFile), '-v7.3')