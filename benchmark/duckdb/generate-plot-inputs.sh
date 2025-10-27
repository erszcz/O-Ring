#!/usr/bin/env bash

BASENAME=$(basename $0 .sh)
TMPFILE=$(mktemp -t $BASENAME)

for NODES in `seq 10000 20000 90000`; do
  OUTPUT_CSV="plot-inputs/x-trips.nodes$(printf %06d ${NODES}).csv"
  cat <<EOF > $TMPFILE
COPY (
  FROM "all-results"
  SELECT concat(trips, '-', "#nodes") AS "x=trips nodes=${NODES}",
  "rust-async-std-runtime-median",
  "rust-smol-b-runtime-median",
  "rust-smol-unb-runtime-median",
  "rust-tokio-runtime-median"
  WHERE "#nodes"=${NODES}
  ORDER BY "trips"
) TO '${OUTPUT_CSV}' (HEADER, DELIMITER ',');
EOF

  duckdb results.duckdb < $TMPFILE
done

for TRIPS in `seq 500 4000 4500`; do
  OUTPUT_CSV="plot-inputs/x-nodes.trips$(printf %06d ${TRIPS}).csv"
  cat <<EOF > $TMPFILE
COPY (
  FROM "all-results"
  SELECT concat("#nodes", '-', trips) AS "x=nodes trips=${TRIPS}",
  "rust-async-std-runtime-median",
  "rust-smol-b-runtime-median",
  "rust-smol-unb-runtime-median",
  "rust-tokio-runtime-median"
  WHERE "trips"=${TRIPS}
  ORDER BY "#nodes"
) TO '${OUTPUT_CSV}' (HEADER, DELIMITER ',');
EOF

  duckdb results.duckdb < $TMPFILE
done
