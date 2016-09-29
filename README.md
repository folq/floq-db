# Floq DB Migrations

## Prerequisites

You need to install [Sqitch](http://sqitch.org), or use the `sqitch.sh` which
runs Sqitch in a Docker container.

## Initialization

Edit `sqitch.conf` if you want to change the database target(s) and set the DB
password using SQITCH_PASSWORD, then run:

```
sqitch deploy --verify --target <TARGET>
```

