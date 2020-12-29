function random_interleaved_trials(olfCh, nReps)
%--------------------------------------------------------------------------
% Edit for each animal/experiment change
%--------------------------------------------------------------------------
% exp.lineName  = 'R24C12-Gal4_ACR1 R26A01-LexA_LexAop-mCD8-GFP_PN';
% exp.lineName  = 'R24C12-gal4_X_UAS-CsChrimson-mVenus';
% exp.lineName  = 'NP1227-gal4_X_20x-UAS-GtACR1';
% exp.lineName  = 'NP1227-Gal4_ACR1 R26A01-LexA_LexAop-mCD8-GFP_PN';
% exp.lineName  = 'NP1227-Gal4_ACR1 R26A01-LexA_LexAop-mCD8-GFP_PN';
% exp.lineName  = 'R78F09-Gal4_UAS_CsChrimson R26A01-LexA_LexAop-mCD8-GFP_PN';
% exp.lineName  = 'R67B06-Gal4_ACR1 R26A01-LexA_LexAop-mCD8-GFP_PN';
exp.lineName  = 'R78F09-Gal4_GFP R60F02-LexA_Chrimson_LN';
% exp.lineName  = 'R78F09-Gal4_ACR1 R26A01-LexA_LexAop-mCD8-GFP_PN';

% exp.lineName  = 'R78F09-Gal4_ACR1 R26A01-LexA_LexAop-mCD8-GFP_PN';
% exp.lineName = 'R78F09-Gal4';

% exp.lineName  = 'R24C12-gal4_X_20x-UAS-GtACR1';
% exp.lineName  = 'R24C12-gal4_X_20x-UAS-GtACR1';

% exp.name = 'Var_freq_stim__farnesol_10^-5_8s_490_LED_pulse_same_waveform_20p_ND25_ND3';
% exp.name = 'Var_freq_stim_2-hep_10^-2_8s_490_LED_pulse_100p_ND25_ND3';
% % exp.name = 'Var_freq_stim__2-hep_10^-1';
% exp.name = '1s_2-hep_10^-2_1s_490_LED_pulse_100p';
% exp.name = '1s_PO_old_valve';
% exp.name = 'pulse_train_490_LED_pulse_100p_ND3_+1uM_TTX_VClamp_0mV';
% exp.name = '1s_490_LED_pulse_100p_1uM_TTX_Vclamp_-70mV';
exp.name = '2s_490_LED_pulse_100p';
% exp.name = '2s_490_LED_pulse_100p_ND25_ND3';
% exp.name = '1s_565_LED_pulse_10p_ND25_ND3';
% exp.name = '1s_2-hep_10^-2_slightly_dep';


% exp.name = '1.5ms_pulse_500ms_ipi_vclamp_+CGP';
% exp.name = 'no_odor_valve';
% exp.name = 'empty_vial';
% exp.name = '2-hep_10^-2';
% exp.name = '2-hep_10^-2_2.5s_pulse';f
% exp.name = '3.5s_490_LED_pulse_30p_min_knob_pos_ND25_ND3';
% exp.name = '500ms_shutter_pulse_ND25_ND25_2.5s_concurrent_500m_odor_2_hep_10-2';
% exp.name = '2.5s_2-hep_10^-2';
% exp.name = '2.5s_2-hep_10^-2_and_shutter_pulse_no_NDs';
% exp.name = 'Var_freq_stim_2-hep_10^-1_1.5s_490_LED_pulse_10p_ND25_ND3';
% exp.name = '2.5s_480_LED_pulse_30p_min_knob_pos_ND25_ND3';
% exp.name = '2.5s_480_LED_pulse_100p_min_knob_pos_ND25_ND3_100p_duty_2-hep_10^-2_2.5s_pulse';
% exp.name = '2.5s_480_LED_pulse_100p_max_knob_pos';
% exp.name = '2.5s_no_pulse_max_power_+1uM_TTX';
% exp.name = '500ms_odor_pulse';
% exp.name = '2-hep_10^-2_4.5s_pulse_3.5s_490_LED_pulse_10p_min_knob_pos_ND25_ND3_obj_far_away';
exp.number = 1; % Number per day
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
odorTrainDuration = 8; % Duration of odor pulse train in s
trialDuration = 15;
% olfCh = 0;           % Indexing for digital outputs starts at 0. NOTE: MUST EDIT get_channel_names.m
nOlfCh = length(olfCh);
% nReps = 1;
stimType = 'single';

