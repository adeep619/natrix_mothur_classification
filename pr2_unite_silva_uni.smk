rule all:
   input:
       expand(["{database}/unite_v8.3.tax", "{database}/pr2db.{pr2_db_version}.tax","{database}/silva_db.silva_db.{silva_db_version}.tax"],
           database=config["database"], pr2_db_version=config['pr2_db_version'], silva_db_version=config['silva_db_version'])
rule download_pr2:
    output:
        "{database}/pr2db.{pr2_db_version}.fasta",
        "{database}/pr2db.{pr2_db_version}.tax"
    params:
        db_version=config["pr2_db_version"],
        database=config["database"],
    shell:
        """
        wget -P ./ --progress=bar https://github.com/pr2database/pr2database/releases/download/v{params.db_version}/pr2_version_{params.db_version}_SSU_mothur.fasta.gz;
        wget -P ./ --progress=bar https://github.com/pr2database/pr2database/releases/download/v{params.db_version}/pr2_version_{params.db_version}_SSU_mothur.tax.gz;
		gunzip -c ./pr2_version_{params.db_version}_SSU_mothur.fasta.gz > {params.database}/pr2db.{params.db_version}.fasta;
		gunzip -c ./pr2_version_{params.db_version}_SSU_mothur.tax.gz > {params.database}/pr2db.{params.db_version}.tax;
        rm ./pr2_version_{params.db_version}_SSU_mothur.tax.gz ./pr2_version_{params.db_version}_SSU_mothur.fasta.gz;
        """
rule download_unite:
    params:
        database=config["database"],

    output:
        "{database}/unite_v8.3.fasta",
        "{database}/unite_v8.3.tax"

    shell:
        """
        wget -P ./ --progress=bar  -O UNITE_public_mothur_10.05.2021.tgz --progress=bar https://files.plutof.ut.ee/public/orig/38/6A/386A46113D04602A78FB02497D9B0E1A8FE2145B23C2A6314A62B419F0D08E73.tgz;
        tar -xvf UNITE_public_mothur_10.05.2021.tgz;
        mv UNITE_public_mothur_10.05.2021/UNITE_public_mothur_10.05.2021_taxonomy.txt {params.database}/unite_v8.3.tax;
        mv UNITE_public_mothur_10.05.2021/UNITE_public_mothur_10.05.2021.fasta {output[0]};
        rm -rf UNITE_public_mothur_10.05.2021;
        """
rule download_silva:
    output:
        "{database}/silva_db.{silva_db_version}.fasta",
        "{database}/silva_db.{silva_db_version}.tax"
    params:
        db_version=config["silva_db_version"],
        database=config['database'],
        scripts=config['scripts'] #to access scripts in scripts directory
    shell:
        """
        #wget -P ./ --progress=bar -O silva_{params.db_version}.fasta.gz https://www.arb-silva.de/fileadmin/silva_databases/current/Exports/SILVA_{params.db_version}_SSURef_tax_silva.fasta.gz;
        gunzip -c silva_{params.db_version}.fasta.gz > {params.database}/silva_db.{params.db_version}.fasta;
        wget -P ./ --progress=bar -O silva_{params.db_version}.tax.gz https://www.arb-silva.de/fileadmin/silva_databases/current/Exports/taxonomy/taxmap_slv_ssu_ref_{params.db_version}.txt.gz
        gunzip -c silva_{params.db_version}.tax.gz > {params.database}/silva_db.{params.db_version}.tax;
        bash {params.scripts}/new.sh {params.database}/silva_db.{params.db_version}.tax > {params.database}/silva.tax.tmp; #to convert silva taxonomy file to mothur format
        rm {params.database}/silva_db.{params.db_version}.tax;
        mv {params.database}/silva.tax.tmp {params.database}/silva_db.{params.db_version}.tax;
        sed 1d -i {params.database}/silva_db.{params.db_version}.tax #to remove header in taxonomy file
        """

