#source /idi/sabeti-scratch/kjsiddle/dnanexus/dx-toolkit/environment
## dx login --token 3aQSon1SFT7Op4l0a8bvrXR3gf9fMUmn
#dx select project-F5z8Jpj0Yqp6fFpXGfJVBg3b                          # LASV/FUO 15-17

############# STANDARD OPTIONS ###############
APPNAME="classify_kaiju"
APPDIR="/pipelines/1.25.0/$APPNAME/"
STAGE0="stage-0"

RESOURCEDIR="/resource_files"
REFERENCEDIR="/references"

INPUTDIR="raw_bam/"
OUTPUTDIR="output/"

ACCEPTFILTER_RE="bam"                     # ** Accept only files whose full paths match this regex pattern
REJECTFILTER_RE="norejects"               # ** Reject any file whose full path matches this regex pattern

## negative depletion filters
OPTIONS=" -i$STAGE0.kaiju_db_lz4=$RESOURCEDIR/kaiju.nr.20180420.fmi.lz4"
OPTIONS+=" -i$STAGE0.krona_taxonomy_db_tgz=$RESOURCEDIR/taxonomy-krona-20160502.tar.lz4"
OPTIONS+=" -i$STAGE0.ncbi_taxonomy_db_tgz=$RESOURCEDIR/taxonomy-ncbi_full-20160923.tar.lz4"

##############################################
#DEBUG=0  # Uncomment to print filenames but not actually run

for SAMPLE in $(dx find data --name *.bam --path /$INPUTDIR --delimiter "*" | cut -f 4 -d "*")
do
   SAMPLENAME=$(basename $SAMPLE)
   if [[ $SAMPLE =~ $ACCEPTFILTER_RE ]] && [[ ! $SAMPLE =~ $REJECTFILTER_RE ]]  ; then
      if [[ $DEBUG ]] ; then
         echo $SAMPLE
      else
         dx run "$APPDIR/$APPNAME" --yes \
              --destination "$OUTPUTDIR" \
              --name "$APPNAME|${SAMPLENAME%.*}" \
              -i$STAGE0.reads_unmapped_bam="$SAMPLE" $OPTIONS
      fi
   fi
done

