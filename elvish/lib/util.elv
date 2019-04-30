fn abort [&code=1 a]{
  echo (styled $a red)
  exit $code
}

fn set-title [a]{
  print "\e]0;"$a"\e\\"
}

fn merge-list [a b]{
  for c $b { a = [$@a $c] }
  put $a
}

fn merge-map [a b]{
  for k $b { a[$k] = $b[$k] }
  put $a
}

fn if-not-zero [a b]{
  if (not-eq $a 0) { $b }
}

fn switch [a b]{
  $b[$a]
}

fn pad [a b &with=' ' &left=$true]{
  a = (to-string $a)
  p = (repeat (- $b (count $a)) $with | joins '')
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

fn fold [a b]{
  s = $a[0]
  for i [(range 1 (count $a))] {
    s = ($b $s $a[$i])
  }
  put $s
}

fn randselect [a]{
  put $a[(randint 0 (count $a))]
}

fn to-upper-ascii [a]{ if (and (< (ord $a) 123) (> (ord $a) 96)) { chr (- (ord $a) 32) } else { put $a } }
fn to-lower-ascii [a]{ if (and (< (ord $a) 91 ) (> (ord $a) 64)) { chr (+ (ord $a) 32) } else { put $a } }
