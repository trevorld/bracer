#' Bash-style brace expansion
#'
#' `expand_braces()` performs brace expansions on strings.
#' `str_expand_braces()` is an alternate that returns a list of character vectors.
#' Made popular by Unix shells, brace expansion allows users to concisely generate
#' certain character vectors by taking a single string and (recursively) expanding
#' the comma-separated lists and double-period-separated integer and character
#' sequences enclosed within braces in that string.
#' The double-period-separated numeric integer expansion also supports padding the resulting numbers with zeros.
#' @param string input character vector
#' @param engine If `'r'` use a pure R parser.
#'               If `'v8'` use the 'braces' Javascript parser via the suggested V8 package.
#'               If `NULL` use `'v8'` if `'V8'` package detected else use `'r'`;
#'               in either case send a `message()` about the choice
#'               unless `getOption(bracer.engine.inform')` is `FALSE`.
#' @return `expand_braces()` returns a character vector while
#'         `str_expand_braces()` returns a list of character vectors.
#'
#' @examples
#'   expand_braces("Foo{A..F}", engine = "r")
#'   expand_braces("Foo{01..10}", engine = "r")
#'   expand_braces("Foo{A..E..2}{1..5..2}", engine = "r")
#'   expand_braces("Foo{-01..1}", engine = "r")
#'   expand_braces("Foo{{d..d},{bar,biz}}.{py,bash}", engine = "r")
#'   expand_braces(c("Foo{A..F}", "Bar.{py,bash}", "{{Biz}}"), engine = "r")
#'   str_expand_braces(c("Foo{A..F}", "Bar.{py,bash}", "{{Biz}}"), engine = "r")
#' @import stringr
#' @export
expand_braces <- function(string, engine = getOption("bracer.engine", NULL)) {
    c(str_expand_braces(string, engine = engine), recursive = TRUE)
}

#' @rdname expand_braces
#' @export
str_expand_braces <- function(string, engine = getOption("bracer.engine", NULL)) {
    if (!is.null(engine)) engine <- tolower(engine)
    if (is.null(engine)) {
        if (requireNamespace("V8", quietly = TRUE)) {
            engine <- "v8"
            if (!isTRUE(getOption("bracer.engine.inform")))
                message("Setting 'engine' argument to 'v8' (suggested package 'V8' detected)")
        } else {
            engine <- "r"
            if (!isTRUE(getOption("bracer.engine.inform")))
                warning("Setting 'engine' argument to 'r' (suggested package 'V8' not detected)")
        }
    }
    if (engine == "v8" && !requireNamespace("V8", quietly = TRUE)) {
        engine <- "r"
        message("Suggested package 'V8' not detected. Instead setting 'engine' argument to 'r'")
    }
    switch(engine,
           v8 = lapply(string, expand_braces_v8),
           r = lapply(string, expand_braces_r))
}
