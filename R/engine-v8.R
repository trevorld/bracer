bracer_env <- new.env()

expand_braces_v8 <- function(string) {
    if (is.null(bracer_env$js)) {
        bracer_env$js <- V8::v8()
        invisible(bracer_env$js$source(system.file("js/braces_bundle.js", package = "bracer")))
    }
    bracer_env$js$assign("string", string)
    cmd <- str_glue("output = braces.expand(string, {{ rangeLimit: Infinity }});")
    invisible(bracer_env$js$eval(cmd))
    bracer_env$js$get("output")
}
