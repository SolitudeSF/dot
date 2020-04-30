use epm
use str
use util
use config

fn xqt [a]{ e $E:XBPS_DISTDIR/srcpkgs/$a/template }

fn r [@a]{
  f = (mktemp)
  if ?(ranger --choosedir=$f $@a) { cd (e:cat $f) }
  rm -f $f
}

fn alias [cmd @a]{ put [@b]{ (external $cmd) $@a $@b } }

ls~ = (alias lc)
cat~ = (alias bat --paging=never)
xr~ = (alias sudo xbps-remove -R)
o~ = (alias gio open)

edit:insert:binding[Ctrl-X] = { edit:-instant:start }

edit:abbr = [
  &'.etc'='.local/etc/'
]

{
  use github.com/xiaq/edit.elv/smart-matcher
  use theme
  use completers
  use autopairs
  smart-matcher:apply
  autopairs:enable
  util:add-before-readline {
    util:set-title (tilde-abbr $pwd)
  }
  util:add-after-readline [a]{
    if (eq $a '') { ls }
    util:set-title (str:split ' ' $a | take 1)' '(tilde-abbr $pwd)
  }
}

-override-wcwidth 🦀 2
E:GPG_TTY = (tty)
E:NIMPH_TOKEN = (cat ~/sns/github.key)
