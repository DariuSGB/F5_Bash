#########################################################################
# title: Check_DNS_Latency.sh                                           #
# author: Dario Garrido                                                 #
# date: 20200410                                                        #
# description: Check DNS latency (alert if higher than 50 ms)           #
#########################################################################

while true ; do
	sleep 1 ;
	date=$(date '+%Y-%m-%d %H:%M:%S') ;
	output=$(dig @localhost www.google.com A | grep time | awk '{print $4}') ;
	if (( output > 50 )) ; then echo $date $output 'ms !!!!!!!!!!' ; else echo $date $output 'ms' ; fi ;
done
