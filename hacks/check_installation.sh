#!/bin/bash
# Check if all the required packages and tools are installed on the execution environment.

if kind --version > /dev/null 2>&1; then
    echo "KIND detected"
else
    echo "KIND not detected!" 1>&2
fi

if terraform --version