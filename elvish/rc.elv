use epm
use util
use config

fn xqt [a]{ e $E:XBPS_DISTDIR/srcpkgs/$a/template }

fn r [@a]{
  f = (mktemp)
  if ?(ranger --choosedir=$f $@a) { cd (e:cat $f) }
  rm -f $f
}

fn alias [cmd @a]{ put [@b]{ (external $cmd) (explode $a) $@b } }

ls~ = (alias lc)
cat~ = (alias bat --paging=never)
xr~ = (alias sudo xbps-remove -R)
o~ = (alias gio open)

-exports- = [&]

edit:insert:binding[Ctrl-X] = { edit:-instant:start }

{
  use github.com/xiaq/edit.elv/smart-matcher
  use theme
  use completers
  use stack
  use module
  -exports- = (module:exported $stack:)
  smart-matcher:apply
  util:add-before-readline {
    util:set-title (tilde-abbr $pwd) >/dev/tty
  }
  util:add-after-readline [a]{
    if (eq $a '') { ls } >/dev/tty
    util:set-title (splits ' ' $a | take 1)' '(tilde-abbr $pwd) >/dev/tty
  }
}

-override-wcwidth 🦀 2
set-env GPG_TTY (tty)
set-env NIMPH_TOKEN (cat ~/sns/github.key)
