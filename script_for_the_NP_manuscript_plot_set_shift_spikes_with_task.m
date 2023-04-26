function script_for_the_NP_manuscript_plot_set_shift_spikes_with_task


% Author: Eric Song 

% figpath = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18';
% figpath = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-24_15-17-10';
% figpath = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-27_16-16-50';

figpath = 'Z:\projmon\ericsprojects\NP_manuscript';


        data(1).path = ...
            'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\Record Node 101\experiment1\recording1\structure.oebin';
        data(1).unitfilepath = ...
            'Z:\projmon\ericsprojects\NP_manuscript\Data\SpikeyieldsData\trimmedData\CSF02SpikesFrom1stProbe_09232021_trimmed';
        data(1).unitfilepath2 = ...
            'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\SpikesFrom2ndProbe_09232021';
        data(1).logfn = ...
            'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\CSF02_2021_09_23__14_50_02';



load(data(1).unitfilepath,'trial')
setshift=read_set_shift_behavior_one_file_only_imcomplete_session(data(1).logfn);




% pi_unit2plot_unitindx = 122; % 112 for 24rd
% pt_unit2plot_unitindx = 135; % 121 for 24rd

pi_unit2plot_unitindx = 84; % for 23rd
pt_unit2plot_unitindx = 77; % for 23rd

% pi_unit2plot_unitindx = [85,86,87]; % 112 for 27rd
% pt_unit2plot_unitindx = [88,89]; % 121 for 27rd



% read in task data
% tmpfn = dir('*.csv');
% logfn = tmpfn.name;
% setshift = read_set_shift_behavior_one_file_only(logfn);
% times in seconds.

% read in spike data
% trial = do_set_shift_neuropixel_spikes_one_file_only(datapath,0);
% times in miliseconds.

path = data(1).path;
% path = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\Record Node 101\experiment1\recording1\structure.oebin';
% path = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-24_15-17-10\Record Node 101\experiment1\recording1\structure.oebin';
% path = 'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-27_16-16-50\Record Node 101\experiment1\recording1\structure.oebin';

task_starttime = load_open_ephys_binary(path,'events',1,'mmap'); %%% in samples!!
tmpdata = load_open_ephys_binary(path,'continuous',1,'mmap'); %%% in samples!!
recordstarttime = tmpdata.Timestamps(1);
time_offset = double(task_starttime.Timestamps(1)-recordstarttime)/30; %%% in miliseconds !!


tasktimes = []; 
for rl = 1:length(setshift.rules)
   for bl = 1: length(setshift.rules(rl).blocks) 
    for tr = 1: length(setshift.rules(rl).blocks(bl).trials)
        tmp = [setshift.rules(rl).blocks(bl).trials(tr).initiation_time,setshift.rules(rl).blocks(bl).trials(tr).response_time];
       tasktimes = [tasktimes;tmp]; %#ok<AGROW>

    end
   end
end
%intervaltimes = intervaltimes((tasktimes(:,2)-tasktimes(:,1)>2),:); % choose those only when task took longer than 2s.
tasktimes = tasktimes((tasktimes(:,2)-tasktimes(:,1)>2),:); % choose those only when task took longer than 2s.
tasktimes = [tasktimes(:,2)-2,tasktimes(:,2)]; % cut the task to 2s. still in seconds!
intervaltimes = [tasktimes(:,2)-4,tasktimes(:,2)-2]; % cut the task to 2s. still in seconds!

tasktimes = tasktimes * 1000 + time_offset; % changed to miliseconds and adjusted by offset
intervaltimes = intervaltimes * 1000 + time_offset; % changed to miliseconds and adjusted by offset


