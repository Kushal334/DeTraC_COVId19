%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step 3 :
% applying PCA to project the high-dimension feature space into
% a lower-dimension, such that the highly correlated features were ignored.
% This step is important for the class decomposition to produce a more
% homogeneous classes.
% we looking for the number of components that required to explain 
% 95% variability.
%coeff : the principal component coefficients aka eigenvectors of 
%        covariance matrix of x arranged in descending order.
%score : the projections of the original data on the principal component
%        vector space.
%latent: the variances of the eigenvectors of the covariance matrix
%        and arranged in descending order 
%explained: Percentage of the total variance explained by each principal
%         component.
%
% Input :
% features_normal  ----->  noimages_norm  x 4096
% features_COVID19   -----> noimages_COVID x 4096
% features_SARS    -----> noimages_SARS x 4096
%
% Output :
% x_normal :   the new feature space for normal features.
% y_COVID19:   the new feature space for COVID_19 features.
% z_SARS   :   the new feature space for SARS features.

%%
X= features_normal;
Y= features_COVID19;
Z= features_SARS;

[coeff_1,score_1,latent_1,~,explained_1] = pca(X,'Algorithm','eig');
[coeff_2,score_2,latent_2,~,explained_2] = pca(Y,'Algorithm','eig');
[coeff_3,score_3,latent_3,~,explained_3] = pca(Z,'Algorithm','eig');

%% reduce the dimentionality of normal features space
sum_explained = 0;
idx = 0;
while sum_explained <= 95
    idx = idx + 1;
    sum_explained = sum_explained + explained_1(idx);
end

X_reduce = score_1(:, 1:idx);


%% reduce the dimentionality of COVID19 features space

sum_explained = 0;
idx2 = 0;
while sum_explained <= 95
    idx2 = idx2 + 1;
    sum_explained = sum_explained + explained_2(idx2);
end

Y_reduce = score_2(:, 1:idx2);

%% reduce the dimentionality of SARS features space

sum_explained = 0;
idx3 = 0;
while sum_explained <= 95
    idx3 = idx3 + 1;
    sum_explained = sum_explained + explained_3(idx3);
end

Z_reduce = score_3(:, 1:idx3);


%% Create scree plot.
%Make a scree plot of the percent variability explained by each principal component.
% explained_1-----> containes features normal
% explained_2 ----> containes features COVID19
% explained_3 ----> containes features SARS

plot(cumsum(explained_1));
xlabel('Number of components');x = linspace(0,5); xlim([1 100]);
ylabel('Variance Explained (%)');
hold on
plot(idx,95,'ro','MarkerFaceColor','auto')
 
 % or with bar
figure()
pareto(explained_1)
xlabel('Number of components');
ylabel('Variance Explained (%)');
