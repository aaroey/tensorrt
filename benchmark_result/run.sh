set -x

export PYTHONPATH=/usr/local/google/home/laigd/Workspace/aaroey/mymodels:$PYTHONPATH
cd tftrt/examples/image-classification

run() {
  local use_trt=--use_trt
  local trttag='trt'
  if [[ "$precision" == 'FP32' ]]; then
    use_trt=''
    trttag=notrt
  fi
  local dataflags=--use_synthetic
  if [[ "$use_data" ]]; then
    local data_dir=$HOME/team_brain/imagenet-data/for-tftrtrepo-from-nvtfdocker-v18.08-py3
    dataflags="--data_dir $data_dir --calib_data_dir $data_dir"
  fi

  python -u image_classification.py \
    --model $net \
    "$dataflags" \
    --mode benchmark \
    --batch_size $batch  \
    --num_warmup_iterations 1 \
    --num_iterations 2 \
    $use_trt \
    --precision $precision \
    --mode=benchmark \
    --num_calib_inputs $batch \
    > ~/Workspace/aaroey/mytftrtrepo/logs/log.$net.$trttag.$precision.batch$batch 2>&1
}

for net in mobilenet_v2; do
  for precision in INT8 FP32 FP16; do
    for batch in 1; do
      net=$net precision=$precision batch=$batch run
    done
  done
done

"
for net in vgg_19 mobilenet_v2 resnet_v2_50; do
  for precision in FP32 FP16 INT8; do
    for batch in 1 8 128; do
      net=$net precision=$precision batch=$batch run
    done
  done
done
"
