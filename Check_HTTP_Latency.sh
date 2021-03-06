#########################################################################
# title: Check_HTTP_Latency.sh                                          #
# author: Dario Garrido                                                 #
# date: 20200410                                                        #
# description: Check HTTP latency (alert if higher than 2 s)            #
#########################################################################

while : ; do
	start=$(date +%s) ;
	out=$(curl -w "%{num_connects} %{time_connect} %{time_appconnect} %{time_pretransfer} %{time_starttransfer} %{time_total}" -m 5 -o /dev/null -s 10.1.1.1 ) ;
	end=$(date +%s) ;
	let diff=$end-$start ;
	if (( diff > 2 )) ;
	    then date;
	    echo -e "\n$diff $out";
	else echo -n ".";
	fi ;
done
