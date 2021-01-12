function run_voltage_step_trial(nReps)
%--------------------------------------------------------------------------
% Edit for each animal/experiment change
%--------------------------------------------------------------------------
% exp.lineName  = 'R24C12-gal4_X_20x-UAS-GtACR2_unlabeled';
% exp.lineName  = 'R78F09-Gal4_ACR1 R26A01-LexA_LexAop-mCD8-GFP_LN';
% exp.lineName = 'R78F09-Gal4';
exp.lineName  = 'R78F09-Gal4_GFP R60F02-LexA_Chrimson_LN';
% exp.name = 'voltage_steps_1uM_TTX_5mM_4-AP_10mM_TEA';
exp.name = 'voltage_steps_1uM_TTX';
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
sampRate = 2e4; 

extCommand = [zeros(0.5*sampRate,1);...
              ones(0.5*sampRate, 1);...
              zeros(2 *sampRate,1)];

odorSignal = zeros(length(extCommand), 1);
ledSignal = [ones(1.5 * sampRate, 1);...
             zeros(1.5 * sampRate, 1)];
         
mVSteps = [-40, -20, -10, 10, 20, 40] * 1e-3;
nSteps = length(mVSteps);

trialOrder(1:2:(2 * nSteps * nReps)) = repmat(1:nSteps, 1, nReps);
trialOrder(2:2:(2 * nSteps * nReps)) = repmat(1:nSteps, 1, nReps);
trialOrder = [1, trialOrder];

storedLEDSig = ledSignal;
storedExtCommand = extCommand;
for iTrial = 1:length(trialOrder)
    
    extCommand = storedExtCommand ...
                 * mVSteps(trialOrder(iTrial))...
                 * 50;   % Hard coded scaling factor for 200B (front-switched)
    
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