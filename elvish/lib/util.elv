use str
use math

fn abort {|&code=1 a|
  echo (styled $a red) >&2
  exit $code
}

fn set-title {|a|
  print "\e]0;"$a"\e\\"
}

fn path-abbr {|a &len=1|
  put (str:split / (dirname $a) | each {|x|
    var l = (count $x)
    if (eq 0 $l) { put '' } else { put $x[0..(math:min $len $l)] }
  } | str:join /)/(basename $a)
}

fn merge-map {|a b|
  keys $b | each {|k| set a[$k] = $b[$k] }
  put $a
}

fn index-of {|a b|
  var r = 0
  for val $a {
    if (eq $val $b) { put $r; return }
    set r = (+ $r 1)
  }
  num -1
}

fn pad {|str len &with=' ' &left=$true|
  var a = (to-string $str)
  var p = (repeat (- $len (count $a)) $with | str:join '')
  if $left {
    put $p$a
  } else {
    put $a$p
  }
}

fn replace-ext {|file ext|
  var dot = (str:last-index $file .)
  if (!= $dot -1) {
    put $file[0..(+ 1 $dot)]$ext
  } else {
    put $file'.'$ext
  }
}

fn add-before-readline {|@hooks|
  for hook $hooks {
    if (not (has-value $edit:before-readline $hook)) {
      set edit:before-readline = (conj $edit:before-readline $hook)
    }
  }
}

fn add-after-readline {|@hooks|
  for hook $hooks {
    if (not (has-value $edit:after-readline $hook)) {
      set edit:after-readline = (conj $edit:after-readline $hook)
    }
  }
}

fn add-after-command {|@hooks|
  for hook $hooks {
    if (not (has-value $edit:after-readline $hook)) {
      set edit:after-command = (conj $edit:after-command $hook)
    }
  }
}

fn eval-namespace {|&ns=(ns [&]) code|
  eval &ns=$ns &on-end=$put~ $code
}

fn mimes {|@files|
  var result = [&]
  each {|file|
    set result[$file] = [
      &file=(file -bL --mime-type $file)
      &xdg-mime=(xdg-mime query filetype $file)
      &handlr=(handlr mime --json $file | from-json)[0][mime]
    ]
  } $files
  put $result
}
