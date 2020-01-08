#!/bin/bash

TFTRT_PATH=/usr/local/google/home/laigd/Workspace/aaroey/mytftrtrepo
MODEL_PATH=/usr/local/google/home/laigd/Workspace/aaroey/mymodels
export PYTHONPATH="$PYTHONPATH:$MODEL_PATH"

install() {
  pushd $MODEL_PATH
  cd research/slim
  python setup.py install
  popd
}
run() {
  echo Setup tensorflow/tensorrt...
  local example_path="$TFTRT_PATH/tftrt/examples/image-classification/"
  local model="mobilenet_v1"
  local dynamic_op_params=--use_trt_dynamic_op
  local output_file="$TFTRT_PATH/output_tftrt_fp16_bs8_${model}"
  echo $output_file

  pushd $example_path
  python -u image_classification.py \
    --root_saved_model_dir /data/tensorflow/image_classification/saved_models \
    --model $model \
    --precision INT8 \
    --mode validation \
    --batch_size 8 \
    --use_trt \
    --num_iterations 100 \
    --data_dir /data/imagenet/train-val-tfrecord \
    --calib_data_dir "/data/imagenet/train-val-tfrecord" \
    --num_calib_inputs 8 \
    $dynamic_op_params 2>&1 | tee $output_file

  popd
  echo "DONE testing $test_case"
}
