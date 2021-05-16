brace_token <- "(?<!\\\\)\\{([^}]|\\\\\\})*(?<!\\\\)\\}"
has_brace <- function(string) {
    str_detect(string, brace_token)
}

expand_braces_r <- function(string, process = TRUE) {
    locations <- get_locations(string) # Find brace starts and ends
    n <- nrow(locations)
    if (n == 0) return(process_string(string))
    braced <- vector("list", n)
    for (ii in seq(length.out = n)) {
        braced[[ii]] <- expand_brace(string, locations, ii)
    }
    preamble <- get_preamble(string, locations)
    non_braced <- vector("character", n)
    for (ii in seq(length.out = max(n - 1, 0))) {
        non_braced[ii] <- get_middle(string, locations, ii, ii + 1)
    }
    non_braced[n] <- get_postfix(string, locations)

    df <- expand.grid(rev(braced), stringsAsFactors = FALSE)
    value <- preamble
    for (ii in seq(n)) {
        value <- paste0(value, df[, n + 1 - ii], non_braced[ii])
    }
    if (process) {
        process_string(value)
    } else {
        value
    }
}

data_frame <- function(...) data.frame(..., stringsAsFactors = FALSE)

# get locations of top level braces
get_locations <- function(string) {
    left_brace <- "(?<!\\\\)\\{"
    left_locations <- str_locate_all(string, left_brace)[[1]]
    if (nrow(left_locations) == 0) return(matrix(numeric(0), ncol = 2))
    df_left <- data_frame(index = left_locations[, 1], char = "{")
    right_brace <- "(?<!\\\\)\\}"
    right_locations <- str_locate_all(string, right_brace)[[1]]
    if (nrow(right_locations) == 0) return(matrix(numeric(0), ncol = 2))
    df_right <- data_frame(index = right_locations[, 1], char = "}")
    df <- rbind(df_left, df_right)
    df <- df[order(df$index), ]
    df$level <- 0
    level <- 1
    for (ii in seq(length = nrow(df))) {
        if (df[ii, 2] == "{") {
            df[ii, 3] <- level
            level <- level + 1
        } else {
            level <- level - 1
            df[ii, 3] <- level
        }
    }
    df <- df[which(df$level == 1), ]
    matrix(df$index, ncol = 2, byrow = TRUE)
}

zero_pad <- function(numbers, width = 2) {
    is_neg <- which(sign(numbers) < 0)
    padded_numbers <- str_pad(numbers, width, pad = "0")
    padded_numbers[is_neg] <- paste0("-", str_pad(abs(numbers[is_neg]), width - 1, pad = "0"))
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
    il <- locations[i, 1]
    ir <- locations[i, 2]
    brace <- str_sub(string, il, ir)
    inner <- str_sub(brace, 2, -2)
    if (has_comma(inner)) {
        expand_comma(inner)
    } else if (has_periods(inner)) {
        expand_periods(inner)
    } else if (has_brace(inner)) {
        paste0("{", expand_braces_r(inner, FALSE), "}")
    } else {
        brace
    }
}

comma_token <- "(?<!\\\\),(?![^\\{]*\\})"
# comma_token <- "(?<!\\\\),(?![^\\{]*[^\\\\]\\})" # nolint
has_comma <- function(string) {
    str_detect(string, comma_token)
}

expand_comma <- function(string) {
    elements <- str_split(string, comma_token)[[1]]
    elements <- lapply(elements, expand_braces_r, FALSE)
    elements <- c(elements, recursive = TRUE)
    elements
}

ASCII <- c(" ", "!", '"', "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", # nolint
           "-", ".", "/", as.character(0:9), ":", ";", "<", "=", ">", "?", "@",
           LETTERS, "[", "\\", "]", "^", "_", "`", letters, "{", "|", "}", "~")

has_pad <- function(digits) {
    any(str_detect(digits[1:2], "^-?0[0-9]+"))
}

alpha2_token <- "^[[:alpha:]]\\.{2}[[:alpha:]]$"
alpha3_token <- "^[[:alpha:]]\\.{2}[[:alpha:]]\\.{2}-?[[:digit:]]+$"
digit2_token <- "^-?[[:digit:]]+\\.{2}-?[[:digit:]]+$"
digit3_token <- "^-?[[:digit:]]+\\.{2}-?[[:digit:]]+\\.{2}-?[[:digit:]]+$"
period_token <- paste(alpha2_token, alpha3_token, digit2_token, digit3_token, sep = "|")

has_periods <- function(string) {
    str_detect(string, period_token)
}

expand_periods <- function(string) {
    if (str_detect(string, alpha2_token)) {
        i_left <- match(str_sub(string, 1, 1), ASCII)
        i_right <- match(str_sub(string, 4, 4), ASCII)
        ASCII[i_left:i_right]
    } else if (str_detect(string, alpha3_token)) {
        items <- str_split(string, "\\.{2}")[[1]]
        i_left <- match(items[1], ASCII)
        i_right <- match(items[2], ASCII)
        by <- sign(i_right - i_left) * abs(as.numeric(items[3]))
        ASCII[seq(i_left, i_right, by)]
    } else if (str_detect(string, digit2_token)) {
        digits <- str_split(string, "\\.{2}")[[1]]
        numbers <- as.numeric(digits)
        values <- seq(numbers[1], numbers[2])
        if (has_pad(digits)) {
            zero_pad(values, max(str_count(digits)))
        } else {
            values
        }
    } else if (str_detect(string, digit3_token)) {
        digits <- str_split(string, "\\.{2}")[[1]]
        numbers <- as.numeric(digits)
        by <- sign(numbers[2] - numbers[1]) * abs(numbers[3])
        values <- seq(numbers[1], numbers[2], by)
        if (has_pad(digits[1:2])) {
            zero_pad(values, max(str_count(digits[1:2])))
        } else {
            values
        }
    }
}

get_preamble <- function(string, locations) {
    index <- locations[1, 1]
    if (index == 1)
        ""
    else
        stringr::str_sub(string, 1, index - 1)
}

get_middle <- function(string, locations, il, ir) {
    il <- locations[il, 2]
    ir <- locations[ir, 1]
    if (il + 1 < ir)
        stringr::str_sub(string, il + 1, ir - 1)
    else
        ""
}

get_postfix <- function(string, locations) {
    index <- locations[nrow(locations), 2]
    n <- stringr::str_count(string)
    if (index == n)
        ""
    else
        str_sub(string, index + 1, n)
}
