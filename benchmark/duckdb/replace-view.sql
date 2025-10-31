CREATE OR REPLACE VIEW "all-results" AS

FROM       "cpp"
INNER JOIN "elixir"             ON ("cpp"."#nodes" = "elixir"."#nodes") AND ("cpp".trips = elixir.trips)
INNER JOIN "erlang"             ON ("cpp"."#nodes" = "erlang"."#nodes") AND ("cpp".trips = erlang.trips) 
INNER JOIN "go"                 ON ("cpp"."#nodes" = "go"."#nodes") AND ("cpp".trips = go.trips) 
INNER JOIN "haskell-channels"   ON ("cpp"."#nodes" = "haskell-channels"."#nodes") AND ("cpp".trips = "haskell-channels".trips) 
INNER JOIN "haskell-mvars"      ON ("cpp"."#nodes" = "haskell-mvars"."#nodes") AND ("cpp".trips = "haskell-mvars".trips) 
INNER JOIN "kotlin-native"      ON ("cpp"."#nodes" = "kotlin-native"."#nodes") AND ("cpp".trips = "kotlin-native".trips) 
INNER JOIN "rust-async-std"     ON ("cpp"."#nodes" = "rust-async-std"."#nodes") AND ("cpp".trips = "rust-async-std".trips)
INNER JOIN "rust-smol-b"        ON ("cpp"."#nodes" = "rust-smol-b"."#nodes") AND ("cpp".trips = "rust-smol-b".trips)
INNER JOIN "rust-smol-unb"      ON ("cpp"."#nodes" = "rust-smol-unb"."#nodes") AND ("cpp".trips = "rust-smol-unb".trips)
INNER JOIN "rust-tokio"         ON ("cpp"."#nodes" = "rust-tokio"."#nodes" AND ("cpp".trips = "rust-tokio".trips))

