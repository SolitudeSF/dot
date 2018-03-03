use epm
use util
use config
use module

fn ls [@a]{ e:exa --group-directories-first -s Name $@a }
fn xqt [a]{ e $E:XBPS_DISTDIR/srcpkgs/$a/template }
fn xr [@a]{ sudo xbps-remove -R $@a }

-exports- = [&]


{
  use theme
  use completers
  use github.com/xiaq/edit.elv/smart-matcher
  use stack
  -exports- = (module:exported $stack:)
  smart-matcher:apply
  util:add-before-readline {
    util:set-title (tilde-abbr $pwd) >/dev/tty
  }
  util:add-after-readline [a]{
    if (eq $a '') { print "\r" >/dev/tty; ls >/dev/tty }
    util:set-title (splits ' ' $a | take 1)' '(tilde-abbr $pwd) >/dev/tty
  }
}

set-env GPG_TTY (tty)
