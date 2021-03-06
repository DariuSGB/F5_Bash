#########################################################################
# title: Collect_SSL_Summary.sh                                         #
# author: Dario Garrido                                                 #
# date: 20200410                                                        #
# description: Collect info from all SSL Profiles and their usage       #
#########################################################################

#----------------------------------------------------------------------------------------------

# EXISTING SSL PROFILE LIST
sslprof_c=$( tmsh -q -c "cd / ; list ltm profile client-ssl recursive" | grep "profile" | awk '{ print $4 }' | tr '\n' ' ' )
sslprof_s=$( tmsh -q -c "cd / ; list ltm profile server-ssl recursive" | grep "profile" | awk '{ print $4 }' | tr '\n' ' ' )

# CAPTURE VIRTUALS BY PROFILE
vs_sslprof_c=$( tmsh -q -c "cd / ; list ltm virtual recursive profiles { $(echo $sslprof_c) }" )
vs_sslprof_s=$( tmsh -q -c "cd / ; list ltm virtual recursive profiles { $(echo $sslprof_s) }" )

# CAPTURE PROFILES BY CERTIFICATE
pf_sslprof_c=$( tmsh -q -c "cd / ; list ltm profile client-ssl recursive { cert chain key defaults-from ciphers }" )
pf_sslprof_s=$( tmsh -q -c "cd / ; list ltm profile server-ssl recursive { cert chain key defaults-from ciphers }" )

# CAPTURE CERTIFICATES
sslcert=$( tmsh -q -c "cd / ; list sys file ssl-cert recursive expiration-string" )

# CHECK PROFILES IN USE
check_vs_sslprof_c=$( echo "$vs_sslprof_c" | grep -A1 "profiles {" | grep -v "profiles" | grep "[a-zA-Z]" | awk '{ print $1 }' | sort | uniq )
check_vs_sslprof_s=$( echo "$vs_sslprof_s" | grep -A1 "profiles {" | grep -v "profiles" | grep "[a-zA-Z]" | awk '{ print $1 }' | sort | uniq )

# CHECK CERTIFICATES IN USE (deprecated - check later below)
#check_cert_sslprof_c=$( tmsh -q -c "cd / ; list ltm profile client-ssl recursive $( echo "$check_vs_sslprof_c" | tr '\n' ' ' ) { cert chain }" | grep -e "cert" -e "chain" | awk '{ print $2 }' | grep -v "none" | sort | uniq )
#check_cert_sslprof_s=$( tmsh -q -c "cd / ; list ltm profile server-ssl recursive $( echo "$check_vs_sslprof_s" | tr '\n' ' ' ) { cert chain }" | grep -e "cert" -e "chain" | awk '{ print $2 }' | grep -v "none" | sort | uniq )

#----------------------------------------------------------------------------------------------

# FORMAT VIRTUAL SERVER OUTPUT
T1C1=$( echo "$vs_sslprof_c" | grep "virtual" | awk '{ print $3 }' )
T1C2=$( echo "$vs_sslprof_c" | grep -A1 "profiles" | grep -v "profiles {" | grep "[a-zA-Z]" | sed "s/profiles//" | awk '{ print $1 }' )
T1C3=$( echo "$vs_sslprof_s" | grep -A1 "profiles" | grep -v "profiles {" | grep "[a-zA-Z]" | sed "s/profiles//" | awk '{ print $1 }' )

echo -e "************ VIRTUAL SERVER LIST ************"

paste -d ';' <( echo "$T1C1" ) <( echo "$T1C2" ) <( echo "$T1C3" )

#----------------------------------------------------------------------------------------------

# FORMAT CLIENT SSL PROFILE OUTPUT
T2C1=$( echo "$pf_sslprof_c" | grep "profile " | awk '{ print $4 }' )
T2C2=$( echo "$pf_sslprof_c" | grep "cert " | awk '{ print $2 }' )
T2C3=$( echo "$pf_sslprof_c" | grep "chain " | awk '{ print $2 }' )
T2C4=$( echo "$pf_sslprof_c" | grep "key " | awk '{ print $2 }' )
T2C5=$( echo "$pf_sslprof_c" | grep "ciphers " | awk '{ print $2 }' )
T2C6=$( echo "$pf_sslprof_c" | grep "defaults-from " | awk '{ print $2 }' )

echo -e "************ CLIENT SSL PROFILE LIST ************"

paste -d ';' <( echo "$T2C1" ) <( echo "$T2C2" ) <( echo "$T2C3" ) <( echo "$T2C4" ) <( echo "$T2C5" ) <( echo "$T2C6" )

echo -e "************ CLIENT SSL PROFILE LIST (IN USE) ************"

echo "$check_vs_sslprof_c"

#----------------------------------------------------------------------------------------------

# FORMAT SERVER SSL PROFILE OUTPUT
T3C1=$( echo "$pf_sslprof_s" | grep "profile " | awk '{ print $4 }' )
T3C2=$( echo "$pf_sslprof_s" | grep "cert " | awk '{ print $2 }' )
T3C3=$( echo "$pf_sslprof_s" | grep "chain " | awk '{ print $2 }' )
T3C4=$( echo "$pf_sslprof_s" | grep "key " | awk '{ print $2 }' )
T3C5=$( echo "$pf_sslprof_s" | grep "ciphers " | awk '{ print $2 }' )
T3C6=$( echo "$pf_sslprof_s" | grep "defaults-from " | awk '{ print $2 }' )

echo -e "************ SERVER SSL PROFILE LIST ************"

paste -d ';' <( echo "$T3C1" ) <( echo "$T3C2" ) <( echo "$T3C3" ) <( echo "$T3C4" ) <( echo "$T3C5" ) <( echo "$T3C6" )

echo -e "************ SERVER SSL PROFILE LIST (IN USE) ************"

echo "$check_vs_sslprof_s"

#----------------------------------------------------------------------------------------------

# FORMAT CERTIFICATE OUTPUT
T4C1=$( echo "$sslcert" | grep "ssl-cert" | awk '{ print $4 }' )
T4C2=$( echo "$sslcert" | grep "expiration-string" | awk -F "\"" '{ print $2 }' )

echo -e "************ CERTIFICATE LIST ************"

paste -d ';' <( echo "$T4C1" ) <( echo "$T4C2" )

echo -e "************ CERTIFICATE LIST (IN USE) ************"

#----------------------------------------------------------------------------------------------

# CHECK CERTIFICATES IN USE
if [[ "$check_vs_sslprof_c" ]] ; then
	# CLIENT CERTIFICATE IN USE
	check_cert_sslprof_c=$( tmsh -q -c "cd / ; list ltm profile client-ssl recursive $( echo "$check_vs_sslprof_c" | tr '\n' ' ' ) { cert chain }" | grep -e "cert" -e "chain" | awk '{ print $2 }' | grep -v "none" | sort | uniq )
fi

if [[ "$check_vs_sslprof_s" ]] ; then
	# SERVER CERTIFICATE IN USE
	check_cert_sslprof_s=$( tmsh -q -c "cd / ; list ltm profile server-ssl recursive $( echo "$check_vs_sslprof_s" | tr '\n' ' ' ) { cert chain }" | grep -e "cert" -e "chain" | awk '{ print $2 }' | grep -v "none" | sort | uniq )
fi

sslcert_active=$( awk 'NF' <(echo "$check_cert_sslprof_c" ; echo "$check_cert_sslprof_s" | sort | uniq ) )
echo "$sslcert_active"

#----------------------------------------------------------------------------------------------
