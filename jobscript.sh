#!/bin/bash

source /home/106/ht5438/snakemake_workflows/dorado/gadimod.sh

export TMPDIR=$PBS_JOBFS

set -ueo pipefail
{exec_job}
