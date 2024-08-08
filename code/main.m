clc
clear
close

f = csvread('dataset_easy.csv');
% 
%f = f(randperm(size(f,1)),:);
% 
%Reduction of features
dataset = f(:,1:10);
% 
% %NORMALIZATION
%dataset = normalize(dataset);
% 
%PCA
[coeff, scores, latent] = pca(dataset);
selected_features = latent > 10000; %no norm 10000 norm 0.6
selected_pc = coeff(:, 1:sum(selected_features));
reduced_dataset_PCA = dataset * selected_pc;

% reduced_dataset = tsne(dataset, 'NumDimensions', 5);

labels = f(:,13);

%KMEANS
% rng(2)
% kmeans_result = kmeans(reduced_dataset_PCA, 7, 'Replicates', 12);
% nmi = nmi_calculator(labels', kmeans_result', 7, 7)
% accuracy = accuracy_calculator(labels', kmeans_result')
% 
% gscatter(reduced_dataset_PCA(:,1),reduced_dataset_PCA(:,2),kmeans_result)


% %HIERARCHICAL
% rng(1)
% c = hierarchical_clustering(reduced_dataset_PCA, 700, 7); %no norm 700
% nmi = nmi_calculator(labels', c, 7, 7)
% accuracy = accuracy_calculator(labels', c)
% gscatter(reduced_dataset_PCA(:,1),reduced_dataset_PCA(:,2),c)

%GMM
% rng(3)
% GMModel=fitgmdist(reduced_dataset_PCA,7);
% idx = cluster(GMModel, reduced_dataset_PCA);
% nmi = nmi_calculator(labels', idx', 7, 7)
% accuracy = accuracy_calculator(labels', idx')
% gscatter(reduced_dataset_PCA(:,1),reduced_dataset_PCA(:,2),idx)

% BSAS then Kmeans
bsas_prediction = hierarchical_clustering(reduced_dataset_PCA, 700, 7);
nmi_calculator(labels', bsas_prediction, 7, 7)

%means for each dimension of prediction
mean1 = mean((bsas_prediction == 1)'.* reduced_dataset_PCA, 1);
mean2 = mean((bsas_prediction == 2)'.* reduced_dataset_PCA, 1);
mean3 = mean((bsas_prediction == 3)'.* reduced_dataset_PCA, 1);
mean4 = mean((bsas_prediction == 4)'.* reduced_dataset_PCA, 1);
mean5 = mean((bsas_prediction == 5)'.* reduced_dataset_PCA, 1);
mean6 = mean((bsas_prediction == 6)'.* reduced_dataset_PCA, 1);
mean7 = mean((bsas_prediction == 7)'.* reduced_dataset_PCA, 1);

kmeans_prediction = kmeans(reduced_dataset_PCA, 7, 'Distance', 'sqeuclidean', 'Start', [mean1; mean2; mean3; mean4; mean5; mean6; mean7]);
nmi_calculator(labels', kmeans_prediction', 7, 7)
accuracy = accuracy_calculator(labels', kmeans_prediction')
% 
% gscatter(reduced_dataset_PCA(:,1),reduced_dataset_PCA(:,2),kmeans_prediction)

%Original plot
% gscatter(reduced_dataset_PCA(:,1),reduced_dataset_PCA(:,2),labels)

%SPECTRAL
% spectral = csvread('s6_2.csv');
% spectral = spectral(:,1);
% nmi = nmi_calculator(labels', spectral', 7, 7)
% accuracy = accuracy_calculator(labels', spectral')
% gscatter(reduced_dataset_PCA(:,1),reduced_dataset_PCA(:,2), spectral)

%SPECTRAL
% aglo = csvread('dataset_easy_agglomerative.csv');
% aglo = aglo(:,1);
% nmi = nmi_calculator(labels', aglo', 7, 7)
% accuracy = accuracy_calculator(labels', aglo')
% gscatter(reduced_dataset_PCA(:,1),reduced_dataset_PCA(:,2), aglo)




