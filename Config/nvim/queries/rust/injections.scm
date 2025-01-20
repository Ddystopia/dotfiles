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

(
  (macro_invocation
    macro: ((identifier) @_html_def)
    (token_tree) @injection.content (#set! injection.language "css") (#set! injection.include-children))

    (#eq? @_html_def "css")
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


(call_expression
  function: (scoped_identifier
      name: ((identifier) @fn_name (#eq? @fn_name "query")))
  arguments: (arguments [
       (raw_string_literal (string_content) @injection.content (#set! injection.language "sql") (#set! injection.include-children) (#set! "priority" 1000) )
       (string_literal (string_content) @injection.content (#set! injection.language "sql") (#set! injection.include-children) (#set! "priority" 1000) )
     ]))

(macro_invocation
  macro: (scoped_identifier
        path: (identifier)
        name: ((identifier) @name
          (#any-of? @name
            "query"
            "query_as"
            "query_as_unchecked"
            "query_file"
            "query_file_as"
            "query_file_as_unchecked"
            "query_file_scalar"
            "query_file_scalar_unchecked"
            "query_file_unchecked"
            "query_scalar"
            "query_scalar_unchecked"
            "query_unchecked"
           )))
  (token_tree [
     (raw_string_literal (string_content) @injection.content (#set! injection.language "sql") (#set! injection.include-children) (#set! "priority" 1000) )
     (string_literal (string_content) @injection.content (#set! injection.language "sql") (#set! injection.include-children) (#set! "priority" 1000) )
   ]))
