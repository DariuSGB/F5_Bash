#########################################################################
# title: Collect_Tmctl_Stats.sh                                         #
# author: Dario Garrido                                                 #
# date: 20200410                                                        #
# description: Collect tmctl stats                                      #
#########################################################################

while true; do
	date >> /var/tmp/output_tmctl.txt;
	date +%s >> /var/tmp/output_tmctl.txt;
	tmctl -ai -c -d blade >> /var/tmp/output_tmctl.txt;
	date;
	echo "Collecting tmctl stats. Press ^c to stop";
	sleep 5;
done
