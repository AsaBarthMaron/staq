clear
% label = 'Vclamp_bath';
% label = 'Vclamp_seal';
% label = 'Vclamp_seal_spikes';
% label = 'Vclamp_cell';
% 


% label = 'Iclamp_seal';
label = 'Iclamp_whole_cell_spike_rinput_step';
% label = 'Iclamp_zero';


exp.lineName  = 'NP1227-gal4';
exp.number = '1'; % Number per day
%--------------------------------------------------------------------------
%-Set up filepaths for logging---------------------------------------------
%--------------------------------------------------------------------------
exp.folderName    = 'Z:\Data\recordings\LN_dynamics\';
fullDateTime        = datestr(now,30);
exp.date             = [fullDateTime(1:4), '-', fullDateTime(5:6), '-',...
                       fullDateTime(7:8)];
exp.saveDir = fullfile(exp.folderName, exp.lineName, exp.date);
matSaveFile = [exp.date '_' exp.lineName '_' label '.mat'];
if ~exist(exp.saveDir,'dir')
    mkdir(exp.saveDir);
end

trialLength = 5;
if strcmp(label, 'Vclamp_seal') || strcmp(label, 'Vclamp_cell')
    sampRate = 1e5;
else
    sampRate = 1e4;
end

pA = -10;
[spacer_data, spacer_daqInfo] = spacer_trial(5, pA, sampRate);
save(fullfile(exp.saveDir, matSaveFile))
clf
plot(scale_200B_data(spacer_data))
% plot((spacer_data(:,3) /100 * 1e3))
pipetteResistanceCalc(spacer_data(:,3)) 
% accessResistanceCalc(spacer_data(:,3)/10, 10e3)  