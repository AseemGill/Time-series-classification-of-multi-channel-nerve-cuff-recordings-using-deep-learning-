%% Parameters
clear all
numFolds = 3;
art_th = 15;
validation_percentage = 0.2;
ratnum = 10;
savepath = strcat('M:\Peripheral Nerve Studies\MCC Projects\Ryan K\Exploration\Aseem\Rat', string(ratnum),'\SetsforML');

disp(savepath)

% [FILENAME, PATHNAME] = uigetfile('M:\Peripheral Nerve Studies\MCC Projects\Ryan K\Exploration\Aseem\');
% temp = split(FILENAME,'_');

base_dir = strcat('M:\Peripheral Nerve Studies\MCC Projects\Ryan K\Exploration\Aseem\Rat', string(ratnum),'\')

split_no = 1;
section_no = 1;

%%
for i_1 = [1:3]
    for j_1 = [1:3]
        split_no = i_1;
        section_no = j_1;
 
        DF = strcat(base_dir, 'Rat', string(ratnum), '_Aseem_firing_rate_DF_', string(split_no), 'of3_section_', string(section_no), 'of3');
        PF = strcat(base_dir, 'Rat', string(ratnum), '_Aseem_firing_rate_PF_', string(split_no), 'of3_section_', string(section_no), 'of3');
        Prick = strcat(base_dir, 'Rat', string(ratnum), '_Aseem_firing_rate_Prick_', string(split_no), 'of3_section_', string(section_no), 'of3');

        name = strcat('Aseem_Rat', string(ratnum), '_', string(split_no), 'of3_section_', string(section_no), 'of3');
        
        name = char(name);
        
        disp(split_no*section_no)
        disp(name)
        % data = load([PATHNAME '\' FILENAME]);
        
        %DF
        data1 = load([DF]);
        if i_1 + j_1 == 2
            All_Classes{1} = data1.CAPsDF_FR;
            clear DF
            clear data1
        else
            All_Classes{1} = cat(3,All_Classes{1},data1.CAPsDF_FR);
            size(All_Classes{1})
            clear DF
            clear data1
        end
        
        %PF
        data2 = load([PF]);
        if i_1 + j_1 == 2
            All_Classes{2} = data2.CAPsPF_FR;
            clear PF
            clear data2
        else
            All_Classes{2} = cat(3,All_Classes{2},data2.CAPsPF_FR);
            clear PF
            clear data2
        end
        
        %PRICK
        data3 = load([Prick]);
        if i_1 + j_1 == 2
            All_Classes{3} = data3.CAPsPrick_FR;
            clear Prick
            clear data3
        else
            All_Classes{3} = cat(3,All_Classes{3},data3.CAPsPrick_FR);
            clear Prick
            clear data3
        end


    end
end

        All_Classes_artifact_remove = RemoveArtifact(All_Classes,art_th);

        All_equal_Classes = equalizeClasses(All_Classes,1);

        clear All_Classes
        clear All_equal_Classes 

        All_equal_Classes_artifact_remove = equalizeClasses(All_Classes_artifact_remove,1);
        % [training_sets training_labels testing_sets testing_labels] = PreprocessData(All_Classes,numFolds,1);

        clear All_Classes_artifact_remove
        
        [training_sets training_labels validation_sets validation_labels testing_sets testing_labels] = PreprocessData_Aseem(All_equal_Classes_artifact_remove,numFolds,1,validation_percentage);

        clear All_equal_Classes_artifact_remove
        %%
        
        final_path = savepath + '\' + name + '_eq'
        save(final_path,'-v7.3');

        % training_sets = convert_TO_TE(training_sets);
        % validation_sets = convert_TO_TE(validation_sets);
        % testing_sets = convert_TO_TE(testing_sets);
        % 
        % save([savepath '\' temp{1} '_eq_TE']);
        
        
        clear training_sets training_labels validation_sets validation_labels testing_sets testing_labels
%     end
% end

clear all