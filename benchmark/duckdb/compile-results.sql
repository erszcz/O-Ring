CREATE TABLE "cpp" AS FROM '../output/cpp.csv';
CREATE TABLE "erlang" AS FROM '../output/erlang.csv';
CREATE TABLE "go" AS FROM '../output/go.csv';
CREATE TABLE "haskell-mvars" AS FROM '../output/haskell-mvars.csv';
CREATE TABLE "rust" AS FROM '../output/rust.csv';

CREATE VIEW "all-results" AS
FROM cpp
JOIN erlang ON cpp."#nodes" = erlang."#nodes" AND cpp.trips = erlang.trips
JOIN go ON cpp."#nodes" = go."#nodes" AND cpp.trips = go.trips
JOIN "haskell-mvars" ON cpp."#nodes" = "haskell-mvars"."#nodes" AND cpp.trips = "haskell-mvars".trips
JOIN rust ON cpp."#nodes" = rust."#nodes" AND cpp.trips = rust.trips
SELECT
    cpp."#nodes", cpp.trips, cpp.iterations,

    cpp."setup mean[ms]" AS 'cpp-setup-mean',
    cpp."setup RMS" AS 'cpp-setup-rms',
    cpp."setup median[ms]" AS 'cpp-setup-median',
    cpp."setup 98th percentile[ms]" AS 'cpp-setup-98p',
    cpp."time to finish mean[ms]" AS 'cpp-runtime-mean',
    cpp."time to finish RMS" AS 'cpp-runtime-rms',
    cpp."time to finish median[ms]" AS 'cpp-runtime-median',
    cpp."time to finish 98th percentile[ms]" AS 'cpp-runtime-98p',

    erlang."setup mean[ms]" AS 'erlang-setup-mean',
    erlang."setup RMS" AS 'erlang-setup-rms',
    erlang."setup median[ms]" AS 'erlang-setup-median',
    erlang."setup 98th percentile[ms]" AS 'erlang-setup-98p',
    erlang."time to finish mean[ms]" AS 'erlang-runtime-mean',
    erlang."time to finish RMS" AS 'erlang-runtime-rms',
    erlang."time to finish median[ms]" AS 'erlang-runtime-median',
    erlang."time to finish 98th percentile[ms]" AS 'erlang-runtime-98p',

    go."setup mean[ms]" AS 'go-setup-mean',
    go."setup RMS" AS 'go-setup-rms',
    go."setup median[ms]" AS 'go-setup-median',
    go."setup 98th percentile[ms]" AS 'go-setup-98p',
    go."time to finish mean[ms]" AS 'go-runtime-mean',
    go."time to finish RMS" AS 'go-runtime-rms',
    go."time to finish median[ms]" AS 'go-runtime-median',
    go."time to finish 98th percentile[ms]" AS 'go-runtime-98p',

    "haskell-mvars"."setup mean[ms]" AS 'haskell-mvars-setup-mean',
    "haskell-mvars"."setup RMS" AS 'haskell-mvars-setup-rms',
    "haskell-mvars"."setup median[ms]" AS 'haskell-mvars-setup-median',
    "haskell-mvars"."setup 98th percentile[ms]" AS 'haskell-mvars-setup-98p',
    "haskell-mvars"."time to finish mean[ms]" AS 'haskell-mvars-runtime-mean',
    "haskell-mvars"."time to finish RMS" AS 'haskell-mvars-runtime-rms',
    "haskell-mvars"."time to finish median[ms]" AS 'haskell-mvars-runtime-median',
    "haskell-mvars"."time to finish 98th percentile[ms]" AS 'haskell-mvars-runtime-98p',

    rust."setup mean[ms]" AS 'rust-setup-mean',
    rust."setup RMS" AS 'rust-setup-rms',
    rust."setup median[ms]" AS 'rust-setup-median',
    rust."setup 98th percentile[ms]" AS 'rust-setup-98p',
    rust."time to finish mean[ms]" AS 'rust-runtime-mean',
    rust."time to finish RMS" AS 'rust-runtime-rms',
    rust."time to finish median[ms]" AS 'rust-runtime-median',
    rust."time to finish 98th percentile[ms]" AS 'rust-runtime-98p' ;

-- vim: sw=4 ts=4 sts=4 et
