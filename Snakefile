import pandas as pd
from snakemake.utils import validate

validate(config, "schema/config.schema.yaml")

units = pd.read_table(config["general"]["units"], index_col=["sample", "unit"],
    dtype=str)
units.index = units.index.set_levels([i.astype(str) for i in units.index.levels])
name_ext = config["merge"]["name_ext"][:-1]

def is_single_end(sample, unit):
    return pd.isnull(units.loc[(sample,unit), "fq2"])

if config["merge"]["paired_End"]:
    reads = [1,2]
else:
    reads = 1

rule all:
    input:
        "results/finalData/unfiltered_table.csv",
        "results/finalData/filtered_table.csv",
        "results/finalData/swarm_table.csv" if config["general"]["seq_rep"] == "OTU" else [],
        "results/qc/multiqc_report.html" if config["general"]["multiqc"] else [],
        "results/finalData/figures/AmpliconDuo.RData" if config["merge"]["ampliconduo"] and config["merge"]["filter_method"] == "split_sample" else [],
        #"results/finalData/filtered_blast_table.csv" if config["blast"]["blast"] else [],
        #"results/finalData/filtered_blast_table_complete.csv" if config["blast"]["blast"] else []
        "database/pr2db.4.14.0.fasta", "database/pr2db.4.14.0.tax",
        "database/silva_db.138.1.fasta", "database/silva_db.138.1.tax",
        "database/unite_v8.3.fasta", "database/unite_v8.3.tax", 
        "results/finalData/representatives.0.wang.taxonomy", 
        "results/finalData/swarm_mothur.csv",
        "results/finalData/OTU_table_mumu.csv"
ruleorder: assembly > prinseq

include: "rules/demultiplexing.smk"
include: "rules/quality_control.smk"
include: "rules/read_assembly.smk"
include: "rules/dereplication.smk"
include: "rules/chim_rm.smk"
include: "rules/merging.smk"
include: "rules/clustering.smk"
#include: "rules/blast.smk"
include: "rules/pr2_unite_silva.smk" 
include: "rules/classify.smk"
include: "rules/mumu.smk"