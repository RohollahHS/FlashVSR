module --force purge all
module load StdEnv/2023  intel/2025.2.0  openmpi/5.0.8
module load cuda/12.9
source /scratch/rohhs/venvs/FlashVSR/bin/activate

cd $PROJECTS_DIR/FlashVSR/examples/WanVSR/

input=inputs/768_416_bike.mp4
results_dir=/scratch/rohhs/downloads/

python infer_flashvsr_v1.1_tiny_long_video.py --inputs $input --results_dir $results_dir
