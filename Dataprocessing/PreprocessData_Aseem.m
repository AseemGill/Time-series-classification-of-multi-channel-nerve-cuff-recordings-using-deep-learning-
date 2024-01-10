function [training_sets training_labels validation_sets validation_labels testing_sets testing_labels] = PreprocessData_Aseem(Classes,numFolds,type,percentage);

    Folds = splitFolds(Classes,numFolds);
    
    [training_sets training_labels testing_sets testing_labels] = getTrain_Test_Sets(Folds);
    
    [validation_sets validation_labels training_sets training_labels] = getValidationSet(training_sets,training_labels,percentage);
    
    
    for i = 1:size(training_sets,2);
        training_sets{i} = convert_data_to_range_neg1_1(training_sets{i});
        validation_sets{i} = convert_data_to_range_neg1_1(validation_sets{i});
        testing_sets{i} = convert_data_to_range_neg1_1(testing_sets{i});
    end
    
    if type == 1; %rebuild the structure to numObvs x electrodes x timesamples
        
        for i = 1:size(training_sets,2);
            training_sets{i} = reshape(training_sets{i}',size(training_sets{i},2),56,2250);
            validation_sets{i} = reshape(validation_sets{i}',size(validation_sets{i},2),56,2250);
            testing_sets{i} = reshape(testing_sets{i}',size(testing_sets{i},2),56,2250);
        end
        
        
        
    end


    
end