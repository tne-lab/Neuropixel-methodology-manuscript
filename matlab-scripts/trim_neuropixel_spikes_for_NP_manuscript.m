function trim_neuropixel_spikes_for_NP_manuscript

% Author: Eric Song 
datapath = 'Z:\projmon\ericsprojects\NP_Manuscript\Data\SpikeyieldsData\orignaldata';

   
    cd(datapath)
    tmpdir = dir('CSF0*');

   badunits = struct; 
    
badunits(1).IDs = [131; 139];
badunits(2).IDs = [1,2,4,8,11,14,16,18,19,23,24,29,30,37,38,39,40,47,...
51,52,53,61,63,64,66,67,69,74,75,100,101,114,115,123,125,129,136:144];
badunits(3).IDs = [1,46,52,145,149];
badunits(4).IDs = [2:4,6,8,9,11,12,16:19,27,36,37,42,43,53:59,61,68:70,...
72:74,76,77,79:85,87:89,91:93,86:99,105:107,110];
badunits(5).IDs = [1,7,11,40,41,49:52,54];
badunits(6).IDs = [31,32,49:51,57:59,61,64,66,79,80,92];
badunits(7).IDs = [1,4,5,7,8,19,33:35,39,44,47,51,58];
badunits(8).IDs = [1:3,9,11,12];
badunits(9).IDs = []; %none
   
   
   
   
for day = 1:9

    load(tmpdir(day).name,'trial')

tr=1;
if ~isfield(trial(tr),'units')
else
    f1 = figure('name',sprintf('all good units day%d',day)); %#ok<NASGU>
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    for u=1:length(trial(tr).units)
        subplot(ceil(sqrt(length(trial(tr).units))),ceil(sqrt(length(trial(tr).units))),u)
        plot(median(trial(tr).units(u).spikeData,1,'omitnan'),'LineWidth',1.5,'Color','r')
        box off
        axis off
    end

    
end % end of if isemapty(trial(tr).units)
% badunits = input('badunits=');
% if badnunits ==0
%     
% else
trial.units(badunits(day).IDs) = [];
% end

tmpname = split(tmpdir(day).name,'.');
newfilename = sprintf('%s_trimmed.mat',tmpname{1});
save(newfilename,'trial')
% 
% 
clear trial newfilename
end % for day =1:3





