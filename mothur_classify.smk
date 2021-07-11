rule mothur_classify_silva:
    output:
        "./representatives.1.wang.tax.summary",
        "./representatives.1.wang.taxonomy"
    input:
        "./representatives.fasta"
    params:
        template={config['template']},
        taxonomy={config['taxonomy']},
        search={config['search']},
        method={config['method']},
        processors={config['proc']}
    conda:
        "./mothur.yaml"
    shell:
        """
        mothur "#classify.seqs(fasta={input[0]}, template={params.template}, taxonomy={params.taxonomy}, method={params.method}, processors={params.processors}, search={params.search})" ;
        """