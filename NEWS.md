bracer 1.2.2
============

* Add a vignette.

bracer 1.2.1
============

* No user-facing changes (we tweaked examples/tests so that the package check should still pass on platforms with buggy V8 installations).

bracer 1.2.0
============

* ``expand_braces()``, ``str_expand_braces()``, and ``glob()`` now support a new argument ``engine`` (#4):

  * If `'r'` use a pure R parser.
  * If `'v8'` use the 'braces' Javascript parser via the suggested V8 package.
  * If `NULL` use `'v8'` if `'V8'` package detected else use `'r'`;
    in either case send a `message()` about the choice
    unless `getOption(bracer.engine.inform')` is `FALSE`.

  The 'braces' Javascript parser can handle some edge cases that the pure R parser cannot.

bracer 1.1.1
============

* ``expand_braces()`` now handles vectorized input and returns one character vector with all the brace expansions.  New function ``str_expand_braces()`` offers an alternative that instead returns a list of character vectors.
* New function ``glob`` provides a wrapper around ``Sys.glob`` that supports
  both brace and wildcard expansion on file paths.

bracer 1.0.1
============

* ``expand_braces()`` can now parse nested braces.

bracer 0.1
==========

* Initial version of ``expand_braces()`` function which has partial support for Bash-style brace expansion.
