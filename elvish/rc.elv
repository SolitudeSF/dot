use epm
use str
use util
use path
use config

fn xqt {|a| e $E:XBPS_DISTDIR/srcpkgs/$a/template }

fn r {|@a|
  var f = (mktemp)
  if ?(ranger --choosedir=$f $@a) { cd (e:cat $f) }
  rm -f $f
}

fn edit-current-command {
  print $edit:current-command > /tmp/elvish-edit-command-$pid.elv
  e /tmp/elvish-edit-command-$pid.elv </dev/tty >/dev/tty 2>&1
  set edit:current-command = (slurp </tmp/elvish-edit-command-$pid.elv)[0..-1]
}

fn alias {|cmd @a| put {|@b| (external $cmd) $@a $@b } }

var ls~ = (alias lc)
var cat~ = (alias bat --paging=never)
var xr~ = (alias sudo xbps-remove -R)
var o~ = (alias gio open)
var g~ = (alias kitty +kitten hyperlinked_grep)

set edit:insert:binding[Ctrl-X] = { edit:-instant:start }
set edit:insert:binding[Alt-E] = { edit-current-command }

set edit:abbr = [
  &'.etc'='~/.local/etc/'
]

{
  use theme
  use completers
  util:add-before-readline {
    util:set-title (tilde-abbr $pwd)
  }
  util:add-after-readline {|a|
    if (eq $a '') { ls }
    util:set-title (str:split ' ' $a | take 1)' '(tilde-abbr $pwd)
  }
}

-override-wcwidth 🦀 2
set-env GPG_TTY (tty)
