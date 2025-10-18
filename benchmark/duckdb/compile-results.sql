CREATE TABLE "cpp" AS FROM '../output/cpp.csv';
ALTER TABLE "cpp" RENAME "setup RMS"                          TO "cpp-setup-rms";
ALTER TABLE "cpp" RENAME "setup mean[ms]"                     TO "cpp-setup-mean[ms]";
ALTER TABLE "cpp" RENAME "setup median[ms]"                   TO "cpp-setup-median[ms]";
ALTER TABLE "cpp" RENAME "setup 98th percentile[ms]"          TO "cpp-setup-98p[ms]";
ALTER TABLE "cpp" RENAME "time to finish RMS"                 TO "cpp-runtime-rms";
ALTER TABLE "cpp" RENAME "time to finish mean[ms]"            TO "cpp-runtime-mean[ms]";
ALTER TABLE "cpp" RENAME "time to finish median[ms]"          TO "cpp-runtime-median[ms]";
ALTER TABLE "cpp" RENAME "time to finish 98th percentile[ms]" TO "cpp-runtime-98p[ms]";

CREATE TABLE "elixir" AS FROM '../output/elixir.csv';
ALTER TABLE "elixir" RENAME "setup RMS"                          TO "elixir-setup-rms";
ALTER TABLE "elixir" RENAME "setup mean[ms]"                     TO "elixir-setup-mean[ms]";
ALTER TABLE "elixir" RENAME "setup median[ms]"                   TO "elixir-setup-median[ms]";
ALTER TABLE "elixir" RENAME "setup 98th percentile[ms]"          TO "elixir-setup-98p[ms]";
ALTER TABLE "elixir" RENAME "time to finish RMS"                 TO "elixir-runtime-rms";
ALTER TABLE "elixir" RENAME "time to finish mean[ms]"            TO "elixir-runtime-mean[ms]";
ALTER TABLE "elixir" RENAME "time to finish median[ms]"          TO "elixir-runtime-median[ms]";
ALTER TABLE "elixir" RENAME "time to finish 98th percentile[ms]" TO "elixir-runtime-98p[ms]";

CREATE TABLE "erlang" AS FROM '../output/erlang.csv';
ALTER TABLE "erlang" RENAME "setup RMS"                          TO "erlang-setup-rms";
ALTER TABLE "erlang" RENAME "setup mean[ms]"                     TO "erlang-setup-mean[ms]";
ALTER TABLE "erlang" RENAME "setup median[ms]"                   TO "erlang-setup-median[ms]";
ALTER TABLE "erlang" RENAME "setup 98th percentile[ms]"          TO "erlang-setup-98p[ms]";
ALTER TABLE "erlang" RENAME "time to finish RMS"                 TO "erlang-runtime-rms";
ALTER TABLE "erlang" RENAME "time to finish mean[ms]"            TO "erlang-runtime-mean[ms]";
ALTER TABLE "erlang" RENAME "time to finish median[ms]"          TO "erlang-runtime-median[ms]";
ALTER TABLE "erlang" RENAME "time to finish 98th percentile[ms]" TO "erlang-runtime-98p[ms]";

CREATE TABLE "go" AS FROM '../output/go.csv';
ALTER TABLE "go" RENAME "setup RMS"                          TO "go-setup-rms";
ALTER TABLE "go" RENAME "setup mean[ms]"                     TO "go-setup-mean[ms]";
ALTER TABLE "go" RENAME "setup median[ms]"                   TO "go-setup-median[ms]";
ALTER TABLE "go" RENAME "setup 98th percentile[ms]"          TO "go-setup-98p[ms]";
ALTER TABLE "go" RENAME "time to finish RMS"                 TO "go-runtime-rms";
ALTER TABLE "go" RENAME "time to finish mean[ms]"            TO "go-runtime-mean[ms]";
ALTER TABLE "go" RENAME "time to finish median[ms]"          TO "go-runtime-median[ms]";
ALTER TABLE "go" RENAME "time to finish 98th percentile[ms]" TO "go-runtime-98p[ms]";

CREATE TABLE "haskell-channels" AS FROM '../output/haskell-channels.csv';
ALTER TABLE "haskell-channels" RENAME "setup RMS"                          TO "haskell-channels-setup-rms";
ALTER TABLE "haskell-channels" RENAME "setup mean[ms]"                     TO "haskell-channels-setup-mean[ms]";
ALTER TABLE "haskell-channels" RENAME "setup median[ms]"                   TO "haskell-channels-setup-median[ms]";
ALTER TABLE "haskell-channels" RENAME "setup 98th percentile[ms]"          TO "haskell-channels-setup-98p[ms]";
ALTER TABLE "haskell-channels" RENAME "time to finish RMS"                 TO "haskell-channels-runtime-rms";
ALTER TABLE "haskell-channels" RENAME "time to finish mean[ms]"            TO "haskell-channels-runtime-mean[ms]";
ALTER TABLE "haskell-channels" RENAME "time to finish median[ms]"          TO "haskell-channels-runtime-median[ms]";
ALTER TABLE "haskell-channels" RENAME "time to finish 98th percentile[ms]" TO "haskell-channels-runtime-98p[ms]";

CREATE TABLE "haskell-mvars" AS FROM '../output/haskell-mvars.csv';
ALTER TABLE "haskell-mvars" RENAME "setup RMS"                          TO "haskell-mvars-setup-rms";
ALTER TABLE "haskell-mvars" RENAME "setup mean[ms]"                     TO "haskell-mvars-setup-mean[ms]";
ALTER TABLE "haskell-mvars" RENAME "setup median[ms]"                   TO "haskell-mvars-setup-median[ms]";
ALTER TABLE "haskell-mvars" RENAME "setup 98th percentile[ms]"          TO "haskell-mvars-setup-98p[ms]";
ALTER TABLE "haskell-mvars" RENAME "time to finish RMS"                 TO "haskell-mvars-runtime-rms";
ALTER TABLE "haskell-mvars" RENAME "time to finish mean[ms]"            TO "haskell-mvars-runtime-mean[ms]";
ALTER TABLE "haskell-mvars" RENAME "time to finish median[ms]"          TO "haskell-mvars-runtime-median[ms]";
ALTER TABLE "haskell-mvars" RENAME "time to finish 98th percentile[ms]" TO "haskell-mvars-runtime-98p[ms]";

CREATE TABLE "rust" AS FROM '../output/rust.csv';
ALTER TABLE "rust" RENAME "setup RMS"                          TO "rust-setup-rms";
ALTER TABLE "rust" RENAME "setup mean[ms]"                     TO "rust-setup-mean[ms]";
ALTER TABLE "rust" RENAME "setup median[ms]"                   TO "rust-setup-median[ms]";
ALTER TABLE "rust" RENAME "setup 98th percentile[ms]"          TO "rust-setup-98p[ms]";
ALTER TABLE "rust" RENAME "time to finish RMS"                 TO "rust-runtime-rms";
ALTER TABLE "rust" RENAME "time to finish mean[ms]"            TO "rust-runtime-mean[ms]";
ALTER TABLE "rust" RENAME "time to finish median[ms]"          TO "rust-runtime-median[ms]";
ALTER TABLE "rust" RENAME "time to finish 98th percentile[ms]" TO "rust-runtime-98p[ms]";

