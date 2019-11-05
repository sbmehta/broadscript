cat 20190924.Morogoro_virus.xml \
| xtract -pattern INSDSeq \
	    -element INSDSeq_accession-version\
	    -element INSDSeq_length \
	    -lbl "r" -clr \
            -element INSDSeq_create-date \
            -lbl "r" -clr \
	    -element INSDSeq_update-date \
	    -element INSDSeq_topology \
	    -element INSDSeq_comment \
	    -element INSDSeq_source \
	    -element INSDSeq_organism \
	    -element INSDSeq_taxonomy \
	    -element INSDSeq_definition \
	    -element INSDSeq_sequence \
	    -group INSDFeature -if INSDFeature_key -equals source \
   	       -block INSDQualifier -if INSDQualifier_name -equals host \
	          -element INSDQualifier_value \
	       -block INSDFeature -unless INSDQualifier_name -equals host -lbl "\-" \
   	       -block INSDQualifier -if INSDQualifier_name -equals country \
	          -element INSDQualifier_value \
	       -block INSDFeature -unless INSDQualifier_name -equals country -lbl "\-" \
   	       -block INSDQualifier -if INSDQualifier_name -equals organism \
	          -element INSDQualifier_value \
	       -block INSDFeature -unless INSDQualifier_name -equals orgranism -lbl "\-" \
	       -block INSDQualifier -if INSDQualifier_name -equals strain \
	          -element INSDQualifier_value \
	       -block INSDFeature -unless INSDQualifier_name -equals strain -lbl "\-" \
	       -block INSDQualifier -if INSDQualifier_name -equals segment \
	          -element INSDQualifier_value \
	       -block INSDFeature -unless INSDQualifier_name -equals strain -lbl "\-" \
               -block INSDQualifier -if INSDQualifier_name -equals collection_date \
                  -lbl "r" -clr -element INSDQualifier_value \
	       -block INSDFeature -unless INSDQualifier_name -equals collection_date -lbl "\-" \
| head -n 20    


# xtract -insd source segment collection_date
