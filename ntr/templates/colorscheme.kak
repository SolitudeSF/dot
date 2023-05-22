# Kakoune default color scheme

# For Code
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

# For markup
face global title blue
face global header cyan
face global mono green
face global block magenta
face global link cyan
face global bullet cyan
face global list yellow

# builtin faces
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
