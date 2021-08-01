%% Loading a file

fclose('all');
subjects = (11);

filepath= '/Users/antoniya/Desktop/Documents/uni_stuff/FU/Programming/Matlab/SCAN_NCM_Matlab_project_I-main 2';
for subjnum = subjects

    file = dir(fullfile(filepath, sprintf('SJ0%d_Response.mat', subjnum)));
     %% Check if file exists
     if isfile(fullfile(filepath, file.name)) 
         
     fid = fopen(fullfile(filepath, file.name));
     data=open(file.name);
     data = data.log_file.responses';
     play = find(data(:,5) == 1);
     hold = find(data(:,5) == 2);
     
     %% Computing mean for the two conditions
     avg_play = mean(data(play,4));
     avg_hold = mean(data(hold,4));
     
     %% Saving it all in a struct 
     Statistics.Average.i(subjnum).play= avg_play;
     Statistics.Average.i(subjnum).hold= avg_hold;
        
        
     fclose(fid);
     %% Move to next if file does not exist
     else
         continue 
     end
end 