declare-option -docstring "git branch holding the current buffer" str git_branch

hook global WinCreate .* %{
    hook window NormalIdle .* %{ evaluate-commands %sh{
        branch=$(cd "$(dirname "${kak_buffile}")" && git rev-parse --abbrev-ref HEAD 2>/dev/null)
        [ -n "${branch}" ] && printf 'set window git_branch %%{%s}' "${branch}"
    } }
}
