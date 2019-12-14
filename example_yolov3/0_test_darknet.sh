#!/bin/bash

#mkdir -p $(pwd)/results
#rm $(pwd)/results/*
#rm $(pwd)/5_file_for_test/yolov3_darknet_result.txt

../darknet_origin/darknet detector valid  5_file_for_test/coco.data 0_model_darknet/yolov3.cfg 0_model_darknet/yolov3.weights -out yolov3_results_
cat results/yolov3_results_* >> 5_file_for_test/yolov3_darknet_result.txt
