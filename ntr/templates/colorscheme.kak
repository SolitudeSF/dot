declare-option str slate "rgb:637777"
declare-option str peach "rgb:f78c6c"
declare-option str gold "rgb:ecc48d"
declare-option str pink "rgb:c792ea"
declare-option str paleblue "rgb:7fdbca"
declare-option str grey2 "rgb:222222"
declare-option str grey4 "rgb:444444"
declare-option str grey7 "rgb:777777"
declare-option str greyE "rgb:eeeeee"

# builtin
face global Default default,default
face global PrimarySelection default,rgba:<{strip:<{darken:<{color4}>:0.2}>:#}>80+g
face global SecondarySelection default,rgba:<{strip:<{darken:<{color4}>:0.3}>:#}>80+g
face global PrimaryCursor black,white+fg
face global SecondaryCursor black,rgb:<{strip:<{darken:<{color7}>:0.2}>:#}>+fg
face global PrimaryCursorEol black,cyan+fg
face global SecondaryCursorEol black,cyan+fg
face global LineNumbers default,default
face global LineNumberCursor default,default+r
face global MenuForeground yellow,blue
face global MenuBackground white,black
face global MenuInfo cyan
face global Information yellow,default
face global Error black,red
face global DiagnosticError red
face global DiagnosticWarning yellow
face global StatusLine cyan,default
face global StatusLineMode yellow,default
face global StatusLineInfo blue,default
face global StatusLineValue green,default
face global StatusCursor black,cyan
face global Prompt yellow,default
face global MatchingChar default,default+b
face global Whitespace default,default+fd
face global BufferPadding blue,default

# code
face global value red
face global type yellow
face global variable green
face global module green
face global function cyan
face global string magenta
face global keyword blue
face global operator yellow
face global attribute green
face global comment cyan
face global documentation comment
face global meta magenta
face global builtin default+b

# markup
face global title blue
face global header cyan
face global mono green
face global block magenta
face global link cyan
face global bullet cyan
face global list yellow

# lsp
face global InfoMono              "%opt{gold}"
face global InfoBlock             "green"
face global InfoLink              "magenta+u"
face global InfoBullet            "magenta"
face global InfoDiagnosticError   "red"
face global InfoDiagnosticWarning "%opt{peach}"
face global InfoDiagnosticHint    "%opt{paleblue}"
face global InfoDiagnosticInfo    "blue"

# inlay hints

face global InlayDiagnosticError   "red+i"
face global InlayDiagnosticWarning "%opt{peach}+i"
face global InlayDiagnosticHint    "%opt{paleblue}+i"
face global InlayDiagnosticInfo    "blue+i"

# tree-sitter
face global ts_attribute                 "%opt{paleblue}"
face global ts_comment                   "%opt{slate}+i"
face global ts_conceal                   "magenta+i"
face global ts_constant                  "%opt{paleblue}"
face global ts_constant_character_escape "%opt{peach}"
face global ts_constant                  "blue"
face global ts_diff_plus                 "green"
face global ts_diff_minus                "red"
face global ts_diff_delta                "blue"
face global ts_diff_delta_moved          "blue+i"
face global ts_error                     "red+b"
face global ts_function                  "blue+i"
face global ts_function_macro            "%opt{peach}"
face global ts_function_special          "magenta"
face global ts_info                      "blue+b"
face global ts_hint                      "%opt{paleblue}+b"
face global ts_keyword                   "magenta"
face global ts_keyword_control_import    "green+i"
face global ts_keyword_control_return    "magenta+i"
face global ts_keyword_control_exception "red"
face global ts_label                     "default"
face global ts_markup_heading            "blue+b"
face global ts_markup_heading_marker     "%opt{grey4}+d"
face global ts_markup_heading_1          "blue+b"
face global ts_markup_heading_2          "%opt{paleblue}+b"
face global ts_markup_heading_3          "green+b"
face global ts_markup_heading_4          "magenta+b"
face global ts_markup_heading_5          "%opt{peach}+b"
face global ts_markup_heading_6          "%opt{slate}+b"
face global ts_markup_list               "magenta"
face global ts_markup_bold               "default+b"
face global ts_markup_italic             "default+i"
face global ts_markup_strikethrough      "default+s"
face global ts_markup_link               "magenta+u"
face global ts_markup_link_url           "%opt{slate}+u"
face global ts_markup_quote              "green+i"
face global ts_markup_raw                "%opt{gold}"
face global ts_namespace                 "%opt{peach}"
face global ts_operator                  "magenta"
face global ts_property                  "magenta"
face global ts_punctuation               "default"
face global ts_punctuation_special       "magenta"
face global ts_special                   "%opt{greyE}"
face global ts_spell                     "blue"
face global ts_string                    "%opt{gold}"
face global ts_string_regexp             "green"
face global ts_string_special_path       "%opt{gold}+u"
face global ts_text                      "default"
face global ts_type                      "green"
face global ts_variable                  "green"
face global ts_variable_parameter        "green+i"
face global ts_variable_builtin          "green+b"
face global ts_warning                   "%opt{peach}+b"
