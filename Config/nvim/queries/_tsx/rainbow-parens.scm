; inherits: typescript

(jsx_element
  (jsx_opening_element
    name: (_) @opening)
  (jsx_closing_element
    name: (_) @closing)) @container

(jsx_self_closing_element
  name: (_) @intermediate) @container

(jsx_expression
  "{" @opening
  "}" @closing) @container

; (element
;   (start_tag
;     ("<" (tag_name) ">") @opening)
;   (end_tag
;     ("</" (tag_name) ">") @closing)) @container

