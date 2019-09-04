#!/bin/bash

# THIS SCRIPT DO:
# 1 : make training_x and pictures_x folders
#     copy merge.py into pictures_x      | read merge.py's comments for description
#     do the training, 
#    .pb files 'll be saved into training_x
#    .png files into pictures_x
#  EXAMPLE if u set nb_epochs  :          1.pb is always the imagenet                      | 1.png is the choosen layer visualized from imagenet
#                                         2.pb the network after (nb_epochs) epochs        | 2.png is the choosen layer visualized after (nb_epochs) epochs
#                                         x.pb the network after (x-1)*(nb_epochs) epochs  | x.png is the choosen layer visualized after (nb_epochs)*(x-1) epochs
#      sed -i is a method( search and reaplace ), so u can set all the parameters from this scrips
#      .sh files should have execute permission    |   chmod +x ./yourscriptname.sh
#      run .sh file                                |            ./yourscriptname.sh  

######  NOTE : before running the script, delete training_x, pictures_x folders ###################################################

mkdir training_x
mkdir pictures_x
cp merge.py pictures_x/merge.py


#sed -i 's/nb_epoch = .*/nb_epoch = 5/' train.py    # SET : visualize after every x'th epochs
#sed -i 's/COLUMNS = .*/COLUMNS = 15/' vis.py       # SET : change how much neuron should be visualized       |THESE TWO-      |
#sed -i 's/columns = .*/columns = 15/' merge.py     # SET : change how much neuron should be visualized       |MUST BE THE SAME|



for i in {1..50}                                     # SET : iterate from 1 to "value", means (1:train for (np_epochs) epochs 2:visualize after training) repeate (1 and 2) "value" times
do
    
    if [ $i == 1 ]; then                            # both variables set to False, so we do not finetune or load weights from previous training
        sed -i 's/do_load_model = .*/do_load_model = False/' train.py
        sed -i 's/do_finetune = .*/do_finetune = False/' train.py
        echo "i=1"        
    fi
    if [ $i  == 2 ]; then                           # finetune = True, we starting to finetune the model, but this is the first one, so still dont want to load weights from previous training
        sed -i 's/do_finetune = .*/do_finetune = True/' train.py
        sed -i 's/do_load_model = .*/do_load_model = False/' train.py
        echo "i=2"
    fi
    if [ $i != 2 ] && [ $i != 1 ]; then             # here we finetune for nb_epochs, but load the weights from the previous iteration
        sed -i 's/do_finetune = .*/do_finetune = True/' train.py        
        sed -i 's/do_load_model = .*/do_load_model = True/' train.py
        echo "i>2"
    fi
                                                    # each iteration we train->visualize->copy the network's condition->move .pb and .png to the correct folders as mentioned above
    python train.py
    cat googlenet-node-names | grep Branch_3_b_1x1_act/Relu | python vis.py googlenetLucid.pb - $i
    cp googlenetLucid.pb $i.pb
    mv $i.pb training_x
    mv $i.png pictures_x

done
                                                    # finally, we cd into pictures_x folder and run merge.py ( this should be executed next to the images )
													# NOTE : before running the script, delete training_x, pictures_x folders
													# if u have your .pb files from a previous training, use vis_script.sh !!!


