#!/bin/bash

mkdir female
mkdir male

for f in *.jpg
do
        echo $f
        IFS=$' '
        attr_values=($(grep "$f" list_attr_celeba.txt))
        file=${attr_values[0]}

        male_attr=${attr_values[21]}

        if [ $male_attr == 1 ]
                then echo "male"
                cp $f male
        elif [ $male_attr == -1 ]
                then echo "female"
                cp $f female
        fi

        echo $male_attr

done

mkdir ../celeba-m-f
mv female ../celeba-m-f
mv male ../celeba-m-f

