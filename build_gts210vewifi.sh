#!/bin/bash

# Own values
export CCACHE_DIR=~/android/.ccache16
export OUT_DIR_COMMON_BASE=~/out-android

# Use pre-defined build script
source z_patches/build_device.sh gts210vewifi $1



