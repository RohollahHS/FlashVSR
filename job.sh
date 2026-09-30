##### Directories Setup
SRUN_ARGS="--ntasks=$SLURM_NNODES --ntasks-per-node=1"
export XDG_CACHE_HOME=${SLURM_TMPDIR}/.cache
export XDG_CONFIG_HOME=${SLURM_TMPDIR}/.config
export TRITON_CACHE_DIR=${SLURM_TMPDIR}/.cache/triton
export TMPDIR=${SLURM_TMPDIR}/.cache/tmp
export VLLM_CACHE_ROOT=${SLURM_TMPDIR}/vllm_cache
export VLLM_CONFIG_ROOT=${SLURM_TMPDIR}/vllm_config
export VLLM_ASSETS_CACHE=${SLURM_TMPDIR}/assets_cache
export FLASHINFER_WORKSPACE_BASE=${SLURM_TMPDIR}/flashinfer
srun $SRUN_ARGS mkdir -p ${XDG_CACHE_HOME}
srun $SRUN_ARGS mkdir -p ${XDG_CONFIG_HOME}
srun $SRUN_ARGS mkdir -p ${TRITON_CACHE_DIR}
srun $SRUN_ARGS mkdir -p ${TMPDIR}
srun $SRUN_ARGS mkdir -p ${VLLM_CACHE_ROOT}
srun $SRUN_ARGS mkdir -p ${VLLM_CONFIG_ROOT}
srun $SRUN_ARGS mkdir -p ${VLLM_ASSETS_CACHE}
srun $SRUN_ARGS mkdir -p ${FLASHINFER_WORKSPACE_BASE}

##### Env Setup
module --force purge all
module load StdEnv/2023  intel/2025.2.0  openmpi/5.0.8
module load cuda/12.9
source /scratch/rohhs/venvs/FlashVSR/bin/activate

cd $PROJECTS_DIR/FlashVSR/examples/WanVSR/

##### Run the code

input="/scratch/rohhs/downloads/yt-dlp/biker.mp4"
results_dir=/scratch/rohhs/downloads/yt-dlp

python infer_flashvsr_v1.1_tiny_long_video.py --inputs $input --results_dir $results_dir --scale 1.0 2>&1 | tee -a "$SLURM_OUTPUTS/${SLURM_JOB_ID}_super_resolution.log"
