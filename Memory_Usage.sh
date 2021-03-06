#########################################################################
# title: Memory_Usage.sh                                                #
# author: Dario Garrido                                                 #
# date: 20200410                                                        #
# description: Show memory usage in percentage (%)                      #
#########################################################################

awk '
BEGIN {
	while (("free" | getline) > 0 ) {
	    if ($1 == "Mem:") {
	        print("\nMem Used:\t\t", ($3 / $2) * 100)
	    } else if ($2 ~ "buffers") {
	        print("Used After Buffers:\t", ($4 / $3) * 100)
	    } else if($1 == "Swap:") {
	        print("Swap Used:\t\t", ($3 / $2) * 100)
	    }
	} close("free")
}'
