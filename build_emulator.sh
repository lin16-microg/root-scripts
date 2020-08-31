#!/bin/bash

# Own values
export CCACHE_DIR=~/android/.ccache16

# Use pre-defined build script
source z_patches/build_device.sh x86 test

