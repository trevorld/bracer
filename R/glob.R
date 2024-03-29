#' Brace and Wildcard expansion on file paths
#'
#' `glob()` is a wrapper around [Sys.glob()] that uses
#' [expand_braces()] to support both brace and wildcard
#' expansion on file paths.
#' @param paths character vector of patterns for relative or absolute filepaths.
#' @inheritParams expand_braces
#' @param ... Passed to [Sys.glob()]
#' @examples
#'   dir <- system.file("R", package="bracer")
#'   path <- file.path(dir, "*.{R,r,S,s}")
#'   glob(path, engine = "r")
#' @export
glob <- function(paths, ..., engine = getOption("bracer.engine", NULL)) {
    paths <- expand_braces(paths, engine = engine)
    Sys.glob(paths, ...)
}
