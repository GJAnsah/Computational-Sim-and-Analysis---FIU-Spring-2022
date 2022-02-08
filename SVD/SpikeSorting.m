%% BME6717 Dataset 2 Spike Sorting with SVD

% In NeuronData.mat are 300 records of recordings from an electrode implanted in motor cortex of an 
% animal. The data have been aligned in time using a thresholding algorithm and the records have been 
% trimmed to include only a 48 sample time window around the detected peaks (action potentials) from 
% the time series record. This electrode records noise and action potentials from many different neurons 
% simultaneously.
% 1) Use SVD and/or PCA to analyze the dataset.
% 2) Estimate how many neurons are being recorded from the electrode and classify each observation.


%% IMPORTING DATA

SpikeData = importdata('NeuronData.mat');

%% PLOTTING
%%
%all records from raw data
figure(1)
plot(SpikeData')
xlabel('time(s)')
ylabel('voltage(uV)')
title('Plots of all 300 records')
%%
%plots of 6 random records of electrode recording
figure(2)
selection=randi(300,1,4);
for i=1:length(selection)
    hold on
    j=selection(i);
    subplot(2,2,i)
    plot(SpikeData(j,:))
    xlabel('time(s)')
    ylabel('voltage(uV)')
    title(['Record ' num2str(j)])
end
sgtitle('Plots of 4 random records of electrode recordings')
%% NOISE REMOVAL - PCA

%computing PCA
[coeff, score, ~,...
    ~, explained,mu] = pca(SpikeData);
%mu - column means
%explained varainces by each principal component
%%
%bar plot explained variance from data
figure(3)
subplot(211)
bar(explained)
xlabel('Prinicpal Component')
ylabel('percentage variance eplained')
title('Explained variances of each Principal Component')

subplot(212)
b=bar(explained(1:10));
xlabel('Prinicpal Component')
ylabel('percentage variance eplained')
title('Explained variances of first 10 Principal Components')
xtips1 = b.XEndPoints;
ytips1 = b.YEndPoints;
labels1 = string(b.YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

%%
%Reconstructing from first 1-4 Principal Components
for n=1:4
    SpikeData_new{n} = score(:,1:n) * coeff(:,1:n)' + mu;
end

%%
% Plotting 4 random signals for each reconstructed dataset
figure(2)
for n=1:4
    SpikeData_0=SpikeData_new{n};
    for i=1:length(selection)
        hold on
        j=selection(i);
        subplot(2,2,i)
        plot(SpikeData_0(j,:))
        xlabel('time(s)')
        ylabel('voltage(uV)')
        title(['Record ' num2str(j)])
    end
end
sgtitle('Plots of 4 random records of electrode recordings')
legend('Original signal','1 PC','2 PC','3 PC','4 PC')
%%
% Plotting reconstructed dataset
figure(4)
plot(SpikeData_new{2}')
xlabel('time(s)')
ylabel('voltage(uV)')
title('Plots of all 300 records')
subtitle('after Singular Value Decomposition with 2 PC')
%%
% Visualizing Clusters
for n=1:4
    SpikeData_0=SpikeData_new{n};
    [coeff, score, latent,...
        tsquared, explained,mu] = pca(SpikeData_0);
    id=kmeans(SpikeData_0,3);

    figure(5)
    sgtitle("Neuron Clusters For All 300 Records")

    subplot(2,2,n)
    hold on
    plot(SpikeData_0(id==1,:)','r')
    plot(mean(SpikeData_0(id==1,:),1),'k',"LineWidth",1.8)
    plot(SpikeData_0(id==2,:)','g')
    plot(mean(SpikeData_0(id==2,:),1),'k',"LineWidth",1.8)
    plot(SpikeData_0(id==3,:)','b')
    plot(mean(SpikeData_0(id==3,:),1),'k',"LineWidth",1.8)

    title(['All Records Using ' ,num2str(n),' Principal Components'])
    xlabel('time(s)')
    ylabel('voltage(uV)')

    figure(6)
    sgtitle("PC 1 vs PC 2 for Reconstructed Dataset")
    subplot(2,2,n)
    gscatter(score(:,1),score(:,2),id)
    xlabel('PC 1'); ylabel('PC 2')
    title(['Using ',num2str(n),' Principal Components'])
    lgnd = legend("1","2","3"); title(lgnd,"Neuron");
end
