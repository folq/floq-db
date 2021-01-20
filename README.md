
## Local development install guide

The following recipe is for installing a dockerized local postgres with an up-to-date schema.


``` sh
make hverdagsverktoydb
```

You might have to repeat the following commands a few times to get it up and running :shrug:

```sh
cd sqitch
./sqitch deploy --target dev --verify
cd ../functions
./deploy.sh --dev
cd ..
```


You also have to set a password in the `add_employee_user.sql` file, when you get an error about it.

The same password needs to be set in `postgrest.conf` where it says `<PasswordGoesHere>`

Next you need to install `postgrest`, and then run it in this directory with `postgrest postgrest.conf`


## For now we have two different ways to alter the database

### Sqitch
Should be used for all tables, and everything we need for the tables to work: custom types, extensions ++. Can also be used for functions needed in migrations.

### SQL-files deployed manually
For all functions and views, that are created and updated mainly to develop our API exposed through postgrest.

### Why?
Because the Sqitch migrations don't make much sense when we iterate over functions often. It is hard following their changes in git when we end up with v1, v2, v3... of every function.

Hopefully we can use some other tool (pgRebase?) to maintain the functions in a nicer way. In the future.

### Hooks
Please make sure to read [hooks/README.md](hooks/README.md) to ensure that no passwords are committed.



