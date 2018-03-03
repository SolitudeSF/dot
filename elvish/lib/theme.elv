use re
use git
use util
use timer

edit:rprompt-persistent = $true
edit:prompt-stale-threshold = 0.1
edit:rprompt-stale-transform = { put ⏳ }
edit:-prompt-eagerness = 5
pwd-limit = 20
max-dir-len = 1
basesym = ▲

if (or (has-env SSH_CLIENT) (has-env SSH_TTY)) {
  basesym = ◆
}

fn sym {
  if ?(isnimbleproject) {
    put 👑
  } else { put $basesym }
}

fn pwd {
  tmp = (tilde-abbr $pwd)
  if (or (< (count $tmp) $pwd-limit) (< $max-dir-len 1)) {
    put $tmp
  } else {
    re:replace '(\.?[^/]{'$max-dir-len'})[^/]*/' '$1/' $tmp
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

edit:prompt = {
  put "\n "(sym)' '
  styled (pwd)'  ' cyan
}

edit:rprompt = {
  if (not-eq $num-bg-jobs 0) {
    put ' '$num-bg-jobs
  }
  put $timer:composed
  git
}
