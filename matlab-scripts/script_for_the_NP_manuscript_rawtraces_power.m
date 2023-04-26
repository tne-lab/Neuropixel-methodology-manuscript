function script_for_the_NP_manuscript_rawtraces_power
% function script_for_the_NP_manuscript is to produce figures for
% the NP manuscript. Example: script_for_the_NP_manuscript(1)
% plotnum == 1: raw traces & bipolar traces


% Author: Eric Song,
% Date: Feb.21. 2023


params.Fs = 500;  % it is 2500 originally but will be downsampled to 500.
params.tapers = [3 5];
params.fpass = [0 30];
params.trialave = 0;
% movingwin = [0.5 0.01];
% datapath = 'E:\NP Manuscript';
% figpath = 'E:\NP Manuscript\CSF03_3d_PL';
figpath = 'Z:\projmon\ericsprojects\NP_manuscript\FiguresForPaper';


% this is for dPAL
data(1).path = ...
   'E:\dPAL\EPHYSDATA\Neuropixel probes\ESM04\03092021\OPEN-EPHYS-ESM04-P_2021-03-09_15-18-34_dPAL\Record Node 102\experiment1\recording1\structure.oebin';
% % this is for setshift
data(2).path = ...
    'E:\SetShift\EPHYSDATA\NP\CSF02\2021-09-23_14-50-18\Record Node 101\experiment1\recording1\structure.oebin';
% % this is for reuse
data(3).path = ...
    'E:\SetShift\EPHYSDATA\NP\CSF03\CSF03_2022-03-29_14-52-47\Record Node 102\experiment1\recording1\structure.oebin';




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%   raw traces & bipolar traces                                %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for whichday = 1:3
    path = data(whichday).path;
    
    % read in the data for chosen channels from recording
    RawData = load_open_ephys_binary(path, 'continuous',2,'mmap');
    origdata = double(RawData.Data.Data(1).mapped);
    ch = (1:10:384);
    trimmedData = origdata(ch,:);
    data1 = downsample(trimmedData',5)'; % downsampling; from 2500 -->500
    t = 1000*(1:1000)/500; % 2 sec of data, in miliseconds
    f1 = figure('name',sprintf('raw traces day#%d%s',whichday,datestr(now,30))); %#ok<*TNOW1,*DATST>
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    set(gca, 'FontName', 'Arial', 'FontSize', 28, 'FontWeight', 'bold')
    hold on
    for i = 1:size(data1,1)
        % pick times 130-132s to plot and space out the traces
        plot(t,data1(i,500*130+1:500*132)'+1000*(i-1),'LineWidth',1.5)
    end
    yticks(-5000:5000:40000);
    yticklabels({'','0','5','10','15','20','25','30','35','40'});
    xlabel('Time (milliseconds)')
    ylabel('Every 10th Channel Along the Shank')
    saveas(f1,fullfile(figpath,f1.Name),'png')
    saveas(f1,fullfile(figpath,f1.Name),'fig')
    
    %         %%% figure 2 bipolar data traces
    %         bipodata = nan(size(origdata,1),size(origdata,2));
    %         for i = 1:size(origdata,1)
    %             bipodata(i,:)=neuropixel_REreference(i,origdata);
    %         end
    %         data2 = bipodata(ch,:);
    %
    %         f2 = figure('name',sprintf('bipolar traces day#%d%s',whichday,datestr(now,30)));
    %         set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    %         set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
    %         hold on
    %         for i = 1:size(data2,1)
    %             plot(data2(i,2500*130+1:2500*132)'+300*(i-1))
    %         end
    %
    %         saveas(f2,fullfile(figpath,f2.Name),'png')
    %         saveas(f2,fullfile(figpath,f2.Name),'fig')
    
    %%% figure 3
    %data2 = bipodata;
    %     numseg = floor(size(data2,2)/(6*2500));
    data2 = trimmedData;
    numseg = 15;
    segmentedData = nan(size(data2,1),6*2500,numseg);
    
    for i = 1:size(data2,1) % looping through channels
        for j = 1:numseg % looping through segments/trials.
            segmentedData(i,:,j) = ...
                data2(i,(numseg-1)*6*2500+1+2500*130:numseg*6*2500+2500*130);
        end
    end
    
    params.Fs = 2500;
    [S,f] = mtspectrumc(squeeze(segmentedData(1,:,:)),params);
    power = nan(size(segmentedData,1),size(S,1));
    clear S
    for i = 1:size(segmentedData,1) % i: channels
        [S,f] = mtspectrumc(squeeze(segmentedData(i,:,:)),params);
        S = median(10*log10(S),2); % S = frq x trial;
        
        power(i,:) = S; % power = channel x frq x trial;
        clear S
    end
    %power = normalize(power,2,'zscore');
    
    %power = normalize(power,2,'norm');
    f3 = figure('name',sprintf('Neuropixel probe power spectrum day #%d%s',whichday,datestr(now,30)));
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    set(gca, 'FontName', 'Arial', 'FontSize', 32, 'FontWeight', 'bold')
    %clims = [-1,3];
    imagesc(f,(1:size(power,1)),power);
    %imagesc(f,(1:size(power,1)),power,clims);
    
    axis xy;
    shading flat;%no black boxes around pixles
    colorbar;
    set(gca, 'FontName', 'Arial', 'FontSize', 32, 'FontWeight', 'bold')
    ylim([-.5 40.5]);
    yticks(0:5:40)
    yticklabels(0:500:40*500)
    %     xlim([.5 31.5]);
    %     xticks(0:5:31)
    %     xticklabels(0:250:31*50)
    xlabel('Frequency(Hz)','FontSize', 32, 'FontWeight', 'bold');
    ylabel('Distance from tip of probe (\mum)','FontSize', 32, 'FontWeight', 'bold');
    colormap(parula);
    %title(sprintf('Power spectrum'),'FontSize', 14, 'FontWeight', 'bold')
    
    saveas(f3,fullfile(figpath,f3.Name),'png')
    saveas(f3,fullfile(figpath,f3.Name),'fig')
    
end



% end