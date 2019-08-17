#' Brace and Wildcard expansion on file paths
#'
#' \code{glob} is a wrapper around \code{Sys.glob} that uses
#' \code{expand_braces} to support both brace and wildcard
#' expansion on file paths.
#' @param paths character vector of patterns for relative or absolute filepaths.
#' @param ... Passed to \code{Sys.glob}
#' @examples
#'   dir <- system.file("R", package="bracer")
#'   path <- file.path(dir, "*.{R,r,S,s}")
#'   glob(path)
#' @export
glob <- function(paths, ...) {
    paths <- expand_braces(paths)
    Sys.glob(paths, ...)
}
