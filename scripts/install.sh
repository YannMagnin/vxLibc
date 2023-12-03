#!/usr/bin/env bash

#---
# Help screen
#---

function help() {
  cat << EOF
Installation script for vxLibc project (own implementation of the Libc)

Usage: $0 [options...]

Options:
  -h, --help            display this help
  -y, --yes             do not display validation step
  -v, --verbose         display more information during operations
      --prefix-sysroot  sysroot (install) prefix path
      --overwrite       remove the cloned OpenLibm repo if already exists

Notes:
    This project is mainly automatically installed as a dependency of the
  sh-elf-vhex (Vhex's compiler) project.
EOF
  exit 0
}

#---
# Parse arguments
#---

verbose=false
skip_input=false
overwrite=false
prefix=''
for arg; do
  case "$arg" in
    -h | --help)                help;;
    -y | --yes)                 skip_input=true;;
    -v | --verbose)             verbose=true;;
         --prefix-sysroot=*)    prefix=${arg#*=};;
         --overwrite)           overwrite=true;;
    *)
      echo "error: unreconized argument '$arg', giving up." >&2
      exit 1
  esac
done

#---
# Preliminary check
#---

if test -z "$prefix"
then
  echo 'You need to specify the sysroot prefix, abord' >&2
  exit 1
fi

if [[ ! $(sh-elf-vhex-gcc --version) ]]
then
  echo -e \
    'You need to install the sh-elf-vhex compiler to install this '       \
    'project.\n'                                                          \
    'Also note that the installation if the compiler will automatically ' \
    'install this project'
  exit 1
fi

_src=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$_src" || exit 1
source ./_utils.sh

if [[ -d '../_fxlibc' &&  "$overwrite" != 'true' ]]
then
  echo 'vxLibc already installed, nothing to do'
  exit 0
fi

if [[ "$skip_input" != 'true' ]]
then
  echo 'This script will compile and install the vxLibc project'
  echo "  - prefix    = $prefix"
  echo "  - verbose   = $verbose"
  echo "  - overwrite = $overwrite"
  read -p 'Perform operations [Yn] ? ' -r valid
  if [[ "$valid" == 'n' ]]; then
    echo 'Operation aborted' >&2
    exit 1
  fi
fi

[[ -d '../_fxlibc' ]] && rm -rf ../_fxlibc

[[ "$verbose" == 'true' ]] && export VERBOSE=1

#---
# Build / install operations
#---

echo "$TAG check if the vxOpenLibc is installed..."
if ! test -f "$prefix/lib/libm.a"
then
  echo "$TAG install the vxOpenLibm..."
  test -d ../_vxopenlibm && rm -rf ../_vxopenlibm
  callcmd \
    git \
    clone \
    https://github.com/YannMagnin/vxOpenLibm.git \
    --depth 1 \
    ../_vxopenlibm

  echo "$TAG install the vxOpenLibm..."
  ../_vxopenlibm/scripts/install.sh \
      --prefix-sysroot="$prefix" \
      --yes \
      --overwrite
fi

echo "$TAG clone fxlibc..."
callcmd \
  git \
  clone \
  https://gitea.planet-casio.com/Vhex-Kernel-Core/fxlibc.git \
  --depth 1 \
  ../_fxlibc

echo "$TAG apply patches..."
cp -r ../patches/* ../_fxlibc/

echo "$TAG configure..."
callcmd \
  cmake \
  -DCMAKE_INSTALL_PREFIX="$prefix" \
  -DCMAKE_TOOLCHAIN_FILE=../patches/toolchain.cmake \
  -B ../_fxlibc/_build-vhex \
  -S ../_fxlibc

echo "$TAG build..."
callcmd cmake --build ../_fxlibc/_build-vhex/

echo "$TAG install..."
callcmd cmake --install ../_fxlibc/_build-vhex/
echo "$prefix" > ../_fxlibc/_build-vhex/sysroot.txt
