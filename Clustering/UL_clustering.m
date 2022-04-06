%% BME 6717: Clustering and Unsupervised Learning

% Goal: Automatically identify the number of nematodes present in each slide image.
% Background: Nematodes are a common model used in biology to study 
% physiological phenomenon including neural dynamics, social behavior, 
% memory, fear responses, and more. The complexity of the organism lies 
% in a “goldilocks” range such that it is simple enough to characterize 
% its behaviors and physiology comprehensively, and sophisticated enough 
% to exhibit classical behavioral responses relevant to higher organisms.
% Moreover, its simplicity allows assays to be conducted on a large scale,
% facilitating statistical robustness; however, the scale requires 
% substantial effort to catalogue the behavior of many organisms.
% 
% The dataset (NematodeImagesThresholded.mat) contains five slide 
% still-frame images of nematodes. The light microscope images were 
% thresholded based on pixel intensity, then set to 1 if the intensity
% was greater than the threshold and 0 otherwise. The data were then 
% reorganized for memory compression as a list of all normalized
% x-y coordinates of the “on” pixels in the slide image. We require an 
% analysis procedure capable of automatically identifying the number 
% of nematodes in each image.

clear
close all

load('NematodeImagesThresholded.mat');
%% Data Visualization
 
n=5; %slide number

slide = SlideGrab{n};

slideName=strcat('Slide-',num2str(n));

figure;
plot(slide(:,1),slide(:,2),'.k','Markersize',2)
title(slideName)
set(gca,'box','on','YTick',[],'Xtick',[],'FontName','Garamond'); axis equal

%saveas(gcf,strcat(slideName,'.png'))

%% k-distance graph from DBSCAN documentation
minpts=100;

kD = pdist2(slide,slide,'euc','Smallest',minpts);
figure;
plot(sort(kD(end,:)));
title('k-distance graph')
xlabel('Points sorted with 50th nearest distances')
ylabel('100th nearest distances')
grid
%% Clustering
epsilon = 53; %

idx = dbscan(slide,epsilon,minpts,Distance="cityblock");

clusterNum=length(unique(idx));


figure;
gscatter(slide(idx~=-1,1),slide(idx~=-1,2),idx(idx~=-1))
% gscatter(slide(:,1),slide(:,2),idx)
title({slideName,strcat('Number of nematodes=',num2str(clusterNum-1)),...
    strcat('epsilon=',num2str(epsilon))})
set(gca,'box','on','YTick',[],'Xtick',[],'FontName','Garamond','FontSize',10); axis equal
set(legend,'Visible','off');
saveas(gcf,strcat('clustered',slideName,'.png'))
%% Silhouette Measure
figure;
s=silhouette(slide,idx,'cityblock');
boxplot(s(idx~=-1));
title(strcat('Silhouette values for ',slideName))
saveas(gcf,strcat('box',slideName,'.png'))
