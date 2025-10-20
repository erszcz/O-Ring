#!/bin/sh

TMPFILE=tmpfile

for nodes in `seq 10000 20000 90000`; do
  cat <<EOF > $TMPFILE
COPY (
  FROM "all-results"
  SELECT concat(trips, '-', "#nodes") AS "x=trips nodes=${nodes}",
  "cpp-runtime-median",
  "erlang-runtime-median",
  "go-runtime-median",
  "haskell-mvars-runtime-median",
  "rust-runtime-median"
  WHERE "#nodes"=${nodes}
  ORDER BY "trips"
) TO 'uplot.x-trips.nodes${nodes}.csv' (HEADER, DELIMITER ',');
EOF

  duckdb results.duckdb < tmpfile
done

for trips in `seq 500 1000 4500`; do
  cat <<EOF > $TMPFILE
COPY (
  FROM "all-results"
  SELECT concat("#nodes", '-', trips) AS "x=nodes trips=${trips}",
  "cpp-runtime-median",
  "erlang-runtime-median",
  "go-runtime-median",
  "haskell-mvars-runtime-median",
  "rust-runtime-median"
  WHERE "trips"=${trips}
  ORDER BY "#nodes"
) TO 'uplot.x-nodes.trips${trips}.csv' (HEADER, DELIMITER ',');
EOF

  duckdb results.duckdb < tmpfile
done
