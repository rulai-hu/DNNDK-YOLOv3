./../caffe-master/build/examples/yolo/yolov3_detect.bin 1_model_caffe/v3.prototxt \
                                                        1_model_caffe/v3.caffemodel \
                                                        5_file_for_test/image.txt \
                                                        -out_file 5_file_for_test/yolov3_caffe_result.txt \
                                                        -confidence_threshold 0.005 \
                                                        -classes 80 \
                                                        -anchorCnt 3 

