#   DeTraC_COVId19

 Here, we validate and adopt our deep CNN approach, called Decompose, Transfer, and Compose (DeTraC), for the classification of COVID-19 chest X-ray images. DeTrac has achieved a high accuracy of 97.35% (with sensitivity of 98.23% and specificity of 96.34%) in the detection of COVID-19 X-ray images from normal, and severe acute respiratory syndrome cases. 
 
 
## **Dataset description**

We used **80** samples of normal CXRs from the Japanese Society of Radiological Technology and the following open source chest radiography datasets, which contains **105** and **11** samples of COVID-19 and SARS (with 4248×3480 pixels).


```python
open source for chest radiography datasets:
 https://github.com/ieee8023/covid-chestxray-dataset
```
## **Requirement**

Matlab R2019a - window 8 or later version

## A guidance for usage

1. Consist of three parts :
 - Run (Training_original_classes.m) matlab file on the original classes (dataset A),
 - check the validation accuracy to get the significant classification performence ,
 - using the learned weights to get the features for each class separetly (extract_features.m).
2. Run (Pca_CXR.m) matlab file to reduce the dimension features space for each original class.
3. Run (construct_dataset_B.m) to apply the K-means clustering algorithm.
4. Run (Training_after_decompose.m) to apply the DeTraC model.

## **Results**

DeTraC_COVID19 achieved high accuracy of 97.35% which proved that CNNs have an effective and robust solution for the detection 
of the COVID-19 cases from CXR images and as a consequence this can be contributed to control the spread of the disease.


**Table 1:** COVID-19 classification obtained byDeTraC-Vgg19 on chest X-rayimages.
|  Accuracy | Sensitivity  |  Specificity | 
| ------------ | ------------ | ------------ |
|  97.35%      | 98.23%      |      96.34%  |  

 Fig: the learning curve accuracy and loss between training and test sets.

![1](https://github.com/asmaa4may/DeTraC_COVId19/blob/master/images/Learningcurve.PNG ) 


## Contact
Please do not hesitate to contact us if you have any question. asmaa.abbas@science.aun.edu.eg

## Citation

 If you used DeTraC and found it useful, please cite the following papers:
 
 •	Abbas A, Abdelsamea MM, Gaber MM. DeTraC: **Transfer Learning of Class Decomposed Medical Images in Convolutional Neural Networks. IEEE Access** 2020. ( https://ieeexplore.ieee.org/document/9075155?source=authoralert)
 
 •	Abbas A, Abdelsamea MM, Gaber MM. **Classification of COVID-19 in chest X-ray images usingDeTraC deep convolutional neural network. Applied Intelligence, to appear** 2020.

 
## License
[MIT](https://github.com/asmaa4may/DeTraC_COVId19/blob/master/LICENSE)





