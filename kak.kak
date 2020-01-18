# External plugins

eval %sh{
    kak-lsp --kakoune -s $kak_session
    colorcol
}

# Initialization

decl -hidden regex curword

set global ui_options ncurses_assistant=none
set global scrolloff 7,7
set global autoreload yes
set global grepcmd 'rg -iHL --column'
set global modelinefmt '%opt{modeline_git_branch} %val{bufname}
%val{cursor_line}:%val{cursor_char_column} {{mode_info}}
{{context_info}}◂%val{client}⊙%val{session}▸'

alias global sw sudo-write
alias global cdb change-directory-current-buffer
alias global f find
alias global s sort-selections

face global LineNumbersWrapped black

addhl global/number-lines number-lines -hlcursor -separator ' '
addhl global/ruler column 80 default,rgb:303030
addhl global/trailing-whitespace regex '\h+$' 0:default,red
addhl global/todo regex \b(TODO|FIXME|XXX|NOTE)\b 0:default+rb
addhl global/matching-brackets show-matching
addhl global/wrap wrap -word -indent -marker ''
addhl global/current-word dynregex '%opt{curword}' 0:+b

# Keybinds

map global normal <space> ,
map global normal -docstring 'remove all sels except main' <backspace> <space>
map global normal -docstring 'remove main sel' <a-backspace> <a-space>
map global normal -docstring 'comment line' '#' ': comment-line<ret>'
map global normal -docstring 'comment block' '<a-#>' ': comment-block<ret>'
map global normal -docstring 'delete to end of line' D <a-l>d
map global normal -docstring 'yank to end of line' Y <a-l>
map global user -docstring 'replay macro' . q
map global user -docstring 'record macro' <a-.> Q

map global normal w ': word-select-next-word<ret>'
map global normal <a-w> ': word-select-next-big-word<ret>'
map global normal q ': word-select-previous-word<ret>'
map global normal <a-q> ': word-select-previous-big-word<ret>'
map global normal Q B
map global normal <a-Q> <a-B>

map global user -docstring 'add phantom selection' <a-f> ': phantom-selection-add-selection<ret>'
map global user -docstring 'clear all phantom selections' <a-F> ': phantom-selection-select-all<ret>: phantom-selection-clear<ret>'
map global user -docstring 'next phantom selection' f ': phantom-selection-iterate-next<ret>'
map global user -docstring 'previous phantom selection' F ': phantom-selection-iterate-prev<ret>'

map global normal -docstring 'select view' <a-%> ': select-view<ret>'
map global view   -docstring 'select view' s '<esc>: select-view<ret>'

map global user -docstring 'add mark' m ': mark-word<ret>'
map global user -docstring 'clear marks' M ': mark-clear<ret>'

map global user -docstring 'replace mode' r ': replace<ret>'

map global user -docstring 'expand selection' e ': expand<ret>'
map global user -docstring 'expand repeat' E ': expand-repeat<ret>'

map global normal -docstring 'buffers…' b ': enter-buffers-mode<ret>'
map global normal -docstring 'buffers (lock)…' B ': enter-user-mode -lock buffers<ret>'

map global user -docstring "next error" l ': lint-next-error<ret>'
map global user -docstring "previous error" L ': lint-previous-error<ret>'

declare-user-mode anchor
map global normal ';' ': enter-user-mode anchor<ret>'
map global anchor -docstring 'ensure anchor after cursor' h '<a-:><a-;>'
map global anchor -docstring 'ensure cursor after anchor' l '<a-:>'
map global anchor -docstring 'flip cursor and anchor' f '<a-;>'
map global anchor -docstring 'reduce to anchor' a '<a-;>;'
map global anchor -docstring 'reduce to cursor' c ';'
map global anchor -docstring 'select cursor and anchor' s '<a-S>'

declare-user-mode clipboard
map global normal ',' ': enter-user-mode clipboard<ret>'
map global clipboard -docstring 'clip-paste after' p '<a-!>xsel -b -o<ret>'
map global clipboard -docstring 'clip-paste before' P '!xsel -b -o<ret>'
map global clipboard -docstring 'clip-paste replace' R '|xsel -b -o<ret>'
map global clipboard -docstring 'clip-yank' y '<a-|>xclip -i -f -sel c<ret>'
map global clipboard -docstring 'clip-cut' d '<a-|>xclip -i -f -sel c<ret><a-d>'
map global clipboard -docstring 'clip-cut -> insert mode' c '<a-|>xclip -i -f -sel c<ret><a-c>'

