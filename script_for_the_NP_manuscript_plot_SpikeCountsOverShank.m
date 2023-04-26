
function script_for_the_NP_manuscript_plot_SpikeCountsOverShank

figpath = 'Z:\projmon\ericsprojects\NP_manuscript\FiguresForPaper';
%%%%%%%%%%%%script_for_the_NP_manuscript_rawtraces_power%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Probe 1 CSF02  new probe
load('Z:\projmon\ericsprojects\NP_manuscript\Data\SpikeyieldsData\trimmedData\CSF02SpikesFrom1stProbe_09222021_trimmed','trial');
% load('E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-20_10-16-15\SpikesFrom1stProbe1min_09202021');
trial_day1 = trial;
load('Z:\projmon\ericsprojects\NP_manuscript\Data\SpikeyieldsData\trimmedData\CSF02SpikesFrom1stProbe_09232021_trimmed','trial');
% load('E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-24_15-17-10\SpikesFrom1stProbe1min_09242021');
trial_day2 = trial;
load('Z:\projmon\ericsprojects\NP_manuscript\Data\SpikeyieldsData\trimmedData\CSF02SpikesFrom1stProbe_09242021_trimmed','trial');
% load('E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-29_15-43-07\SpikesFrom1stProbe1min_09292021');
trial_day3 = trial;

% Probe 1 CSF04 twice reused probe
load('Z:\projmon\ericsprojects\NP_manuscript\Data\SpikeyieldsData\trimmedData\CSF04SpikesFrom1stProbe_10122021_trimmed','trial');
trial_day4 = trial;
load('Z:\projmon\ericsprojects\NP_manuscript\Data\SpikeyieldsData\trimmedData\CSF04SpikesFrom1stProbe_10132021_trimmed','trial');
trial_day5 = trial;
load('Z:\projmon\ericsprojects\NP_manuscript\Data\SpikeyieldsData\trimmedData\CSF04SpikesFrom1stProbe_10142021_trimmed','trial');
trial_day6 = trial;

nbins = 39;

day1 = zeros; day2 = zeros; day3 = zeros; day4 = zeros; day5 = zeros; day6 = zeros;
for i = 1:length(trial_day1.units)
    day1(i) = trial_day1.units(i).channel;
end
for i = 1:length(trial_day2.units)
    day2(i) = trial_day2.units(i).channel;
end
for i = 1:length(trial_day3.units)
    day3(i) = trial_day3.units(i).channel;
end
for i = 1:length(trial_day4.units)
    day4(i) = trial_day4.units(i).channel;
end
for i = 1:length(trial_day5.units)
    day5(i) = trial_day5.units(i).channel;
end
for i = 1:length(trial_day6.units)
    day6(i) = trial_day6.units(i).channel;
end


figure
hist1 = histogram(day1, nbins);
fulldata(1,:) = hist1.Values;
figure
hist2 = histogram(day2, nbins);
fulldata(2,:) = hist2.Values;
figure
hist3 = histogram(day3, nbins);
fulldata(3,:) = hist3.Values;

figure
hist4 = histogram(day4, nbins);
fulldata1(1,:) = hist4.Values;
figure
hist5 = histogram(day5, nbins);
fulldata1(2,:) = hist5.Values;
figure
hist6 = histogram(day6, nbins);
fulldata1(3,:) = hist6.Values;


