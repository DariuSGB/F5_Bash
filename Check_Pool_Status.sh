#########################################################################
# title: Check_Pool_Status.sh                                           #
# author: Dario Garrido                                                 #
# date: 20210521                                                        #
# description: Check global pool status                                 #
#########################################################################

tmsh -c "cd / ; show ltm pool recursive members" | awk '
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
  print "Pool|Member|Availability|State"
}
/^Ltm::Pool/{
  pool=$2
}
/Ltm::Pool Member:/{
  member=$(NF)
}
/^  \|   Availability/{
  avail=$4
}
/^  \|   State/{
  state=$4
}
/^  \| Traffic/{
  printf pool "|" member "|"
  printf color(avail) "|"
  printf color(state) "\n"
  pool="  \""
}
' | column -t -s "|"
