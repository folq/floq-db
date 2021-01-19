#!/bin/bash

case "$1" in
     -d|--dev)
         HOST=localhost
         PORT=5433
         shift
         ;;
     *)
         echo "No environment specified"
         exit 3
         ;;
esac

for f in *.sql
do
 echo "deploying $f to $HOST:$PORT"
 psql -f "$f" -h $HOST -p $PORT -d hverdagsverktoy -U root
done
