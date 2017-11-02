#' Snowflake driver class.
#'
#' @keywords internal
#' @export
#' @import RJDBC
#' @import methods
#' @importClassesFrom RJDBC JDBCDriver
setClass('SnowflakeDriver', contains = 'JDBCDriver')


#' Snowflake DBI wrapper
#'
#' @export
Snowflake <- function() {
    new('SnowflakeDriver')
}


#' Constructor of SnowflakeDriver
#'
#' @name SnowflakeDriver
#' @rdname SnowflakeDriver-class
setMethod(initialize, 'SnowflakeDriver', function(.Object, ...) {
    jdbc <- JDBC(driverClass = 'com.snowflake.client.jdbc.SnowflakeDriver',
                 identifier.quote = '"')
    .Object@jdrv = jdbc@jdrv
    .Object@identifier.quote = jdbc@identifier.quote
    .Object
})


#' Snowflake connection class
#'
#' Class which represents the Snowflake connections.
#'
#' @export
#' @importClassesFrom RJDBC JDBCConnection
#' @keywords internal
setClass('SnowflakeConnection',
         contains = 'JDBCConnection',
         slots = list(
             account_name = 'character',
             region_id = 'character',
             user = 'character',
             password = 'character',
             warehouse = 'character',
             db = 'character',
             schema = 'character'))


#' Connect to Snowflake
#'
#' @param drv An object created by \code{Snowflake()}
#' @param account_name Snowflake account name, which is the subdomain part of your Snowflake warehouse
#' @param region_id id of the region assigned to your Snowflake account
#' @param user Snowflake username
#' @param password Snowflake password
#' @param db default database to use
#' @param schema default schema to use
#' @param warehouse default warehouse / compute cluster to use
#' @param ... other parameters passed to the JDBC driver
#' @rdname Snowflake
#' @seealso \href{https://docs.snowflake.net/manuals/user-guide/jdbc-configure.html}{Snowflake JDBC Manual} for more connections options.
#' @export
#' @examples
#' \dontrun{
#' require(DBI)
#' con <- dbConnect(AWR.Snowflake::Snowflake(),
#'   account_name = 'foobar', user = 'username', password = '***', db = 'SNOWFLAKE_SAMPLE_DATA')
#' dbListTables(con)
#' dbGetQuery(con, 'SELECT COUNT(*) from TPCDS_SF100TCL.call_center')
#' dbGetQuery(con, 'SELECT * FROM tpch_sf1.lineitem limit 5')
#' dbDisconnect(con)
#' }
setMethod('dbConnect', 'SnowflakeDriver', function(drv, account_name, region_id = 'us-west-2',
                                                   user, password,
                                                   db = 'nodb',
                                                   schema = 'noschema',
                                                   warehouse = 'nowarehouse',
                                                   ...) {

    ## set URL params
    opts <- match.call()[-1]
    opts$drv <- opts$account_name <- opts$region_id <- NULL
    opts <- paste(lapply(names(opts), function(opt) paste0(opt, '=', opts[[opt]])),
                  collapse = '&')

    url <- sprintf('jdbc:snowflake://%s%s.snowflakecomputing.com?%s',
                   account_name, ifelse(region_id == 'us-west-2', '', paste0(region_id, '.')), opts)

    con <- callNextMethod(drv, url = url)

    new('SnowflakeConnection', jc = con@jc,
        account_name = account_name, region_id = region_id,
        user = user, password = password, db = db, schema = schema, warehouse = warehouse)

})