fig = figure('units','normalized','outerposition',[0 0 1 1]);
% b = bar(fulldata');
% xline([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5 14.5 15.5 16.5 17.5 18.5 19.5 20.5 21.5 22.5 23.5 24.5 25.5 26.5 27.5 28.5 29.5 30.5 31.5 32.5 33.5 34.5 35.5 36.5 37.5 38.5],':k','LineWidth',1.5,'alpha',1)
hold on 
plot(smoothdata(fulldata(1,:),10),'LineWidth',4,'Color','r')
plot(smoothdata(fulldata(2,:),10),'LineWidth',4,'Color','g')
plot(smoothdata(fulldata(3,:),10),'LineWidth',4,'Color','b')
hold off


ylim([0,20])
leg = {'Day 13','Day 14','Day 15'};
legend(leg,'Orientation','horizontal');
set(gca, 'FontName', 'Arial', 'FontSize', 50, 'FontWeight', 'bold')
title('Putative Units for a New Probe','FontSize',50); xlabel('Every 10 Channels','FontSize',50); ylabel('Number of Units','FontSize',50);


figname = sprintf('CSF02 Unit Data 3 Days Probe 1');
saveas(fig,fullfile(figpath,figname),'png')
saveas(fig,fullfile(figpath,figname),'fig')

fig1 = figure('units','normalized','outerposition',[0 0 1 1]);
% c = bar(fulldata1');
% xline([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5 14.5 15.5 16.5 17.5 18.5 19.5 20.5 21.5 22.5 23.5 24.5 25.5 26.5 27.5 28.5 29.5 30.5 31.5 32.5 33.5 34.5 35.5 36.5 37.5 38.5],':k','LineWidth',1.5,'alpha',1)
hold on 
plot(smoothdata(fulldata1(1,:),10),'LineWidth',4,'Color','r')
plot(smoothdata(fulldata1(2,:),10),'LineWidth',4,'Color','g')
plot(smoothdata(fulldata1(3,:),10),'LineWidth',4,'Color','b')
hold off


ylim([0,14])
leg = {'Day 27','Day 28','Day 29'};
legend(leg,'Orientation','horizontal');
set(gca, 'FontName', 'Arial', 'FontSize', 50, 'FontWeight', 'bold')
title('Putative Units for a Twice Re-used Probe','FontSize',50); xlabel('Every 10 Channels','FontSize',50); ylabel('Number of Units','FontSize',50);


figname = sprintf('CSF04 Unit Data 3 Days Probe 1');
saveas(fig1,fullfile(figpath,figname),'png')
saveas(fig1,fullfile(figpath,figname),'fig')


% Getting Data from CSF03 and plotting

% loading CSF03 Probe 1
load('Z:\projmon\ericsprojects\NP_manuscript\Data\SpikeyieldsData\trimmedData\CSF03SpikesFrom1stProbe1min_03292022_trimmed','trial');
% load('E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-29_14-52-47\SpikesFrom1stProbe1min_03292022');
trial2_day1 = trial;
load('Z:\projmon\ericsprojects\NP_manuscript\Data\SpikeyieldsData\trimmedData\CSF03SpikesFrom1stProbe1min_03302022_trimmed','trial');
% load('E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-29_14-52-47\SpikesFrom1stProbe1min_03292022');
trial2_day2 = trial;
load('Z:\projmon\ericsprojects\NP_manuscript\Data\SpikeyieldsData\trimmedData\CSF03SpikesFrom1stProbe1min_03312022_trimmed','trial');
% load('E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-29_14-52-47\SpikesFrom1stProbe1min_03292022');
trial2_day3 = trial;

% %CSF03 Probe 2
% load('E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-29_14-52-47\SpikesFrom2ndProbe1min_03292022');
% trial2_day4 = trial;
% load('E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-30_15-02-57\SpikesFrom2ndProbe1min_03302022');
% trial2_day5 = trial;
% load('E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-31_14-46-54\SpikesFrom1stProbe1min_03312022');
% trial2_day6 = trial;
% nbins = 39;

day1_2 = zeros; day2_2 = zeros; day3_2 = zeros; % day4_2 = zeros; day5_2 = zeros; day6_2 = zeros;
for i = 1:length(trial2_day1.units)
    day1_2(i) = trial2_day1.units(i).channel;
end
for i = 1:length(trial2_day2.units)
    day2_2(i) = trial2_day2.units(i).channel;
end
for i = 1:length(trial2_day3.units)
    day3_2(i) = trial2_day3.units(i).channel;
end
% for i = 1:length(trial2_day4.units)
%     day4_2(i) = trial2_day4.units(i).channel;
% end
% for i = 1:length(trial2_day5.units)
%     day5_2(i) = trial2_day5.units(i).channel;
% end
% for i = 1:length(trial2_day6.units)
%     day6_2(i) = trial2_day6.units(i).channel;
% end

figure
hist12 = histogram(day1_2, nbins);
fulldata2(1,:) = hist12.Values;
figure
hist22 = histogram(day2_2, nbins);
fulldata2(2,:) = hist22.Values;
figure
hist32 = histogram(day3_2, nbins);
fulldata2(3,:) = hist32.Values;

% figure
% hist42 = histogram(day4_2, nbins);
% fulldata3(1,:) = hist42.Values;
% figure
% hist52 = histogram(day5_2, nbins);
% fulldata3(2,:) = hist52.Values;
% figure
% hist62 = histogram(day6_2, nbins);
% fulldata3(3,:) = hist62.Values;

fig2 = figure('units','normalized','outerposition',[0 0 1 1]);
% d = bar(fulldata2');
% xline([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5 14.5 15.5 16.5 17.5 18.5 19.5 20.5 21.5 22.5 23.5 24.5 25.5 26.5 27.5 28.5 29.5 30.5 31.5 32.5 33.5 34.5 35.5 36.5 37.5 38.5],':k','LineWidth',1.5,'alpha',1)

hold on 
plot(smoothdata(fulldata2(1,:),10),'LineWidth',4,'Color','r')
plot(smoothdata(fulldata2(2,:),10),'LineWidth',4,'Color','g')
plot(smoothdata(fulldata2(3,:),10),'LineWidth',4,'Color','b')
hold off


ylim([0,14])
leg = {'Day 13','Day 14','Day 15'};
legend(leg,'Orientation','horizontal');
set(gca, 'FontName', 'Arial', 'FontSize', 50, 'FontWeight', 'bold')
title('Putative Units for a Re-used Probe','FontSize',50); xlabel('Every 10 Channels','FontSize',50); ylabel('Number of Units','FontSize',50);


figname = sprintf('CSF03 Unit Data 3 Days Probe 1');
saveas(fig2,fullfile(figpath,figname),'png')
saveas(fig2,fullfile(figpath,figname),'fig')

% fig3 = figure('units','normalized','outerposition',[0 0 1 1]);
% % e = bar(fulldata3');
% % xline([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5 14.5 15.5 16.5 17.5 18.5 19.5 20.5 21.5 22.5 23.5 24.5 25.5 26.5 27.5 28.5 29.5 30.5 31.5 32.5 33.5 34.5 35.5 36.5 37.5 38.5],':k','LineWidth',1.5,'alpha',1)
% hold on 
% plot(smoothdata(fulldata3(1,:),10),'LineWidth',3,'Color','r')
% plot(smoothdata(fulldata3(2,:),10),'LineWidth',3,'Color','g')
% plot(smoothdata(fulldata3(3,:),10),'LineWidth',3,'Color','y')
% hold off
% 
% 
% 
% leg = {'Day 1','Day 2','Day 3'}; 
% legend(leg,'Orientation','horizontal');
% set(gca, 'FontName', 'Arial', 'FontSize', 20, 'FontWeight', 'bold')
% title('Putative Units for a Re-used Probe','FontSize',24); xlabel('Every 10 Channels','FontSize',20); ylabel('Number of Units','FontSize',20);
% 
% 
% figname = sprintf('CSF03 Unit Data 3 Days Probe 2');
% saveas(fig3,fullfile(figpath,figname),'png')
% saveas(fig3,fullfile(figpath,figname),'fig')


fig3 = figure('name','Total_unitcounts_acrossdays');
plot(sum(fulldata,2),'LineWidth',5,'LineStyle','-','Color','k')
hold on
plot(sum(fulldata1,2),'LineWidth',5,'LineStyle',':','Color','k')
plot(sum(fulldata2,2),'LineWidth',5,'LineStyle','--','Color','k')
xlim([0.5,3.5])
ylim([0,200])
legend('New','Reused','Twice reused')
legend('Location','north')
set(gca, 'FontName', 'Arial', 'FontSize', 50, 'FontWeight', 'bold')
xticks([1,2,3])
xticklabels({'Day 1','Day 2','Day 3'});
ylabel('Number of Units')
title('Unit Counts Per Recording')
box off
set(gcf, 'Position', [373	42	1293	954]);
saveas(fig3,fullfile(figpath,fig3.Name),'png')
saveas(fig3,fullfile(figpath,fig3.Name),'fig')