switch stimType
    case 'Kathy'
    impulse{1} = [ones((0.02 * sampRate),1)*1; zeros((0.08 * sampRate),1)];
    impulse{2} = [ones((0.2 * sampRate),1)*1; zeros((0.38 * sampRate),1)];
    impulse{3} = [ones((2 * sampRate),1)*1; zeros((1.58 * sampRate),1)];
    % 
    % impulse{1} = [zeros((0.02 * sampRate),1)*1; zeros((0.08 * sampRate),1)];
    % impulse{2} = [zeros((0.2 * sampRate),1)*1; zeros((0.38 * sampRate),1)];
    % impulse{3} = [zeros((2 * sampRate),1)*1; zeros((1.58 * sampRate),1)];

    odorSignal(:,1) = [zeros(2 * sampRate, 1); repmat(impulse{1}, 60, 1); zeros(3 * sampRate, 1)];
    odorSignal(:,2) = [zeros(2 * sampRate, 1);  repmat(impulse{2}, 10,1); zeros(3.2 * sampRate, 1)];
    odorSignal(:,3) = [zeros(2 * sampRate, 1);   repmat(impulse{3}, 2, 1); zeros(ceil(1.84 * sampRate), 1)];
%     odorSignal(:,1) = [zeros(2 * sampRate, 1);   repmat(impulse{3}, 2, 1)];
%     odorSignal(:,2) = [zeros(2 * sampRate, 1);   repmat(impulse{3}, 2, 1)];
%     odorSignal(:,3) = [zeros(2 * sampRate, 1);   repmat(impulse{3}, 2, 1)];
%     
    ledSignal = zeros(length(odorSignal), 1);
    iti = 5;
    case 'Emre'
        impulse{1} = [ones((0.05 * sampRate),1)*1; zeros((0.05 * sampRate),1)];
        ledSignal = [zeros(5 * sampRate, 1); repmat(impulse{1}, 60, 1); zeros(5 * sampRate, 1)];
        odorSignal = zeros(length(ledSignal), 1);
        iti = 30;
    case 'light+odor'
        ledSignal = [zeros((1.25 * sampRate),1); repmat([ones(6,1); ones(4,1)], 2e3, 1); zeros((3.25 * sampRate),1)];
        odorSignal = [zeros((1.75 * sampRate),1); repmat([ones(6,1); ones(4,1)], 1e3, 1); zeros((3.75 * sampRate),1)];
%         ledSignal = [repmat([ones(6,1); ones(4,1)], 2e3, 1); zeros((4.75 * sampRate),1)];
%         odorSignal = [zeros((2 * sampRate),1); repmat([ones(6,1); ones(4,1)], 1e3, 1); zeros((3.75 * sampRate),1)];
        iti = 5;
%         odorSignal(odorSignal ~= 0) = 0;
%         ledSignal = ledSignal * 0.50;   
        ledSignal = odorSignal;
    case 'light+kathy'
%         impulse{1} = [ones((0.02 * sampRate),1)*1; zeros((0.08 * sampRate),1)];
        impulse{1} = [ones((0.1 * sampRate),1)*1; zeros((0.19 * sampRate),1)];
        impulse{2} = [ones((0.2 * sampRate),1)*1; zeros((0.38 * sampRate),1)];
        impulse{3} = [ones((2 * sampRate),1)*1; zeros((1.58 * sampRate),1)];

%         odorSignal(:,1) = [zeros(2 * sampRate, 1); repmat(impulse{1}, 60, 1); zeros(3 * sampRate, 1)];
        odorSignal(:,1) = [zeros(2 * sampRate, 1);  repmat(impulse{1}, 20,1); zeros(3.2 * sampRate, 1)];
        odorSignal(:,2) = [zeros(2 * sampRate, 1);  repmat(impulse{2}, 10,1); zeros(3.2 * sampRate, 1)];
        odorSignal(:,3) = [zeros(2 * sampRate, 1);   repmat(impulse{3}, 2, 1); zeros(ceil(1.84 * sampRate), 1)];
        ledSignal = [zeros(1.5 * sampRate, 1); ones(8 * sampRate, 1); zeros(1.5 * sampRate, 1)];
%         ledSignal = [zeros(1. 5 * sampRate, 1); zeros(5 * sampRate, 1); ones(0.1 * sampRate, 1); zeros(0.9 * sampRate, 1); zeros(3.5 * sampRate, 1)];
%         ledSignal = odorSignal * 0.2;
        iti = 5;
%         ledSignal = ledSignal * 0.5;  
    case 'single'
