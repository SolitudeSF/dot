set-env GPG_TTY (tty)
set-env CCACHE_DIR $E:XDG_CACHE_HOME/ccache
set-env NUGET_PACKAGES $E:XDG_CACHE_HOME/NuGetPackages

use epm
use os
use doc
use str
use path
use file

use util
use config
use television

var mise: = (util:eval-namespace (mise activate elvish | slurp))

fn xqt {|a| e $E:XBPS_DISTDIR/srcpkgs/$a/template }

fn d {|@a|
  var f = (os:temp-file "yazi-*")
  if ?(yazi --cwd-file=$f[name] $@a) { cd (slurp <$f) }
  file:close $f
  os:remove $f[name]
}

fn edit-current-command {
  var temp-file = (os:temp-file "*.elv")
  print $edit:current-command >$temp-file
  try {
    e $temp-file[name] <$path:dev-tty >$path:dev-tty 2>&1
    set edit:current-command = (slurp <$temp-file | str:trim-right (one) "\n")
  } finally {
    file:close $temp-file
    os:remove $temp-file[name]
  }
}

fn stratify {|strata| exec strat $strata elvish }
fn newdir {|name| os:mkdir-all $name; put $name }
fn prev { kitty @ get-text --extent=last_non_empty_output }

fn .. { cd .. }
fn alias {|cmd @a| put {|@b| (external $cmd) $@a $@b } }

var ls~ = (alias lc)
var cat~ = (alias bat --paging=never)
var xr~ = (alias sudo xbps-remove -R)
var o~ = (alias gio open)
var g~ = (alias kitten hyperlinked_grep)
var f~ = (alias f --hyperlink=auto)

set edit:insert:binding[Ctrl-X] = { edit:-instant:start }
set edit:insert:binding[Ctrl-N] = { edit:navigation:start; edit:navigation:trigger-filter }
set edit:insert:binding[Ctrl-T] = { television:smart-autocomplete }
set edit:insert:binding[Alt-r] = { television:shell-history }
set edit:insert:binding[Alt-e] = { edit-current-command }

set edit:abbr = [
  &'.etc'='~/.local/etc/'
]

set before-chdir = (conj $before-chdir {|_|
  set edit:location:pinned = [$pwd (take 4 [(each {|dir|
    if (not (eq $pwd $dir)) { put $dir }
  } $edit:location:pinned )] )]
})

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
  util:add-after-command {|_|
    semp:output-end
  }
}

eval (navi widget elvish | slurp)
mise:activate
-override-wcwidth 🦀 2
