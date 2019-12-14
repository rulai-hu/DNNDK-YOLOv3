#!/bin/bash

#Assume the dnnc-dpu1.3.0 is installed in /usr/local/bin

dnnc-dpu1.3.0 --prototxt=3_model_after_quantize/deploy.prototxt \
              --caffemodel=3_model_after_quantize/deploy.caffemodel \
              --dpu=4096FA \
              --cpu_arch=arm64 --output_dir=4_model_elf \
              --net_name=yolo --mode=normal --save_kernel
