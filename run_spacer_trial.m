clear
%% Specify line name and experiment type
% label = 'Vclamp_bath';
% label = 'Vclamp_seal' ;
% label = 'Vclamp_seal_spikes';
% label = 'Vclamp_cell'; 

% label = 'Iclamp_seal';
% label = 'Iclamp_zero'; 
label = 'Iclamp_fast_whole_cell_current_step';
% label = 'Iclamp_normal_whole_cell_current_step';

% Line name & experiment #
exp.lineName  = 'R78F09-Gal4_GFP R60F02-LexA_Chrimson_LN';
exp.number = 1; % Number per day

trialLength = 5;
if strcmp(label, 'Vclamp_seal') || strcmp(label, 'Vclamp_cell')|| strcmp(label, 'Vclamp_seal_spikes')
    sampRate = 1e5;
else
    sampRate = 1e4;
end
%% Set up filepaths for logging
exp.folderName    = 'Z:\Data\recordings\optogenetic_LN_stim\';
fullDateTime        = datestr(now,30);
exp.date             = [fullDateTime(1:4), '-', fullDateTime(5:6), '-',...
                       fullDateTime(7:8)];
exp.saveDir = fullfile(exp.folderName, exp.lineName, exp.date);
matSaveFile = [exp.date '_' exp.lineName '_' label '_' num2str(exp.number) '.mat'];
if ~exist(exp.saveDir,'dir')
    mkdir(exp.saveDir);
end
%% Run trial
patchCh = 3;
pA = -40;
[spacer_data, spacer_daqInfo] = spacer_trial(trialLength, pA, sampRate);
%% Analyze data
switch label
    case 'Vclamp_bath'
        Rpipette = calc_pipette_resistance(spacer_data, sampRate);
        disp(['Pipette resistance: ' num2str(Rpipette) ' MOhm'])
    case 'Vclamp_seal'
        Rseal = calc_seal_resistance(spacer_data, sampRate);
        disp(['Seal resistance: ' num2str(Rseal / 1e3) ' GOhm'])
    case 'Vclamp_cell'
%     case 'Iclamp_zero'
%     case 'Iclamp_normal_whole_cell_current_step'
end


clf
d = scale_200B_data(spacer_data);
plot((1/sampRate):(1/sampRate):trialLength, d(:,1))
hold on
hold on

save(fullfile(exp.saveDir, matSaveFile))