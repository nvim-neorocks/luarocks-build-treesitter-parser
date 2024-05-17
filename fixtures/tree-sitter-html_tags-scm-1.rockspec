local git_ref = '548853648d7cff7e0d959ff95209e8aa97a793bc'
local modrev = 'scm'
local specrev = '1'

local repo_url = 'https://github.com/nvim-neorocks/luarocks-stub'

rockspec_format = '3.0'
package = 'tree-sitter-html_tags'
version = modrev ..'-'.. specrev

description = {
  summary = 'tree-sitter parser for html_tags',
  labels = { 'neovim', 'tree-sitter' } ,
  homepage = 'https://github.com/nvim-neorocks/luarocks-stub',
  license = 'Apache-2.0'
}

dependencies = {
  'luarocks-build-treesitter-parser >= 1.1.1',
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = 'luarocks-stub-' .. '548853648d7cff7e0d959ff95209e8aa97a793bc',
}

build = {
  type = "treesitter-parser",
  lang = "html_tags",
  parser = false,
  queries = {
    ["highlights.scm"] = [==[
(tag_name) @tag

; (erroneous_end_tag_name) @error ; we do not lint syntax errors
(comment) @comment @spell

(attribute_name) @tag.attribute

((attribute
  (quoted_attribute_value) @string)
  (#set! "priority" 99))

(text) @none @spell

((element
  (start_tag
    (tag_name) @_tag)
  (text) @markup.heading)
  (#eq? @_tag "title"))

((element
  (start_tag
    (tag_name) @_tag)
  (text) @markup.heading.1)
  (#eq? @_tag "h1"))

((element
  (start_tag
    (tag_name) @_tag)
  (text) @markup.heading.2)
  (#eq? @_tag "h2"))

((element
  (start_tag
    (tag_name) @_tag)
  (text) @markup.heading.3)
  (#eq? @_tag "h3"))

((element
  (start_tag
    (tag_name) @_tag)
  (text) @markup.heading.4)
  (#eq? @_tag "h4"))

((element
  (start_tag
    (tag_name) @_tag)
  (text) @markup.heading.5)
  (#eq? @_tag "h5"))

((element
  (start_tag
    (tag_name) @_tag)
  (text) @markup.heading.6)
  (#eq? @_tag "h6"))

((element
  (start_tag
    (tag_name) @_tag)
  (text) @markup.strong)
  (#any-of? @_tag "strong" "b"))

((element
  (start_tag
    (tag_name) @_tag)
  (text) @markup.italic)
  (#any-of? @_tag "em" "i"))

((element
  (start_tag
    (tag_name) @_tag)
  (text) @markup.strikethrough)
  (#any-of? @_tag "s" "del"))

((element
  (start_tag
    (tag_name) @_tag)
  (text) @markup.underline)
  (#eq? @_tag "u"))

((element
  (start_tag
    (tag_name) @_tag)
  (text) @markup.raw)
  (#any-of? @_tag "code" "kbd"))

((element
  (start_tag
    (tag_name) @_tag)
  (text) @string.special.url)
  (#eq? @_tag "a"))

((attribute
  (attribute_name) @_attr
  (quoted_attribute_value
    (attribute_value) @string.special.url))
  (#any-of? @_attr "href" "src"))

[
  "<"
  ">"
  "</"
  "/>"
] @tag.delimiter

"=" @operator
]==],
    ["indents.scm"] = [==[
[
  ((element
    (start_tag
      (tag_name) @_not_special))
    (#not-any-of? @_not_special "meta" "link"))
  (element
    (self_closing_tag))
] @indent.begin

; These tags are usually written one-lined and doesn't use self-closing tags so special-cased them
; but add indent to the tag to make sure attributes inside them are still indented if written multi-lined
((start_tag
  (tag_name) @_special)
  (#any-of? @_special "meta" "link")) @indent.begin

; These are the nodes that will be captured when we do `normal o`
; But last element has already been ended, so capturing this
; to mark end of last element
(element
  (end_tag
    ">" @indent.end))

(element
  (self_closing_tag
    "/>" @indent.end))

; Script/style elements aren't indented, so only branch the end tag of other elements
(element
  (end_tag) @indent.branch)

[
  ">"
  "/>"
] @indent.branch

(comment) @indent.ignore
]==],
    ["injections.scm"] = [==[
((comment) @injection.content
  (#set! injection.language "comment"))

; <style>...</style>
; <style blocking> ...</style>
; Add "lang" to predicate check so that vue/svelte can inherit this
; without having this element being captured twice
((style_element
  (start_tag) @_no_type_lang
  (raw_text) @injection.content)
  (#not-lua-match? @_no_type_lang "%slang%s*=")
  (#not-lua-match? @_no_type_lang "%stype%s*=")
  (#set! injection.language "css"))

((style_element
  (start_tag
    (attribute
      (attribute_name) @_type
      (quoted_attribute_value
        (attribute_value) @_css)))
  (raw_text) @injection.content)
  (#eq? @_type "type")
  (#eq? @_css "text/css")
  (#set! injection.language "css"))

; <script>...</script>
; <script defer>...</script>
((script_element
  (start_tag) @_no_type_lang
  (raw_text) @injection.content)
  (#not-lua-match? @_no_type_lang "%slang%s*=")
  (#not-lua-match? @_no_type_lang "%stype%s*=")
  (#set! injection.language "javascript"))

; <script type="mimetype-or-well-known-script-type">
(script_element
  (start_tag
    (attribute
      (attribute_name) @_attr
      (#eq? @_attr "type")
      (quoted_attribute_value
        (attribute_value) @_type)))
  (raw_text) @injection.content
  (#set-lang-from-mimetype! @_type))

; <a style="/* css */">
((attribute
  (attribute_name) @_attr
  (quoted_attribute_value
    (attribute_value) @injection.content))
  (#eq? @_attr "style")
  (#set! injection.language "css"))

; lit-html style template interpolation
; <a @click=${e => console.log(e)}>
; <a @click="${e => console.log(e)}">
((attribute
  (quoted_attribute_value
    (attribute_value) @injection.content))
  (#lua-match? @injection.content "%${")
  (#offset! @injection.content 0 2 0 -1)
  (#set! injection.language "javascript"))

((attribute
  (attribute_value) @injection.content)
  (#lua-match? @injection.content "%${")
  (#offset! @injection.content 0 2 0 -2)
  (#set! injection.language "javascript"))

; <input pattern="[0-9]"> or <input pattern=[0-9]>
(element
  (_
    (tag_name) @_tagname
    (#eq? @_tagname "input")
    (attribute
      (attribute_name) @_attr
      [
        (quoted_attribute_value
          (attribute_value) @injection.content)
        (attribute_value) @injection.content
      ]
      (#eq? @_attr "pattern"))
    (#set! injection.language "regex")))

; <input type="checkbox" onchange="this.closest('form').elements.output.value = this.checked">
(attribute
  (attribute_name) @_name
  (#lua-match? @_name "^on[a-z]+$")
  (quoted_attribute_value
    (attribute_value) @injection.content)
  (#set! injection.language "javascript"))
]==],
  },
}
