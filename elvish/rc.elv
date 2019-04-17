use epm
use util
use config
use module


fn alias [@a]{ put [@b]{ (external $a[0]) (explode $a[1:]) $@b } }

fn xqt [a]{ e $E:XBPS_DISTDIR/srcpkgs/$a/template }

fn r [@a]{
  f = (mktemp)
  if ?(ranger --choosedir=$f $@a) { cd (e:cat $f) }
  rm -f $f
}

ls~ = (alias exa --group-directories-first -s Name)
cat~ = (alias bat)
xr~ = (alias sudo xbps-remove -R)

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
