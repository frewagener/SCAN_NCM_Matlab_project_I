%% Steps for the data analysis
% 1: Create a struct with the meaning aspects of the data (mean of accuracy
% for the two conditions + mean of RT for the two conditions)
% 2: Plot average data and across participants
%% Loading a file

fclose('all');
subjects = [11, 21, 41]; %put the numbers of interest 

filepath= '/Users/antoniya/Desktop/Documents/uni_stuff/FU/Programming/Matlab/SCAN_NCM_Matlab_project_I-main/Log_files';
for subjnum = subjects

    file = dir(fullfile(filepath, sprintf('SJ0%d_Response.mat', subjnum)));
     %% Check if file exists
     if isfile(fullfile(filepath, file.name)) 
         
     fid = fopen(fullfile(filepath, file.name));
     data=open(file.name);
     data = data.log_file.responses';
     play_cond = find(data(:,5) == 1);
     hold_cond = find(data(:,5) == 2);
     
     %% Computing mean for the two conditions & saving it all in a struct
     
     Statistics.AverageAcc.i(subjnum).play= mean(data(play_cond,4));
     Statistics.AverageAcc.i(subjnum).hold= mean(data(hold_cond,4));
     Statistics.AverageRT.i(subjnum).play = mean(data(play_cond, 1));
     Statistics.AverageRT.i(subjnum).hold = mean(data(hold_cond, 1));
     Statistics.TrialRT.i(subjnum).play = data(play_cond, 1);
     Statistics.TrialRT.i(subjnum).hold = data(hold_cond, 1);
      
        
     fclose(fid);
     %% Move to next if file does not exist
     else
         continue 
     end
end 

tiledlayout(2,2)
%% Grand Average Accuracy plot

[test_acc_h, test_acc_p]  = ttest([Statistics.AverageAcc.i.play], [Statistics.AverageAcc.i.hold]);

nexttile
Grand_mean_acc = [mean([Statistics.AverageAcc.i.play]), mean([Statistics.AverageAcc.i.hold])];
Grand_sem_acc = [std([Statistics.AverageAcc.i.play])/sqrt(length([Statistics.AverageAcc.i.play])), std([Statistics.AverageAcc.i.hold])/sqrt(length([Statistics.AverageAcc.i.hold]))];
h1 = bar(Grand_mean_acc);
title('Grand Average accuracy results')
labels = {'PLAY', 'HOLD'};
hold on
set(gca,'xticklabel',labels)
hold on
ylim([0.0 1.0])
hold on
ylabel('Accuracy (%)')
hold on
er = errorbar(Grand_mean_acc, Grand_sem_acc);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
hold on
legend(h1,"p = " + test_acc_p);


%% Grand RT plot

[test_RT_h, test_RT_p]  = ttest([Statistics.AverageRT.i.play], [Statistics.AverageRT.i.hold]);

nexttile
Grand_mean_RT = [mean([Statistics.AverageRT.i.play]), mean([Statistics.AverageRT.i.hold])];
Grand_sem_RT = [std([Statistics.AverageRT.i.play])/sqrt(length([Statistics.AverageRT.i.play])), std([Statistics.AverageRT.i.hold])/sqrt(length([Statistics.AverageRT.i.hold]))];
h2 = bar(Grand_mean_RT);
title('Grand Average RT results')
labels = {'PLAY', 'HOLD'};
hold on
set(gca,'xticklabel',labels)
hold on
ylim([0.0 1.5])
hold on
ylabel('RT (ms)')
hold on
er = errorbar(Grand_mean_RT, Grand_sem_RT);    
er.Color = [0 0 0];                            
er.LineStyle = 'none'; 
hold on
legend(h2,"p = " + test_RT_p);
hold off


%% Average acc for each participant

a = [Statistics.AverageAcc.i.play; Statistics.AverageAcc.i.hold].';
nexttile
h3 = bar(a);
title('Accuracy across participants')
hold on
ylim([0.0 1.0])
hold on
ylabel('Accuracy (%)')
hold on
xlabel('Participant number')
hold on
% Legend will show names for each color
legend({'PLAY', 'HOLD'}')
hold off 
%% RT across participants 

b = [Statistics.AverageRT.i.play; Statistics.AverageRT.i.hold].';
nexttile
h4 = bar(b);
title('RT across participants')
hold on
ylim([0.0 1.5])
hold on
ylabel('RT (ms)')
hold on
xlabel('Participant number')
hold on
% Legend will show names for each color
legend({'PLAY', 'HOLD'}')
sgtitle('Quick Statistics') 

%% RT across trials 
figure
Trial_RT_play = mean([Statistics.TrialRT.i(:).play],2);
N_trial_play = 1:length(Trial_RT_play);

Trial_RT_hold = mean([Statistics.TrialRT.i(:).hold],2);
N_trial_hold = 1:length(Trial_RT_hold);

scatter(N_trial_play, Trial_RT_play,  'r', 'filled')
hold on
scatter(N_trial_hold,Trial_RT_hold, 'b', 'filled')
hold on
title('Scatter plots for RT across trials')
hold on
ylabel('RT (ms)')
hold on
xlabel('Trial number')
hold on
legend('PLAY','HOLD');



