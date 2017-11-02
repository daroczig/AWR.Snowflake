# AWR.Snowflake

This is an R client to interact with [Snowflake](https://www.snowflake.net), including wrapper functions 
around the [Snowflake JDBC driver](https://docs.snowflake.net/manuals/user-guide/jdbc.html).

## Installation

The package is not yet hosted on CRAN. 

But you can easily install the most recent development version of the R package as well:

```r
devtools::install_github('daroczig/AWR.Snowflake')
```

## What is it good for?

This provides a simplified DBI driver for Snowflake:

```r
require(DBI)
con <- dbConnect(AWR.Snowflake::Snowflake(),
  account_name = 'foobar', user = 'username', password = '***', db = 'SNOWFLAKE_SAMPLE_DATA')
dbListTables(con)
dbGetQuery(con, 'SELECT COUNT(*) from TPCDS_SF100TCL.call_center')
dbGetQuery(con, 'SELECT * FROM tpch_sf1.lineitem limit 5')
dbDisconnect(con)
```

Installing and loading the JDBC driver package is handled automatically. 

## What if I want to do other cool things with Snowflake and R?

Most database functionality is actually provided by RJDBC, but if you have Snowflake-specific
features in mind, please open a ticket on the feature request, or even better, submit a pull request :)

## It doesn't work here!

To be able to use this package, you need to have a Snowflake account. If you do not have one already, you sign up for a free trial.
