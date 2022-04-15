set-env ASDF_DIR $E:XDG_DATA_HOME/asdf
set-env GPG_TTY (tty)

use epm
use str
use util
use path
use config
use asdf

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
var asdf~ = $asdf:asdf~

set edit:insert:binding[Ctrl-X] = { edit:-instant:start }
set edit:insert:binding[Alt-E] = { edit-current-command }

set edit:abbr = [
  &'.etc'='~/.local/etc/'
]

{
  use theme
  use completers
  use smart-matcher
  use semantic-prompt semp
  util:add-before-readline {
    util:set-title (tilde-abbr $pwd)
  }
  util:add-after-readline {|a|
    util:set-title (str:split ' ' $a | take 1)' '(tilde-abbr $pwd)
    semp:output-start
    if (eq $a '') { ls }
  }
  util:add-after-command {|a|
    semp:output-end
  }
}

-override-wcwidth 🦀 2
