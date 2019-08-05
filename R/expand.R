#' Bash-style brace expansion
#'
#' \code{expand_braces} provides partial support for
#' Bash-style brace expansion.
#' @param string input character vector
#' @return A character vector
#' @examples
#'   expand_braces("Foo{A..F}")
#'   expand_braces("Foo{01..10}")
#'   expand_braces("Foo{A..F}{1..5..2}")
#'   expand_braces("Foo{a..f..2}{-01..5}")
#' @import stringr
#' @export
expand_braces <- function(string) {
    # Find brace starts and ends
    brace_token <- "(?<!\\\\)\\{([^}]|\\\\\\})*(?<!\\\\)\\}"
    locations <- str_locate_all(string, brace_token)[[1]]
    n <- nrow(locations)
    if (n == 0) return(process_string(string))
    braced <- vector("list", n)
    for (ii in seq(length.out=n)) {
        braced[[ii]] <- expand_brace(string, locations, ii)
    }
    preamble <- get_preamble(string, locations)
    non_braced <- vector("character", n)
    for (ii in seq(length.out=max(n-1,0))) {
        non_braced[ii] <- get_middle(string, locations, ii, ii+1)
    }
    non_braced[n] <- get_postfix(string, locations)

    df <- expand.grid(rev(braced), stringsAsFactors=FALSE)
    value <- preamble
    for (ii in seq(n))
        value <- paste0(value, df[,n+1-ii], non_braced[ii])
    process_string(value)
}

zero_pad <- function(numbers, width=2) {
    is_neg <- which(sign(numbers) < 0)
    padded_numbers <- str_pad(numbers, width, pad="0")
    padded_numbers[is_neg] <- paste0("-", str_pad(abs(numbers[is_neg]), width-1, pad="0"))
    padded_numbers
}

process_string <- function(string) {
    string <- gsub("\\\\\\.", ".", string)
    string <- gsub("\\\\,", ",", string)
    string <- gsub("\\\\\\{", "{", string)
    string <- gsub("\\\\\\}", "}", string)
    string
}

expand_brace <- function(string, locations, i) {
    il <- locations[i,1]
    ir <- locations[i,2]
    brace <- str_sub(string, il, ir)
    if (str_detect(brace, "(?<!\\\\),")) { # comma split
        expand_comma(brace)
    } else if (str_detect(brace, "\\.{2}")) {
        expand_periods(brace)
    } else {
        brace
    }
}

expand_comma <- function(string) {
    string <- str_sub(string, 2, -2)
    str_split(string, "(?<!\\\\),")[[1]]
}

ASCII <- c(" ", "!", '"', "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", 
           "-", ".", "/", as.character(0:9), ":", ";", "<", "=", ">", "?", "@",
           LETTERS, "[", "\\", "]", "^", "_", "`", letters, "{", "|", "}", "~")

has_pad <- function(digits) {
    any(str_detect(digits[1:2], "^-?0[0-9]+"))
}

expand_periods <- function(string) {
    if (str_detect(string, "\\{[[:alpha:]]\\.{2}[[:alpha:]]\\}")) {
        i_left <- match(str_sub(string, 2, 2), ASCII)
        i_right <- match(str_sub(string, 5, 5), ASCII)
        ASCII[i_left:i_right]
    } else if (str_detect(string, "\\{[[:alpha:]]\\.{2}[[:alpha:]]\\.{2}-?[[:digit:]]+\\}")) {
        string <- str_sub(string, 2, -2)
        items <- str_split(string, "\\.{2}")[[1]]
        i_left <- match(items[1], ASCII)
        i_right <- match(items[2], ASCII)
        by <- sign(i_right-i_left)*abs(as.numeric(items[3]))
        ASCII[seq(i_left,i_right,by)]
    } else if (str_detect(string, "\\{-?[[:digit:]]+\\.{2}-?[[:digit:]]+\\}")) {
        string <- str_sub(string, 2, -2)
        digits <- str_split(string, "\\.{2}")[[1]]
        numbers <- as.numeric(digits)
        values <- seq(numbers[1], numbers[2])
        if (has_pad(digits)) {
            zero_pad(values, max(str_count(digits)))
        } else {
            values
        }
    } else if (str_detect(string, "\\{-?[[:digit:]]+\\.{2}-?[[:digit:]]+\\.{2}-?[[:digit:]]+\\}")) {
        string <- str_sub(string, 2, -2)
        digits <- str_split(string, "\\.{2}")[[1]]
        numbers <- as.numeric(digits)
        by <- sign(numbers[2]-numbers[1])*abs(numbers[3])
        values <- seq(numbers[1], numbers[2], by)
        if (has_pad(digits[1:2])) {
            zero_pad(values, max(str_count(digits[1:2])))
        } else {
            values
        }
    } else {
        string
    }
}

get_preamble <- function(string, locations) {
    index <- locations[1,1]
    if (index == 1)
        ""
    else
        stringr::str_sub(string, 1, index-1)
}

get_middle <- function(string, locations, il, ir) {
    il <- locations[il,2]
    ir <- locations[ir,1]
    if (il+1<ir)
        stringr::str_sub(string, il+1, ir-1)
    else
        ""
}

get_postfix <- function(string, locations) {
    index <- locations[nrow(locations),2]
    n <- stringr::str_count(string)
    if (index == n)
        ""
    else
        str_sub(string, index+1, n)
}
