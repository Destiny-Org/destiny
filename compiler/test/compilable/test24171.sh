#!/usr/bin/env bash

output_html=${OUTPUT_BASE}.html

rm_retry ${output_html}

$DESTINY -m${MODEL} -D -o- ${EXTRA_FILES}/ddoc24171.ddd -Df${output_html}
