% Modify the last fully connected layer to adopt with new output classes.
% Inisiailize Weights and Bias for the new fully connected layer
% Add the softmax layer and the classification layer


function    Layers = SeriesNet_newtask(Img_net,numClasses)


layersTransfer = Img_net.Layers(1:end-3);
lastFcLayer=Img_net.Layers(end-2);
InpSize = lastFcLayer.InputSize;


newFC =fullyConnectedLayer(numClasses,'Name','new_FC','WeightL2Factor',1);
newFC.Weights= randn([numClasses InpSize]) * 0.0001;
newFC.Bias= randn([numClasses 1])*0.0001 + 1; 
newFC.WeightLearnRateFactor=10;
newFC.BiasLearnRateFactor=20;


Layers =[...
            layersTransfer
            newFC
            softmaxLayer('Name','prob')       
            classificationLayer('Name','coutput')
            ];

end

