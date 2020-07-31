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

}

require-module kittyutils
