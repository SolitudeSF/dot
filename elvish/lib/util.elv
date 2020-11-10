use str
use math

fn abort [&code=1 a]{
  echo (styled $a red) >&2
  exit $code
}

fn set-title [a]{
  print "\e]0;"$a"\e\\"
}

fn path-abbr [a &len=1]{
  put (str:split / (dirname $a) | each [x]{
    l = (count $x)
    if (eq 0 $l) { put '' } else { put $x[0..(math:min $len $l)] }
  } | str:join /)/(basename $a)
}

fn merge-map [a b]{
  keys $b | each [k]{ a[$k] = $b[$k] }
  put $a
}

fn index-of [a b]{
  r = 0
  for val $a {
    if (eq $val $b) { put $r; return }
    r = (+ $r 1)
  }
  float64 -1
}

fn pad [a b &with=' ' &left=$true]{
  a = (to-string $a)
  p = (repeat (- $b (count $a)) $with | str:join '')
  if $left {
    put $p$a
  } else {
    put $a$p
  }
}

fn add-before-readline [@hooks]{
  for hook $hooks {
    if (not (has-value $edit:before-readline $hook)) {
      edit:before-readline=[ $@edit:before-readline $hook ]
    }
  }
}

fn add-after-readline [@hooks]{
  for hook $hooks {
    if (not (has-value $edit:after-readline $hook)) {
      edit:after-readline=[ $@edit:after-readline $hook ]
    }
  }
}
