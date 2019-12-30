clear
%% Specify line name and experiment type
% label = 'Vclamp_bath';
% label = 'Vclamp_seal' ;
% label = 'Vclamp_seal_spikes';
% label = 'Vclamp_cell'; 

% label = 'Iclamp_seal';
% label = 'Iclamp_fast_whole_cell_current_step';
label = 'Iclamp_normal_whole_cell_current_step';
% label = 'Iclamp_zero'; 

% exp.lineName  = 'NP1227-Gal4_ACR1 R26A01-LexA_LexAop-mCD8-GFP_PN';
% exp.lineName  = 'R24C12-gal4_X_UAS-CsChrimson-mVenus';
% exp.lineName  = 'R78F09-Gal4_ACR1 R26A01-LexA_LexAop-mCD8-GFP_PN';
exp.lineName  = 'R78F09-Gal4_UAS_CsChrimson R26A01-LexA_LexAop-mCD8-GFP_PN';
% exp.lineName = 'R78F09-Gal4';
exp.number = 1; % Number per day

trialLength = 5;
if strcmp(label, 'Vclamp_seal') || strcmp(label, 'Vclamp_cell')
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
pA = -35;
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
% plot(scale_200B_data(spacer_data))
d = scale_200B_data(spacer_data);
plot(d(:,1))
hold on
% plot(spacer_data(:,11) / 100 * 1e3)
% plot(scale_200B_data(spacer_data(:,9:15)))
% plot((spacer_data(:,3) /100 * 1e3))
% pipetteResistanceCalc(spacer_data(:,patchCh)) 
% accessResistanceCalc(spacer_data(:,3)/10, 10e3) 
save(fullfile(exp.saveDir, matSaveFile))