clear
% label = 'Vclamp_bath';
% label = 'Vclamp_seal' ;
% label = 'Vclamp_seal_spikes';
% label = 'Vclamp_cell'; 



% % label = 'Iclamp_seal';
% label = 'Iclamp_whole_cell_current_step';
% label = 'Iclamp_fast_whole_cell_current_step';
label = 'Iclamp_normal_whole_cell_current_step_take2';
% label = 'Iclamp_zero'; 
% label = 'end_of_experiment_oscillations';

% exp.lineName  = 'NP1227-gal4_X_20x-UAS-GtACR1';
% exp.lineName  = 'R24C12-gal4_X_UAS-CsChrimson-mVenus';
% exp.lineName  = 'R78F09-Gal4_ACR1 R26A01-LexA_LexAop-mCD8-GFP_PN';
exp.lineName  = 'R78F09-Gal4_ACR1 R26A01-LexA_LexAop-mCD8-GFP_PN_2';
% exp.lineName = 'R78F09-Gal4';
exp.number = 1; % Number per day
%--------------------------------------------------------------------------
%-Set up filepaths for logging---------------------------------------------
%--------------------------------------------------------------------------
exp.folderName    = 'Z:\Data\recordings\optogenetic_LN_stim\';
fullDateTime        = datestr(now,30);
exp.date             = [fullDateTime(1:4), '-', fullDateTime(5:6), '-',...
                       fullDateTime(7:8)];
exp.saveDir = fullfile(exp.folderName, exp.lineName, exp.date);
matSaveFile = [exp.date '_' exp.lineName '_' label '_' num2str(exp.number) '.mat'];
if ~exist(exp.saveDir,'dir')
    mkdir(exp.saveDir);
end

trialLength = 5;
if strcmp(label, 'Vclamp_seal') || strcmp(label, 'Vclamp_cell')
    sampRate = 1e5;
else
    sampRate = 1e4;
end

patchCh = 3;
pA = -35;
[spacer_data, spacer_daqInfo] = spacer_trial(trialLength, pA, sampRate);
save(fullfile(exp.saveDir, matSaveFile))
clf
% plot(scale_200B_data(spacer_data))
d = scale_200B_data(spacer_data);
plot(d(:,1))
hold on
% plot(spacer_data(:,11) / 100 * 1e3)
% plot(scale_200B_data(spacer_data(:,9:15)))
% plot((spacer_data(:,3) /100 * 1e3))
pipetteResistanceCalc(d(:,1)) 
% pipetteResistanceCalc(spacer_data(:,patchCh)) 
% accessResistanceCalc(spacer_data(:,3)/10, 10e3)  