#!/usr/bin/env bash


$DESTINY -c -of${OUTPUT_BASE} ${EXTRA_FILES}/test19376.di
! ls ${OUTPUT_BASE}/test19376.${OBJ}
