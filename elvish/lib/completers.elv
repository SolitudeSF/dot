use re
use util

use github.com/xiaq/edit.elv/compl/git
git:apply

fn overlap-at [a b]{
  for i [(range 1 (- (count $b) 1))] {
    if (has-value $a $b[$i]) { put $i; return }
  }
  put $false
}

fn prefix-completer [p a]{
  edit:completion:arg-completer[$p] = [@cmd]{
    if (eq (count $cmd) 2) {
      $a $@cmd
    } elif (has-key $edit:completion:arg-completer $cmd[1]) {
      $edit:completion:arg-completer[$cmd[1]] (explode $cmd[1:])
    } else {
      edit:complete-filename $cmd[-1]
    }
  }
}

fn complete-directory [a]{
  dir = (path-dir $a)/
  if (has-prefix $a $dir) {
    a = (replaces &max=1 $dir '' $a)
  } else {
    dir = ''
  }
  for x [(put $dir*[match-hidden][nomatch-ok]$a*[match-hidden][nomatch-ok])] {
    if (-is-dir $x) { edit:complex-candidate &code-suffix=/ &style='blue;bold' $x }
  }
}

edit:completion:arg-completer[cd] = [@cmd]{
  if (eq (count $cmd) 2) {
    complete-directory $cmd[1]
  }
}

edit:completion:arg-completer[kak] = [@cmd]{
  if (eq $cmd[-2] -c) {
    kak -l
  } else {
    edit:complete-filename $cmd[-1]
  }
}

edit:completion:arg-completer[waifu2x-converter-cpp] = [@cmd]{
  if (has-value [-i --input -o --output] $cmd[-2]) {
    edit:complete-filename $cmd[-1]
  } elif (has-value [-m --mode] $cmd[-2]) {
    put noise scale noise_scale
  } elif (eq $cmd[-2] --noise_level) {
    put 1 2 3
  } else {
    put --scale_ratio --noise_level --mode --jobs -i -o
  }
}

kitty-cmds = []
kitty-kittens = []

edit:completion:arg-completer[kitty] = [@cmd]{
  if (== (count $kitty-cmds) 0) {
    @kitty-cmds = (kitty @ --help | peach [x]{ if (re:match '^  \w' $x) { put $x[2:] } })
    @kitty-kittens = (pwd=/usr/lib/kitty/kittens fd main.py | peach [x]{ path-dir $x })
  }
  if (has-value [kitten '+kitten'] $cmd[-2]) {
    explode $kitty-kittens
  } elif (eq $cmd[-2] '@') {
    explode $kitty-cmds
  } else {
    edit:complete-filename $cmd[-1]
  }
}

edit:completion:arg-completer[sv] = [@cmd]{
  if (eq (count $cmd) 2) {
    put status up down once pause cont hup alarm interrupt quit kill term 1 2 \
      exit start try-restart check {force-,}{stop,reload,restart,shutdown}
  } else {
    pwd=/var/service put *
  }
}

