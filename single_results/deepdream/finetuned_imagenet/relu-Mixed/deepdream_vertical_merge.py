# iterate over png files in the current folder, and merge them into one png (merged.png) 
# PARAMETER :
#                       column    :    SAME as the COLUMN in vis.py ( the number of neurons visualized )
# NOTE : if u change the size of the generated images(in vis.py), change height and width here too!
from PIL import Image
import os
import sys

LAYERS = sys.argv[1:]


layers = []
for l in sys.stdin:
    layers.append(l.strip())


number_of_layers = len(layers)

def merge():
    number_of_pictures = 0
    for filename in os.listdir():
        if filename.endswith(".png"):
            x = filename.zfill(15)
            os.rename(filename,x)
            number_of_pictures += 1
   
       
    height = 256
    width = 256
    merged = Image.new('RGB', (width*number_of_layers, height*number_of_pictures))
    iterator = 0
    for filename in sorted(os.listdir()):
        if filename.endswith(".png"):
            print(filename)
            y = Image.open(filename)
            merged.paste(y, (0, iterator*height))
            iterator += 1
    return merged

merge().save('deepdream_merged.png')
