#########################################################################
# title: Check_Pool_Status.sh                                           #
# author: Patrik Jonsson                                                #
# date: 20200410                                                        #
# description: Check global pool status                                 #
# https://pastebin.com/kRp17AxR                                         #
#########################################################################

tmsh show ltm pool detail | gawk --posix '
function red(s) {
    printf "\033[1;31m" s "\033[0m "
}
function green(s) {
    printf "\033[1;32m" s "\033[0m "
}
function blue(s) {
    printf "\033[1;34m" s "\033[0m "
}
BEGIN {
	print "Pool|Member|Availability|State"
}
/^Ltm::Pool/{
	pool=$2
	firstRef=1
}
/Ltm::Pool Member:/{
	if(firstRef == 1){
	    firstRef=0
	    printf pool "|" $(NF)
	} else {
	    printf " " "|" $(NF)
	}
}
/^  {1}\| +(State|Availability)/{
	printf "|"
	if($4 == "available" || $4 == "enabled"){
	    green($4)
	} else if($4 == "unknown"){
	    blue($4)
	} else {
	    red($4)
	}	
}
/^  \| +Traffic/{
	printf "\n"
}
' | column -t -s "|"
