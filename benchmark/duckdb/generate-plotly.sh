#!/bin/bash

set -euo pipefail

INPUT_FILE="${1}"

if [ -z "${INPUT_FILE}" ]; then
    echo "Usage: $0 <input-csv-file>"
    exit 1
fi

if [ ! -f "${INPUT_FILE}" ]; then
    echo "Error: Input file '${INPUT_FILE}' not found."
    exit 1
fi

awk -F, -f generate-plotly.awk "${INPUT_FILE}"
