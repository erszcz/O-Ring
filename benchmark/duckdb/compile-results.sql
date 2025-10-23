CREATE TABLE "rust-async-std" AS FROM '../output/rust-async-std.csv';
CREATE TABLE "rust-smol" AS FROM '../output/rust-smol.csv';

CREATE VIEW "all-results" AS
FROM "rust-async-std"
JOIN "rust-smol" ON "rust-async-std"."#nodes" = "rust-smol"."#nodes" AND "rust-async-std".trips = "rust-smol".trips
SELECT
    "rust-async-std"."#nodes", "rust-async-std".trips, "rust-async-std".iterations,

    "rust-async-std"."setup mean[ms]" AS 'rust-async-std-setup-mean',
    "rust-async-std"."setup RMS" AS 'rust-async-std-setup-rms',
    "rust-async-std"."setup median[ms]" AS 'rust-async-std-setup-median',
    "rust-async-std"."setup 98th percentile[ms]" AS 'rust-async-std-setup-98p',
    "rust-async-std"."time to finish mean[ms]" AS 'rust-async-std-runtime-mean',
    "rust-async-std"."time to finish RMS" AS 'rust-async-std-runtime-rms',
    "rust-async-std"."time to finish median[ms]" AS 'rust-async-std-runtime-median',
    "rust-async-std"."time to finish 98th percentile[ms]" AS 'rust-async-std-runtime-98p',

    "rust-smol"."setup mean[ms]" AS 'rust-smol-setup-mean',
    "rust-smol"."setup RMS" AS 'rust-smol-setup-rms',
    "rust-smol"."setup median[ms]" AS 'rust-smol-setup-median',
    "rust-smol"."setup 98th percentile[ms]" AS 'rust-smol-setup-98p',
    "rust-smol"."time to finish mean[ms]" AS 'rust-smol-runtime-mean',
    "rust-smol"."time to finish RMS" AS 'rust-smol-runtime-rms',
    "rust-smol"."time to finish median[ms]" AS 'rust-smol-runtime-median',
    "rust-smol"."time to finish 98th percentile[ms]" AS 'rust-smol-runtime-98p' ;

-- vim: sw=4 ts=4 sts=4 et
