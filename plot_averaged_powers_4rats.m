function plot_averaged_powers_4rats



figpath = 'Z:\projmon\ericsprojects\NP_manuscript';


params.Fs = 2500;  % it is 2500 originally but will be downsampled to 500.
params.tapers = [3 5];
params.fpass = [0 30];
params.trialave = 0;
movingwin = [0.5 .01];


tmpdata = 1:params.Fs*2+1;

[~,t,f]=mtspecgramc(tmpdata,movingwin,params);



PLclusterIDs = [21,12,24,20];
STclusterIDs = [17,17,22,6];

load('Z:\projmon\ericsprojects\NP_manuscript\Data\LFPdata\NPrats_20221102T170823_CSF02.mat','rat')
csf02 = rat;
clear rat
load('Z:\projmon\ericsprojects\NP_manuscript\Data\LFPdata\NPrats_20221102T173852_CSF03.mat','rat')
csf03 = rat;
clear rat
load('Z:\projmon\ericsprojects\NP_manuscript\Data\LFPdata\UCLArats_20221103T134513_CSF01.mat','rat')
csf01 = rat;
clear rat
load('Z:\projmon\ericsprojects\NP_manuscript\Data\LFPdata\UCLArats_20221103T152041_CSM01.mat','rat')
csm01 = rat;
clear rat
rat(1) = csf01;rat(1).name = 'csf01';
rat(2).region = csm01.region;rat(2).name = 'csm01';
rat(3).region = csf02.region;rat(3).name = 'csf02';
rat(4).region = csf03.region;rat(4).name = 'csf03';

for i = 1:length(PLclusterIDs)

PowerPL_cor(:,:,i) = rat(i).region(1).cluster(PLclusterIDs(i)).S;

PowerPL_incor(:,:,i) = rat(i).region(1).cluster(PLclusterIDs(i)).S2;

PowerST_cor(:,:,i) = rat(i).region(2).cluster(STclusterIDs(i)).S;

PowerST_incor(:,:,i) = rat(i).region(2).cluster(STclusterIDs(i)).S2;
end


PowerPL_cor = median(PowerPL_cor,3);
PowerPL_incor = median(PowerPL_incor,3);
PowerST_cor = median(PowerST_cor,3);
PowerST_incor = median(PowerST_incor,3);


for reg = 1:2
f1 = figure('name',sprintf('Power specgram heatmap 4rats averaged region %d',reg));
        subplot(1,3,1)

%         S = data(i).S;
if reg == 1
    normS = PowerPL_cor;
elseif reg ==2
    normS = PowerST_cor;
end
%         normS = S;
        pcolor(t,f, normS'); colormap(parula); shading flat
        hold on
        xlabel('Time(sec)'); ylabel('Frequency (Hz)');
        axis xy;
        clim([-5 5]); 
        % colorbar
        ylim(params.fpass);
        title('Correct trials')
        set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
       
        
        subplot(1,3,2)

        if reg == 1
            normS2 = PowerPL_incor;
        elseif reg ==2
            normS2 = PowerST_incor;
        end

        pcolor(t,f, normS2'); colormap(parula); shading flat
        xlabel('Time(sec)'); ylabel('Frequency (Hz)');
        axis xy;
        clim([-5 5]); 
        % colorbar;
        ylim(params.fpass);
        title('Incorrect trials')
        set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
%         colorbar.Ticks = [-5,-2.5,0,2.5,5];
        
        subplot(1,3,3)
        S3 = normS - normS2;
S4 = S3;
        pcolor(t,f, S4'); colormap(parula); shading flat
        xlabel('Time(sec)'); ylabel('Frequency (Hz)');
        axis xy;
        clim([-5 5]); 
        % colorbar;
        ylim(params.fpass);
        title('Correct - Incorrect')
        f1.Position = [1996 494 1798 387];
        set(gca, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold')
%         colorbar.Ticks = [-5,-2.5,0,2.5,5];
        
        saveas(f1,fullfile(figpath,f1.Name),'png')
        saveas(f1,fullfile(figpath,f1.Name),'fig')
        
end