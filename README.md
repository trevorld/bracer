bracer
======

[![Travis-CI Build Status](https://travis-ci.org/trevorld/bracer.png?branch=master)](https://travis-ci.org/trevorld/bracer)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/trevorld/bracer?branch=master&svg=true)](https://ci.appveyor.com/project/trevorld/bracer)
[![Coverage Status](https://img.shields.io/codecov/c/github/trevorld/bracer/master.svg)](https://codecov.io/github/trevorld/bracer?branch=master)
[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

``bracer`` provides partial support for [Bash-style brace expansion](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Brace-Expansion) in R.


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
expand_braces("Foo{A..F}{1..5..2}")
```

```
##  [1] "FooA1" "FooA3" "FooA5" "FooB1" "FooB3" "FooB5" "FooC1" "FooC3"
##  [9] "FooC5" "FooD1" "FooD3" "FooD5" "FooE1" "FooE3" "FooE5" "FooF1"
## [17] "FooF3" "FooF5"
```

```r
expand_braces("Foo{a..f..2}{-01..5}")
```

```
##  [1] "Fooa-01" "Fooa000" "Fooa001" "Fooa002" "Fooa003" "Fooa004" "Fooa005"
##  [8] "Fooc-01" "Fooc000" "Fooc001" "Fooc002" "Fooc003" "Fooc004" "Fooc005"
## [15] "Fooe-01" "Fooe000" "Fooe001" "Fooe002" "Fooe003" "Fooe004" "Fooe005"
```

To install the developmental version use the following commands in R:


```r
remotes::install_github("trevorld/bracer")
```

``bracer`` currently does not properly support the proper Bash-style brace expansion under several conditions such as:

1. Nested braces e.g. ``{{a..d},{1..2}}``
2. Unbalanced braces e.g. ``{a,d}}``
3. Using quotes to escape terms e.g. ``{'a,b','c'}``
4. Including a non-escaping backslash ahead of a brace or comma e.g. ``{a,b\\\\\\\\}}``
