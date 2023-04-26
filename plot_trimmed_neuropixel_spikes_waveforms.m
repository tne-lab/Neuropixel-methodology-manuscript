function plot_trimmed_neuropixel_spikes_waveforms

% Author: Eric Song 
% Wrote and modified: 3/17/2023

figpath = 'Z:\projmon\ericsprojects\NP_manuscript\Data\SpikeyieldsData\trimmedData';
datapath = 'Z:\projmon\ericsprojects\NP_manuscript\Data\SpikeyieldsData\trimmedData';

    cd(datapath)
    tmpdir = dir('CSF0*');

     
   
   
for day = 1:9

    load(tmpdir(day).name)

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


    
end % end of if isemapty(trial(tr).units)

clear trial 
end % for day =1:3



