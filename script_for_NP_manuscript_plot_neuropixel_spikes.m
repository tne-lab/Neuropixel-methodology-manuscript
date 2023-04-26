function script_for_NP_manuscript_plot_neuropixel_spikes

% Author: Eric Song 
figpath = 'Z:\projmon\ericsprojects\NP_Manuscript\FiguresForPaper';

metadata = struct;
    
%     metadata(1).filename = 'E:\NP Manuscript\Data\ESM04_Mar102021spikes_dpal.mat';
%     metadata(1).units2plot = [7,10,12,13];
    metadata(1).filename = 'Z:\projmon\ericsprojects\NP_manuscript\Data\SpikeyieldsData\examplespikedata\CSF02_Sep232021spikes_setshift_trimmed.mat';
    metadata(1).units2plot = [4,7,12,18];
    % badunits = ... % channels taken out from the orig trial to trimmed.
    %[1,2,4,8,11,14,16,18,19,23,24,29,30,37,38,39,40,47,51,52,53,61,63,64,66,67,69,74,75,100,101,114,115,116,123,125,129,(136:144)];

    metadata(2).filename = 'Z:\projmon\ericsprojects\NP_manuscript\Data\SpikeyieldsData\examplespikedata\ESF03_May062021spikes_reuse_trimmed.mat';
%     badunits = [1,3,6,10,11,16,17,18,19,25,27,32,33,34,35,75,82,84,85,86,89,90,91,98,102,103,104,113,117,121,122];
    metadata(2).units2plot = [3,8,9,14];
% metadata(3).units2plot = [12,13,14,15];
% metadata(3).units2plot = 16:19;
    
%         metadata(4).filename = 'E:\NP Manuscript\Data\CSF03_SpikesFrom1stProbe1min_03292022_reused.mat';
%     metadata(4).units2plot = [5,13,14,16];


for day = 1:2

    units2plot = metadata(day).units2plot;
    load(metadata(day).filename)
% this is for open field: ESM06
% day = 3;

% this is for dPAL: ESM04
% day = 4;

% this is for setshift: CSF02
% day = 5;

% this is for reuse: ESF03
% day = 6;

tr=1;
if ~isfield(trial(tr),'units')
else
    f1 = figure('name',sprintf('all good units day%d',day));
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    for u=1:length(trial(tr).units)
        subplot(ceil(sqrt(length(trial(tr).units))),ceil(sqrt(length(trial(tr).units))),u)
        plot(median(trial(tr).units(u).spikeData,1,'omitnan'),'LineWidth',1.5,'Color','r')
        box off
        axis off
    end
    
        saveas(f1,fullfile(figpath,f1.Name),'png')
    saveas(f1,fullfile(figpath,f1.Name),'fig')
