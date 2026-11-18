#!/usr/bin/env bash

output_html=${OUTPUT_BASE}.html

rm_retry ${output_html}

$DESTINY -m${MODEL} -D -o- ${EXTRA_FILES}/ddoc9764.dd -Df${output_html}


${EXTRA_FILES}/ddocAny-postscript.sh 9764
