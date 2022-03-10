
%loading data
load('BreastCancerData.mat');

Data= BreastCancerData.tissueMeasures;

Pathology= BreastCancerData.pathology;

%converting pathology to numeric targets
targets= zeros(1,length(Pathology));

for i=1:length(targets)
    if string(Pathology{i})== 'Benign'
        targets(i)=1;
    else
        targets(i)=0;
    end
end


% partitioning data randomly into train and test sets;
[trainInd,testInd,valInd] = dividerand(664,0.8,0.2,0); %train and test indices


%creating a feedforward network with n (1 - 6) layers and a random number
%of nodes in each layer
n=randi(6);
layerNodes = zeros(1,n);
for i=1:n
    layerNodes(i)=randi(20);
end

%using the machine learning and statistical toolbox
Mdl=fitcnet(Data(:,trainInd)',targets(:,trainInd),LayerSizes=layerNodes,Activations="relu");

%predicting targets using ANN
netTest=predict(Mdl,Data(:,testInd)');

%real test targets
trueTest = targets(:,testInd);

% checking test accuracy
testAccuracy = 1 - loss(Mdl,Data(:,testInd)',targets(:,testInd), ...
    "LossFun","classiferror")
    
%confusion matrix
confusionchart(trueTest,netTest)
