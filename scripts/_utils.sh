# module used to provide common variables / functions
# this file must not be manually invoked

#---
# Internals
#---

# workaround used to self-kill the current process if an error is detected
# in function
trap 'exit 1' TERM
export TOP_PID=$$

#---
# Public
#---

export TAG='<vxLibc>'

# abstract the verbose mode
function callcmd() {
  if [[ -v 'VERBOSE' ]]
    then
      echo "$@"
      if ! "$@"; then
        echo "$TAG error: command failed, abort"
        kill -s TERM $TOP_PID
      fi
  else
    out='vxlibc_crash.txt'
    if ! "$@" >"$out" 2>&1; then
      echo "$TAG error: command failed, please check $(pwd)/$out o(x_x)o" >&2
      echo "$@" >&2
      kill -s TERM $TOP_PID
    fi
    rm -f "$out"
  fi
}
