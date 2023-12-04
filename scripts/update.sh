#!/usr/bin/env bash

#---
# Help screen
#---

function help() {
  cat << EOF
Update script for the vxLibc project (own implementation of the libc)

Usage: $0 [options...]

Options:
  -h, --help        display this help
  -y, --yes         do not display validation step
  -v, --verbose     display more information during operations

Notes:
    This project is mainly installed automatically as a dependency of the
  sh-elf-vhex (Vhex's compiler) project.
EOF
  exit 0
}

#---
# Parse arguments
#---

verbose=false
skip_input=false
for arg; do
  case "$arg" in
    -h | --help)    help;;
    -y | --yes)     skip_input=true;;
    -v | --verbose) verbose=true;;
    *)
      echo "error: unrecognized argument '$arg', giving up." >&2
      exit 1
  esac
done

#---
# Preliminary check
#---

_src=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$_src" || exit 1
source ./_utils.sh

if ! test -f '../_fxlibc/_build-vhex/sysroot.txt'
then
  echo 'vxLibc not installed, nothing to do'
  exit 0
fi
prefix=$(cat '../_fxlibc/_build-vhex/sysroot.txt')

if [[ "$skip_input" != 'true' ]]
then
  echo "This script will update the vxLibc for the sysroot '$prefix'"
  read -p 'Perform operations [Yn] ? ' -r valid
  if [[ "$valid" == 'n' ]]
  then
    echo 'Operations aborted' >&2
    exit 1
  fi
fi

#---
# Manual update
#---

[[ "$verbose" == 'true' ]] && export VERBOSE=1

if test -d '../.git'
then
  echo "$TAG try to bump the repository..."
  callcmd git pull
else
  echo "$TAG WARNING: not a git repository"
fi

if test -d '../_vxopenlibm'
then
  echo "$TAG try to bump the vxOpenLibm dependency..."
  ../_vxopenlibm/scripts/update.sh --yes
else
  echo "$TAG WARNING: vxOpenLibm installed externally, skipped"
fi

echo "$TAG update operations will reclone and rebuild the project..."
./install.sh --prefix-sysroot="$prefix" --yes --overwrite
