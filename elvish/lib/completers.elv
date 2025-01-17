use re
use str
use path
use util

fn overlap-at {|a b|
  for i [(range 1 (- (count $b) 1))] {
    if (has-value $a $b[$i]) { put $i; return }
  }
  put $false
}

fn at-command {|cmd|
  == (count $cmd) 2
}

fn prefix-completer {|p a|
  set edit:completion:arg-completer[$p] = {|@cmd|
    if (== (count $cmd) 2) {
      $a $@cmd
    } elif (has-key $edit:completion:arg-completer $cmd[1]) {
      $edit:completion:arg-completer[$cmd[1]] (all $cmd[1..])
    } else {
      edit:complete-filename $cmd[-1]
    }
  }
}

set edit:completion:arg-completer[waifu2x-converter-cpp] = {|@cmd|
  if (has-value [-i --input -o --output] $cmd[-2]) {
    edit:complete-filename $cmd[-1]
  } elif (has-value [-m --mode] $cmd[-2]) {
    put noise scale noise-scale
  } elif (eq $cmd[-2] --noise-level) {
    put 0 1 2 3
  } else {
    put --scale-ratio --noise-level --mode --jobs --png-compression ^
      --image-quality --silent -i -o
  }
}

var kitty-cmds = $nil
var kitty-kittens = $nil

set edit:completion:arg-completer[kitty] = {|@cmd|
  if (not $kitty-cmds) {
    set @kitty-cmds = (kitty @ --help | peach {|x| if (re:match '^  \w' $x) { put $x[2..] } })
    set @kitty-kittens = (tmp pwd = /usr/lib/kitty/kittens; f main.py | peach {|x| path:dir $x })
  }
  if (has-value [kitten '+kitten'] $cmd[-2]) {
    all $kitty-kittens
  } elif (eq $cmd[-2] '@') {
    all $kitty-cmds
  } else {
    edit:complete-filename $cmd[-1]
  }
}

set edit:completion:arg-completer[sv] = {|@cmd|
  if (== (count $cmd) 2) {
    put status up down once pause cont hup alarm interrupt quit kill term 1 2 ^
      exit start try-restart check {force-,}{stop,reload,restart,shutdown}
  } else {
    tmp pwd = /var/service; put *
  }
}

