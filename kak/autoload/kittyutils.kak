provide-module kittyutils %{

require-module kitty

define-command new-tab -params .. -command-completion -docstring '
new-tab [<commands>]: create a new kakoune client in new tab
The ''terminal-tab'' alias is being used to determine the user''s preferred terminal emulator
The optional arguments are passed as commands to the new client' %{
    try %{
        terminal-tab kak -c %val{session} -e "%arg{@}"
    } catch %{
        fail "The 'terminal-tab' alias must be defined to use this command"
    }
}

define-command kitty-terminal-overlay -params 1.. -shell-completion -docstring '
kitty-terminal <program> [<arguments>]: create a new terminal as a kitty overlay window
The program passed as argument will be executed in the new terminal' \
%{
    nop %sh{
        match=""
        if [ -n "$kak_client_env_KITTY_WINDOW_ID" ]; then
            match="--match=id:$kak_client_env_KITTY_WINDOW_ID"
        fi
        listen=""
        if [ -n "$kak_client_env_KITTY_LISTEN_ON" ]; then
            listen="--to=$kak_client_env_KITTY_LISTEN_ON"
        fi
        kitty @ $listen launch --no-response --type="overlay" --cwd="$PWD" $match "$@"
    }
}

}

require-module kittyutils