%         odorSignal = [zeros((1.75 * sampRate),1); ones(1 * sampRate, 1); zeros((2.75 * sampRate),1)]
        odorSignal = [zeros((1.25 * sampRate),1); ones(2 * sampRate, 1); zeros((3.25 * sampRate),1)];
%         ledSignal = [zeros((1.75 * sampRate),1); repmat([ones(6,1); ones(4,1)], 1e3, 1); zeros((3.75 * sampRate),1)]
%                ledSignal = [zeros((1.25 * sampRate),1); repmat([ones(6,1); ones(4,1)], 8e3, 1); zeros((3.25 * sampRate),1)];
%                ledSignal = [zeros((1.25 * sampRate),1); repmat([ones(500,1); zeros(3500,1)], 2e1, 1); zeros((3.25 * sampRate),1)];
%                ledSignal = [zeros((1.25 * sampRate),1); repmat([ones(500,1); zeros(9500,1)], 8, 1); zeros((3.25 * sampRate),1)];

% ledSignal = [zeros((2 * sampRate),1); ones(0.05 * sampRate, 1); zeros(0.95 * sampRate, 1); zeros((4 * sampRate),1)]
%         ledSignal = [zeros(1.5 * sampRate, 1); ones(8 * sampRate, 1); zeros(1.5 * sampRate, 1)];
%         ledSignal = [zeros((1.75 * sampRate),1); ones(500,1); zeros((4.8 * sampRate),1)]
%         impulse{1} = [zeros((1.75 * sampRate),1); ones((2.5 * sampRate),1)*1; zeros((3.75 * sampRate),1)];
%         odorSignal = impulse{1};
        iti = 5;
%         odorSignal = [zeros((1.75 * sampRate),1); repmat([ones(6,1); ones(4,1)], 1e3, 1); zeros((3.75 * sampRate),1)];
        
        ledSignal = odorSignal;
%         ledSignal = [zeros(1.5 * sampRate, 1); ones(8 * sampRate, 1); zeros(1.5 * sampRate, 1)];
%         ledSignal = ledSignal * 0.50;
        odorSignal = zeros(length(ledSignal), 1);
%         ledSignal = zeros(length(odorSignal), 1);

end

conditions = 1:(nOlfCh * size(odorSignal, 2)); % Gives each condition type a unique ID
conditions = repmat(conditions',nReps,1); % Repeats those IDs by the numebr of trials

randTrials = ones(nReps,1);
% randTrials = [ones(nReps,1);
% randTrials = repmat([1 2 3], 1, nReps);
% randTrials = [ 1 repmat([1 1 2 2 3 3], 1, nReps)];
% randTrials = [ 2 repmat([2 2], 1, nReps)];
% % randTrials = randsample(conditions, length(conditions)); % Randomizes conditions
% load('Z:\Data\recordings\LN_dynamics\NP1227-gal4\2016-12-17\2016-12-17_2-hep_10^-1_randTrials.mat');
% daqInfo = struct;

% [access_test, access_daqInfo] = spacer_trial(iti, 0, sampRate * 10);

storedLEDSig = ledSignal;
for iTrial = 1:length(randTrials)
    
    % This performs a remapping from linear space (of unique trial IDs) to 
    % N x 3 space, where N is the number of olfactometer channels, and 3 is
    % the (hard coded) number of odor pulse types.
    [iOdor, pulseType] = ind2sub([length(olfCh), 3], randTrials(iTrial));
%     
%     ledSignal = zeros(length(ledSignal),3);
%     if ((iTrial > 1) && (mod(iTrial,2)))
%         ledSignal = storedLEDSig;
%     end
    disp(['Trial ' num2str(iTrial) ' of ' num2str(length(randTrials))])

%     [spacer_data(:,:,iTrial), spacer_daqInfo(iTrial)] = spacer_trial(iti, 0, sampRate);
%     disp(accessResistanceCalc(spacer_data(:,3,iTrial)/10, 10e3) )
    [data(:,:,iTrial), daqInfo(iTrial)] = odor_trial(odorSignal(:, pulseType), olfCh(iOdor), sampRate, ledSignal(:,1));
%     [data(:,:,iTrial), daqInfo(iTrial)] = odor_trial(odorSignal(:, 3), olfCh(iOdor), sampRate);
    
%     save(fullfile(exp.saveDir, matSaveFile))
    if mod(iTrial,5) == 0
%         save(fullfile(exp.saveDir, matSaveFile))
    end
    title(num2str(iTrial))
end
save(fullfile(exp.saveDir, matSaveFile), '-v7.3')