### Downloaded from S Mehta github repo 01/08/19 ###

# login to environment and select working project #
#use Python-2.7
#source /idi/sabeti-scratch/kjsiddle/dnanexus/dx-toolkit/environment
# dx select [project directory]

################ TARGET DATA #################
## flowcell ids are stored in flowcells_run_list.txt ##

while read FLOWCELLNAME;
do
echo $FLOWCELLNAME

FLOWCELLDIR="$FLOWCELLNAME"    # ** Start with all bam files anywhere below this directory (recursive)
ACCEPTFILTER_RE=".bam"                     # ** Accept only files whose full paths match this regex pattern
REJECTFILTER_RE="subsamp|Unmatched"         # ** Reject any file whose full path matches this regex pattern

############# STANDARD OPTIONS ###############
## all below options will need to be changed to reflect the layout and viral-ngs versions in your project ##

APPNAME="align_and_plot"
APPDIR="/pipelines/v1.21.2/align_and_plot"

ASSEMBLYDIR="/align_and_plot"
RESOURCEDIR="/resource_files"
REFERENCEDIR="/resource_files/RefSeqs"

## metagenomic databases (again change if project layout is different)
OPTIONS=" -istage-1.assembly_fasta=$REFERENCEDIR/GBvirusC.fna" # this is the reference file of the microbe of interest
OPTIONS+=" -istage-1.gatk_jar=$RESOURCEDIR/GenomeAnalysisTK-3.6.tar.bz2"
OPTIONS+=" -istage-1.novocraft_license=$RESOURCEDIR/novoalign.lic"

## create output directory
OUTPUTDIR="$ASSEMBLYDIR/$FLOWCELLNAME"
#dx mkdir $OUTPUTDIR


##############################################
#DEBUG=0  # Uncomment to print filenames but not actually run

echo Options: $OPTIONS

for SAMPLE in $(dx find data --name *.bam --path /flowcells/$FLOWCELLDIR --delimiter "*" | cut -f 4 -d "*")
do
   SAMPLENAME=$(basename $SAMPLE)
   if [[ $SAMPLE =~ $ACCEPTFILTER_RE ]] && [[ ! $SAMPLE =~ $REJECTFILTER_RE ]]  ; then
      if [[ $DEBUG ]] ; then
         echo dx run "$APPDIR/$APPNAME" --yes --destination "$OUTPUTDIR" --name "$APPNAME|$FLOWCELLNAME|${SAMPLENAME%.*}" --tag "$FLOWCELLNAME" -istate-1.reads_unmapped_bam="$SAMPLE" -istage-1.sample_name="$SAMPLENAME" $OPTIONS
      else
         dx run "$APPDIR/$APPNAME" --yes \
              --destination "$OUTPUTDIR" \
              --name "$APPNAME|$FLOWCELLNAME|${SAMPLENAME%.*}" \
              --tag "$FLOWCELLNAME" \
              -istage-1.reads_unmapped_bam="$SAMPLE" -istage-1.sample_name="$SAMPLENAME" $OPTIONS
      fi
   fi
done


done <flowcells_run_list.txt # this is a txt file where each line corresponds to a flowcell (or other subdirectory of raw input files) in your project
