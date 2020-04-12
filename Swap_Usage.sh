#########################################################################
# title: Swap_Usage.sh                                                  #
# author: Dario Garrido                                                 #
# date: 20200410                                                        #
# description: Show swap memory used by processes                       #
#########################################################################

for file in /proc/*/status ; do
	awk '/VmSwap|Name/{
	    printf $2 " " $3
	}END{
	    print ""
	}' $file; done | sort -k 2 -n -r | less
