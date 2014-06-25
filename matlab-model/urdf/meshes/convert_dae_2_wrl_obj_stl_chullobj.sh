#!/bin/bash
 # echo of all files in a directory

for file in *.stl
do
  name=${file%%[.]*}
#  meshlabserver -i $file -o $name'.wrl' -om vn
#  meshlabserver -i $file -o $name'.stl' -om vn
  meshlabserver -i $file -o $name'.obj' -om vn
  #echo $name'.wrl' 
done
for file in *_chull.wrl
do
  name=${file%%[.]*}
  #echo $name'.wrl' 
done
