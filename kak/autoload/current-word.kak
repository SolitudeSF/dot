# Stolen from eraserhd

declare-option -hidden regex curword
declare-option -hidden regex curword_word_class

set-face global CurWord +b

add-highlighter global/current-word dynregex '%opt{curword}' 0:CurWord

define-command -override -hidden highlight-curword %{
    eval -draft %{
        try %{
            execute-keys <space><a-i>w
            set-option buffer curword "(?<!%opt{curword_word_class})\Q%val{selection}\E(?!%opt{curword_word_class})"
        } catch %{
            set-option buffer curword ''
        }
    }
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
