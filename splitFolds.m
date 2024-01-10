function Folds = splitFolds(Classes,numFolds)

    Folds = cell(2,numFolds);

    for i = 1:size(Classes,2);
        
        numSamps = size(Classes{i},3);
        numClassSamps = floor(numSamps / numFolds);
        
        for j = 1:numFolds;
            if i == 1;
                Folds{1,j} = Classes{i}(:,:,1+(j-1)*numClassSamps:j*numClassSamps);
                Folds{2,j} = ones(length(1+(j-1)*numClassSamps:j*numClassSamps),1);
            elseif j ~= numFolds;
                Folds{1,j} = cat(3,Folds{1,j},Classes{i}(:,:,1+(j-1)*numClassSamps:j*numClassSamps));
                Folds{2,j} = [Folds{2,j}; i*ones(length(1+(j-1)*numClassSamps:j*numClassSamps),1)];
            else
                Folds{1,j} = cat(3,Folds{1,j},Classes{i}(:,:,1+(j-1)*numClassSamps:end));
                Folds{2,j} = [Folds{2,j}; i*ones(size(Classes{i}(:,:,1+(j-1)*numClassSamps:end),3),1)];
            end
        end
        
    end
        
end