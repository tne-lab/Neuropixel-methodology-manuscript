function clean_data = get_clean_NP_data_automatic_ES(data,timestamps,segments)
% clean_data = get_clean_data(file,path)

Region1Data = data(1:size(data,1)/2,:);
Region2Data = data(size(data,1)/2+1:size(data,1),:);

%% Convert into fieldtrip data format
region1data = {};
region2data = {};
% expand struct
for i = 1:size(data,1)/2
    region1data.label(1,i) = cellstr(['1R',num2str(i)]);
    region2data.label(1,i) = cellstr(['2R',num2str(i)]);
end
% define label
region2data.label = region2data.label';
region1data.label = region1data.label';
% define time
region2data.time{1,:} = timestamps';
region1data.time{1,:} = timestamps';
% define data
region2data.trial{1} = Region2Data;
region1data.trial{1} = Region1Data;
% define fsample
region2data.fsample = 2500;
region1data.fsample = 2500;

%% Filter the IL and BLA data
% Fs=1500; % sampling frequency
region1_filtered_data = region1data;
region2_filtered_data = region2data;

% V_IL = region1data.trial{1,1};
% V_BLA = region2data.trial{1,1};
% 
% for i=1:4 % Filter theta from IL and gamma from BLA
%     [PL_filtered_data.trial{1,1}(i,:)] = Filt_data(V_IL(i,:),4,8,375,Fs); % filter theta? IL
%     [ST_filtered_data.trial{1,1}(i,:)] = Filt_data(V_BLA(i,:),4,8,375,Fs); % filter gamma from BLA
%     % Fast Gamma: 70:140, Slow Gamma 40:70
% end

%% Cut data into uniform segments
cfg = [];
% cfg.length = 5; % 2 second segments
%cfg.overlap = 0.2; % 20 percent overlap

seg = zeros(size(segments,1),1);
cfg.trl = [segments,seg];
region2data_redefine = ft_redefinetrial(cfg,region2_filtered_data);
region1data_redefine = ft_redefinetrial(cfg,region1_filtered_data);

% %% Remove Artifacts
% temp_data = ft_appenddata(cfg,region1data_redefine,region2data_redefine); % Concatenate IL and BLA
% cfg = [];
% cfg = ft_databrowser(cfg,temp_data);  % Visually highlight trials that contain artifacts
% clean_data = ft_rejectartifact(cfg,temp_data);  % Remove highlighted trials
% % Note that: clean_data.trial{1,:}(1:4,:) are IL channels
% %            clean_data.trial{1,:}(5:8,:) are BLA channels

%% Remove Artifacts _ automatic
cfg = [];
temp = ft_appenddata(cfg,region1data_redefine,region2data_redefine);  % combine IL and BLA data
cfg.artfctdef.zvalue.channel = temp.label;
cfg.artfctdef.zvalue.cutoff = 50; % changes sensitivity of rejection. Higher = less sensitive
% Cutoff is currently the average standard deviation of all 8 channels
cfg.artfctdef.zvalue.trlpadding = 0;
cfg.artfctdef.zvalue.artpadding = 0;  % must be defined whether or not they're used
cfg.artfctdef.zvalue.fltpadding = 0;

cfg.artfctdef.zvalue.cumulative = 'yes';  % filtering the data only for rejection purposes
cfg.artfctdef.zvalue.medianfilter = 'no';  % this is temporary. Original data integrity is maintained
cfg.artfctdef.zvalue.medianfiltord = 9;  % doesn't seem to have any effect (I think)
cfg.artfctdef.zvalue.absdiff = 'yes';

disp('Opening interactive menu. This may take a moment.')
cfg.artfctdef.zvalue.interactive = 'no';  % visually gauge what the zscore cutoff should be

% [cfg, artifacts] = ft_artifact_zvalue(cfg,temp);
[cfg, ~] = ft_artifact_zvalue(cfg,temp);
[clean_data] = ft_rejectartifact(cfg,temp);  % reject artifacts
% Note that: clean_data.trial{1,:}(1:4,:) are IL channels
%            clean_data.trial{1,:}(5:8,:) are BLA channels



end