set edit:completion:arg-completer[man] = {|@cmd|
  tmp pwd = /bedrock/cross/man; put man*/* | each {|a|
    re:replace &literal=$true '(\.\dp?)?(\.gz)?$' '' (path:base $a)
  }
}

set edit:completion:arg-completer[kill] = {|@cmd|
  ps -u (whoami) --no-headers -o pid,command |^
    re:awk {|_ p @c| edit:complex-candidate &display=(print ' '$@c) $p }
}

set edit:completion:arg-completer[nimble] = {|@cmd|
  if (== (count $cmd) 2) {
    put {un,}install develop check init publish build c cc js test doc{,2} ^
      refresh search list tasks path dump
    if (> (count [*[nomatch-ok].nimble]) 0) {
      nimble tasks 2>&- | re:awk {|_ a @_| put $a }
    }
  } elif (eq $cmd[-2] install) {
    for x (from-json <~/.nimble/packages_official.json) { put $x[name] }
  } elif (eq $cmd[-2] uninstall) {
    var idx = (util:index-of $cmd[-1] '@')
    if (== $idx -1) {
      nimble list -i | re:awk {|_ n @_| put $n }
    } else {
      var pkgs = [&]
      nimble list -i | re:awk {|_ n @v|
        var @ver = $@v[..-1]
        set ver[0] = $ver[0][1..]
        set pkgs[$n] = $ver
      }
      var pkg = $cmd[-1][..$idx]
      if (has-key $pkgs $pkg) {
        for v $pkgs[$pkg] { put $pkg@$v }
      }
    }
  }
}

set edit:completion:arg-completer[bspc] = {|@cmd|
  if (== (count $cmd) 2) {
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

set edit:completion:arg-completer[ntr] = {|@cmd|
  if (not (str:has-prefix $cmd[-1] '-')) {
    tmp pwd = $E:XDG_CONFIG_HOME/ntr/contexts; put **
  }
}

set edit:completion:arg-completer[update] = {|@cmd|
  update | each {|x| if (str:has-prefix $x "    ") { put $x[4..] } }
}

set edit:completion:arg-completer[xr] = {|@cmd|
  xpkg -m
  xpkg -O | peach {|x| edit:complex-candidate &display=(styled $x bg-red) $x }
}

set edit:completion:arg-completer[xi] = {|@cmd|
  tmp pwd = $E:XBPS_DISTDIR/srcpkgs; put *
}

var xbps-src-cmds = $nil
var xbps-src-arch = $nil

set edit:completion:arg-completer[xbps-src] = {|@cmd|
  if (not $xbps-src-cmds) {
    set @xbps-src-cmds = (xbps-src -h | take 129 | drop 4 | each {|x| put (re:find &max=1 '^\w+(\-\w+)*' $x)[text] })
    set @xbps-src-arch = (xbps-src -h | take 162 | drop 136)[1..]
  }
  if (eq $cmd[-2] '-a') {
    all $xbps-src-arch
  } else {
    if (not (overlap-at $xbps-src-cmds $cmd)) {
      all $xbps-src-cmds
    } else {
      tmp pwd = $E:XBPS_DISTDIR/srcpkgs; put *
    }
  }
}

set edit:completion:arg-completer[strat] = {|@cmd|
  var @strata = (brl list)
  var has-strat = (overlap-at $strata $cmd)
  if (not $has-strat) {
    all $strata
  } else {
    edit:complete-sudo (all $cmd[$has-strat..])
  }
}

set edit:completion:arg-completer[brl] = {|@cmd|
  var @brl-cmds = (brl -h | take 36 | drop 5 | each {|x| put (re:find &max=1 '^  \w+' $x)[text][2..] })
  set edit:completion:arg-completer[brl] = {|@cmd|
    var has-command = (overlap-at $brl-cmds $cmd)
    if (not $has-command) {
      all $brl-cmds
    } else {
      var c = $cmd[$has-command]
      if (has-value [status enable disable hide show] $c) {
        brl list
      } elif (eq $c fetch) {
        brl fetch -L
      } elif (eq $c which) {
        edit:complete-sudo (all $cmd[$has-command..])
      }
    }
  }
  $edit:completion:arg-completer[brl] $@cmd
}

set edit:completion:arg-completer[tam] = {|@cmd|
  if (at-command $cmd) {
    put install uninstall enable disable update list query search
  } else {
    var c = $cmd[1]
    if (has-value [uninstall update query] $c) {
      tam list -s
    } elif (eq $c enable) {
      tam list -s -d
    } elif (eq $c disable) {
      tam list -s -e
    } elif (eq $c list) {
      put '--short' '--enabled' '--disabled'
    }
  }
}

set edit:completion:arg-completer[handlr] = {|@cmd|
  if (at-command $cmd) {
    put get set add unset launch open list
  } elif (and (== (count $cmd) 3) (has-value [get set add unset launch] $cmd[-2])) {
    handlr autocomplete -m
  } elif (and (== (count $cmd) 4) (has-value [set add] $cmd[-3])) {
    handlr autocomplete -d | each {|x|
      var desktop name = (str:split "\t" $x)
      edit:complex-candidate $desktop &display=$desktop' '$name
    }
  } else {
    edit:complete-filename $@cmd
  }
}

set edit:completion:arg-completer[promotescript] = {|@cmd|
  tmp pwd = ~/.local/bin; f -t f
}

set edit:completion:arg-completer[ferium] = {|@cmd|
  var cmds = [add complete help list modpack profile remove upgrade]
  var cmd-pos = (overlap-at $cmds $cmd)
  if (not $cmd-pos) {
    if (> (count $cmd) 2) {
      if (eq $cmd[-2] --config-file) {
        edit:complete-filename $cmd[-1]
      } elif (has-value [--threads -t] $cmd[-2]) {
        range 9
      } else {
        all $cmds
        put --config-file --github-token --help --threads --version
      }
    } else {
      all $cmds
      put --config-file --github-token --help --threads --version
    }
  } else {
    var command = $cmd[$cmd-pos]
    if (eq $command help) {
      all $cmds
    } elif (eq $command add) {
      put --dont-add-dependencies --dont-check-game-version --dont-check-mod-loader
    } elif (eq $command list) {
      put --markdown --verbose
    }
  }
}

set edit:completion:arg-completer[vkpurge] = {|@cmd|
  var cmds = [list rm]
  var cmd-pos = (overlap-at $cmds $cmd)
  if (not $cmd-pos) {
    all $cmds
  } else {
    var command = $cmd[$cmd-pos]
    if (eq $command rm) {
      vkpurge list
      put all
    }
  }
}

set edit:completion:arg-completer[dinitctl] = {|@cmd|
  var cmds = [status is-started is-failed start stop restart wake release unpin unload reload list shutdown add-dep rm-dep enable disable trigger untrigger setenv catlog signal]
  var cmd-pos = (overlap-at $cmds $cmd)
  if (not $cmd-pos) {
    all $cmds
  }
}

set edit:completion:arg-completer[stratify] = {|@cmd|
  if (== 2 (count $cmd)) { brl list }
}

set edit:completion:arg-completer[playerctl] = {|@cmd|
  var cmds = [play pause play-pause stop next previous position volume status metadata open loop shuffle]
  var cmd-pos = (overlap-at $cmds $cmd)
  if (not $cmd-pos) {
    all $cmds
  } elif (eq $cmd[$cmd-pos] open) {
    edit:complete-filename $cmd[-1]
  } elif (eq $cmd[$cmd-pos] loop) {
    put None Track Playlist
  } elif (eq $cmd[$cmd-pos] shuffle) {
    put On Off Toggle
  }
}

set edit:completion:arg-completer[vips] = {|@cmd|
  var @cmds = (vips -c)
  var cmd-pos = (overlap-at $cmds $cmd)
  if (not $cmd-pos) {
    all $cmds
  } else {
    edit:complete-filename $cmd[-1]
  }
}

set edit:completion:arg-completer[mise] = {|@cmd|
  var cmds = [activate alias a backends b bin-paths cache completion config cfg deactivate direnv doctor dr env e exec x generate gen implode install i latest link ln ls list ls-remote outdated plugins p prune registry reshim run r self-update set settings shell sh sync tasks t trust uninstall remove rm unset upgrade up use u version v watch w where which help]
  var cmd-pos = (overlap-at $cmds $cmd)
  if (not $cmd-pos) {
    all $cmds
  } else {
    var command = $cmd[$cmd-pos]
    if (or (==s $command upgrade) (==s $command up)) {
      keys (mise ls --json | from-json)
    }
  }
}
set edit:completion:arg-completer[edit-script] = $edit:complete-sudo~
set edit:completion:arg-completer[whereis] = $edit:complete-sudo~
set edit:completion:arg-completer[which] = $edit:complete-sudo~

set edit:completion:arg-completer[xq] = $edit:completion:arg-completer[xi]
set edit:completion:arg-completer[xqt] = $edit:completion:arg-completer[xi]
set edit:completion:arg-completer[xbps-install] = $edit:completion:arg-completer[xi]

var prefixes = [
  &sudo=$edit:complete-sudo~
  &strace=$edit:complete-sudo~
  &time=$edit:complete-sudo~
  &torify=$edit:complete-sudo~
]

keys $prefixes | each {|k| prefix-completer $k $prefixes[$k] }

each {|c|
  set edit:completion:arg-completer[$c] = {|@arg|
      eval (carapace $c elvish | slurp)
      $edit:completion:arg-completer[$c] $@arg
  }
} [git kak ffmpeg cargo mkdir dd rsync yt-dlp gitui mpv env set-env unset-env elvish nu sysctl mount umount go pip gdb bluetoothctl]
