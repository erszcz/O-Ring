#!/bin/sh

lang=$1
csv=$2

cat <<EOD
CREATE TABLE "$lang" AS FROM '$csv';
EOD