SELECT
  "cpp"."#nodes",
  "cpp"."trips",
  "cpp"."iterations",

  "cpp"."setup mean[ms]"                                  AS "cpp-setup-mean",
  "cpp"."setup RMS"                                       AS "cpp-setup-rms",
  "cpp"."setup median[ms]"                                AS "cpp-setup-median",
  "cpp"."setup 98th percentile[ms]"                       AS "cpp-setup-98p",
  "cpp"."time to finish mean[ms]"                         AS "cpp-runtime-mean",
  "cpp"."time to finish RMS"                              AS "cpp-runtime-rms",
  "cpp"."time to finish median[ms]"                       AS "cpp-runtime-median",
  "cpp"."time to finish 98th percentile[ms]"              AS "cpp-runtime-98p",

  "elixir"."setup mean[ms]"                               AS "elixir-setup-mean",
  "elixir"."setup RMS"                                    AS "elixir-setup-rms",
  "elixir"."setup median[ms]"                             AS "elixir-setup-median",
  "elixir"."setup 98th percentile[ms]"                    AS "elixir-setup-98p",
  "elixir"."time to finish mean[ms]"                      AS "elixir-runtime-mean",
  "elixir"."time to finish RMS"                           AS "elixir-runtime-rms",
  "elixir"."time to finish median[ms]"                    AS "elixir-runtime-median",
  "elixir"."time to finish 98th percentile[ms]"           AS "elixir-runtime-98p",

  "erlang"."setup mean[ms]"                               AS "erlang-setup-mean",
  "erlang"."setup RMS"                                    AS "erlang-setup-rms",
  "erlang"."setup median[ms]"                             AS "erlang-setup-median",
  "erlang"."setup 98th percentile[ms]"                    AS "erlang-setup-98p",
  "erlang"."time to finish mean[ms]"                      AS "erlang-runtime-mean",
  "erlang"."time to finish RMS"                           AS "erlang-runtime-rms",
  "erlang"."time to finish median[ms]"                    AS "erlang-runtime-median",
  "erlang"."time to finish 98th percentile[ms]"           AS "erlang-runtime-98p",

  "go"."setup mean[ms]"                                   AS "go-setup-mean",
  "go"."setup RMS"                                        AS "go-setup-rms",
  "go"."setup median[ms]"                                 AS "go-setup-median",
  "go"."setup 98th percentile[ms]"                        AS "go-setup-98p",
  "go"."time to finish mean[ms]"                          AS "go-runtime-mean",
  "go"."time to finish RMS"                               AS "go-runtime-rms",
  "go"."time to finish median[ms]"                        AS "go-runtime-median",
  "go"."time to finish 98th percentile[ms]"               AS "go-runtime-98p",

  "haskell-channels"."setup mean[ms]"                     AS "haskell-channels-setup-mean",
  "haskell-channels"."setup RMS"                          AS "haskell-channels-setup-rms",
  "haskell-channels"."setup median[ms]"                   AS "haskell-channels-setup-median",
  "haskell-channels"."setup 98th percentile[ms]"          AS "haskell-channels-setup-98p",
  "haskell-channels"."time to finish mean[ms]"            AS "haskell-channels-runtime-mean",
  "haskell-channels"."time to finish RMS"                 AS "haskell-channels-runtime-rms",
  "haskell-channels"."time to finish median[ms]"          AS "haskell-channels-runtime-median",
  "haskell-channels"."time to finish 98th percentile[ms]" AS "haskell-channels-runtime-98p",

  "haskell-mvars"."setup mean[ms]"                        AS "haskell-mvars-setup-mean",
  "haskell-mvars"."setup RMS"                             AS "haskell-mvars-setup-rms",
  "haskell-mvars"."setup median[ms]"                      AS "haskell-mvars-setup-median",
  "haskell-mvars"."setup 98th percentile[ms]"             AS "haskell-mvars-setup-98p",
  "haskell-mvars"."time to finish mean[ms]"               AS "haskell-mvars-runtime-mean",
  "haskell-mvars"."time to finish RMS"                    AS "haskell-mvars-runtime-rms",
  "haskell-mvars"."time to finish median[ms]"             AS "haskell-mvars-runtime-median",
  "haskell-mvars"."time to finish 98th percentile[ms]"    AS "haskell-mvars-runtime-98p",

  "kotlin-native"."setup mean[ms]"                        AS "kotlin-native-setup-mean",
  "kotlin-native"."setup RMS"                             AS "kotlin-native-setup-rms",
  "kotlin-native"."setup median[ms]"                      AS "kotlin-native-setup-median",
  "kotlin-native"."setup 98th percentile[ms]"             AS "kotlin-native-setup-98p",
  "kotlin-native"."time to finish mean[ms]"               AS "kotlin-native-runtime-mean",
  "kotlin-native"."time to finish RMS"                    AS "kotlin-native-runtime-rms",
  "kotlin-native"."time to finish median[ms]"             AS "kotlin-native-runtime-median",
  "kotlin-native"."time to finish 98th percentile[ms]"    AS "kotlin-native-runtime-98p",

  "rust-async-std"."setup mean[ms]"                       AS "rust-async-std-setup-mean",
  "rust-async-std"."setup RMS"                            AS "rust-async-std-setup-rms",
  "rust-async-std"."setup median[ms]"                     AS "rust-async-std-setup-median",
  "rust-async-std"."setup 98th percentile[ms]"            AS "rust-async-std-setup-98p",
  "rust-async-std"."time to finish mean[ms]"              AS "rust-async-std-runtime-mean",
  "rust-async-std"."time to finish RMS"                   AS "rust-async-std-runtime-rms",
  "rust-async-std"."time to finish median[ms]"            AS "rust-async-std-runtime-median",
  "rust-async-std"."time to finish 98th percentile[ms]"   AS "rust-async-std-runtime-98p",

  "rust-smol-b"."setup mean[ms]"                          AS "rust-smol-b-setup-mean",
  "rust-smol-b"."setup RMS"                               AS "rust-smol-b-setup-rms",
  "rust-smol-b"."setup median[ms]"                        AS "rust-smol-b-setup-median",
  "rust-smol-b"."setup 98th percentile[ms]"               AS "rust-smol-b-setup-98p",
  "rust-smol-b"."time to finish mean[ms]"                 AS "rust-smol-b-runtime-mean",
  "rust-smol-b"."time to finish RMS"                      AS "rust-smol-b-runtime-rms",
  "rust-smol-b"."time to finish median[ms]"               AS "rust-smol-b-runtime-median",
  "rust-smol-b"."time to finish 98th percentile[ms]"      AS "rust-smol-b-runtime-98p",

  "rust-smol-unb"."setup mean[ms]"                        AS "rust-smol-unb-setup-mean",
  "rust-smol-unb"."setup RMS"                             AS "rust-smol-unb-setup-rms",
  "rust-smol-unb"."setup median[ms]"                      AS "rust-smol-unb-setup-median",
  "rust-smol-unb"."setup 98th percentile[ms]"             AS "rust-smol-unb-setup-98p",
  "rust-smol-unb"."time to finish mean[ms]"               AS "rust-smol-unb-runtime-mean",
  "rust-smol-unb"."time to finish RMS"                    AS "rust-smol-unb-runtime-rms",
  "rust-smol-unb"."time to finish median[ms]"             AS "rust-smol-unb-runtime-median",
  "rust-smol-unb"."time to finish 98th percentile[ms]"    AS "rust-smol-unb-runtime-98p",

  "rust-tokio"."setup mean[ms]"                           AS "rust-tokio-setup-mean",
  "rust-tokio"."setup RMS"                                AS "rust-tokio-setup-rms",
  "rust-tokio"."setup median[ms]"                         AS "rust-tokio-setup-median",
  "rust-tokio"."setup 98th percentile[ms]"                AS "rust-tokio-setup-98p",
  "rust-tokio"."time to finish mean[ms]"                  AS "rust-tokio-runtime-mean",
  "rust-tokio"."time to finish RMS"                       AS "rust-tokio-runtime-rms",
  "rust-tokio"."time to finish median[ms]"                AS "rust-tokio-runtime-median",
  "rust-tokio"."time to finish 98th percentile[ms]"       AS "rust-tokio-runtime-98p" ;

-- vim: sw=4 ts=4 sts=4 et
