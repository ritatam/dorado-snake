#!/bin/bash
#PBS -P xf3
#PBS -q normal
#PBS -l walltime=48:00:00
#PBS -l ncpus=1
#PBS -l mem=2G
#PBS -l storage=scratch/xf3+gdata/xf3
#PBS -l wd
#PBS -j oe
#PBS -M rita.tam@anu.edu.au
#PBS -m abe

###change settings here###
script_dir=/abspath/to/dorado-snake-nci
conda_snakemake_env=/path/to/miniconda/envs/snakemake
storage=scratch/xf3+gdata/xf3
##########################

conda activate ${conda_snakemake_env}
source ${script_dir}/gadimod.sh

set -ueo pipefail
logdir=log
mkdir -p $logdir
export TMPDIR=${PBS_JOBFS:-$TMPDIR}
TARGET=${TARGET:-all}

QSUB="qsub -q {cluster.queue} -l ncpus={cluster.ncpus} -l ngpus={cluster.ngpus}"
QSUB="$QSUB -l walltime={cluster.time} -l mem={cluster.mem} -N {cluster.name} -l storage=${cluster.storage}"
QSUB="$QSUB -l wd -m abe -j oe -o $logdir -P {cluster.project}" 

snakemake																	    \
	-j 1000																	    \
	--max-jobs-per-second 2													    \
	--cluster-config ${script_dir}/cluster.yaml		\
	--local-cores ${PBS_NCPUS:-1}											    \
	--js ${script_dir}/jobscript.sh			    	\
	--nolock																    \
	--keep-going															    \
	--rerun-incomplete														    \
	--use-envmodules														    \
	--cluster "$QSUB"														    \
	"$TARGET"
