#!/bin/bash
mkdir input  results database
path=$(pwd)
echo 'pr2_db_version: "4.14.0"' > config_mothur.yml
echo 'silva_db_version: "138.1"' >> config_mothur.yml
echo "database: '$path/database'" >> config_mothur.yml
echo "scripts: '$path/scripts/'" >> config_mothur.yml
echo '# mothur parameter' >> config_mothur.yml
echo 'search: "kmer"' >> config_mothur.yml
echo 'method: "wang"' >> config_mothur.yml
echo "silva_ref: '$path/database/silva_db.138.1.tax'" >> config_mothur.yml
echo "silva_tax: ' $path/database/silva_db.138.1.fasta'" >> config_mothur.yml
echo "pr2_ref: '$path/database/pr2db.4.14.0.fasta'" >> config_mothur.yml
echo "pr2_tax:  '$path/database/pr2db.4.14.0.tax' " >> config_mothur.yml
echo 'threads: 16' >> config_mothur.yml
echo "results: '$path/results'" >> config_mothur.yml
echo "input: '$path/input'" >> config_mothur.yml
echo '' >> config_mothur.yml
