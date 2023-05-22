# Stolen from mawww/eraserhd
declare-option -hidden regex curword
declare-option -hidden str curword_type 'normal'
declare-option -hidden regex curword_word_class
set-face global CurrentWord +b
add-highlighter global/ dynregex '%opt{curword}' 0:CurrentWord

define-command -override -hidden highlight-curword-normal %{
    evaluate-commands -draft %{
        try %{
            execute-keys ,<a-i>w
            set-option buffer curword "(?<!%opt{curword_word_class})\Q%val{selection}\E(?!%opt{curword_word_class})"
        } catch %{
            set-option buffer curword ''
        }
    }
}
define-command -override -hidden highlight-curword-lsp %{
    set-option buffer curword ''
    lsp-highlight-references
}
define-command -override -hidden highlight-curword %{
    "highlight-curword-%opt{curword_type}"
}
define-command -override -hidden make-curword-word-class %{
    evaluate-commands %sh{
        eval set -- "$kak_quoted_opt_extra_word_chars"
        word_class='['
        while [ $# -ne 0 ]; do
            case "$1" in
                -) word_class="$word_class-";;
            esac
            shift
        done
        word_class="$word_class"'\w'
        eval set -- "$kak_quoted_opt_extra_word_chars"
        while [ $# -ne 0 ]; do
            case "$1" in
                "-") ;;
                "]") word_class="$word_class"'\]';;
                "'") word_class="$word_class''";;
                *)   word_class="$word_class$1";;
            esac
            shift
        done
        word_class="$word_class]"
        printf "set-option window curword_word_class '%s'\\n" "$word_class"
    }
}
hook -group highlight-curword global NormalIdle .* highlight-curword
hook -group highlight-curword global WinSetOption extra_word_chars=.* make-curword-word-class
