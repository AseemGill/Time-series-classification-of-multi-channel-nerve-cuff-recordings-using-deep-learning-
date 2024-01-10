function CAPs = getCAPs_Aseem(input_data,locs,len);
    disp(max(locs))
    disp("SIZE")
    % disp(size(locs))
    
    
    [x,y] = (size(locs))
    
    disp("HI")
    disp(y)
    parfor i = 1:y
        disp(locs(i)+(len))
        disp(i)
                
        if locs(i)+(len) < locs(end) & locs(i)-(len) > 0;
            disp("Trigger")
            
%             size(input_data(:,locs(i)-(len-1):locs(i)+(len)))
            CAPs(:,:,i) = convert_data_to_range_neg1_1(input_data(:,locs(i)-(len-1):locs(i)+(len)));
        end 
    end
    
end

