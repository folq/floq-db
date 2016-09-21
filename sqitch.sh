#!/bin/sh
docker run -v `pwd`:/src/ \
  -e "SQITCH_PASSWORD=${SQITCH_PASSWORD}" \
  --rm docteurklein/sqitch:pgsql "$@"

