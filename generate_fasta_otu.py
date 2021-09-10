# this script is for generating fasta from mothur OTU Table file
import sys
import csv
f1 = open(sys.argv[2], 'w')
with open(sys.argv[1], 'r') as file:
        reader = csv.reader(file)
        for row in reader:
            f1.write('>' + row[0] + '\n' + row[1] + "\n")

