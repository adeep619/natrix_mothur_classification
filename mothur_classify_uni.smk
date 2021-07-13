
rule mothur_classify_silva:
        output:
            expand(["{results}/representatives.1.wang.tax.summary", "{results}/representatives.1.wang.taxonomy"],
                results=config["results"])
        input:
            expand("{input}/representatives.fasta", input=config["input"])
        params:
            reference=config['pr2_ref'],
            taxonomy=config['pr2_tax'],
            search=config['search'],
            method=config['method'],
            database=config['database']
        conda:
            "./mothur.yaml"

        threads:
            config['threads']
        shell:
            """
                         mothur "#classify.seqs(fasta={input[0]}, reference={params.reference}, taxonomy={params.taxonomy}, method={params.method}, processors={threads}, search={params.search}" ; # to run mothur command use # in front of every function name
            """
