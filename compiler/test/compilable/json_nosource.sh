#!/usr/bin/env bash
$DESTINY -Xi=compilerInfo -Xf=${OUTPUT_BASE}.out
./compilable/extra-files/json-postscript.sh json_nosource
