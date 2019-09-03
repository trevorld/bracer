bracer 1.1.1
============

* ``expand_braces`` now handles vectorized input and returns one character vector with all the brace expansions.  New function ``str_expand_braces`` offers an alternative that instead returns a list of character vectors.
* New function ``glob`` provides a wrapper around ``Sys.glob`` that supports
  both brace and wildcard expansion on file paths.

bracer 1.0.1
============

* ``expand_braces`` can now parse nested braces.

bracer 0.1
==========

* Initial version of ``expand_braces`` function which has partial support for Bash-style brace expansion.
