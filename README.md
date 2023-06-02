# dorado-snake-nci
snakemake pipeline for duplex basecalling with dorado on **NCI**

![DAG](https://github.com/ritatam/dorado-snake-nci/blob/main/dag.svg)

This pipeline automates the jobs detailed in nanoporetech's duplex_tools [repo](https://github.com/nanoporetech/duplex-tools#usage-with-dorado-recommended). It also incorporates the `split_on_adapter` tool at the end of the pipeline to split chimeric reads on detected adapters (yet false positives could be a problem which can be hard to assess without having the true adapter sequence).

Setup:
- install [dorado](https://github.com/nanoporetech/dorado) and [duplex_tools](https://github.com/nanoporetech/duplex-tools) as instructed. (note: the newest dorado v0.3.0 hasn't been tested in this pipeline)
- (important) download dorado models for simplex and duplex basecalling. Examples:
	- `dorado download --model dna_r10.4.1_e8.2_260bps_sup@v4.1.0`
	- `dorado download --model dna_r10.4.1_e8.2_4khz_stereo@v1.1`
- have an input directory containing raw [pod5](https://github.com/nanoporetech/pod5-file-format) files converted from fast5. Example command:
	`mkdir pod5`
	`cd fast5/  # contains all raw fast5 files` 
	`for file in *.fast5; do pod5 convert fast5 ${file} ../pod5/${file::-6}.pod5; done`

Before using this script:
- change settings in `config.yaml`
- adjust resource requirement in `cluster.yaml`
- change all the paths in `gadimod.sh`, `jobscript.sh` and `submit_on_node.sh` to your own (will improve this in the future)

Running this script:
`qsub submit_on_node.sh`

Any questions please contact: Rita.Tam@anu.edu.au