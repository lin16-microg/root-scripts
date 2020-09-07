#!/bin/bash

# Own values
export OUT_DIR_COMMON_BASE=~/out-android
source build/envsetup.sh
lunch lineage_x86-userdebug
emulator

