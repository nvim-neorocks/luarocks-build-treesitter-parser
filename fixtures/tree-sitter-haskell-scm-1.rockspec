local git_ref = '95a4f0023741b3bee0cc500f3dab9c5bab2dc2be'
local modrev = 'scm'
local specrev = '1'

local repo_url = 'https://github.com/tree-sitter/tree-sitter-haskell'

rockspec_format = '3.0'
package = 'tree-sitter-haskell'
version = modrev ..'-'.. specrev

description = {
  summary = 'tree-sitter parser and Neovim queries for haskell',
  labels = { 'neovim', 'tree-sitter' } ,
  homepage = 'https://github.com/tree-sitter/tree-sitter-haskell',
  license = 'UNKNOWN'
}

build_dependencies = {
  'luarocks-build-treesitter-parser >= 1.3.0',
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = 'tree-sitter-haskell-' .. '95a4f0023741b3bee0cc500f3dab9c5bab2dc2be',
}

build = {
  type = "treesitter-parser",
  lang = "haskell",
  sources = { "src/parser.c", "src/scanner.c" },
  generate_from_grammar = false,
  generate_requires_npm = false,
  location = nil,
  copy_directories = { "queries" },
  queries = {
    ["folds.scm"] = [==[
[
  (exp_apply)
  (exp_do)
  (function)
] @fold
]==],
    ["highlights.scm"] = [==[
; ----------------------------------------------------------------------------
; Parameters and variables
; NOTE: These are at the top, so that they have low priority,
; and don't override destructured parameters
(variable) @variable

(pat_wildcard) @variable

(function
  patterns: (patterns
    (_) @variable.parameter))

(exp_lambda
  (_)+ @variable.parameter
  "->")

(function
  infix: (infix
    lhs: (_) @variable.parameter))

(function
  infix: (infix
    rhs: (_) @variable.parameter))

; ----------------------------------------------------------------------------
; Literals and comments
(integer) @number

(exp_negation) @number

(exp_literal
  (float)) @number.float

(char) @character

(string) @string

(con_unit) @string.special.symbol ; unit, as in ()

(comment) @comment

; FIXME: The below documentation comment queries are inefficient
; and need to be anchored, using something like
; ((comment) @_first . (comment)+ @comment.documentation)
; once https://github.com/neovim/neovim/pull/24738 has been merged.
;
; ((comment) @comment.documentation
;   (#lua-match? @comment.documentation "^-- |"))
;
; ((comment) @_first @comment.documentation
;  (comment) @comment.documentation
;   (#lua-match? @_first "^-- |"))
;
; ((comment) @comment.documentation
;   (#lua-match? @comment.documentation "^-- %^"))
;
; ((comment) @_first @comment.documentation
;  (comment) @comment.documentation
;   (#lua-match? @_first "^-- %^"))
;
; ((comment) @comment.documentation
;   (#lua-match? @comment.documentation "^{-"))
;
; ((comment) @_first @comment.documentation
;  (comment) @comment.documentation
;   (#lua-match? @_first "^{-"))
; ----------------------------------------------------------------------------
; Punctuation
[
  "("
  ")"
  "{"
  "}"
  "["
  "]"
] @punctuation.bracket

[
  (comma)
  ";"
] @punctuation.delimiter

; ----------------------------------------------------------------------------
; Keywords, operators, includes
[
  "forall"
  "âˆ€"
] @keyword.repeat

(pragma) @keyword.directive

[
  "if"
  "then"
  "else"
  "case"
  "of"
] @keyword.conditional

[
  "import"
  "qualified"
  "module"
] @keyword.import

[
  (operator)
  (constructor_operator)
  (type_operator)
  (tycon_arrow)
  (qualified_module) ; grabs the `.` (dot), ex: import System.IO
  (qualified_type)
  (qualified_variable)
  (all_names)
  (wildcard)
  "."
  ".."
  "="
  "|"
  "::"
  "=>"
  "->"
  "<-"
  "\\"
  "`"
  "@"
] @operator

(module) @module

((qualified_module
  (module) @constructor)
  .
  (module))

(qualified_type
  (module) @module)

(qualified_variable
  (module) @module)

(import
  (module) @module)

(import
  (module) @constructor
  .
  (module))

[
  (where)
  "let"
  "in"
  "class"
  "instance"
  "pattern"
  "data"
  "newtype"
  "family"
  "type"
  "as"
  "hiding"
  "deriving"
  "via"
  "stock"
  "anyclass"
  "do"
  "mdo"
  "rec"
  "infix"
  "infixl"
  "infixr"
] @keyword

; ----------------------------------------------------------------------------
; Functions and variables
(signature
  name: (variable) @function)

(function
  name: (variable) @function)

(function
  name: (variable) @variable
  rhs: [
    (exp_literal)
    (exp_apply
      (exp_name
        [
          (constructor)
          (variable)
          (qualified_variable)
        ]))
    (quasiquote)
    ((exp_name)
      .
      (operator))
  ])

(function
  name: (variable) @variable
  rhs: (exp_infix
    [
      (exp_literal)
      (exp_apply
        (exp_name
          [
            (constructor)
            (variable)
            (qualified_variable)
          ]))
      (quasiquote)
      ((exp_name)
        .
        (operator))
    ]))

; Consider signatures (and accompanying functions)
; with only one value on the rhs as variables
(signature
  .
  (variable) @variable
  .
  (_) .)

((signature
  .
  (variable) @_name
  .
  (_) .)
  .
  (function
    name: (variable) @variable)
  (#eq? @_name @variable))

; but consider a type that involves 'IO' a function
(signature
  name: (variable) @function
  .
  (type_apply
    (type_name) @_type)
  (#eq? @_type "IO"))

((signature
  name: (variable) @_name
  .
  (type_apply
    (type_name) @_type)
  (#eq? @_type "IO"))
  .
  (function
    name: (variable) @function)
  (#eq? @_name @function))

; functions with parameters
; + accompanying signatures
(function
  name: (variable) @function
  patterns: (patterns))

((signature) @function
  .
  (function
    name: (variable) @function
    patterns: (patterns)))

(function
  name: (variable) @function
  rhs: (exp_lambda))

; view patterns
(pat_view
  (exp_name
    [
      (variable) @function.call
      (qualified_variable
        (variable) @function.call)
    ]))

; consider infix functions as operators
(exp_infix
  [
    (variable) @operator
    (qualified_variable
      (variable) @operator)
  ])

; partially applied infix functions (sections) also get highlighted as operators
(exp_section_right
  [
    (variable) @operator
    (qualified_variable
      (variable) @operator)
  ])

(exp_section_left
  [
    (variable) @operator
    (qualified_variable
      (variable) @operator)
  ])

; function calls with an infix operator
; e.g. func <$> a <*> b
(exp_infix
  (exp_name
    [
      (variable) @function.call
      (qualified_variable
        ((module) @module
          (variable) @function.call))
    ])
  .
  (operator))

; infix operators applied to variables
((exp_name
  (variable) @variable)
  .
  (operator))

((operator)
  .
  (exp_name
    [
      (variable) @variable
      (qualified_variable
        (variable) @variable)
    ]))

; function calls with infix operators
((exp_name
  [
    (variable) @function.call
    (qualified_variable
      (variable) @function.call)
  ])
  .
  (operator) @_op
  (#any-of? @_op "$" "<$>" ">>=" "=<<"))

; right hand side of infix operator
((exp_infix
  [
    (operator)
    (variable)
  ] ; infix or `func`
  .
  (exp_name
    [
      (variable) @function.call
      (qualified_variable
        (variable) @function.call)
    ]))
  .
  (operator) @_op
  (#any-of? @_op "$" "<$>" "=<<"))

; function composition, arrows, monadic composition (lhs)
((exp_name
  [
    (variable) @function
    (qualified_variable
      (variable) @function)
  ])
  .
  (operator) @_op
  (#any-of? @_op "." ">>>" "***" ">=>" "<=<"))

; right hand side of infix operator
((exp_infix
  [
    (operator)
    (variable)
  ] ; infix or `func`
  .
  (exp_name
    [
      (variable) @function
      (qualified_variable
        (variable) @function)
    ]))
  .
  (operator) @_op
  (#any-of? @_op "." ">>>" "***" ">=>" "<=<"))

; function composition, arrows, monadic composition (rhs)
((operator) @_op
  .
  (exp_name
    [
      (variable) @function
      (qualified_variable
        (variable) @function)
    ])
  (#any-of? @_op "." ">>>" "***" ">=>" "<=<"))

; function defined in terms of a function composition
(function
  name: (variable) @function
  rhs: (exp_infix
    (_)
    .
    (operator) @_op
    .
    (_)
    (#any-of? @_op "." ">>>" "***" ">=>" "<=<")))

(exp_apply
  (exp_name
    [
      (variable) @function.call
      (qualified_variable
        (variable) @function.call)
    ]))

; function compositions, in parentheses, applied
; lhs
(exp_apply
  .
  (exp_parens
    (exp_infix
      (exp_name
        [
          (variable) @function.call
          (qualified_variable
            (variable) @function.call)
        ])
      .
      (operator))))

; rhs
(exp_apply
  .
  (exp_parens
    (exp_infix
      (operator)
      .
      (exp_name
        [
          (variable) @function.call
          (qualified_variable
            (variable) @function.call)
        ]))))

; variables being passed to a function call
(exp_apply
  (_)+
  .
  (exp_name
    [
      (variable) @variable
      (qualified_variable
        (variable) @variable)
    ]))

; Consider functions with only one value on the rhs
; as variables, e.g. x = Rec {} or x = foo
(function
  .
  (variable) @variable
  .
  [
    (exp_record)
    (exp_name
      [
        (variable)
        (qualified_variable)
      ])
    (exp_list)
    (exp_tuple)
    (exp_cond)
  ] .)

; main is always a function
; (this prevents `main = undefined` from being highlighted as a variable)
(function
  name: (variable) @function
  (#eq? @function "main"))

; scoped function types (func :: a -> b)
(pat_typed
  pattern: (pat_name
    (variable) @function)
  type: (fun))

; signatures that have a function type
; + functions that follow them
(signature
  (variable) @function
  (fun))

((signature
  (variable) @_type
  (fun))
  .
  (function
    (variable) @function)
  (#eq? @function @_type))

(signature
  (variable) @function
  (context
    (fun)))

((signature
  (variable) @_type
  (context
    (fun)))
  .
  (function
    (variable) @function)
  (#eq? @function @_type))

((signature
  (variable) @function
  (forall
    (context
      (fun))))
  .
  (function
    (variable)))

((signature
  (variable) @_type
  (forall
    (context
      (fun))))
  .
  (function
    (variable) @function)
  (#eq? @function @_type))

; ----------------------------------------------------------------------------
; Types
(type) @type

(type_star) @type

(type_variable) @type

(constructor) @constructor

; True or False
((constructor) @boolean
  (#any-of? @boolean "True" "False"))

; otherwise (= True)
((variable) @boolean
  (#eq? @boolean "otherwise"))

; ----------------------------------------------------------------------------
; Quasi-quotes
(quoter) @function.call

(quasiquote
  [
    (quoter) @_name
    (_
      (variable) @_name)
  ]
  (#eq? @_name "qq")
  (quasiquote_body) @string)

(quasiquote
  (_
    (variable) @_name)
  (#eq? @_name "qq")
  (quasiquote_body) @string)

; namespaced quasi-quoter
(quasiquote
  (_
    (module) @module
    .
    (variable) @function.call))

; Highlighting of quasiquote_body for other languages is handled by injections.scm
; ----------------------------------------------------------------------------
; Exceptions/error handling
((variable) @keyword.exception
  (#any-of? @keyword.exception
    "error" "undefined" "try" "tryJust" "tryAny" "catch" "catches" "catchJust" "handle" "handleJust"
    "throw" "throwIO" "throwTo" "throwError" "ioError" "mask" "mask_" "uninterruptibleMask"
    "uninterruptibleMask_" "bracket" "bracket_" "bracketOnErrorSource" "finally" "fail"
    "onException" "expectationFailure"))

; ----------------------------------------------------------------------------
; Debugging
((variable) @keyword.debug
  (#any-of? @keyword.debug
    "trace" "traceId" "traceShow" "traceShowId" "traceWith" "traceShowWith" "traceStack" "traceIO"
    "traceM" "traceShowM" "traceEvent" "traceEventWith" "traceEventIO" "flushEventLog" "traceMarker"
    "traceMarkerIO"))

; ----------------------------------------------------------------------------
; Fields
(field
  (variable) @variable.member)

(pat_field
  (variable) @variable.member)

(exp_projection
  field: (variable) @variable.member)

(import_item
  (type)
  .
  (import_con_names
    (variable) @variable.member))

(exp_field
  field: [
    (variable) @variable.member
    (qualified_variable
      (variable) @variable.member)
  ])

; ----------------------------------------------------------------------------
; Spell checking
(comment) @spell
]==],
    ["injections.scm"] = [==[
; -----------------------------------------------------------------------------
; General language injection
(quasiquote
  (quoter) @injection.language
  (quasiquote_body) @injection.content)

((comment) @injection.content
  (#set! injection.language "comment"))

; -----------------------------------------------------------------------------
; shakespeare library
; NOTE: doesn't support templating
; TODO: add once CoffeeScript parser is added
; ; CoffeeScript: Text.Coffee
; (quasiquote
;  (quoter) @_name
;  (#eq? @_name "coffee")
;  ((quasiquote_body) @injection.content
;   (#set! injection.language "coffeescript")))
; CSS: Text.Cassius, Text.Lucius
(quasiquote
  (quoter) @_name
  (#any-of? @_name "cassius" "lucius")
  (quasiquote_body) @injection.content
  (#set! injection.language "css"))

; HTML: Text.Hamlet
(quasiquote
  (quoter) @_name
  (#any-of? @_name "shamlet" "xshamlet" "hamlet" "xhamlet" "ihamlet")
  (quasiquote_body) @injection.content
  (#set! injection.language "html"))

; JS: Text.Julius
(quasiquote
  (quoter) @_name
  (#any-of? @_name "js" "julius")
  (quasiquote_body) @injection.content
  (#set! injection.language "javascript"))

; TS: Text.TypeScript
(quasiquote
  (quoter) @_name
  (#any-of? @_name "tsc" "tscJSX")
  (quasiquote_body) @injection.content
  (#set! injection.language "typescript"))

; -----------------------------------------------------------------------------
; HSX
(quasiquote
  (quoter) @_name
  (#eq? @_name "hsx")
  (quasiquote_body) @injection.content
  (#set! injection.language "html"))

; -----------------------------------------------------------------------------
; Inline JSON from aeson
(quasiquote
  (quoter) @_name
  (#eq? @_name "aesonQQ")
  (quasiquote_body) @injection.content
  (#set! injection.language "json"))

; -----------------------------------------------------------------------------
; SQL
; postgresql-simple
(quasiquote
  (quoter) @injection.language
  (#eq? @injection.language "sql")
  (quasiquote_body) @injection.content)

(quasiquote
  (quoter) @_name
  (#any-of? @_name "persistUpperCase" "persistLowerCase" "persistWith")
  (quasiquote_body) @injection.content
  (#set! injection.language "haskell_persistent"))
]==],
  },
  extra_files = {
    ["nvim-treesitter-LICENSE"] = [[
The tree-sitter queries that are bundled with this package
have been borrowed from nvim-treesitter.
See the following license:

                                 Apache License
                           Version 2.0, January 2004
                        http://www.apache.org/licenses/

   TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

   1. Definitions.

      "License" shall mean the terms and conditions for use, reproduction,
      and distribution as defined by Sections 1 through 9 of this document.

      "Licensor" shall mean the copyright owner or entity authorized by
      the copyright owner that is granting the License.

      "Legal Entity" shall mean the union of the acting entity and all
      other entities that control, are controlled by, or are under common
      control with that entity. For the purposes of this definition,
      "control" means (i) the power, direct or indirect, to cause the
      direction or management of such entity, whether by contract or
      otherwise, or (ii) ownership of fifty percent (50%) or more of the
      outstanding shares, or (iii) beneficial ownership of such entity.

      "You" (or "Your") shall mean an individual or Legal Entity
      exercising permissions granted by this License.

      "Source" form shall mean the preferred form for making modifications,
      including but not limited to software source code, documentation
      source, and configuration files.

      "Object" form shall mean any form resulting from mechanical
      transformation or translation of a Source form, including but
      not limited to compiled object code, generated documentation,
      and conversions to other media types.

      "Work" shall mean the work of authorship, whether in Source or
      Object form, made available under the License, as indicated by a
      copyright notice that is included in or attached to the work
      (an example is provided in the Appendix below).

      "Derivative Works" shall mean any work, whether in Source or Object
      form, that is based on (or derived from) the Work and for which the
      editorial revisions, annotations, elaborations, or other modifications
      represent, as a whole, an original work of authorship. For the purposes
      of this License, Derivative Works shall not include works that remain
      separable from, or merely link (or bind by name) to the interfaces of,
      the Work and Derivative Works thereof.

      "Contribution" shall mean any work of authorship, including
      the original version of the Work and any modifications or additions
      to that Work or Derivative Works thereof, that is intentionally
      submitted to Licensor for inclusion in the Work by the copyright owner
      or by an individual or Legal Entity authorized to submit on behalf of
      the copyright owner. For the purposes of this definition, "submitted"
      means any form of electronic, verbal, or written communication sent
      to the Licensor or its representatives, including but not limited to
      communication on electronic mailing lists, source code control systems,
      and issue tracking systems that are managed by, or on behalf of, the
      Licensor for the purpose of discussing and improving the Work, but
      excluding communication that is conspicuously marked or otherwise
      designated in writing by the copyright owner as "Not a Contribution."

      "Contributor" shall mean Licensor and any individual or Legal Entity
      on behalf of whom a Contribution has been received by Licensor and
      subsequently incorporated within the Work.

   2. Grant of Copyright License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      copyright license to reproduce, prepare Derivative Works of,
      publicly display, publicly perform, sublicense, and distribute the
      Work and such Derivative Works in Source or Object form.

   3. Grant of Patent License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      (except as stated in this section) patent license to make, have made,
      use, offer to sell, sell, import, and otherwise transfer the Work,
      where such license applies only to those patent claims licensable
      by such Contributor that are necessarily infringed by their
      Contribution(s) alone or by combination of their Contribution(s)
      with the Work to which such Contribution(s) was submitted. If You
      institute patent litigation against any entity (including a
      cross-claim or counterclaim in a lawsuit) alleging that the Work
      or a Contribution incorporated within the Work constitutes direct
      or contributory patent infringement, then any patent licenses
      granted to You under this License for that Work shall terminate
      as of the date such litigation is filed.

   4. Redistribution. You may reproduce and distribute copies of the
      Work or Derivative Works thereof in any medium, with or without
      modifications, and in Source or Object form, provided that You
      meet the following conditions:

      (a) You must give any other recipients of the Work or
          Derivative Works a copy of this License; and

      (b) You must cause any modified files to carry prominent notices
          stating that You changed the files; and

      (c) You must retain, in the Source form of any Derivative Works
          that You distribute, all copyright, patent, trademark, and
          attribution notices from the Source form of the Work,
          excluding those notices that do not pertain to any part of
          the Derivative Works; and

      (d) If the Work includes a "NOTICE" text file as part of its
          distribution, then any Derivative Works that You distribute must
          include a readable copy of the attribution notices contained
          within such NOTICE file, excluding those notices that do not
          pertain to any part of the Derivative Works, in at least one
          of the following places: within a NOTICE text file distributed
          as part of the Derivative Works; within the Source form or
          documentation, if provided along with the Derivative Works; or,
          within a display generated by the Derivative Works, if and
          wherever such third-party notices normally appear. The contents
          of the NOTICE file are for informational purposes only and
          do not modify the License. You may add Your own attribution
          notices within Derivative Works that You distribute, alongside
          or as an addendum to the NOTICE text from the Work, provided
          that such additional attribution notices cannot be construed
          as modifying the License.

      You may add Your own copyright statement to Your modifications and
      may provide additional or different license terms and conditions
      for use, reproduction, or distribution of Your modifications, or
      for any such Derivative Works as a whole, provided Your use,
      reproduction, and distribution of the Work otherwise complies with
      the conditions stated in this License.

   5. Submission of Contributions. Unless You explicitly state otherwise,
      any Contribution intentionally submitted for inclusion in the Work
      by You to the Licensor shall be under the terms and conditions of
      this License, without any additional terms or conditions.
      Notwithstanding the above, nothing herein shall supersede or modify
      the terms of any separate license agreement you may have executed
      with Licensor regarding such Contributions.

   6. Trademarks. This License does not grant permission to use the trade
      names, trademarks, service marks, or product names of the Licensor,
      except as required for reasonable and customary use in describing the
      origin of the Work and reproducing the content of the NOTICE file.

   7. Disclaimer of Warranty. Unless required by applicable law or
      agreed to in writing, Licensor provides the Work (and each
      Contributor provides its Contributions) on an "AS IS" BASIS,
      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
      implied, including, without limitation, any warranties or conditions
      of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
      PARTICULAR PURPOSE. You are solely responsible for determining the
      appropriateness of using or redistributing the Work and assume any
      risks associated with Your exercise of permissions under this License.

   8. Limitation of Liability. In no event and under no legal theory,
      whether in tort (including negligence), contract, or otherwise,
      unless required by applicable law (such as deliberate and grossly
      negligent acts) or agreed to in writing, shall any Contributor be
      liable to You for damages, including any direct, indirect, special,
      incidental, or consequential damages of any character arising as a
      result of this License or out of the use or inability to use the
      Work (including but not limited to damages for loss of goodwill,
      work stoppage, computer failure or malfunction, or any and all
      other commercial damages or losses), even if such Contributor
      has been advised of the possibility of such damages.

   9. Accepting Warranty or Additional Liability. While redistributing
      the Work or Derivative Works thereof, You may choose to offer,
      and charge a fee for, acceptance of support, warranty, indemnity,
      or other liability obligations and/or rights consistent with this
      License. However, in accepting such obligations, You may act only
      on Your own behalf and on Your sole responsibility, not on behalf
      of any other Contributor, and only if You agree to indemnify,
      defend, and hold each Contributor harmless for any liability
      incurred by, or claims asserted against, such Contributor by reason
      of your accepting any such warranty or additional liability.

   END OF TERMS AND CONDITIONS

   APPENDIX: How to apply the Apache License to your work.

      To apply the Apache License to your work, attach the following
      boilerplate notice, with the fields enclosed by brackets "[]"
      replaced with your own identifying information. (Don't include
      the brackets!)  The text should be enclosed in the appropriate
      comment syntax for the file format. We also recommend that a
      file or class name and description of purpose be included on the
      same "printed page" as the copyright notice for easier
      identification within third-party archives.

   Copyright [yyyy] [name of copyright owner]

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
]],
  },
}
