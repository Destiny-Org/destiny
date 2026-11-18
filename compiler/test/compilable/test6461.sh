#!/usr/bin/env bash


src=${EXTRA_FILES}/${TEST_NAME}


$DESTINY -lib -m${MODEL} -of${OUTPUT_BASE}a${LIBEXT} -I${src} ${src}/a.d
$DESTINY -lib -m${MODEL} -of${OUTPUT_BASE}b${LIBEXT} -I${src} ${src}/b.d

$DESTINY -m${MODEL} -of${OUTPUT_BASE}_main -I${src} ${src}/main.d ${OUTPUT_BASE}a${LIBEXT} ${OUTPUT_BASE}b${LIBEXT}

rm_retry ${OUTPUT_BASE}{a${LIBEXT},b${LIBEXT},_main${EXE},_main${OBJ}}
