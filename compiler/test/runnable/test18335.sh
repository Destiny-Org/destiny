#!/usr/bin/env bash


if [ "${OS}" == "osx" ] && [ "${MODEL}" == "64" ]; then
    echo "void main(){}" | "${DESTINY}" -o- -v - | grep predefs | grep -q "D_ObjectiveC"
fi
