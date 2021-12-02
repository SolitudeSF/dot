use git
use math
use util

set edit:rprompt-persistent = $true
set edit:prompt-stale-threshold = 0.1
set edit:rprompt-stale-transform = {|x| put ⏳$x }
set edit:-prompt-eagerness = 5

var pwd-limit = 20
var max-dir-len = 1
var basesym = ▲

if (or (has-env SSH_CLIENT) (has-env SSH_TTY)) {
  set basesym = ◆
}

fn sym {
  var o = (var e = ?(getprojecticon))
  if $e { put $o } else { put $basesym }
}

fn pwd {
  var tmp = (tilde-abbr $pwd)
  if (or (< (count $tmp) $pwd-limit) (< $max-dir-len 1)) {
    put $tmp
  } else {
    util:path-abbr $tmp &len=$max-dir-len
  }
}

fn duration {
  var delta = (exact-num (math:round $edit:command-duration))
  var s = 0
  var m = 0
  var h = 0

  if (> $delta 3600) {
    set s = (% $delta 60)
    set m = (/ (- (% $delta 3600) $s) 60)
    set h = (/ (- $delta (* $m 60) $s) 3600)
  } elif (> $delta 60) {
    set s = (% $delta 60)
    set m = (/ (- $delta $s) 60)
  } else {
    set s = $delta
  }

  if (> $h 0) {
    styled ' ⏱'$h':'(util:pad $m 2 &with=0)':'(util:pad $s 2 &with=0) bold
  } elif (> $m 0) {
    styled ' ⏱'$m':'(util:pad $s 2 &with=0) bold
  } elif (> $s 5) {
    styled ' ⏱'$s bold
  }
}

fn git {
  git:refresh-status
  if (not-eq $git:branch '') {
    if (not-eq $git:untracked 0) {
      styled ' +'$git:untracked magenta
    }
    if (not-eq $git:dirty 0) {
      styled ' ✎'$git:dirty red
    }
    if (not-eq $git:staged 0) {
      styled ' ✓'$git:staged green
    }
    if (not-eq $git:ahead 0) {
      styled ' ⇡'$git:ahead blue
    }
    if (not-eq $git:behind 0) {
      styled ' ⇣'$git:behind blue
    }
    styled ' '$git:branch cyan
  }
}

set edit:prompt = {
  put "\n "(sym)' '
  styled (pwd)'  ' cyan
}

set edit:rprompt = {
  if (not-eq $num-bg-jobs 0) {
    put ' '$num-bg-jobs
  }
  duration
  git
}