unit = struct;
for u = 1:length(trial.units)
    unit(u).task_spikecount = 0;unit(u).interval_spikecount = 0;
    unit(u).channel = trial.units(u).channel;  
     for i = 1:size(tasktimes,1)
        if sum(trial.units(u).ts>tasktimes(i,1)&trial.units(u).ts<tasktimes(i,2))== 0
            unit(u).task(i).st = NaN; unit(u).task(i).spikecount = 0;
        else
        unit(u).task(i).st = ...
            trial.units(u).ts(trial.units(u).ts>tasktimes(i,1)&trial.units(u).ts<tasktimes(i,2))...
            -tasktimes(i,1);  
        unit(u).task(i).spikecount = length(unit(u).task(i).st);
        %scatter(unit(u).task(i).st_ad,ones(length(unit(u).task(i).st_ad),1)*(size(tasktimes,1)+1-i),'x','MarkerEdgecolor',[0 0 0])
        end
        
        if sum(trial.units(u).ts>intervaltimes(i,1)&trial.units(u).ts<intervaltimes(i,2))== 0 
            unit(u).interval(i).st = NaN; unit(u).interval(i).spikecount = 0;
        else
        unit(u).interval(i).st =... 
            trial.units(u).ts(trial.units(u).ts>intervaltimes(i,1)&trial.units(u).ts<intervaltimes(i,2))...
            -tasktimes(i,1);   
        unit(u).interval(i).spikecount = length(unit(u).interval(i).st);
        %scatter(unit(u).interval(i).st_ad,ones(length(unit(u).interval(i).st_ad),1)*(size(tasktimes,1)+1-i),'x','MarkerEdgecolor',[0 0 0])
        end
        unit(u).task_spikecount = unit(u).task_spikecount + unit(u).task(i).spikecount;
        unit(u).interval_spikecount = unit(u).interval_spikecount + unit(u).interval(i).spikecount;
    end

end

% plot number of spikes from ALL UNITS during task vs internal
fig1 = figure('name','number of spikes from all units during task vs internal');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % it will make the figure size to full screen.
task_spikecount = []; interval_spikecount = [];
for u = 1:length(unit)
task_spikecount = [task_spikecount,unit(u).task_spikecount];  %#ok<AGROW> % spike times for all units 
interval_spikecount = [interval_spikecount,unit(u).interval_spikecount]; %#ok<AGROW>
end
bar([sum(interval_spikecount),sum(task_spikecount)])
xticklabels({'interval','task'})
box off
    figname1 = ...
        fig1.Name;
    saveas(fig1,fullfile(figpath,figname1),'png')
    saveas(fig1,fullfile(figpath,figname1),'fig')




% plot number of spikes from EACH UNIT during task vs internal
fig2 = figure('name','number of spikes from each unit during task vs internal');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % it will make the figure size to full screen.
for u = 1:length(unit)
    chanorder_orig(u) = unit(u).channel;  %#ok<AGROW>
    %chanorder_orig(u) = trial.units(u).channel; 
    subplot(ceil(sqrt(length(unit))),ceil(sqrt(length(unit))),u)
    bar([unit(u).interval_spikecount,unit(u).task_spikecount])
    xticklabels({'interval','task'})
end
box off
    figname2 = ...
        fig2.Name;
    saveas(fig2,fullfile(figpath,figname2),'png')
    saveas(fig2,fullfile(figpath,figname2),'fig')




% plot number of spikes from EACH UNIT  V2D during task vs internal
fig3 = figure('name','# of spikes from each unit V2D during task vs internal');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % it will make the figure size to full screen.
hold on
[~,ind_orig,~] = unique(chanorder_orig);
ind = sort(ind_orig);
for i = 1: length(ind)
    subplot(ceil(sqrt(length(ind))),ceil(sqrt(length(ind))),i)
    bar([unit(ind(i)).interval_spikecount,unit(ind(i)).task_spikecount])
    xticklabels({'interval','task'})
end
box off
    figname3 = ...
        fig3.Name;
    saveas(fig3,fullfile(figpath,figname3),'png')
    saveas(fig3,fullfile(figpath,figname3),'fig')



% plot only units that have 1.5 more spikes during task than interval.
fig4 = figure('name','prone task units');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % it will make the figure size to full screen.
[~,a] = find(task_spikecount > 1.5*interval_spikecount); % choose index of units that have 1.5 more spikes during task than interval.

pt_task_spikecount = task_spikecount(a);
pt_interval_spikecount = interval_spikecount(a);

for i = 1:length(pt_task_spikecount)
subplot(9,9,i)
bar([pt_interval_spikecount(i),pt_task_spikecount(i)])
xticklabels({'interval','task'})
box off
end

    figname4 = ...
        fig4.Name;
    saveas(fig4,fullfile(figpath,figname4),'png')
    saveas(fig4,fullfile(figpath,figname4),'fig')
% pt_unit2plot_unitindx = a(pt_task_spikecount==max(pt_task_spikecount)); % name of the unit with the most task spikes to plot
% fprintf('prone-task unit indices is %d! \n',a)

