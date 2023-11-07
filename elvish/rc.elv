set-env GPG_TTY (tty)
set-env CCACHE_DIR $E:XDG_CACHE_HOME/ccache

use epm
use os
use doc
use str
use path

use util
use config
use atuin

var rtx: = (util:eval-namespace (rtx activate elvish | slurp))

fn xqt {|a| e $E:XBPS_DISTDIR/srcpkgs/$a/template }

fn r {|@a|
  var f = (mktemp)
  if ?(ranger --choosedir=$f $@a) { cd (e:cat $f) }
  rm -f $f
}

fn d {|@a|
  var f = (mktemp)
  if ?(yazi --cwd-file=$f $@a) { cd (e:cat $f) }
  rm -f $f
}

fn edit-current-command {
  var temp-file = "/tmp/elvish-edit-command-"$pid".elv"
  print $edit:current-command > $temp-file
  e $temp-file <$path:dev-tty >$path:dev-tty 2>&1
  set edit:current-command = (slurp <$temp-file | str:trim-right (one) "\n")
}

fn newdir {|name| mkdir -p $name; put $name }

fn alias {|cmd @a| put {|@b| (external $cmd) $@a $@b } }

var ls~ = (alias lc)
var cat~ = (alias bat --paging=never)
var xr~ = (alias sudo xbps-remove -R)
var o~ = (alias gio open)
var g~ = (alias kitten hyperlinked_grep)
var f~ = (alias f --hyperlink=auto)

set edit:insert:binding[Ctrl-X] = { edit:-instant:start }
set edit:insert:binding[Ctrl-N] = { edit:navigation:start; edit:navigation:trigger-filter }
set edit:insert:binding[Alt-E] = { edit-current-command }
set edit:insert:binding[Alt-q] = {
  var oldlen = (count $edit:current-command)
  var olddot = $edit:-dot
  set edit:current-command = "pueue add -- "$edit:current-command
  set edit:-dot = (+ $olddot (- (count $edit:current-command) $oldlen))
}
set edit:insert:binding[Alt-r] = { edit:replace-input (atuin:search $edit:current-command) }

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

eval (navi widget elvish | slurp)
rtx:activate
atuin:activate
-override-wcwidth 🦀 2
