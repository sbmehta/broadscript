#!/bin/zsh

BASEFILE=$1
DEPTH=$2

INFILE="$BASEFILE.cleaned.assembly1-spades.fasta"
OUTFILE="$BASEFILE.filtered.cleaned.spades.fasta"

echo "\\nFiltering contigs: $INFILE limited to length x coverage >= $DEPTH."

if [ ! -f $INFILE ]; then
    echo "$FILE not found."
    exit 1
fi


awk -v depth=$DEPTH 'BEGIN{RS=">";FS="_";ORS="";OFS=""}($4*$6>=depth){print ">",$0}' < $INFILE > $OUTFILE

echo "Kept $(grep -c ">" $OUTFILE) of $(grep -c ">" $INFILE) sequences. \\n"