%     if day == 2
%         units2plot = [1,4,10,18];
%     elseif day == 3
%         units2plot = [35,36,38,39];    %ESM06
%     %units2plot = [1,4,5,6,8,10,12,15,18];
%     
%     elseif day == 4
%         units2plot = [7,10,12,13];    %ESM04
%     %units2plot = [1,4,5,6,8,10,12,15,18]; 
%     
%     elseif day == 5
%         units2plot = [3,7,10,12];    %CSF02 
%         
%     elseif day == 6
%         units2plot = [5,13,14,16];    % ESF03
%         
%     end
    
    f2 = figure('name',[sprintf('chosen good units%d',units2plot(1)),sprintf('&%d',units2plot(2:end)),sprintf(' day#%d',day)]);
        
    numunits = length(units2plot);
    for u = 1:numunits
        
        %trial(tr).units(units2plot(u)).ISIs = trial(tr).units(units2plot(u)).ISIs(trial(tr).units(units2plot(u)).ISIs>1);
        
        subplot(3,numunits,u)
        t=(1:82)*1000/30000;  % t in miliseconds.
        %data = (trial.units(units2plot(u)).spikeData -median(trial.units(units2plot(u)).spikeData,2))'*0.195;
        data = normalize((trial(tr).units(units2plot(u)).spikeData -median(trial(tr).units(units2plot(u)).spikeData,2))'*0.195,'zscore');
        plot(t,data,'Color',[0.5 0.5 0.5])
        hold on
        plot(t,median(data,2,'omitnan'),'LineWidth',3,'Color','r')
%         xlabel('Time (ms)', 'FontWeight', 'bold')
        ylim([-5,5])
%         ylabel('Z-scored Voltage', 'FontWeight', 'bold');
%         title(sprintf('Waveforms'))
        set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
        box off
        axis square
        
        subplot(3,numunits,numunits+u)
        x = linspace(min(trial(tr).units(units2plot(u)).ISIs),min(trial(tr).units(units2plot(u)).ISIs)+100,100);
        y=nan(100,1);
        for j = 1:100-1
            y(j) = length(trial(tr).units(units2plot(u)).ISIs(trial(tr).units(units2plot(u)).ISIs>=x(j)&trial(tr).units(units2plot(u)).ISIs<(x(j+1))));
        end
        y(100)=1;
        plot(x,y,'LineWidth',3,'Color','b')
        %xlabel('ISI(ms)', 'FontWeight', 'bold')
        %ylabel('Spike counts', 'FontWeight', 'bold');
        %title(sprintf('200 individual waveforms'))
        %     xlim([0,100])
        %     xticks(linspace(min(trial(tr).units(units2plot(u)).ISIs)*1000/30000,max(trial(tr).units(units2plot(u)).ISIs)*1000/30000,250));
        set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
        box off
        axis square
        
        axLin = [];
        axLog = subplot(3,numunits,numunits*2+u);
        st = trial(tr).units(units2plot(u)).ts/1000;
        %[xLin, nLin, xLog, nLog]=myACG(st, axLin, axLog);
        myACG_ES(st, axLin, axLog);
        xlabel('')
        ylabel('')
        set(gcf,'position',[2000,100,900,900])
    end
    
    saveas(f2,fullfile(figpath,f2.Name),'png')
    saveas(f2,fullfile(figpath,f2.Name),'fig')
    
    
%     figure('name','chosen good units for rasterplot')
%     hold on
%     set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
%     units2rasterplot = randperm(length(trial.units),10);    
% %     units2rasterplot = [4,5,6,7,8,9];
%     numunits = length(units2rasterplot);
%     st = 0; % in
%     en = 100;% % in secs
%     for u = 1:numunits
%         
%         thisunitspikes=...
%             trial(tr).units(units2rasterplot(u)).ts(st*1000<trial(tr).units(units2rasterplot(u)).ts&trial(tr).units(units2rasterplot(u)).ts<en*1000);
%         
%         if ~isempty(thisunitspikes)
%             a=thisunitspikes*ones(1,100);
%         else
%             a=zeros(1,100);
%         end
%         y = linspace(u+1,u,100);
%         
%         plot(a',y,'color',[0 0 0], 'LineWidth', 0.1)
%         xlim([st, en*1000]);
%         ylim([0,numunits+2]);
%         %         grid off;
%         %         set(gca,'xtick',[])
%         %         set(gca,'ytick',[])
%         %         set(gca,'xticklabel',{[]})
%         %         grid off;
%         %         set(gca,'yticklabel',{[]})
%         %         box off
%         
%         
%         % xticks([2*1000,4*1000,6*1000,8*1000,10*1000]);
%         % xticklabels({'2','4','6','8','10'});
%         xlabel('Time(milisec)')
%         % yticks([15.5,25.5,35.5,45.5]);
%         % yticklabels({'40','30','20','10'});
%         ylabel('Units');
%         set(gca, 'FontName', 'Arial', 'FontSize', 24, 'FontWeight', 'bold')
%         
%         
%     end
    
end % end of if isemapty(trial(tr).units)

clear trial
end % for day =1:3

