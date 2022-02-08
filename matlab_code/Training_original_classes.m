%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =======================================================================
% |         Classification of COVID-19 in chest X-ray images             |
% |                    using  DeTraC deep network                        |  
% =======================================================================
% Asmaa Abbas Hassan, Mohammed M. Abdelsamea, and Mohamed Medhat Gaber
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This paper presents Decompose, Transfer, and Compose (DeTraC) workflow,
% for the classification of COVID-19 chest X-ray images.
% DeTraCcan deal with any irregularitiesin the image dataset by
% investigating its class boundaries using a class decomposition mechanism.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input :
%        Dataset A ----> [COVID19,SARS,Normal]
% Output:
%         evaluation performance for DeTraC model
%         classifier_Accuracy      (ACC)
%         classifier_sensitivity   (SN) 
%         classifier_specifity     (SP)
%         The Area Under the Curve (ACC)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% step 1 : find the network parameters that can be descriminative
%          between the classes.    
%   TP    % No. true positives
%   FP    % No. false positives 
%   FN    % No. false negatives                                 
%   TN    % No. true negatives 

%  Output :
% 'E:\..................\convnet_checkpoint__   .mat') 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% step 2 : using the learned features from step 1 to extract the fetures
%          for each class separetly.  

% load the trained checpoint network that can be descriminated between
% the three classes and determine the layer you want to extract the features
% form it.
% load the images within each class individually and store each class
% as an imageDatastore. 
% specify three separeted variables for each class to contain the activations
% features from the ith images.
%

%  Output :
% Check the Evaluation table to get the pre-trained network
% 'E:\..................\convnet_checkpoint__   .mat') 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% load images
% Create an imageDataStore to read images and store images categories 
% in corresponding sub-folders.
% display the amount of samples in each class

dataset_A='F:\..............\dataset_A';
dataset_A= imageDatastore(dataset_A,'IncludeSubfolders',true,...
           'FileExtensions','.png','LabelSource','foldernames',...
           'ReadFcn',@readAndPreprocessImage);

tbl = countEachLabel(dataset_A)

%% Shuffle files in ImageDatastore
dataset_A = shuffle(dataset_A);

% divide the dataset into 2 groups: 70% for trainingset and 30% for testset
[imdsTrainingSet,imdsTestSet]=splitEachLabel(dataset_A,0.7,'randomize');
numClasses = numel(categories(imdsTrainingSet.Labels));

%%
% hyper parameters for training the network
maxEpochs = 100;
miniBatchSize = 64;
numObservations = numel(trainingimages.Files);
numIterationsPerEpoch = floor(numObservations / miniBatchSize);

opts = trainingOptions('sgdm',...
                    'Initiallearnrate',0.0001,...
                    'Minibatchsize',miniBatchSize,...   
                    'maxEpoch',maxEpochs,...            
                    'L2Regularization',0.001,...        
                    'Shuffle','every-epoch','Momentum',0.9,...
                    'Plots','training-progress','LearnRateSchedule', 'piecewise', ...    
                    'LearnRateSchedule', 'piecewise', 'LearnRateDropFactor', 0.9,'LearnRateDropPeriod',3,...
                    'CheckpointPath' ,'C:\.........\New folder');
                      
%% Loading an ImageNet pre-trained network
% Training the network using the training set and GPU Hardware 
% modifying the network for the new task

Img_net = input('Input the ImageNet pre-trained network: ');
if isa(Img_net,'SeriesNetwork')
    
    Layers=SeriesNet_newtask(Img_net,numClasses);
    [trainedNet,traininfo] = trainNetwork(imdsTrainingSet,Layers,opts);
      
elseif isa(Img_net,'DAGNetwork')

    lgraph=DAGNet_newtask(Img_net,numClasses);
    [trainedNet,traininfo] = trainNetwork(imdsTrainingSet,lgraph,opts);
    
end

%%
%
% Classification DeTraC model
% load mat.file from CheckpointPath to evaluate the classification performance
% Classify the testset images using the fine-tuned network,
% net:  the learned parameters

ChecKpoint_path = dir('C:\.....................\*.mat');  
num=length(ChecKpoint_path);

for i=1 : num

    
      filename = strcat('C:\.........\New folder\',srcFiles_CheckpointPath(i).name);
      load(filename);
           
      [predictedlabels,scores] = classify(net,imdsTestSet);  
      [cmat,classNames] = confusionmat(imdsTestSet.Labels, predictedlabels); 
      cm = confusionchart(cmat,classNames);
      sortClasses(cm,["Covid19","SARS","normal"])
      cmat=cm.NormalizedValues;
           
      [acc, sn, sp]= ConfusionMat_MultiClass (cmat,numClasses);
      
       %% creates a table from the input variables
       Evaluation_Table(i,:) = table({filename},acc,sn,sp);
        
end
     
%% 
