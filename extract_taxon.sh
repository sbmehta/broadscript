#!/bin/zsh

SAMPLE=$1
CLASSIFIER=$2
TAXON=$3
FLOWCELL="HH32MDMXX"
BASEFILE="/d/uafi/metagenomics/$CLASSIFIER.reads/$SAMPLE.$CLASSIFIER.reads.txt"

echo "\\n\\n\\nExtracting: SAMPLE{$SAMPLE} CLASSIFIER{$CLASSIFIER} TAXON{$TAXON}"
echo "Basefile: $BASEFILE"


testflow=$(head -n 1 $BASEFILE | grep -oP '\t\K(\w+)(?=:)' | head -n 1)
if [[ $FLOWCELL != $testflow ]]; then
    fixflow="s/\t$testflow/\t$FLOWCELL/;"   # annoying fix to make sure flowcell name (which i may have compressed) matches raw file
else
    fixflow=""
fi
fixflow=$fixflow"s/\/1//"

if [ ! -f $BASEFILE ]; then
    echo "$BASEFILE not found."
    exit 1
fi

if [ -f ./$SAMPLE.$CLASSIFIER.$TAXON.txt ]; then
    echo "Reusing $SAMPLE.$CLASSIFIER.$TAXON.txt"
else
    echo "Searching read list ..."
    start=$(date +%s)
    grep -P "\t$TAXON(\t|$)" $BASEFILE | sed $fixflow > $SAMPLE.$CLASSIFIER.$TAXON.txt
    finis=$(date +%s)
    echo "Elapsed: $((finis-start)) seconds."
fi
linecount=$(wc -l < $SAMPLE.$CLASSIFIER.$TAXON.txt)
echo "Found $linecount reads."

echo "\\n\\n\\n\\nExtracting read sequences ..."
start=$(date +%s)
awk '{print $2}' $SAMPLE.$CLASSIFIER.$TAXON.txt > $SAMPLE.$CLASSIFIER.$TAXON.list.txt
java -jar ~/samtools-1.9/picard.jar FilterSamReads I=/d/uafi/raw.bam/$SAMPLE.bam O=$SAMPLE.$CLASSIFIER.$TAXON.bam READ_LIST_FILE=$SAMPLE.$CLASSIFIER.$TAXON.list.txt FILTER=includeReadList
rm $SAMPLE.$CLASSIFIER.$TAXON.list.txt
finis=$(date +%s)
echo "\\n\\nElapsed: $((finis-start)) seconds."

echo "Copying to FASTA ..."
samtools fasta $SAMPLE.$CLASSIFIER.$TAXON.bam > $SAMPLE.$CLASSIFIER.$TAXON.fasta

