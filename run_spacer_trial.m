clear
% label = 'Vclamp_bath';
% label = 'Vclamp_seal';
% label = 'Vclamp_seal_spikes';
% label = 'Vclamp_cell';
% label = 'Iclamp_seal';
label = 'Iclamp_whole_cell';

exp.lineName  = 'GMR-70E03-gal4';
exp.number = '1'; % Number per day
%--------------------------------------------------------------------------
%-Set up filepaths for logging---------------------------------------------
%--------------------------------------------------------------------------
exp.folderName    = 'Z:\Data\recordings\LN_dynamics';
fullDateTime        = datestr(now,30);
exp.date             = [fullDateTime(1:4), '-', fullDateTime(5:6), '-',...
                       fullDateTime(7:8)];
exp.saveDir = fullfile(exp.folderName, exp.lineName, exp.date);
matSaveFile = [exp.date '_' exp.lineName '_' label '.mat'];
if ~exist(exp.saveDir,'dir')
    mkdir(exp.saveDir);
end

trialLength = 5;
sampRate = 1e4;
[spacer_data, spacer_daqInfo] = spacer_trial(5, 0, sampRate);
% save(fullfile(exp.saveDir, matSaveFile))
plot(spacer_data(:,3) * 10)