fmt = ['prone-task unit indices are: [', repmat('%d, ', 1, numel(a)-1), '%d]\n'];
fprintf(fmt, a)

figure
% bar([pt_interval_spikecount(a==111),pt_task_spikecount(a==111)])
bar([pt_interval_spikecount(a==122),pt_task_spikecount(a==122)])
xticklabels({'interval','task'})
box off


% plot only units that have 1.5 more spikes during interval than task.
fig5 = figure('name','prone interval units');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % it will make the figure size to full screen.
[~,b] = find(interval_spikecount > 1.5*task_spikecount); % choose index of units that have 1.5 more spikes during task than interval.

pi_task_spikecount = task_spikecount(b);
pi_interval_spikecount = interval_spikecount(b);

for i = 1:length(pi_task_spikecount)
subplot(9,9,i)
bar([pi_interval_spikecount(i),pi_task_spikecount(i)])
xticklabels({'interval','task'})
box off
end

figure
% bar([pi_interval_spikecount(b==124),pi_task_spikecount(b==124)])
bar([pi_interval_spikecount(b==135),pi_task_spikecount(b==135)])
xticklabels({'interval','task'})
box off


    figname5 = ...
        fig5.Name;
    saveas(fig5,fullfile(figpath,figname5),'png')
    saveas(fig5,fullfile(figpath,figname5),'fig')
%pi_unit2plot_unitindx = b(pi_interval_spikecount==max(pi_interval_spikecount)); % name of the unit with the most task spikes to plot
fmt = ['prone-interval unit indices are: [', repmat('%d, ', 1, numel(b)-1), '%d]\n'];
fprintf(fmt, b)



units2plot = pt_unit2plot_unitindx;
fig6 = figure('name','prone task units rasterplot');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % it will make the figure size to full screen.
hold on
for u = 1:length(units2plot)
    
    for i = 1:length(tasktimes)
        if unit(units2plot(u)).task(i).spikecount == 0
        else
            scatter(unit(units2plot(u)).task(i).st,ones(length(unit(units2plot(u)).task(i).st),1)*(size(tasktimes,1)+1-i),'+','MarkerEdgecolor',[1 0 0],'LineWidth',2)
            scatter(unit(units2plot(u)).interval(i).st,ones(length(unit(units2plot(u)).interval(i).st),1)*(size(tasktimes,1)+1-i),'+','MarkerEdgecolor',[0 0 0],'LineWidth',2)
        end
    end
end
xline(0,'k','LineWidth',1.5,'alpha',1)
yline([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40],':k','LineWidth',0.5,'alpha',1)
set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
ylabel('Trials','FontSize',30)
xticks([-1000 0 1000]);  xticklabels({'','',''})
xlabel('Interval                                                        Task   ','FontSize',30);
box off
    figname6 = ...
        fig6.Name;
    saveas(fig6,fullfile(figpath,figname6),'png')
    saveas(fig6,fullfile(figpath,figname6),'fig')


units2plot = pi_unit2plot_unitindx;
fig7 = figure('name','prone interval units rasterplot');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % it will make the figure size to full screen.
hold on
for u = 1:length(units2plot)
    
    for i = 1:length(tasktimes)
        if unit(units2plot(u)).interval(i).spikecount == 0
        else
            scatter(unit(units2plot(u)).task(i).st,ones(length(unit(units2plot(u)).task(i).st),1)*(size(tasktimes,1)+1-i),'+','MarkerEdgecolor',[1 0 0],'LineWidth',2)
            scatter(unit(units2plot(u)).interval(i).st,ones(length(unit(units2plot(u)).interval(i).st),1)*(size(tasktimes,1)+1-i),'+','MarkerEdgecolor',[0 0 0],'LineWidth',2)
        end
    end
end
xline(0,'k','LineWidth',1.5,'alpha',1)
yline([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40],':k','LineWidth',0.5,'alpha',1)
set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
ylabel('Trials','FontSize',30)
xticks([-1000 0 1000]);  xticklabels({'','',''})
xlabel('Interval                                                        Task   ','FontSize',30);
box off
    figname7 = ...
        fig7.Name;
    saveas(fig7,fullfile(figpath,figname7),'png')
    saveas(fig7,fullfile(figpath,figname7),'fig')
    
    
