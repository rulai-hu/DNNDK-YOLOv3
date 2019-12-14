#!/bin/bash

python ../yolo_convert.py 0_model_darknet/yolov3.cfg  0_model_darknet/yolov3.weights 1_model_caffe/v3.prototxt 1_model_caffe/v3.caffemodel
