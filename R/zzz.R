#' @importFrom utils packageVersion download.file
#' @importFrom rJava .jpackage
.onLoad <- function(libname, pkgname) {

    ## path to the java folder
    path <- paste0(system.file('', package = pkgname), 'java')
    if (!file.exists(path)) {
        dir.create(path)
    }

    ## path to the JDBC driver
    file <- sprintf('snowflake-jdbc-%s.jar', packageVersion(pkgname))
    path <- file.path(path, file)

    ## check if the jar is available and install if needed (on first load)
    if (!file.exists(path)) {

        url <- file.path(
            'https://repo1.maven.org/maven2/net/snowflake/snowflake-jdbc',
            packageVersion(pkgname), file)

        ## download the jar file from Maven
        try(download.file(url = url, destfile = path, mode = 'wb'),
            silent = TRUE)

    }

    ## add the RJDBC driver and the log4j properties file to classpath
    rJava::.jpackage(pkgname, lib.loc = libname)

}

.onAttach <- function(libname, pkgname) {

    ## let the user know if the automatic JDBC driver installation failed
    path <- system.file('java', package = pkgname)
    if (length(list.files(path, '^snowflake-jdbc-[0-9.]*jar$')) == 0) {
        packageStartupMessage(
            'The automatic installation of the Snowflake JDBC driver seems to have failed.\n',
            'Please check your Internet connection and if the current user can write to ', path, '\n',
            'If still having issues, install the jar file manually as described at:\n',
            'https://docs.snowflake.net/manuals/user-guide/jdbc-download.html\n')
    }

}