%     u = 124;
%     
%     
%     figure
%     for i = 1:length(tasktimes)
%         
%         taskspikecounts(i) = length(unit(units2plot(u)).task(i).st); %#ok<AGROW>
%         intervalspikecounts(i) = length(unit(units2plot(u)).interval(i).st); %#ok<AGROW>
% 
%     end
%     

%%% Single Unit Interval Prone Spiking

units2plot = pi_unit2plot_unitindx;
% task_bar = []; interval_bar = [];
% fig8 = figure('name','');
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % it will make the figure size to full screen.
% hold on
for u = 1:length(units2plot)
    for i = 1:size(tasktimes,1)
        % if unit(units2plot(u)).interval(i).spikecount == 0

        % else
            task_bar(i) = length(unit(units2plot(u)).task(i).st)/2; %#ok<AGROW> % divided by 2 sec which is the duration of the recording segment.
            interval_bar(i) = length(unit(units2plot(u)).interval(i).st)/2; %#ok<AGROW>
%             task_bar() = (unit(units2plot(u)).task(i).st,ones(length(unit(units2plot(u)).task(i).st),1)*(size(tasktimes,1)+1-i))
%             scatter(unit(units2plot(u)).interval(i).st,ones(length(unit(units2plot(u)).interval(i).st),1)*(size(tasktimes,1)+1-i),'+','MarkerEdgecolor',[0 0 0])
        % end
    end
end

fig8 = figure('name','Single_unit_interval_prone_spiking');
hold on
b1 = bar([0,mean(task_bar)]);
b1.FaceColor = [0.39,0.83,0.07];
b2 = bar([mean(interval_bar),0]);
b2.FaceColor = [1.00,0.41,0.16];
SEM_interval = std(interval_bar)/sqrt(length(interval_bar));
SEM_task = std(task_bar)/sqrt(length(task_bar));
errorbar([mean(interval_bar),mean(task_bar)],[SEM_interval,SEM_task],'k','linestyle','none','LineWidth',1)
xticks(1:2);
xticklabels({'Interval','Task'})
set(gca, 'FontName', 'Arial', 'FontSize', 26, 'FontWeight', 'bold')
ylabel('Spiking Rate (Hz)', 'FontName', 'Ariel','Fontsize', 36, 'FontWeight', 'bold');

box off
    figname8 = ...
        fig8.Name;
    saveas(fig8,fullfile(figpath,figname8),'png')
    saveas(fig8,fullfile(figpath,figname8),'fig')
    
    
    
    
%%% Single Unit Task Prone Spiking

units2plot = pt_unit2plot_unitindx;
task_bar1 = [];interval_bar1=[];
for v = 1:length(units2plot)
    for j = 1:size(tasktimes,1)
        % if unit(units2plot(v)).task(j).spikecount == 0
        % else              
            task_bar1(j) = length(unit(units2plot(v)).task(j).st); %#ok<AGROW>
            interval_bar1(j) = length(unit(units2plot(v)).interval(j).st);  %#ok<AGROW>
        % end
    end
end

fig9 = figure('name','Single_unit_task_prone_spiking');
hold on
b1 = bar([0,mean(task_bar1)]);
b1.FaceColor = [0.39,0.83,0.07];
b2 = bar([mean(interval_bar1),0]);
b2.FaceColor = [1.00,0.41,0.16];
SEM_interval1 = std(interval_bar1)/sqrt(length(interval_bar1));
SEM_task1 = std(task_bar1)/sqrt(length(task_bar1));
errorbar([mean(interval_bar1),mean(task_bar1)],[SEM_interval1,SEM_task1],'k','linestyle','none','LineWidth',1)
xticks(1:2);
xticklabels({'Interval','Task'})
set(gca, 'FontName', 'Arial', 'FontSize', 26, 'FontWeight', 'bold')
ylabel('Spiking Rate (Hz)', 'FontName', 'Ariel','Fontsize', 36, 'FontWeight', 'bold');

box off
    figname9 = ...
        fig9.Name;
    saveas(fig9,fullfile(figpath,figname9),'png')
    saveas(fig9,fullfile(figpath,figname9),'fig')   
    

% %Two unit bar graphs
% unit_chosen = [122,135];
% task_data = [];
% interval_data = [];
% for i = 1:length(unit_chosen)
%     task_data = unit(unit_chosen(i),4); %#ok<AGROW>
%     interval_data(:,i) = unit(unit_chosen(i),5); %#ok<AGROW>
% end

