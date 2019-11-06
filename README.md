For now we have to different ways to alter the database:

### Sqitch
Should be used for all tables, and everything we need for the tables to work: custom types, extensions ++. Can also be used for functions needed in migrations.

### SQL-files deployed manually
For all functions and views, that are created and updated mainly to develop our API exposed through postgrest.

### Why?
Because the Sqitch migrations don't make much sense when we iterate over functions often. It is hard following their changes in git when we end up with v1, v2, v3... of every function.

Hopefully we can use some other tool (pgRebase?) to maintain the functions in a nicer way. In the future.

### Hooks
Please make sure to read [hooks/README.md](hooks/README.md) to ensure that no passwords are committed.