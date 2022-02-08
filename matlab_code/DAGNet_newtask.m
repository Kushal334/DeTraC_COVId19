function lgraph = DAGNet_newtask(Img_net,numClasses)


lgraph = layerGraph(Img_net);

%% Replace the last learnable layer(fully connected layer) and the final 
% classification layer with new layers adapted to the new data set.

[learnableLayer,classLayer] = findLayersToReplace(lgraph);
InpSize=learnableLayer.InputSize;

% The new fully connected layer
% Add the softmax layer and the classification layer 
% inisiailize Weights and Bias for the new fully connected layer

newLearnableLayer =fullyConnectedLayer(numClasses,'Name','new_FC','WeightL2Factor',1);
newLearnableLayer.Weights= randn([numClasses InpSize]) * 0.0001;
newLearnableLayer.Bias= randn([numClasses 1])*0.0001 + 1; 
newLearnableLayer.WeightLearnRateFactor=10;
newLearnableLayer.BiasLearnRateFactor=20;


% The new classification layer
newClassLayer =classificationLayer('Name','new_classoutput');

% Replace these new layers within the layers lgraph
lgraph = replaceLayer(lgraph,learnableLayer.Name,newLearnableLayer);
lgraph = replaceLayer(lgraph,classLayer.Name,newClassLayer);

% conncet these new layers within the layers lgraph
layers = lgraph.Layers;
connections = lgraph.Connections;
lgraph = createLgraphUsingConnections(layers,connections);

                                      
end