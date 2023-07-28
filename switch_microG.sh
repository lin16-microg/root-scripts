#!/bin/bash

#
# Switch script to switch/checkout to the defined branches
# for each build variant and to apply the respective patches
#
# After initial `repo sync`, the branches are initially
# created and checked out
# ------------------------------------------------------------


switch_branches() {
  TOPDIR=$PWD
  cd $2
  echo "-"
  echo "$PWD"
  if [ "$2" == ".repo/local_manifests" ] ; then
    REMOTE="origin"
  else
    REMOTE="github"
  fi
  if [ -n "$(git branch --list $1)" ]; then
    git checkout $1
    git pull $REMOTE $1 --ff-only
  else
    git fetch $REMOTE $1
    git checkout -b $1 $REMOTE/$1
  fi
  cd $TOPDIR
}

switch_zpatch() {
  TOPDIR=$PWD
  cd z_patches
  echo "-"
  echo "$PWD"
  case "$2" in 
    R) ./patches_reverse.sh
       cd $TOPDIR
       switch_branches $1 z_patches
       ;;
    S) ./patches_apply.sh
       ;;
  esac
  cd $TOPDIR
}

#
# Main run
#
case "$1" in
  treble)
    BRANCH1="lin-16.0-treble"
    BRANCH2="lin-16.0-treble"
    BRANCH3="lin-16.0-microG"
    BRANCH4="lin-16.0-microG"
    PATCHV="S"
    ;;
  microG)
    BRANCH1="lin-16.0-microG"
    BRANCH2="lineage-16.0"
    BRANCH3="lin-16.0-microG"
    BRANCH4="lin-16.0-microG"
    PATCHV="S"
    ;;
  default)
    BRANCH1="lineage-16.0"
    BRANCH2="lineage-16.0"
    BRANCH3="lineage-16.0"
    BRANCH4="lineage-16.0"
    PATCHV="S"
    ;;
  reference)
    BRANCH1="lineage-16.0"
    BRANCH2="lineage-16.0"
    BRANCH3="lineage-16.0"
    BRANCH4="changelog"
    PATCHV="N"
    ;;
  *)
    echo "usage: switch_microg.sh default | microG | treble | reference"
    echo "-"
    echo "  default   - LineageOS 16.0"
    echo "  microG    - hardened microG build"
    echo "  treble    - Treble GSI build"
    echo "  reference - 100% LineageOS 16.0 (no patches - for 'repo sync')"
    exit
    ;;
esac

switch_zpatch $BRANCH1 R

switch_branches $BRANCH1 build/make
switch_branches $BRANCH2 external/selinux
switch_branches $BRANCH1 frameworks/av
switch_branches $BRANCH1 frameworks/base
switch_branches $BRANCH1 frameworks/native
switch_branches $BRANCH1 frameworks/opt/net/wifi
switch_branches $BRANCH2 frameworks/opt/telephony
switch_branches $BRANCH1 lineage-sdk
switch_branches $BRANCH3 packages/apps/Contacts
switch_branches $BRANCH3 packages/apps/Dialer
switch_branches $BRANCH3 packages/apps/Jelly
switch_branches $BRANCH1 packages/apps/LineageParts
switch_branches $BRANCH3 packages/apps/Nfc
switch_branches $BRANCH1 packages/apps/Settings
switch_branches $BRANCH3 packages/apps/Trebuchet
switch_branches $BRANCH3 packages/services/Telecomm
switch_branches $BRANCH2 packages/services/Telephony
switch_branches $BRANCH1 system/bt
switch_branches $BRANCH1 system/core
switch_branches $BRANCH3 system/media
switch_branches $BRANCH2 system/netd
switch_branches $BRANCH1 system/sepolicy
switch_branches $BRANCH2 system/vold
switch_branches $BRANCH1 vendor/lineage
switch_branches $BRANCH2 vendor/qcom/opensource/cryptfs_hw
switch_branches $BRANCH1 .repo/local_manifests
switch_branches $BRANCH4 OTA

switch_zpatch $BRANCH1 $PATCHV