# Functions

def type -params 1 -docstring 'Set buffer filetype' %{
    set buffer filetype %arg{1}
}

def lint-on-write -docstring 'Activate linting on buffer write' %{
    lint-enable
    hook buffer BufWritePost .* lint
}

def lsp-engage -docstring 'Enable language server' %{
    lsp-enable
    lsp-auto-hover-enable
    map global user -docstring 'Enter lsp user mode' <a-l> ': enter-user-mode lsp<ret>'
}

def no-tabs -params 1 -docstring 'Indent with spaces' %{
    expandtab
    set buffer indentwidth %arg{1}
    hook buffer InsertKey <space> %{ try %{
        exec -draft h<a-i><space><a-k>^\h+<ret>
        exec -with-hooks <tab>
    }}
}

def clean-trailing-whitespace -docstring 'Remove trailing whitespace' %{
    try %{ exec -draft '%s\h+$<ret>d' }
}

# Hooks

hook global WinCreate .* %{
    smarttab
    readline-enable
    colorcol-enable
    colorcol-auto-refresh
    discord-presence-enable
}

hook global KakBegin .* %{
    state-save-reg-sync colon
    state-save-reg-sync pipe
    state-save-reg-sync slash
}

hook global KakEnd .* %{
    state-save-reg-sync colon
    state-save-reg-sync pipe
    state-save-reg-sync slash
}

hook global WinDisplay .* info-buffers
hook global NormalIdle .* %{ try %{ exec -draft '<a-i>w: palette-status<ret>' } }

hook global BufCreate .* %{
    set buffer tabstop %opt{indentwidth}
}

hook global BufWritePre .* %{ nop %sh{
    mkdir -p "$(dirname "$kak_buffile")"
}}

hook global NormalIdle .* %{
    eval -draft %{ try %{
        exec <space><a-i>w <a-k>\A\w+\z<ret>
        set buffer curword "\b\Q%val{selection}\E\b"
    } catch %{
        set buffer curword ''
    }}
}

eval %sh{ git rev-parse --is-inside-work-tree 2>/dev/null 1>/dev/null && printf %s "
    hook global BufWritePost .* %{ git show-diff }
    hook global BufReload .* %{ git show-diff }
"}

hook global ModuleLoaded kitty %{
    set global kitty_window_type kitty
}

hook global ModuleLoaded smarttab %{
	hook global BufCreate .* %{
		set buffer softtabstop %opt{indentwidth}
	}
}

# Filetype detection

hook global BufCreate .*srcpkgs/.+/template$ %{
    set buffer filetype sh
    def xgensum %{ %sh{ xgensum -i "$kak_buffile" } }
}

hook global BufCreate .*/\.?((sx|xinit)(rc)?|profile) %{ set buffer filetype sh }
hook global BufCreate .*\.ino %{ set buffer filetype cpp }
hook global BufCreate .*\.cs %{ addhl buffer/java }
hook global BufCreate .*\.rasi %{ set buffer filetype css }

# Filetype settings

hook global WinSetOption filetype=sh %{
    set buffer lintcmd 'shellcheck --norc -x -f gcc'
    lint-on-write
}

hook global WinSetOption filetype=elvish %{
    no-tabs 2
}

hook global WinSetOption filetype=(go|rust|c|cpp) %{
    lsp-engage
}

hook global WinSetOption filetype=markdown %{
    set buffer formatcmd 'prettier --parser markdown'
    def -docstring 'render current buffer' render %{
        exec ": connect-terminal glow -s dark %val{buffile} | ${PAGER}<ret>"
    }
}

hook global WinSetOption filetype=python %{
    set global lsp_server_configuration pyls.plugins.jedi_completion.include_params=false
    lsp-engage
}

hook global WinSetOption filetype=nim %{
    set buffer gdb_program 'nim-gdb'
    set buffer formatcmd 'nimprettify'
    set buffer makecmd 'nimble build'
    no-tabs 2
    lsp-engage
}
