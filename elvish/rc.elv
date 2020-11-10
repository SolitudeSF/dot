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

fn edit-current-command {
  print $edit:current-command > /tmp/elvish-edit-command-$pid.elv
  e /tmp/elvish-edit-command-$pid.elv </dev/tty >/dev/tty 2>&1
  edit:current-command = (slurp </tmp/elvish-edit-command-$pid.elv)[0..-1]
}

fn alias [cmd @a]{ put [@b]{ (external $cmd) $@a $@b } }

ls~ = (alias lc)
cat~ = (alias bat --paging=never)
xr~ = (alias sudo xbps-remove -R)
o~ = (alias gio open)
g~ = (alias kitty +kitten hyperlinked_grep)

edit:insert:binding[Ctrl-X] = { edit:-instant:start }
edit:insert:binding[Alt-E] = { edit-current-command }

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
