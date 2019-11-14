#use Python-2.7
#source /idi/sabeti-scratch/kjsiddle/dnanexus/dx-toolkit/environment
#dx login --token g1oEXjoQ4dxcX6Z7nsPusJU5YwzyDPV1 --noprojects     # samar's token till 2019-03-04
#dx select project-F5z8Jpj0Yqp6fFpXGfJVBg3b                          # LASV/FUO 15-17


##############################################
#DEBUG=0  # Uncomment to print filenames but not actually run

for SAMPLE in $(dx ls *.bam)
do
   dx mv "$SAMPLE" "${SAMPLE/\.2/}" 
done

