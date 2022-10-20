#########################################################################
# title: Check_WideIP_Status.sh                                         #
# author: Dario Garrido                                                 #
# date: 20210521                                                        #
# description: Check global WideIP status                               #
#########################################################################

tmsh -q -c "show gtm wideip" | awk '
function red(s) {
  printf "\033[1;31m" s "\033[0m"
}
function green(s) {
  printf "\033[1;32m" s "\033[0m"
}
function blue(s) {
  printf "\033[1;34m" s "\033[0m"
}
function color(str) {
  if(str == "available" || str == "enabled"){
    green(str)
  } else if(str == "unknown"){
    blue(str)
  } else {
    red(str)
  }
}
BEGIN {
  print "WideIP|Availability|State"
}
/^Gtm::WideIp/{
  wideip=$2
}
/^  Availability/{
  avail=$3
}
/^  State/{
  state=$3
}
/^  Returned to DNS/{
  printf wideip "|"
  printf color(avail) "|"
  printf color(state) "\n"
}
' | column -t -s "|"
