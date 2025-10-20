#!/usr/bin/env bash

TMPFILE=tmpfile

for NODES in `seq 10000 20000 90000`; do
  OUTPUT_CSV="uplot.x-trips.nodes$(printf %06d ${NODES}).csv"
  cat <<EOF > $TMPFILE
COPY (
  FROM "all-results"
  SELECT concat(trips, '-', "#nodes") AS "x=trips nodes=${NODES}",
  "cpp-runtime-median",
  "elixir-runtime-median",
  "erlang-runtime-median",
  "go-runtime-median",
  "haskell-channels-runtime-median",
  "haskell-mvars-runtime-median",
  "rust-runtime-median"
  WHERE "#nodes"=${NODES}
  ORDER BY "trips"
) TO '${OUTPUT_CSV}' (HEADER, DELIMITER ',');
EOF

  duckdb results.duckdb < tmpfile
done

for TRIPS in `seq 500 1000 4500`; do
  OUTPUT_CSV="uplot.x-nodes.trips$(printf %06d ${TRIPS}).csv"
  cat <<EOF > $TMPFILE
COPY (
  FROM "all-results"
  SELECT concat("#nodes", '-', trips) AS "x=nodes trips=${TRIPS}",
  "cpp-runtime-median",
  "elixir-runtime-median",
  "erlang-runtime-median",
  "go-runtime-median",
  "haskell-channels-runtime-median",
  "haskell-mvars-runtime-median",
  "rust-runtime-median"
  WHERE "trips"=${TRIPS}
  ORDER BY "#nodes"
) TO '${OUTPUT_CSV}' (HEADER, DELIMITER ',');
EOF

  duckdb results.duckdb < tmpfile
done
