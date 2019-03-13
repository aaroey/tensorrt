set -x

cd tftrt/examples/image-classification

run() {
  use_trt=--use_trt
  trttag='trt'
  if [[ "$precision" == 'FP32' ]]; then
    use_trt=''
    trttag=notrt
  fi

  python -u image_classification.py \
    --model $net \
    --use_synthetic \
    --data_dir /home/laigd/tftrtrepo/data \
    --mode benchmark \
    --calib_data_dir /home/laigd/tftrtrepo/data \
    --batch_size $batch  \
    --num_iterations 200 \
    $use_trt \
    --precision $precision \
    --mode=benchmark \
    --num_calib_inputs $batch \
    > ~/tftrtrepo/log.$net.$trttag.$precision.batch$batch 2>&1
}

for net in resnet_v1_50; do
  for precision in FP32 FP16 INT8; do
    for batch in 1 8 128; do
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
