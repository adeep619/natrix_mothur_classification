rule vsearch_otu:
    input:
        expand("results/finalData/OTU_fasta.file.txt")
    output:
        expand("results/finalData/match_scores.txt")
    conda:
                "/mnt/xio/botany/Aman/Natrix_master/envs/vsearch.yaml"
    shell:
        "vsearch --usearch_global {input} -db {input} --self --id .84 --iddef 1 " \
        "--userout {output} -userfields query+target+id --maxaccepts 0 --query_cov .9 --maxhits 10"

rule generate_otu_fasta:
    input:
        expand("results/finalData/swarm_mothur.csv")
    output:
        expand("results/finalData/OTU_fasta.file.txt")
    params:
        scripts=config['mumu']['otu_fasta_script']
    shell:
        "python {params.scripts} {input} {output} ; sed -i 1,2d {output} ;"

rule run_mumu:
    input:
        expand("results/finalData/swarm_mothur.csv"),
        expand("results/finalData/match_scores.txt")
    output:
        expand("results/finalData/OTU_table_mumu.csv")
    log:
        "results/logs/finalData/otu_mumu.log"
    conda:
        "../envs/mumu.yaml"
    shell:
        "mumu --otu_table {input[0]} --match_list {input[1]} --new_otu_table {output} --log {log}"