edit:completion:arg-completer[man] = [@cmd]{
  pwd=/usr/share/man put man*/* | peach [a]{
    re:replace &literal=$true '\.\dp?$' '' (path-base $a)
  }
}

edit:completion:arg-completer[kill] = [@cmd]{
  ps -u (whoami) --no-headers -o pid,command |\
    eawk [_ p @c]{ edit:complex-candidate &display-suffix=(print ' '$@c) $p }
}

edit:completion:arg-completer[nimble] = [@cmd]{
  if (eq (count $cmd) 2) {
    put {un,}install develop check init publish build c cc js test doc{,2} \
      refresh search list tasks path dump
    if ?(isnimbleproject) {
      nimble tasks 2>/dev/null | eawk [_ a @_]{ put $a }
    }
  } elif (eq $cmd[-2] install) {
    for x (cat ~/.nimble/packages_official.json | from-json) { put $x[name] }
  } elif (eq $cmd[-2] uninstall) {
    pkgs = [&]
    nimble list -i | eawk [_ n @v]{
      @ver = $@v[:-1]
      ver[0] = $ver[0][1:]
      pkgs[$n] = $ver
    }
    if (has-suffix $cmd[-1] '@') {
      for v $pkgs[$cmd[-1][:-1]] {
        put $cmd[-1]$v
      }
    } else { keys $pkgs }
  }
}

pijul-cmds = [add apply branches checkout clone credit delete-branch diff dist\
            generate-completions help init key log ls mv patch pull push\
            record remove revert rollback show-dependencies sign status tag unrecord]

edit:completion:arg-completer[pijul] = [@cmd]{
  if (eq (count $cmd) 2) {
    explode $pijul-cmds
  }
}

neofetch-img = [ascii caca iterm2 jp2a kitty pixterm sixel termpix tycat w3m off]
neofetch-opts = []

edit:completion:arg-completer[neofetch] = [@cmd]{
  if (== (count $neofetch-opts) 0) {
    neofetch-opts = [(_ = ?(neofetch --help | each [x]{
      if (has-prefix $x '    --') {
        put $x | eawk [_ a @_]{ put $a }
      }
    })) --logo -L -v -vv]
  }
  explode $neofetch-opts
}

edit:completion:arg-completer[bspc] = [@cmd]{
  if (eq (count $cmd) 2) {
    put node desktop monitor query wm rule config subscribe quit
  } elif (eq $cmd[1] subscribe) {
    put all report monitor desktop node pointer
  } elif (eq $cmd[1] rule) {
    put --add --remove --list
  } elif (eq $cmd[1] wm) {
    put --dump-state --load-state --add-monitor --adopt-orphans --record-history --get-status
  } elif (eq $cmd[1] query) {
    put --nodes --desktops --monitors --tree
  }
}

edit:completion:arg-completer[ntr] = [@cmd]{
  if (not (has-prefix $cmd[-1] '-')) {
    pwd=$E:XDG_CONFIG_HOME/ntr/contexts put **
  }
}

edit:completion:arg-completer[update] = [@cmd]{
  update | each [x]{ if (has-prefix $x "\t") { put $x[1:] } }
}

edit:completion:arg-completer[xr] = [@cmd]{
  xpkg -m
  xpkg -O | peach [x]{ edit:complex-candidate &style='red;inverse' $x }
}

edit:completion:arg-completer[xi] = [@cmd]{
  pwd=$E:XBPS_DISTDIR/srcpkgs put *
}

xbps-src-cmds = []
xbps-src-arch = []

edit:completion:arg-completer[xbps-src] = [@cmd]{
  if (== (count $xbps-src-cmds) 0) {
    @xbps-src-cmds = (xbps-src -h | take 122 | drop 4 | each [x]{ put (re:find &max=1 '^\w+(\-\w+)*' $x)[text] })
    @xbps-src-arch = (xbps-src -h | take 155 | drop 129)[1:]
  }
  if (eq $cmd[-2] '-a') {
    explode $xbps-src-arch
  } else {
    if (not (overlap-at $xbps-src-cmds $cmd)) {
      explode $xbps-src-cmds
    } else {
      pwd=$E:XBPS_DISTDIR/srcpkgs put *
    }
  }
}

edit:completion:arg-completer[strat] = [@cmd]{
  @strata = (brl list)
  has-strat = (overlap-at $strata $cmd)
  if (not $has-strat) {
    explode $strata
  } else {
    # edit:complete-sudo (explode $cmd[(+ $has-strat 1):])
  }
}

brl-cmds = []

edit:completion:arg-completer[brl] = [@cmd]{
  if (== (count $brl-cmds) 0) {
    @brl-cmds = (brl -h | take 35 | drop 5 | each [x]{ put (re:find &max=1 '^  \w+' $x)[text][2:] })
  }
  len = (count $cmd)
  if (== $len 2) {
    explode $brl-cmds
  } else {
    c = $cmd[1]
    if (has-value [status enable disable hide show] $c) {
      brl list
    } elif (eq $c fetch) {
      brl fetch -L
    }
  }
}

edit:completion:arg-completer[promotescript] = [@cmd]{
  pwd=~/.local/bin fd -t f
}

edit:completion:arg-completer[edit-script] = $edit:complete-sudo~
edit:completion:arg-completer[whereis] = $edit:complete-sudo~
edit:completion:arg-completer[which] = $edit:complete-sudo~

edit:completion:arg-completer[xq] = $edit:completion:arg-completer[xi]
edit:completion:arg-completer[xqt] = $edit:completion:arg-completer[xi]
edit:completion:arg-completer[xbps-install] = $edit:completion:arg-completer[xi]

prefixes = [
  &sudo=$edit:complete-sudo~
  &strace=$edit:complete-sudo~
  &time=$edit:complete-sudo~
  &torify=$edit:complete-sudo~
]

for k [(keys $prefixes)] { prefix-completer $k $prefixes[$k] }
