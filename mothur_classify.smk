rule rule_all:
        input:
                expand(["{results}/representatives.new.0.wang.taxonomy", "{results}/swarm_mothur.csv"], results=config['results'])


rule mothur_classify_silva:
        output:
            expand(["{results}/representatives.new.0.wang.tax.summary", "{results}/representatives.new.0.wang.taxonomy"], results=config["results"])
        input:
            expand("{input}/representatives.new.fasta", input=config["input"])
        params:
            reference=config['pr2_ref'],
            taxonomy=config['pr2_tax'],
            search=config['search'],
            method=config["method"],results=config["results"],path=config["input"]
        threads:
            config["threads"]
        priority: 10
        shell:
                """
                mothur "#classify.seqs(fasta={input[0]}, reference={params.reference}, taxonomy={params.taxonomy}, method={params.method}, processors={threads}, output=simple, search={params.search})" ; # to run mothur command use # in front of every function name
                mv {params.path}/representatives.new.0.wang.tax.summary {params.path}/representatives.new.0.wang.taxonomy {params.results}/;
                """



rule mothur_swarm_merge:
                input:
                        swarm_abundance="results/swarm_table.csv",
                        mothur_tax="results/representatives.new.0.wang.taxonomy"

                output:
                        "{results}/swarm_mothur.csv"
                priority: 2
                params:
                        results=config["results"], scripts=config['scripts']
                shell:
                        "python scripts/merge_mothur_with_swarm.py {input[0]} {input[1]} {output[0]}"
