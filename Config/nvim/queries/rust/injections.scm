(
  (macro_invocation
    macro: (scoped_identifier
      name: (identifier) @macro_name)
    (#match? @macro_name "query(_as)?") ; match `query` or `query_as` macros
    (token_tree
      (string_literal) @sql_query)
  )
  ; Apply SQL highlighting to the query inside the macro
  (#set! @sql_query highlight.sql)
)

(macro_invocation
  (token_tree) @rust)

(macro_definition
  (macro_rule
    left: (token_tree_pattern) @rust
    right: (token_tree) @rust))

[
  (line_comment)
  (block_comment)
] @comment

(
  (macro_invocation
    macro: ((identifier) @_html_def)
    (token_tree) @html)

    (#eq? @_html_def "html")
)

(call_expression
  function: (scoped_identifier
    path: (identifier) @_regex (#eq? @_regex "Regex")
    name: (identifier) @_new (#eq? @_new "new"))
  arguments: (arguments
    (raw_string_literal) @regex))

(call_expression
  function: (scoped_identifier
    path: (scoped_identifier (identifier) @_regex (#eq? @_regex "Regex").)
    name: (identifier) @_new (#eq? @_new "new"))
  arguments: (arguments
    (raw_string_literal) @regex))
