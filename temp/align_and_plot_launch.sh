#use Python-2.7
#source /idi/sabeti-scratch/kjsiddle/dnanexus/dx-toolkit/environment
#dx login --token y8PHfHZDKX9XRxZNQGO7kAzICeno1ehB --noprojects      # samar's token till 2018-03-02
#dx select project-F5z8Jpj0Yqp6fFpXGfJVBg3b                          # LASV/FUO 15-17
dx select project-FPgF38Q0bg5f24jb13v65Pf1


################ TARGET DATA #################
BAMDIR="yfv/bam"

ACCEPTFILTER_RE="bam"              # ** Accept only files whose full paths match this regex pattern
REJECTFILTER_RE="ignoreme"         # ** Reject any file whose full path matches this regex pattern

############# STANDARD OPTIONS ###############
DATASET="YFVMETA"
APPNAME="align_and_plot"
REFERENCEFILE="humanherpesvirus4.fasta"  # yfv_refseq_nig yfv_refseq_senegal MastadenovirusC murine_leukemia_virus humanherpesvirus4 humanherpesvirus7

APPDIR="/pipelines/v1.21.2/align_and_plot"
OUTPUTDIR="/yfv/align/$REFERENCEFILE"
RESOURCEDIR="/resource_files"
REFERENCEDIR="/resource_files/RefSeqs"


## negative depletion filters
OPTIONS=" -istage-1.assembly_fasta=$REFERENCEDIR/$REFERENCEFILE" 
OPTIONS+=" -istage-1.gatk_jar=$RESOURCEDIR/GenomeAnalysisTK-3.6.tar.bz2"               
OPTIONS+=" -istage-1.novocraft_license=$RESOURCEDIR/novoalign.lic"
#OPTIONS+=" -istage-1.aligner_options=\" -l 30 -g 40 -x 20 -t 502 -r Random\""

##############################################
#DEBUG=0  # Uncomment to print filenames but not actually run

for SAMPLE in $(dx find data --name *.bam --path /$BAMDIR --delimiter "*" | cut -f 4 -d "*")
do
   SAMPLENAME=$(basename $SAMPLE)
   if [[ $SAMPLE =~ $ACCEPTFILTER_RE ]] && [[ ! $SAMPLE =~ $REJECTFILTER_RE ]]  ; then
      if [[ $DEBUG ]] ; then
         echo dx mkdir -p $OUTPUTDIR
         echo dx run "$APPDIR/$APPNAME" --yes --destination "$OUTPUTDIR" --name "$APPNAME|$REFERENCEFILE|$DATASET|${SAMPLENAME%.*}" --tag "$REFERENCEFILE|$DATASET" -istage-1.reads_unmapped_bam="$SAMPLE" -istage-1.sample_name="$SAMPLENAME" $OPTIONS
      else
         dx mkdir -p $OUTPUTDIR
         dx run "$APPDIR/$APPNAME" --yes \
              --destination "$OUTPUTDIR" \
              --name "$APPNAME|$REFERENCEFILE|$DATASET|${SAMPLENAME%.*}" \
              --tag "$REFERENCEFILE|$DATASET" \
              -istage-1.reads_unmapped_bam="$SAMPLE" \
              -istage-1.sample_name="$SAMPLENAME" \
               $OPTIONS
      fi
   fi
done
