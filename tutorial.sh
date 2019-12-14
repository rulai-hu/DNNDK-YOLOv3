#! /bin/bash

############################################################################
# set ML_DIR variable

ML_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
export ML_DIR
echo ML_DIR is $ML_DIR


############################################################################
# Section 1.3
############################################################################
if [ ! -d $ML_DIR/caffe-master/ ]; then

# Uncompress all the ```*.tar.gz``` files in the repository, 
    tar -xvf caffe-master.tar.gz 
    tar -xvf darknet_origin.tar.gz
    #split yolov3_deploy.tar.gz yolov3.tar.gz.parta -b 24MB    
    cat yolov3_deploy.tar.gz.partaa* > yolov3_deploy.tar.gz
    tar -xvf yolov3_deploy.tar.gz
    rm yolov3_deploy.tar.gz.*
    cd example_yolov3/5_file_for_test/
    tar -xvf calib_data.tar 
    cd ../../

# Run the following commands from the working directory:
    find . -type f -name "*.txt"   -print0 | xargs -0 dos2unix
    find . -type f -name "*.data"  -print0 | xargs -0 dos2unix
    find . -type f -name "*.cfg"   -print0 | xargs -0 dos2unix
    find . -type f -name "*.names" -print0 | xargs -0 dos2unix
 
# Set the path in the coco.data.relative  file, placed in the example_yolov3/5_file_for_test/ folder
# Set the test images path in the image.txt.relative file, placed in the example_yolov3/5_file_for_test/) folder

    for file in $(find $ML_DIR -iname "*.relative"); do
	sed -e "s^PATH_TO^$ML_DIR^" ${file} > ${file%.relative}
    done

else
    echo "ALREADY DONE"
fi


############################################################################
# Section 2.0: Darknet and Caffe 
############################################################################

cd darknet_origin/
make clean
make -j
cd ..

# NOW you are supposed to be in your Python virtual environment
cd caffe-master/
make clean
make -j
make pycaffe
make distribute

#set the environmental variable
export CAFFE_ROOT=$ML_DIR/caffe-master
export LD_LIBRARY_PATH=$CAFFE_ROOT/distribute/lib:$LD_LIBRARY_PATH
export PYTHONPATH=$CAFFE_ROOT/distribute/python:/usr/local/lib/python2.7/dist-packages/numpy/core/include/:$PYTHONPATH

#check the environment
python -c "import caffe; print caffe.__file__"


############################################################################
# Section 3.0 
############################################################################
cd example_yolov3/
rm results/*
rm 5_file_for_test/yolov3_*_result.txt

# step 0: Darknet to Caffe conversion
bash -v 0_convert.sh 
# step 1: test Darknet and Caffe YOLOv3 models
bash -v 0_test_darknet.sh
bash -v 1_test_caffe.sh
# step 2: quantize YOLOv3 Caffe model
cp 1_model_caffe/v3.caffemodel  ./2_model_for_quantize/
bash -v 2_quantize.sh 
# step 3: compile ELF file
cp 3_model_after_quantize/ref_deploy.prototxt 3_model_after_quantize/deploy.prototxt
bash -v 3_compile.sh
# step 4: prepare the package for the ZCU102 board
cd ..
cp example_yolov3/4_model_elf/dpu_yolo.elf yolov3_deploy/model/
tar -cvf yolov3_deploy.tar ./yolov3_deploy
gzip -v  yolov3_deploy.tar
