bracer
======

[![CRAN Status Badge](https://www.r-pkg.org/badges/version/bracer)](https://cran.r-project.org/package=bracer)
[![Travis-CI Build Status](https://travis-ci.org/trevorld/bracer.png?branch=master)](https://travis-ci.org/trevorld/bracer)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/trevorld/bracer?branch=master&svg=true)](https://ci.appveyor.com/project/trevorld/bracer)
[![Coverage Status](https://img.shields.io/codecov/c/github/trevorld/bracer/master.svg)](https://codecov.io/github/trevorld/bracer?branch=master)
[![Project Status: Inactive – The project has reached a stable, usable state but is no longer being actively developed; support/maintenance will be provided as time allows.](https://www.repostatus.org/badges/latest/inactive.svg)](https://www.repostatus.org/#inactive)

``bracer`` provides support for performing [brace expansions](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Brace-Expansion) on strings in R.


```r
library("bracer")
expand_braces("Foo{A..F}")
```

```
## [1] "FooA" "FooB" "FooC" "FooD" "FooE" "FooF"
```

```r
expand_braces("Foo{01..10}")
```

```
##  [1] "Foo01" "Foo02" "Foo03" "Foo04" "Foo05" "Foo06" "Foo07" "Foo08"
##  [9] "Foo09" "Foo10"
```

```r
expand_braces("Foo{A..E..2}{1..5..2}")
```

```
## [1] "FooA1" "FooA3" "FooA5" "FooC1" "FooC3" "FooC5" "FooE1" "FooE3" "FooE5"
```

```r
expand_braces("Foo{-01..1}")
```

```
## [1] "Foo-01" "Foo000" "Foo001"
```

```r
expand_braces("Foo{{d..d},{bar,biz}}.{py,bash}")
```

```
## [1] "Food.py"     "Food.bash"   "Foobar.py"   "Foobar.bash" "Foobiz.py"  
## [6] "Foobiz.bash"
```

To install the release version on CRAN use the following command in R:


```r
install.packages("bracer")
```

To install the developmental version use the following command in R:


```r
remotes::install_github("trevorld/bracer")
```

``bracer`` currently does not properly support the "correct" (Bash-style) brace expansion under several edge conditions such as:

1. Unbalanced braces e.g. ``{a,d}}``
2. Using surrounding quotes to escape terms e.g. ``{'a,b','c'}``
3. Escaped *inner* braces e.g. ``{a,b\\}c,d}``
4. (Non-escaping) backslashes before braces e.g. ``{a,\\\\{a,b}c}'``
5. Sequences from letters to non-letter ASCII characters e.g. ``X{a..#}X``
