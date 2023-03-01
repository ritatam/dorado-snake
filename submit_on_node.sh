#!/bin/bash
#PBS -P xf3
#PBS -q normal
#PBS -l walltime=48:00:00
#PBS -l ncpus=1
#PBS -l mem=2G
#PBS -l storage=scratch/xf3+gdata/xf3+scratch/xc17
#PBS -l wd

source /home/106/ht5438/snakemake_workflows/dorado/gadimod.sh

conda activate /g/data/xf3/miniconda/envs/snakemake


set -ueo pipefail
logdir=log
mkdir -p $logdir
export TMPDIR=${PBS_JOBFS:-$TMPDIR}
TARGET=${TARGET:-all}

QSUB="qsub -q {cluster.queue} -l ncpus={cluster.ncpus} -l ngpus={cluster.ngpus}"
QSUB="$QSUB -l walltime={cluster.time} -l mem={cluster.mem} -N {cluster.name} -l storage=scratch/xf3+gdata/xf3+scratch/xc17 -M rita.tam@anu.edu.au"
QSUB="$QSUB -l wd -m abe -j oe -o $logdir -P {cluster.project}" 


snakemake																	    \
	-j 1000																	    \
	--max-jobs-per-second 2													    \
	--cluster-config /home/106/ht5438/snakemake_workflows/dorado/cluster.yaml		\
	--local-cores ${PBS_NCPUS:-1}											    \
	--js /home/106/ht5438/snakemake_workflows/dorado/jobscript.sh			    	\
	--nolock																    \
	--keep-going															    \
	--rerun-incomplete														    \
	--use-envmodules														    \
	--cluster "$QSUB"														    \
	"$TARGET"
