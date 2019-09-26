#!/bin/bash

######  NOTE : before running the script, delete pictures_x folder ###################################################

mkdir pictures_x
cp merge.py pictures_x/merge.py

#sed -i 's/nb_epoch = .*/nb_epoch = 5/' train.py    # SET : visualize after every x'th epochs
#sed -i 's/COLUMNS = .*/COLUMNS = 15/' vis.py       # SET : change how much neuron should be visualized       |THESE TWO-      |
#sed -i 's/columns = .*/columns = 15/' merge.py     # SET : change how much neuron should be visualized       |MUST BE THE SAME|

for i in {1..50}                                     # SET : iterate from 1 to "value" must be the number of .pb files
do
                                                    # each iteration we visualize->copy .png to the correct folder
													# set the layer after grep below
    cat googlenet-node-names | grep Mixed_4f_Branch_3_b_1x1_act/Relu | python vis.py training_x/$i.pb - $i
    mv $i.png pictures_x

done
                                                    # finally, we cd into pictures_x folder and run merge.py ( this should be executed next to the images )
													# NOTE : before running the script, delete pictures_x folder
													# if u dont have your .pb files from a previous training, use train_vis_script.sh !!!
cd pictures_x
python merge.py
