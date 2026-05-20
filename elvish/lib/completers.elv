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
} [git jj kak ffmpeg cargo kill which whereis chmod chown mkdir dd lsblk lsusb rsync yt-dlp gitui mpv env set-env unset-env rg elvish nu sysctl mount umount go pip gdb bluetoothctl yay makepkg pacman systemctl systemd-analyze journalctl bun bunx chdman kitty kitten fastfetch lnav man]
