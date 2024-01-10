%% Parameters
clear all
num_folds = 3; % number of folds for crossvalidation
numcons = 16; % number of contacts
timewindow = 100; %number of time samples

fc1 = 10; %hpf cutoff
fc2 = 7500; %lpf cutoff
fs = 30000; %sampling rate
n = 6; %order of filter

RAW_data_pathway = 'M:\Peripheral Nerve Studies\MCC Projects\Aseem G\Dataprocessing\RAW DATA\';
save_pathway = 'M:\Peripheral Nerve Studies\MCC Projects\Aseem G\Dataprocessing';



[b,a] = butter(n,[fc1/(fs/2) fc2/(fs/2)],'bandpass');
ratnum = 10;

% Path to Raw Data
RATDF_files = {'dorsi_170605_122607.rhd','dorsi_170605_122707.rhd','dorsi_170605_122807.rhd'};
RATPF_files = {'plantar_170605_123034.rhd','plantar_170605_123135.rhd','plantar_170605_123235.rhd'};
RATPrick_files = {'prick_170605_124216.rhd','prick_170605_124317.rhd','prick_170605_124417.rhd'};

% Number of timepoints in signal (30kHz)
signal_length = 100;

% Due to RAM limitations may have to split file up specify number of splits
total_section = 3

% Spike firing rate variation timescale is 5-10s or 15e4-30e4 points @ 30kHZ
firing_rate_var = mean([150000,300000]);
DF = load(strcat('M:\Peripheral Nerve Studies\MCC Projects\Ryan K\CNNs\Training_Sets_BP\Training_Sets\RAT',string(ratnum) ,'\DF_VSR_thresh_wspike_butter.mat'), ...
    'locs1','locs2','locs3');

fields = fieldnames(DF);
file = RATDF_files{1}
%% Read DF files & Get CAPs
DF = load(strcat('M:\Peripheral Nerve Studies\MCC Projects\Ryan K\CNNs\Training_Sets_BP\Training_Sets\RAT',string(ratnum) ,'\DF_VSR_thresh_wspike_butter.mat'), ...
    'locs1','locs2','locs3');

fields = fieldnames(DF);
for i = [1:3]
    file = RATDF_files{i};

    read_Intan_RHD2000_file_inputfile(strcat(RAW_data_pathway,'Rat',num2str(ratnum),'\Dorsiflexion\',file));

    if size(amplifier_data,1) == 64;
        amplifier_data(57:64,:) = [];
    end 
    
    for section_no = [1:total_section]

    tripole_data = make_general_tripole(amplifier_data,[1:8 49:56]);

    filt_notch = filter(b,a,tripole_data);

    locs = DF.(fields{i});

    upper_index = floor(section_no*length(locs)/total_section) + 1;
    lower_index = floor((section_no-1)*length(locs)/total_section) + 1;

    if (section_no == total_section)
        shorten_locs = locs(lower_index:end);
    else
        shorten_locs = locs(lower_index:upper_index);
    end
    
    disp(max(shorten_locs))

    name_to_save = strcat('Rat',string(ratnum),'_Aseem_firing_rate_DF_', string(i),'of3_section_', string(section_no), 'of', string(total_section),'.mat')

    clear tripole_data 
    % if i == 1;
    CAPsDF_FR = getCAPs_Aseem(filt_notch,shorten_locs,round(signal_length/2)); %input_data, locs
    % else
    %     CAPsDF_FR = cat(3,CAPsDF_FR,getCAPs_Aseem(filt_notch,DF.(fields{i}),round(firing_rate/2)));
    % end
    clear filt_notch shorten_locs
    
    
    save(name_to_save, 'CAPsDF_FR', '-v7.3')
    
    
    end
end

clear CAPsDF_FR
%% Read PF files & Get CAPs
PF = load(strcat('M:\Peripheral Nerve Studies\MCC Projects\Ryan K\CNNs\Training_Sets_BP\Training_Sets\RAT',string(ratnum) ,'\PF_VSR_thresh_wspike_butter.mat'), ...
    'locs1','locs2','locs3');

fields = fieldnames(PF);
for i = [1:3]
    file = RATPF_files{i};

    read_Intan_RHD2000_file_inputfile(strcat(RAW_data_pathway,'Rat',num2str(ratnum),'\Plantarflexion\',file));

    if size(amplifier_data,1) == 64;
        amplifier_data(57:64,:) = [];
    end 
    
    for section_no = [1:total_section]

    tripole_data = make_general_tripole(amplifier_data,[1:8 49:56]);

    filt_notch = filter(b,a,tripole_data);

    locs = PF.(fields{i});

    upper_index = floor(section_no*length(locs)/total_section) + 1;
    lower_index = floor((section_no-1)*length(locs)/total_section) + 1;

    if (section_no == total_section)
        shorten_locs = locs(lower_index:end);
    else
        shorten_locs = locs(lower_index:upper_index);
    end

    name_to_save = strcat('Rat',string(ratnum),'_Aseem_firing_rate_PF_', string(i),'of3_section_', string(section_no), 'of', string(total_section),'.mat')

    clear tripole_data 
    % if i == 1;
    CAPsPF_FR = getCAPs_Aseem(filt_notch,shorten_locs,round(signal_length/2)); %input_data, locs
    % else
    %     CAPsDF_FR = cat(3,CAPsDF_FR,getCAPs_Aseem(filt_notch,DF.(fields{i}),round(firing_rate/2)));
    % end
    clear filt_notch shorten_locs
    
    
    save(name_to_save, 'CAPsPF_FR', '-v7.3')
    
    
    end
end

clear CAPsPF_FR
%% Read Prick files & Get CAPs
Prick = load(strcat('M:\Peripheral Nerve Studies\MCC Projects\Ryan K\CNNs\Training_Sets_BP\Training_Sets\RAT',string(ratnum) ,'\Prick_VSR_thresh_wspike_butter.mat'), ...
    'locs1','locs2','locs3');

fields = fieldnames(Prick);
for i = [1:3]
    file = RATPrick_files{i};
    
    file
    
    if strcmp(file, 'empty') 
        break
    end

    read_Intan_RHD2000_file_inputfile(strcat(RAW_data_pathway,'Rat',num2str(ratnum),'\Pricking\',file));

    if size(amplifier_data,1) == 64;
        amplifier_data(57:64,:) = [];
    end 
    
    for section_no = [1:total_section]

    tripole_data = make_general_tripole(amplifier_data,[1:8 49:56]);

    filt_notch = filter(b,a,tripole_data);

    locs = Prick.(fields{i});

    upper_index = floor(section_no*length(locs)/total_section) + 1;
    lower_index = floor((section_no-1)*length(locs)/total_section) + 1;

    if (section_no == total_section)
        shorten_locs = locs(lower_index:end-1);
    else
        shorten_locs = locs(lower_index:upper_index);
    end

    name_to_save = strcat('Rat',string(ratnum),'_Aseem_firing_rate_Prick_', string(i),'of2_section_', string(section_no), 'of', string(total_section),'.mat')

    clear tripole_data 
    % if i == 1;
    CAPsPrick_FR = getCAPs_Aseem(filt_notch,shorten_locs,round(signal_length/2)); %input_data, locs
    % else
    %     CAPsDF_FR = cat(3,CAPsDF_FR,getCAPs_Aseem(filt_notch,DF.(fields{i}),signal_length(signal_length/2)));
    % end
    clear filt_notch shorten_locs
    
    
    save(name_to_save, 'CAPsPrick_FR', '-v7.3')
    
    
    end
end